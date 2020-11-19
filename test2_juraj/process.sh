#!/bin/bash

grep "CPU Clock" `ls -v results/proc*/proc*`
grep "Iterations:" `ls -v results/proc*/proc*`
grep "Time" `ls -v results/proc*/proc*`
grep "MByte/s" `ls -v results/proc*/proc*`
grep "Allocate" `ls -v results/proc*/proc*`


#for d in {1..20}
#do
#grep "MByte/s" `ls -v $d/proc*` | cut -f3 | head -n 10 | awk '{s+=$1}END{print "ave S0:",s/NR}' RS=" "

#echo "Process count $d"
#grep "MByte/s" `ls -v results/proc$d/proc*` | cut -f3 
#| awk '{s+=$1}END{print "ave S0:"s " " n}' RS=" "
#grep "MByte/s" `ls -v results/proc$d/proc*` | cut -f3 | awk '{if(n++ > 9)  s+=$1}END{print "ave S1:",s}' RS=" "
#done
