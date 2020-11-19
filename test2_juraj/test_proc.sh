#!/bin/bash

# run the stream using multiple processes
for n in {0..19}
do

N=$((n + 1))
mkdir -p results/proc$N

for i in $(seq 0 $n)
do

sbatch <<-_EOF
#!/bin/bash
#SBATCH --job-name=proc_${i}
#SBATCH --cpus-per-task=1
#SBATCH --nodes=1
#SBATCH --time=0:05:00
#SBATCH --output=results/proc$N/proc_${i}.out
#SBATCH --error=results/proc$N/proc_${i}.err
#SBATCH --nodelist=icsnode30
#SBATCH --mem=3GB
#//SBATCH --reservation=hpc_wednesday

module load likwid
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

read -p "Press any key when >>watch squeue | grep icsnode30<< is empty..."

done
