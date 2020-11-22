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
STRIDE=32
while [ $STRIDE -lt 64 ]
do

# repeat necessary portion of jobs
#(e.g. overall 64 jobs, stride 2: run 2 batches of 32 jobs)
NRUNS=$((STRIDE))
for r in `seq 1 $NRUNS`
do


printf "\nRUN %d: " $r
mkdir -p results/$CLUSTER/stride$STRIDE
NJOBS=$((NCPUS/STRIDE-1))
BATCH=$((NCPUS/STRIDE))

for i in $(seq 0 $NJOBS)
do

JOBid=$((i+(r-1)*BATCH))
CPUid=$((i*STRIDE))

printf "CPU%d-job%d, " $CPUid $JOBid

sbatch <<-_EOF
#!/bin/bash
#SBATCH --job-name=proc_${i}
#SBATCH --cpus-per-task=1
#SBATCH --nodes=1
#SBATCH --time=0:05:00
#SBATCH --output=results/$CLUSTER/stride$STRIDE/run${r}_proc${JOBid}.out
#SBATCH --error=results/$CLUSTER/stride$STRIDE/run${r}_proc${JOBid}.err
#SBATCH --nodelist=$NODE
#//SBATCH --distribution=cyclic,NoPack
#//SBATCH --mem=2GB
#//SBATCH --partition=debug-slim
#SBATCH --partition=med
#//SBATCH --reservation=hpc_wednesday

#module load likwid
export OMP_NUM_THREADS=1
printf "Run%d: CPU%d-job%d\n" $r $CPUid $JOBid
hostname

# run the experiment, local size 1GB, 100 iterations

if [ "$i" -lt "$SOCKETCPUS" ]; then
    #launch first SOCKETCPUS processes on socket 0
    likwid-perfctr -C S0:$CPUid -g MEM likwid-bench -i 100 -t triad -w S0:1000MB:1
else
    #additional processes are placed on socket 1
    likwid-perfctr -C S1:$CPUid -g MEM likwid-bench -i 100 -t triad -w S1:1000MB:1
fi


_EOF
done

#read -p "Press any key when >>watch squeue | grep $NODE<< is empty..."

sleep 15
NQUEUE=`squeue | wc -l`
while [ $NQUEUE -gt 1 ]
do
    printf "squeue has $((NQUEUE-1)) entries, sleeping...\n"
    sleep 5
    NQUEUE=`squeue | wc -l`
done
printf "squeue has $((NQUEUE-1)) entries\n"


done

STRIDE=$((STRIDE*2))
echo " " 
done
