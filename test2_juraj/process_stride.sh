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




s=2
while [ $s -lt 64 ]
do

#HEADER
printf "Statistics for $STRING, STRIDE=$s\n"
printf " "
n=0
while [ $n -lt $NCPUS ]
do
printf "CPU$n "
n=$((n+1))
done
printf "\n"






#DATA
offset=0
for r in `seq 1 $s`
do
    printf "run-$r  "
    for p in `seq 0 $((NCPUS/s-1))`
    do
    pp=$((p+offset))
    grep $STRING results/$CLUSTER/run2/stride$s/run${r}_proc${pp}.out | awk '{printf "%s ",$2}'
    #fill in gaps with zeros
    for e in `seq 1 $((s-1))`
    do
        printf "0 "
    done
    done
offset=$((offset+NCPUS/s))
printf "\n"
done

printf "\n"
s=$((s*2))

done
