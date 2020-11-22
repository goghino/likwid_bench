#!/bin/bash

#CLUSTER=ics
#NODE=icsnode39
#NCPUS=20
#SOCKETCPUS=10
#STRIDE=1

CLUSTER=dxt
NODE=STACK-CALC1
NCPUS=64
SOCKETCPUS=64


#iterate for STRIDE=1,2,4,8,16,32
STRIDE=2
while [ $STRIDE -lt 64 ]
do

# repeat necessary portion of jobs
#(e.g. overall 64 jobs, stride 2: run 2 batches of 32 jobs)
NRUNS=$((STRIDE))
for r in `seq 1 $NRUNS`
do


mkdir -p results/$CLUSTER/stride$STRIDE
NJOBS=$((NCPUS/STRIDE-1))
BATCH=$((NCPUS/STRIDE))

for i in $(seq 0 $NJOBS)
do

JOBid=$((i+(r-1)*BATCH))
export CPUid=$((i*STRIDE))

export OMP_NUM_THREADS=1
printf "Run%d: CPU%d-job%d\n" $r $CPUid $JOBid
# run the experiment, local size 1GB, 100 iteratios
#salloc -N1 -n64 -w STACK-CALC1 -p med
srun -n1 likwid-perfctr -C S0:${CPUid} -g MEM likwid-bench -i 100 -t triad -w S0:1000MB:1 2&>1 > results/$CLUSTER/stride$STRIDE/run${r}_proc${JOBid}.out &
done

#read -p "Press any key when >>watch squeue | grep $NODE<< is empty..."

sleep 2
NQUEUE=`jobs | wc -l`
while [ $NQUEUE -gt 1 ]
do
    printf "jobs has $((NQUEUE)) entries, sleeping...\n"
    sleep 5
    NQUEUE=`jobs | wc -l`
done
printf "jobs has $((NQUEUE)) entries\n"


done

STRIDE=$((STRIDE*2))
echo " " 
done
