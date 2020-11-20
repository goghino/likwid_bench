#!/bin/bash

CLUSTER=ics
NCPUS=20
NUMACORES=10
#STRING="CPU Clock" 
#STRING="Iterations:"
STRING="Time" 
#STRING="MByte/s"
#STRING="Allocate"


nNUMA=$((NCPUS/NUMACORES))


#HEADER
printf "Statistics for $STRING\n"
printf "Proc "
for n in `seq 1 $nNUMA`
do
printf "NUMA$n "
done
printf "\n"


#DATA
for d in `seq 1 $NCPUS`
do

    
printf "$d  "
for n in `seq 1 $nNUMA`
do
    offseta=$(((n-1)*NUMACORES))
    offsetb=$((n*NUMACORES))
    grep $STRING `ls -v results/$CLUSTER/run2/proc$d/proc*` | cut -f4 | awk "NR > $offseta && NR <= $offsetb { print }" | awk '{s+=$1}; END{if (NR>0) printf "%f ", s/NR; else printf "%d ", NR}' 
  
done

printf "\n"

done
