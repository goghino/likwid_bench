#!/bin/bash -l

#SBATCH --job-name=membench
#SBATCH --time=00:30:00
#SBATCH -p high
#SBATCH --nodes=1
#SBATCH --output=res/L3/membench-timeline.out
#SBATCH --error=res/L3/membench-timeline.err
#SBATCH --exclusive


#Time-line mode
likwid-perfctr -C S0:0 -g L3 -t 0.5s ./membench
