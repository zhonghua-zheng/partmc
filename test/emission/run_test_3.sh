#!/bin/bash

# make sure that the current directory is the one where this script is
cd ${0%/*}

echo "../../extract_state_aero_species out/emission_mc_0001_ out/emission_mc_species.txt"
../../extract_state_aero_species out/emission_mc_0001_ out/emission_mc_species.txt
echo "../../extract_sectional_aero_species out/emission_exact_ out/emission_exact_species.txt"
../../extract_sectional_aero_species out/emission_exact_ out/emission_exact_species.txt

echo "../../numeric_diff out/emission_mc_species.txt out/emission_exact_species.txt 0 5e-2 0 0 2 0"
../../numeric_diff out/emission_mc_species.txt out/emission_exact_species.txt 0 5e-2 0 0 2 0
exit $?