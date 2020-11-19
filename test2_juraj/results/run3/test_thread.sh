#!/bin/bash

# run the single stream as multithread application
for i in {1..20}
do

sbatch <<-_EOF
#!/bin/bash
#SBATCH --job-name=thread_${i}
#SBATCH --cpus-per-task=${i}
#SBATCH --nodes=1
#SBATCH --time=0:05:00
#SBATCH --output=results/thread_${i}.out
#SBATCH --error=results/thread_${i}.err
#SBATCH --nodelist=icsnode30
#SBATCH --exclusive

module load likwid
export OMP_NUM_THREADS=$i
printf "Using $i Threads\n"
hostname

# run the experiment
likwid-perfctr -C E:N:$i -g L3 likwid-bench -i 100 -t triad -w N:1000MB:$i
_EOF
done

#cat `ls -v threaded*.out` | grep MByte/s
