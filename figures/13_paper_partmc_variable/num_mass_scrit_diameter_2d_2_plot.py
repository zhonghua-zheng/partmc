#!/usr/bin/env python2.5

import os, sys
import config
import scipy.io
import numpy as np

sys.path.append("../../tool")
import partmc
import mpl_helper
import matplotlib

x_array = np.loadtxt("data/2d_scrit_10K_wei+1_12_x_values.txt") * 1e6
y_array = np.loadtxt("data/2d_scrit_10K_wei+1_12_y_values.txt") 

num_avg1 = np.loadtxt("data/2d_scrit_10K_wei+1_12_hist_average_num.txt") / 1e6
num_avg2 = np.loadtxt("data/2d_scrit_10K_wei-1_12_hist_average_num.txt") / 1e6
num_avg3 = np.loadtxt("data/2d_scrit_10K_wei-4_12_hist_average_num.txt") / 1e6

mass_avg1 = np.loadtxt("data/2d_scrit_10K_wei+1_12_hist_average_mass.txt") * 1e9
mass_avg2 = np.loadtxt("data/2d_scrit_10K_wei-1_12_hist_average_mass.txt") * 1e9
mass_avg3 = np.loadtxt("data/2d_scrit_10K_wei-4_12_hist_average_mass.txt") * 1e9

(figure, axes_array) = mpl_helper.make_fig_array(3,2, figure_width=config.figure_width_double, 
                                                 left_margin=0.7, right_margin=0.6, vert_sep=0.3)

axes = axes_array[2][0]
print 'num1 ', x_array, num_avg1
axes.pcolor(x_array, y_array, num_avg1.transpose(),linewidths = 0.1)
axes.set_xscale("log")
axes.set_yscale("log")
axes.set_ylabel(r"$S_{\rm crit} / \%$")
axes.set_ylim(1e-3,1e2)
axes.set_xlim(5e-3, 5)
axes.grid(True)

axes = axes_array[1][0]
axes.pcolor(x_array, y_array, num_avg2.transpose(),linewidths = 0.1)
axes.set_xscale("log")
axes.set_yscale("log")
axes.set_ylabel(r"$S_{\rm crit} / \%$")
axes.set_ylim(1e-3,1e2)
axes.set_xlim(5e-3, 5)
axes.grid(True)

axes = axes_array[0][0]
axes.pcolor(x_array, y_array, num_avg3.transpose(),linewidths = 0.1)
axes.set_xscale("log")
axes.set_yscale("log")
axes.set_ylabel(r"$S_{\rm crit} / \%$")
axes.set_ylim(1e-3,1e2)
axes.set_xlim(5e-3, 5)
axes.grid(True)
axes.set_xlabel(r"diameter / $\rm \mu m$")

axes = axes_array[2][1]
axes.pcolor(x_array, y_array, mass_avg1.transpose(),linewidths = 0.1)
axes.set_xscale("log")
axes.set_yscale("log")
axes.set_ylim(1e-3,1e2)
axes.set_xlim(5e-3, 5)
axes.grid(True)

axes = axes_array[1][1]
axes.pcolor(x_array, y_array, mass_avg2.transpose(),linewidths = 0.1)
axes.set_xscale("log")
axes.set_yscale("log")
axes.set_ylim(1e-3,1e2)
axes.set_xlim(5e-3, 5)
axes.grid(True)

axes = axes_array[0][1]
axes.pcolor(x_array, y_array, mass_avg3.transpose(),linewidths = 0.1)
axes.set_xscale("log")
axes.set_yscale("log")
axes.set_ylim(1e-3,1e2)
axes.set_xlim(5e-3, 5)
axes.grid(True)
axes.set_xlabel(r"diameter / $\rm \mu m$")

mpl_helper.remove_fig_array_axes(axes_array)

figure.savefig("figs/num_mass_scrit_diameter_2d.pdf")
