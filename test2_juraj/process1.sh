#!/bin/bash

CLUSTER=dxt
NCPUS=64
NUMACORES=64
#STRING="CPU Clock" 
#STRING="Iterations:"
#STRING="Time" 
STRING="MByte/s"
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
for d in `seq 1 $NCPUS`
do
    
printf "Overall-$d  "
for n in `seq 0 $((d-1))`
do
    grep $STRING results/$CLUSTER/proc$d/proc_$n.out | awk '{printf "%s ",$2}'
  
done

printf "\n"

done
