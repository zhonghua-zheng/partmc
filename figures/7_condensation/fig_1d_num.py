#!/usr/bin/env python2.5

import Scientific.IO.NetCDF
import sys
import numpy as np
import matplotlib
matplotlib.use("PDF")
import matplotlib.pyplot as plt
sys.path.append("../../tool")
import pmc_data_nc

def make_plot(in_dir, in_filename1, in_filename2, in_filename3, out_filename,title):
    print in_filename1, in_filename2, in_filename3
    ncf = Scientific.IO.NetCDF.NetCDFFile(in_dir+in_filename1)
    particles1 = pmc_data_nc.aero_particle_array_t(ncf)
    ncf.close()
    ncf = Scientific.IO.NetCDF.NetCDFFile(in_dir+in_filename2)
    particles2 = pmc_data_nc.aero_particle_array_t(ncf)
    ncf.close()
    ncf = Scientific.IO.NetCDF.NetCDFFile(in_dir+in_filename3)
    particles3 = pmc_data_nc.aero_particle_array_t(ncf)
    ncf.close()

    x_axis = pmc_data_nc.pmc_log_axis(min=1e-8,max=1e-4,n_bin=100)
    x_centers = x_axis.centers() 

    wet_diameter1 = particles1.diameter()
    wet_diameter2 = particles2.diameter()
    wet_diameter3 = particles3.diameter()

    hist1 = pmc_data_nc.histogram_1d(wet_diameter1, x_axis, weights = 1 / particles1.comp_vol)
    hist2 = pmc_data_nc.histogram_1d(wet_diameter2, x_axis, weights = 1 / particles2.comp_vol)
    hist3 = pmc_data_nc.histogram_1d(wet_diameter3, x_axis, weights = 1 / particles3.comp_vol)

    plt.clf()
    plt.semilogx(x_axis.centers(), hist1, label = '0 min')
    plt.semilogx(x_axis.centers(), hist2, label = '2 mins')
    plt.semilogx(x_axis.centers(), hist3, label = '10 mins') 
    plt.legend(loc = 'upper left')
    plt.xlabel("wet diameter (m)")
    plt.ylabel("number density (m^{-3})")
    plt.title(title)
    fig = plt.gcf()
    fig.savefig(out_filename)

make_plot("../../new_cond/out/","cond_1_0001_00000001.nc","cond_1_0001_00000121.nc","cond_1_0001_00000601.nc","figs/1d_num_01.pdf","1 hours")
make_plot("../../new_cond/out/","cond_2_0001_00000001.nc","cond_2_0001_00000121.nc","cond_2_0001_00000601.nc","figs/1d_num_07.pdf","7 hours")
make_plot("../../new_cond/out/","cond_3_0001_00000001.nc","cond_3_0001_00000121.nc","cond_3_0001_00000601.nc","figs/1d_num_15.pdf","15 hours")
make_plot("../../new_cond/out/","cond_4_0001_00000001.nc","cond_4_0001_00000121.nc","cond_4_0001_00000601.nc","figs/1d_num_24.pdf","24 hours")

