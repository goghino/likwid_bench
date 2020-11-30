#!/bin/bash

#CLUSTER=ics
#NODE=icsnode39
#NCPUS=20
#SOCKETCPUS=10

CLUSTER=dxt
NODE=STACK-CALC2
NCPUS=128
SOCKETCPUS=64

# run the stream using multiple processes
for n in 1 2 4 8
do

mkdir -p results/$CLUSTER/proc$n
for i in $(seq 0 $((n-1)))
do

sbatch <<-_EOF
#!/bin/bash
#SBATCH --job-name=proc_${i}
#SBATCH --cpus-per-task=1
#SBATCH --nodes=1
#SBATCH --time=0:05:00
#SBATCH --output=results/$CLUSTER/proc$n/proc_${i}.out
#SBATCH --error=results/$CLUSTER/proc$n/proc_${i}.err
#SBATCH --nodelist=$NODE
#SBATCH --partition=med
#//SBATCH --mem=2GB
#//SBATCH --partition=debug-slim
#//SBATCH --reservation=hpc_wednesday

#module load likwid
export OMP_NUM_THREADS=1
printf "Process $i\n"

# run the experiment, local size 1GB, 100 iterations
echo "Executing likwid-pin -C S0:$i hostname"
likwid-pin -C S0:$i hostname
fi


_EOF
done

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

#Example of the results, inspect using "grep -r PID *"
#results/dxt/proc1/proc_0.out:[likwid-pin] Main PID -> core 0 - OK

#results/dxt/proc2/proc_0.out:[likwid-pin] Main PID -> core 0 - OK
#results/dxt/proc2/proc_1.out:[likwid-pin] Main PID -> core 1 - OK

#results/dxt/proc4/proc_0.out:[likwid-pin] Main PID -> core 0 - OK
#results/dxt/proc4/proc_1.out:[likwid-pin] Main PID -> core 1 - OK
#results/dxt/proc4/proc_2.out:[likwid-pin] Main PID -> core 2 - OK
#results/dxt/proc4/proc_3.out:[likwid-pin] Main PID -> core 3 - OK
