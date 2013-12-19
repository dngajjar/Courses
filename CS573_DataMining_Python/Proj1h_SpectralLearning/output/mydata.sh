gnuplot<<EOF
set terminal postscript eps color "Helvetica" 15
set size 0.33,0.33
set xtics (0,0.2,0.4,0.6,0.8,1.0)
set output "mydata.eps"
set palette defined (0  "green", 1 "red")
set nokey
set title "log(\$_ZZ)"
set style fill solid 1 noborder
plot 'mydata.dat'  with circles linecolor palette
EOF
epstopdf "mydata.eps"
