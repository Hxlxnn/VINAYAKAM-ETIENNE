#!/bin/bash
chmod 777 data/data.csv

cut -d ';' -f1,2,5 data/data.csv >temp/s1.csv
tail -n +2 temp/s1.csv > temp/s2.csv

gcc -o progc/s progc/s.c
./progc/s temp/s2.csv

head -n 50 temp/sortie.csv > temp/s.txt
gnuplot gnuplot/histo_s.txt
mv H_s.png images/
