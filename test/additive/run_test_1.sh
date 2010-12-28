#!/bin/bash

# exit on error
set -e
# turn on command echoing
set -v
# make sure that the current directory is the one where this script is
cd ${0%/*}

../../partmc run_part.spec
../../partmc run_exact.spec

../../extract_aero_size_num 1e-8 1e-3 160 out/additive_part_0001_ out/additive_part_size_num.txt
../../extract_sectional_aero_size_num out/additive_exact_ out/additive_exact_size_num.txt

../../numeric_diff out/additive_part_size_num.txt out/additive_exact_size_num.txt 0 5e-2
exit $?
