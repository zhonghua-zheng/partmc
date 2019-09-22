/* Copyright (C) 2019 Christian Guzman
 * Licensed under the GNU General Public License version 1 or (at your
 * option) any later version. See the file COPYING for details.
 *
 * Aerosol phase-specific functions for use by the solver
 *
 */
extern "C" {
/** \file
 * \brief Aerosol phase functions
 */
#include <stdio.h>
#include <stdlib.h>
#include "aero_phase_solver_gpu.h"

// TODO move all shared constants to a common header file
#define CHEM_SPEC_UNKNOWN_TYPE 0
#define CHEM_SPEC_VARIABLE 1
#define CHEM_SPEC_CONSTANT 2
#define CHEM_SPEC_PSSA 3
#define CHEM_SPEC_ACTIVITY_COEFF 4

#define NUM_STATE_VAR_ (int_data[0])
#define NUM_INT_PROP_ 1
#define NUM_FLOAT_PROP_ 0
#define SPEC_TYPE_(x) (int_data[NUM_INT_PROP_+x])
#define MW_(x) (float_data[NUM_FLOAT_PROP_+x])
#define DENSITY_(x) (float_data[NUM_FLOAT_PROP_+NUM_STATE_VAR_+x])
#define INT_DATA_SIZE_ (NUM_INT_PROP_+NUM_STATE_VAR_)
#define FLOAT_DATA_SIZE_ (NUM_FLOAT_PROP_+2*NUM_STATE_VAR_)

/** \brief Flag Jacobian elements used in calculations of mass and volume
 *
 * \param model_data Pointer to the model data(state, env, aero_phase)
 * \param aero_phase_gpu_idx Index of the aerosol phase to find elements for
 * \param state_var_id Index in the state array for this aerosol phase
 * \param jac_struct 1D array of flags indicating potentially non-zero
 *                   Jacobian elements. (The dependent variable should have
 *                   been chosen by the calling function.)
 * \return Number of Jacobian elements flagged
 */
int aero_phase_gpu_get_used_jac_elem(ModelData *model_data, int aero_phase_gpu_idx,
                                 int state_var_id, bool *jac_struct) {

  // Get the requested aerosol phase data
  int *int_data = (int *) aero_phase_gpu_find(model_data, aero_phase_gpu_idx);
  double *float_data = (double *) &(int_data[INT_DATA_SIZE_]);

  int num_flagged_elem = 0;

  for (int i_spec = 0; i_spec < NUM_STATE_VAR_; i_spec++) {
    if (SPEC_TYPE_(i_spec) == CHEM_SPEC_VARIABLE) {
      jac_struct[state_var_id + i_spec] = true;
      num_flagged_elem++;
    }
  }

  return num_flagged_elem;
}

/** \brief Get the mass and average MW in an aerosol phase
 *
 * \param model_data Pointer to the model data (state, env, aero_phase)
 * \param aero_phase_gpu_idx Index of the aerosol phase to use in the calculation
 * \param state_var Pointer the aerosol phase on the state variable array
 * \param mass Pointer to hold total aerosol phase mass
 *             (\f$\mbox{\si{\micro\gram\per\cubic\metre}}\f$ or
 *              \f$\mbox{\si{\micro\gram\per particle}}\f$)
 * \param MW Pointer to hold average MW of the aerosol phase
 *           (\f$\mbox{\si{\kilogram\per\mol}}\f$)
 * \param jac_elem_mass When not NULL, a pointer to an array whose length is the
 *                 number of Jacobian elements used in calculations of mass and
 *                 volume of this aerosol phase returned by
 *                 \c aero_phase_gpu_get_used_jac_elem and whose contents will be
 *                 set to the partial derivatives of mass by concentration
 *                 \f$\frac{dm}{dy_i}\f$ of each component species \f$y_i\f$.
 * \param jac_elem_MW When not NULL, a pointer to an array whose length is the
 *                 number of Jacobian elements used in calculations of mass and
 *                 volume of this aerosol phase returned by
 *                 \c aero_phase_gpu_get_used_jac_elem and whose contents will be
 *                 set to the partial derivatives of total molecular weight by
 *                 concentration \f$\frac{dMW}{dy_i}\f$ of each component
 *                 species \f$y_i\f$.
 */
void aero_phase_gpu_get_mass(ModelData *model_data, int aero_phase_gpu_idx,
                         double *state_var, double *mass, double *MW, double *jac_elem_mass,
                         double *jac_elem_MW) {

  // Set up a pointer for the partial derivatives
  void *partial_deriv = NULL;

  // Get the requested aerosol phase data
  int *int_data = (int *) aero_phase_gpu_find(model_data, aero_phase_gpu_idx);
  double *float_data = (double *) &(int_data[INT_DATA_SIZE_]);

  // Sum the mass and MW
  *mass = 0.0;
  double moles = 0.0;
  int i_jac = 0;
  for (int i_spec = 0; i_spec < NUM_STATE_VAR_; i_spec++) {
    if (SPEC_TYPE_(i_spec) == CHEM_SPEC_VARIABLE ||
        SPEC_TYPE_(i_spec) == CHEM_SPEC_CONSTANT ||
        SPEC_TYPE_(i_spec) == CHEM_SPEC_PSSA) {
      *mass += state_var[i_spec];
      moles += state_var[i_spec] / MW_(i_spec);
      if (jac_elem_mass) jac_elem_mass[i_jac] = 1.0;
      if (jac_elem_MW) jac_elem_MW[i_jac] = 1.0 / MW_(i_spec);
      i_jac++;
    }
  }
  *MW = *mass / moles;
  if (jac_elem_MW) {
    for (int j_jac = 0; j_jac < i_jac; j_jac++) {
      jac_elem_MW[j_jac] = (moles - jac_elem_MW[j_jac] * *mass)
                           / (moles * moles);
    }
  }

}

/** \brief Get the volume of an aerosol phase
 *
 * \param model_data Pointer to the model data (state, env, aero_phase)
 * \param aero_phase_gpu_idx Index of the aerosol phase to use in the calculation
 * \param state_var Pointer to the aerosol phase on the state variable array
 * \param volume Pointer to hold the aerosol phase volume
 *               (\f$\mbox{\si{\cubic\metre\per\cubic\metre}}\f$ or
 *                \f$\mbox{\si{\cubic\metre\per particle}}\f$)
 * \param jac_elem When not NULL, a pointer to an array whose length is the
 *                 number of Jacobian elements used in calculations of mass and
 *                 volume of this aerosol phase returned by
 *                 \c aero_phase_gpu_get_used_jac_elem and whose contents will be
 *                 set to the partial derivatives of total phase volume by
 *                 concentration \f$\frac{dv}{dy_i}\f$ of each component
 *                 species \f$y_i\f$.
 */
void aero_phase_gpu_get_volume(ModelData *model_data, int aero_phase_gpu_idx,
                           double *state_var, double *volume, double *jac_elem) {

  // Set up a pointer for the partial derivatives
  //void *partial_deriv = NULL;

  // Get the requested aerosol phase data
  int *int_data = (int *) aero_phase_gpu_find(model_data, aero_phase_gpu_idx);
  double *float_data = (double *) &(int_data[INT_DATA_SIZE_]);

  // Sum the mass and MW
  *volume = 0.0;
  int i_jac = 0;
  for (int i_spec = 0; i_spec < NUM_STATE_VAR_; i_spec++) {
    if (SPEC_TYPE_(i_spec) == CHEM_SPEC_VARIABLE ||
        SPEC_TYPE_(i_spec) == CHEM_SPEC_CONSTANT ||
        SPEC_TYPE_(i_spec) == CHEM_SPEC_PSSA) {
      *volume += state_var[i_spec] * 1.0e-9 / DENSITY_(i_spec);
      if (jac_elem) jac_elem[i_jac++] = 1.0e-9 / DENSITY_(i_spec);
    }
  }

}

/** \brief Find an aerosol phase in the list
 *
 * \param model_data Pointer to the model data (state, env, aero_phase)
 * \param aero_phase_gpu_idx Index of the desired aerosol phase
 * \return A pointer to the requested aerosol phase
 */
void * aero_phase_gpu_find(ModelData *model_data, int aero_phase_gpu_idx) {

  // Get the number of aerosol phases
  int *aero_phase_data = (int *) (model_data->aero_phase_data);
  int n_aero_phase = *(aero_phase_data++);

  // Loop through the aerosol phases to find the one requested
  for (int i_aero_phase = 0; i_aero_phase < aero_phase_gpu_idx; i_aero_phase++) {

    // Advance the pointer to the next aerosol phase
    aero_phase_data = (int *) aero_phase_gpu_skip((void *) aero_phase_data);

  }

  return (void *) aero_phase_data;

}

/** \brief Skip over an aerosol phase
 *
 * \param aero_phase_data Pointer to the aerosol phase to skip over
 * \return The aero_phase_data pointer advanced by the size of the aerosol
 *         phase
 */
void * aero_phase_gpu_skip(void *aero_phase_data) {
  int *int_data = (int *) aero_phase_data;
  double *float_data = (double *) &(int_data[INT_DATA_SIZE_]);

  return (void *) &(float_data[FLOAT_DATA_SIZE_]);
}

/** \brief Add condensed data to the condensed data block for aerosol phases
 *
 * \param n_int_param Number of integer parameters
 * \param n_float_param Number of floating-point parameters
 * \param int_param Pointer to the integer parameter array
 * \param float_param Pointer to the floating-point parameter array
 * \param solver_data Pointer to the solver data
 */
void aero_phase_gpu_add_condensed_data(int n_int_param, int n_float_param,
                                   int *int_param, double *float_param, void *solver_data) {
  /*ModelData *model_data =
          (ModelData * ) & (((SolverData *) solver_data)->model_data);
  int *aero_phase_data = (int *) (model_data->nxt_aero_phase);

  // Add the integer parameters
  for (; n_int_param > 0; n_int_param--) *(aero_phase_data++) = *(int_param++);

  // Add the floating-point parameters
  double *flt_ptr = (double *) aero_phase_data;
  for (; n_float_param > 0; n_float_param--)
    *(flt_ptr++) = (double) *(float_param++);

  // Set the pointer for the next free space in aero_phase_data;
  model_data->nxt_aero_phase = (void *) flt_ptr;*/
}

#undef NUM_STATE_VAR_
#undef NUM_INT_PROP_
#undef NUM_FLOAT_PROP_
#undef SPEC_TYPE_
#undef MW_
#undef DENSITY_
#undef INT_DATA_SIZE_
#undef FLOAT_DATA_SIZE_
}