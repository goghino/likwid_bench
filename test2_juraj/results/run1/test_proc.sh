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
#SBATCH --reservation=hpc_wednesday

module load likwid
export OMP_NUM_THREADS=1
printf "Process $i\n"
hostname

# run the experiment

if [ "$i" -lt 10 ]; then
    likwid-perfctr -C S0:$i -g L3 likwid-bench -t triad -w S0:500MB:1
else
    likwid-perfctr -C S1:$i -g L3 likwid-bench -t triad -w S1:500MB:1
fi


_EOF
done

read -p "Press any key..."

done
