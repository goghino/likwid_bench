#!/bin/bash

CLUSTER=dxt
NCPUS=64
NUMACORES=64
#STRING="CPU Clock" 
#STRING="Iterations:"
STRING="Time" 
#STRING="MByte/s"
#STRING="Allocate"


nNUMA=$((NCPUS/NUMACORES))


#HEADER
printf "Statistics for $STRING\n"
printf " "
for n in `seq 1 $NCPUS`
do
printf "Proc$n "
done
printf "\n"


#DATA
for n in `seq 1 $NCPUS`
do
    
printf "Overall-$n  "
grep $STRING results/$CLUSTER/run3/jobsteps/proc_$n.out | awk '{printf "%s ",$2}'

printf "\n"

done
