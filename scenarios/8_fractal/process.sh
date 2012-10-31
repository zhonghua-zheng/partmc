#!/bin/sh

# exit on error
set -e
# turn on command echoing
set -v

# The data should have already been generated by ./run.sh

../../build/extract_aero_size --num --dmin 1e-9 --dmax 1e-7 --nbin 100 out/spsd_part_brown_free_df_3_0001
../../build/extract_sectional_aero_size --num out/spsd_sect_brown_free_df_3

../../build/test_fractal_self_preserve out/spsd_part_brown_free_df_3_0001
../../build/test_fractal_self_preserve out/spsd_part_brown_free_df_2_6_0001
../../build/test_fractal_self_preserve out/spsd_part_brown_free_df_2_2_0001
../../build/test_fractal_self_preserve out/spsd_part_brown_free_df_2_0001
../../build/test_fractal_self_preserve out/spsd_part_brown_cont_df_3_0001
../../build/test_fractal_self_preserve out/spsd_part_brown_cont_df_2_2_0001
../../build/test_fractal_self_preserve out/spsd_part_brown_cont_df_1_8_0001

../../build/test_fractal_dimless_time --free out/part_brown_free_df_3_0001
../../build/test_fractal_dimless_time --free out/restart_part_brown_free_df_3_0001
tail -n +2 out/restart_part_brown_free_df_3_0001_dimless_time.txt > out/restart_part_brown_free_df_3_0001_dimless_time_tailed.txt
cat out/part_brown_free_df_3_0001_dimless_time.txt out/restart_part_brown_free_df_3_0001_dimless_time_tailed.txt > out/part_brown_free_df_3_0001_dimless_t_series.txt
../../build/test_fractal_dimless_time --free out/part_brown_free_df_2_8_0001
../../build/test_fractal_dimless_time --free out/restart_part_brown_free_df_2_8_0001
tail -n +2 out/restart_part_brown_free_df_2_8_0001_dimless_time.txt > out/restart_part_brown_free_df_2_8_0001_dimless_time_tailed.txt
cat out/part_brown_free_df_2_8_0001_dimless_time.txt out/restart_part_brown_free_df_2_8_0001_dimless_time_tailed.txt > out/part_brown_free_df_2_8_0001_dimless_t_series.txt
../../build/test_fractal_dimless_time --free out/part_brown_free_df_2_4_0001
../../build/test_fractal_dimless_time --free out/restart_part_brown_free_df_2_4_0001
tail -n +2 out/restart_part_brown_free_df_2_4_0001_dimless_time.txt > out/restart_part_brown_free_df_2_4_0001_dimless_time_tailed.txt
cat out/part_brown_free_df_2_4_0001_dimless_time.txt out/restart_part_brown_free_df_2_4_0001_dimless_time_tailed.txt > out/part_brown_free_df_2_4_0001_dimless_t_series.txt
../../build/test_fractal_dimless_time --free out/part_brown_free_df_2_0001
../../build/test_fractal_dimless_time --free out/restart_part_brown_free_df_2_0001
tail -n +2 out/restart_part_brown_free_df_2_0001_dimless_time.txt > out/restart_part_brown_free_df_2_0001_dimless_time_tailed.txt
cat out/part_brown_free_df_2_0001_dimless_time.txt out/restart_part_brown_free_df_2_0001_dimless_time_tailed.txt > out/part_brown_free_df_2_0001_dimless_t_series.txt
../../build/test_fractal_dimless_time --cont out/part_brown_cont_df_3_0001
../../build/test_fractal_dimless_time --cont out/restart_part_brown_cont_df_3_0001
tail -n +2 out/restart_part_brown_cont_df_3_0001_dimless_time.txt > out/restart_part_brown_cont_df_3_0001_dimless_time_tailed.txt
cat out/part_brown_cont_df_3_0001_dimless_time.txt out/restart_part_brown_cont_df_3_0001_dimless_time_tailed.txt > out/part_brown_cont_df_3_0001_dimless_t_series.txt
../../build/test_fractal_dimless_time --cont out/part_brown_cont_df_1_8_0001
../../build/test_fractal_dimless_time --cont out/restart_part_brown_cont_df_1_8_0001
tail -n +2 out/restart_part_brown_cont_df_1_8_0001_dimless_time.txt > out/restart_part_brown_cont_df_1_8_0001_dimless_time_tailed.txt
cat out/part_brown_cont_df_1_8_0001_dimless_time.txt out/restart_part_brown_cont_df_1_8_0001_dimless_time_tailed.txt > out/part_brown_cont_df_1_8_0001_dimless_t_series.txt
../../build/test_fractal_dimless_time --cont out/part_brown_cont_df_1_0001
../../build/test_fractal_dimless_time --cont out/restart_part_brown_cont_df_1_0001
tail -n +2 out/restart_part_brown_cont_df_1_0001_dimless_time.txt > out/restart_part_brown_cont_df_1_0001_dimless_time_tailed.txt
cat out/part_brown_cont_df_1_0001_dimless_time.txt out/restart_part_brown_cont_df_1_0001_dimless_time_tailed.txt > out/part_brown_cont_df_1_0001_dimless_t_series.txt

# Now run 'gnuplot -persist <filename>.gnuplot' to plot the data