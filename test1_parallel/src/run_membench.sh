#!/bin/bash -l

#SBATCH --job-name=membench
#SBATCH --time=00:30:00
#SBATCH --nodes=1
#SBATCH --output=res/test1_parallel.out
#SBATCH --error=res/test1_parallel.err
#SBATCH --exclusive



#Time-line mode
srun likwid-perfctr -C S0:0 -g L3 -t 0.5s  -o res/membench-timeline1.out -e res/membench-timeline-1.err  ./membench &
srun likwid-perfctr -C S0:0 -g L3 -t 0.5s -o res/membench-timeline2.out -e res/membench-timeline-2.err ./membench &

wait
