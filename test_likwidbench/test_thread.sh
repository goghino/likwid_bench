#!/bin/bash

#CLUSTER=ics
#NODE=icsnode30
#NCPUS=20
#NUMACORES=10

CLUSTER=dxt
NODE=STACK-CALC1
NCPUS=64
NUMACORES=32

# run the single stream as multithread application
for i in `seq 1 $NCPUS`
do

ii=$((i-$NUMACORES))

D=$((1000*NUMACORES))MB

Da=$((1000*i))MB
Db=$((1000*ii))MB

sbatch <<-_EOF
#!/bin/bash
#SBATCH --job-name=thread_${i}
#SBATCH --cpus-per-task=${i}
#SBATCH --nodes=1
#SBATCH --time=0:05:00
#SBATCH --output=results/$CLUSTER/thread_${i}.out
#SBATCH --error=results/$CLUSTER/thread_${i}.err
#xxxSBATCH --nodelist=$NODE
#SBATCH --exclusive

module load likwid
export OMP_NUM_THREADS=$i
printf "Using $i Threads\n"
hostname
printf "Data S0: $Da\n"
printf "Data S1: $Db\n"

# run the experiment, local data size 1000MB per thread, 100 iterations

if [ $i -le $NUMACORES  ]; then
    #first NUMACORES threads are placed on S0, Da=1000*i
    likwid-perfctr -C E:N:$i -g L3 likwid-bench -i 100 -t triad -w S0:$Da:$i
else
    #additional threads are located at socket S1, Db=1000*ii
    #first NUMACORES threads are run on S0
    likwid-perfctr -C E:N:$i -g L3 likwid-bench -i 100 -t triad -w S0:$D:$NUMACORES -w S1:$Db:$ii
fi
_EOF
done

#cat `ls -v threaded*.out` | grep MByte/s
