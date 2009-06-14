# run from inside gnuplot with:
# load "<filename>.gnuplot"
# or from the commandline with:
# gnuplot <filename>.gnuplot

set key top left

set title "Gas mixing ratios (with coag)"

set xrange [0:24]
set xtics 3

set multiplot layout 2,1

set xlabel "time (hours)"
set ylabel "gas mixing ratio (ppb)"

#  column  1: time (s)
#  column  2: H2SO4 (ppb)
#  column  3: HNO3 (ppb)
#  column  4: HCl (ppb)
#  column  5: NH3 (ppb)
#  column  6: NO (ppb)
#  column  7: NO2 (ppb)
#  column  8: NO3 (ppb)
#  column  9: N2O5 (ppb)
#  column 10: HONO (ppb)
#  column 11: HNO4 (ppb)
#  column 12: O3 (ppb)
#  column 13: O1D (ppb)
#  column 14: O3P (ppb)
#  column 15: OH (ppb)
#  column 16: HO2 (ppb)
#  column 17: H2O2 (ppb)
#  column 18: CO (ppb)
#  column 19: SO2 (ppb)
#  column 20: CH4 (ppb)
#  column 21: C2H6 (ppb)
#  column 22: CH3O2 (ppb)
#  column 23: ETHP (ppb)
#  column 24: HCHO (ppb)
#  column 25: CH3OH (ppb)
#  column 26: ANOL (ppb)
#  column 27: CH3OOH (ppb)
#  column 28: ETHOOH (ppb)
#  column 29: ALD2 (ppb)
#  column 30: HCOOH (ppb)
#  column 31: RCOOH (ppb)
#  column 32: C2O3 (ppb)
#  column 33: PAN (ppb)
#  column 34: ARO1 (ppb)
#  column 35: ARO2 (ppb)
#  column 36: ALK1 (ppb)
#  column 37: OLE1 (ppb)
#  column 38: API1 (ppb)
#  column 39: API2 (ppb)
#  column 40: LIM1 (ppb)
#  column 41: LIM2 (ppb)
#  column 42: PAR (ppb)
#  column 43: AONE (ppb)
#  column 44: MGLY (ppb)
#  column 45: ETH (ppb)
#  column 46: OLET (ppb)
#  column 47: OLEI (ppb)
#  column 48: TOL (ppb)
#  column 49: XYL (ppb)
#  column 50: CRES (ppb)
#  column 51: TO2 (ppb)
#  column 52: CRO (ppb)
#  column 53: OPEN (ppb)
#  column 54: ONIT (ppb)
#  column 55: ROOH (ppb)
#  column 56: RO2 (ppb)
#  column 57: ANO2 (ppb)
#  column 58: NAP (ppb)
#  column 59: XO2 (ppb)
#  column 60: XPAR (ppb)
#  column 61: ISOP (ppb)
#  column 62: ISOPRD (ppb)
#  column 63: ISOPP (ppb)
#  column 64: ISOPN (ppb)
#  column 65: ISOPO2 (ppb)
#  column 66: API (ppb)
#  column 67: LIM (ppb)
#  column 68: DMS (ppb)
#  column 69: MSA (ppb)
#  column 70: DMSO (ppb)
#  column 71: DMSO2 (ppb)
#  column 72: CH3SO2H (ppb)
#  column 73: CH3SCH2OO (ppb)
#  column 74: CH3SO2 (ppb)
#  column 75: CH3SO3 (ppb)
#  column 76: CH3SO2OO (ppb)
#  column 77: CH3SO2CH2OO (ppb)
#  column 78: SULFHOX (ppb)

plot "out/urban_plume_wc_gas.txt" using ($1/3600):12 axes x1y1 with lines title "O3", \
     "out/urban_plume_wc_gas.txt" using ($1/3600):7 axes x1y1 with lines title "NO2"

plot "out/urban_plume_wc_gas.txt" using ($1/3600):3 axes x1y1 with lines title "HNO3", \
     "out/urban_plume_wc_gas.txt" using ($1/3600):24 axes x1y1 with lines title "HCHO", \
     "out/urban_plume_wc_gas.txt" using ($1/3600):19 axes x1y1 with lines title "SO2", \
     "out/urban_plume_wc_gas.txt" using ($1/3600):5 axes x1y1 with lines title "NH3"

unset multiplot
