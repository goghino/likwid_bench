#!/bin/bash

#CLUSTER=ics
#NODE=icsnode30
#NCPUS=20

CLUSTER=dxt
NODE=STACK-CALC1
NCPUS=64

# run the stream using multiple processes
for n in `seq 0 $((NCPUS-1))`
do

N=$((n + 1))
mkdir -p results/$CLUSTER/proc$N

for i in $(seq 0 $n)
do

sbatch <<-_EOF
#!/bin/bash
#SBATCH --job-name=proc_${i}
#SBATCH --cpus-per-task=1
#SBATCH --nodes=1
#SBATCH --time=0:05:00
#SBATCH --output=results/$CLUSTER/proc$N/proc_${i}.out
#SBATCH --error=results/$CLUSTER/proc$N/proc_${i}.err
#SBATCH --nodelist=$NODE
#SBATCH --mem=2GB
#//SBATCH --reservation=hpc_wednesday

#module load likwid
export OMP_NUM_THREADS=1
printf "Process $i\n"
hostname

# run the experiment, local size 1GB, 100 iterations

if [ "$i" -lt 10 ]; then
    #launch first 10 processes on socket 0
    likwid-perfctr -C S0:$i -g L3 likwid-bench -i 100 -t triad -w S0:1000MB:1
else
    #additional processes are placed on socket 1
    likwid-perfctr -C S1:$i -g L3 likwid-bench -i 100 -t triad -w S1:1000MB:1
fi


_EOF
done

read -p "Press any key when >>watch squeue | grep $NODE<< is empty..."

done
