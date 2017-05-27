# stock_chart.plt
#
# gnuplot script
#
# faultcode, 26.05.2017
#
# Test on Win7, gnuplot v.5.1: OK!
# good reads:
#   stackoverflow.com/questions/18894756/gnuplot-interchanging-axes/18898979#18898979
#
#
# devel.ideas:
#   - calculate table and file for vol_by_price_data from stock_data inside this script
#     => no extra round via Excel would be needed!
#
#

reset
#
# MODIFY to your needs:
set title "Blackham Resources Ltd. \nBLK, ASX - Yahoo data, with gnuplot 5"
unset key
#
#
############################################################################################
# MODIFY to your needs:                                                                    #
stock_data = "BLK_ASX_2.csv" # >>>>>>>>>>>>>>> MODIFY to your input data file
vol_by_price_data = "BLK_ASX_2_vol-hist.csv" # >>>>>>>>>>>>>>> MODIFY to your input data file
output_graph = "BLK_ASX_2\.png" # >>>>>>>>>>>>>>> MODIFY to your destination dir
Min = 0.1 # where binning starts: price >>>>>>>>>>>>>>> MODIFY to your needs
Max = 1.2 # where binning ends:   price >>>>>>>>>>>>>>> MODIFY to your needs
Top = 1.5 # out of range top price >>>>>>>>>>>>>>> MODIFY to your needs
Interval = 0.1  # price axis interval >>>>>>>>>>>>>>> MODIFY to your needs
Width = 0.01 # 1 cent width >>>>>>>>>>>>>>> MODIFY to your needs
Currency = "AUD"
Max_volume = 30 # for volume chart >>>>>>>>>>>>>>> MODIFY to your needs
Top_volume = 50 # for volume at price chart >>>>>>>>>>>>>>> MODIFY to your needs
Vol_step   = 10 # >>>>>>>>>>>>>>> MODIFY to your needs
Vol_divisor = 1000000 # >>>>>>>>>>>>>>> MODIFY to your needs
#                                                                                          #
############################################################################################
#
#
set terminal push # save the current terminal settings
set terminal png size 1100,1100 # send output to png file
set output output_graph
#
# set input date format:
set timefmt "%Y-%m-%d"
# VERY IMPORTANT: xdata is time data (not just datapoint numbers):
set xdata time
#
set datafile separator ","
#
set logscale y
set format y "%0.1f"
set ytics Min, Interval, Max-Interval
set yrange [Min:Top]
set ylabel Currency
#
set xtics nomirror
#
# have a 2nd y-axis on the right side:
set y2label Currency
set logscale y2
set format y2 "%0.1f"
set y2tics Min, Interval, Max - Interval
set y2range [Min:Top]
#
# have a 2nd x-axis for the volume as overlay inside the price chart:
set x2range [Top_volume:0]
set x2tics Top_volume,-Vol_step,0
set x2label "cumulative volume by price" offset 40
set format x2 "%1.0fm"
#
#
#
set grid
#
set lmargin 10
set rmargin 10
set bmargin 0
#
set format x ""
#
# Aha! >>>>
set multiplot
#
set size 1, 0.7
set origin 0, 0.3
set bmargin 0
#
plot stock_data using 1:2:3:4:5 with financebars lt 6,\
     vol_by_price_data using ($2/1000000/2.0):($1):($2/1000000/2.0):(Width/4.0) with boxxyerrorbars axes x2y2
#
#
#
############# Volume chart below: #############
unset title
unset x2tics
unset x2label
unset y2label
unset logscale y2
unset y2tics
unset y2range
#
set ylabel "volume"
set bmargin
#
# set format x
# set input date format:
set timefmt "%Y-%m-%d"
# set output date and time format:
set format x "%Y-%m-%d"
# VERY IMPORTANT: xdata is time data (not just datapoint numbers):
set xdata time
#
#
#
set size 1.0, 0.3
set origin 0.0, 0.0
set tmargin 1.5
#
unset logscale y
set autoscale y
set format y "%1.0fm" # >>>>>>>>>>>>>>> MODIFY to your needs
set yrange [0:Max_volume]
set ytics 0, Vol_step, Max_volume
#
#
# SPECIAL-LABEL: >>>>>>>>>>>>>>> MODIFY to your needs
set label 1 "Real outlier with 27.2m" at "2016-07-01", 25 left
#
plot stock_data using 1:($6/Vol_divisor) with impulses lt 2
#
# need here before next command:
unset multiplot
#
set output
set terminal pop # restore the current terminal settings
#
#
#
##############################################################
# input data:
#  (a) stock_data:
#  # ASX:BLK, Blackham Resources
#  # Date,Open,High,Low,Close,Volume
#  2015-05-26,0.175000,0.195000,0.175000,0.190000,2046367
#  2015-05-27,0.185000,0.185000,0.180000,0.185000,518624
#  ...
#  2017-05-24,0.285000,0.285000,0.265000,0.270000,6287031
#  2017-05-25,0.275000,0.280000,0.240000,0.250000,6857974
#  2017-05-26,0.270000,0.320000,0.260000,0.315000,7723836
#
#  (b) vol_by_price_data:
#  # closing price, summary volume at this closing price
#  0.140,1014736
#  0.145,2795378
#  0.150,3792251
#  ...
#  1.020,3355195
#  1.110,1968286
#  1.150,2271305
#
# end of stock_chart.plt
