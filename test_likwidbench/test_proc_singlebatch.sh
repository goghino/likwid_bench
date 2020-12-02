#!/bin/bash

#CLUSTER=ics
#NODE=icsnode39
#NCPUS=20
#SOCKETCPUS=10

CLUSTER=dxt
NODE=STACK-CALC1
NCPUS=128
SOCKETCPUS=64

# run the stream using multiple processes
for n in `seq 0 $((SOCKETCPUS-1))`
do

N=$((n + 1))
mkdir -p results/$CLUSTER/jobsteps

sbatch <<-_EOF
#!/bin/bash
#SBATCH --job-name=proc_${N}
#SBATCH --ntasks=${N}
#SBATCH --exclusive
#SBATCH --cpus-per-task=1
#SBATCH --nodes=1
#SBATCH --time=0:05:00
#SBATCH --output=results/$CLUSTER/jobsteps/proc_${N}.out
#SBATCH --error=results/$CLUSTER/jobsteps/proc_${N}.err
#SBATCH --nodelist=$NODE
#SBATCH --partition=med
#//SBATCH --mem=2GB
#//SBATCH --partition=debug-slim
#//SBATCH --reservation=hpc_wednesday

#module load likwid
export OMP_NUM_THREADS=1
printf "Process batch size $N\n"
hostname

# run the experiment, local size 1GB, 100 iterations

for i in `seq -s " " 0 $n`
do

if [ \$i -lt $SOCKETCPUS ]; then
    #launch first SOCKETCPUS processes on socket 0
    likwid-perfctr -C S0:\$i -g MEM likwid-bench -i 100 -t triad -w S0:1000MB:1 &
else
    #additional processes are placed on socket 1
    likwid-perfctr -C S1:\$i -g MEM likwid-bench -i 100 -t triad -w S1:1000MB:1 &
fi

done

wait

_EOF

#read -p "Press any key when >>watch squeue | grep $NODE<< is empty..."

sleep 15
NQUEUE=`squeue | grep -E "$NODE|$USER" |  wc -l`
while [ $NQUEUE -gt 0 ]
do
printf "squeue has $((NQUEUE)) entries, sleeping...\n"
sleep 5
NQUEUE=`squeue | grep -E "$NODE|$USER" |  wc -l`
done
printf "squeue has $((NQUEUE)) entries\n"

done
