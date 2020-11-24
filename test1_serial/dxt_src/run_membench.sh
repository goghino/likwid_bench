#!/bin/bash -l

#SBATCH --job-name=membench
#SBATCH --time=00:30:00
#SBATCH -p high
#SBATCH --nodes=1
#SBATCH --output=res/membench-timeline.out
#SBATCH --error=res/membench-timeline.err
#SBATCH --exclusive


#Time-line mode
likwid-perfctr -C S0:0 -g MEM -t 0.5s ./membench
