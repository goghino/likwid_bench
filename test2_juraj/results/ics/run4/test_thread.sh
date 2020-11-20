#!/bin/bash

# run the single stream as multithread application
for i in {1..20}
do

ii=$((i-10))

Da=$((1000*i))MB
Db=$((1000*ii))MB

sbatch <<-_EOF
#!/bin/bash
#SBATCH --job-name=thread_${i}
#SBATCH --cpus-per-task=${i}
#SBATCH --nodes=1
#SBATCH --time=0:05:00
#SBATCH --output=results/thread_${i}.out
#SBATCH --error=results/thread_${i}.err
#xxxSBATCH --nodelist=icsnode30
#SBATCH --exclusive

module load likwid
export OMP_NUM_THREADS=$i
printf "Using $i Threads\n"
hostname
printf "Data S0: $Da\n"
printf "Data S1: $Db\n"

# run the experiment
if [ $i -lt 11  ]; then
likwid-perfctr -C E:N:$i -g L3 likwid-bench -i 100 -t triad -w S0:$Da:$i
else
likwid-perfctr -C E:N:$i -g L3 likwid-bench -i 100 -t triad -w S0:10000MB:10 -w S1:$Db:$ii
fi
_EOF
done

#cat `ls -v threaded*.out` | grep MByte/s
