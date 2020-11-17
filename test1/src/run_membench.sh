#!/bin/bash -l

#SBATCH --job-name=membench
#SBATCH --time=00:30:00
#SBATCH --nodes=1
#SBATCH --output=res/membench-timeline.out
#SBATCH --error=res/membench-timeline.err
#SBATCH --exclusive



#likwid-perfctr -C S0:1 -g BRANCH -g L3 -O  -o likwid_res ./membench
# Maker API
#likwid-perfctr -C S0:0 -g L3  -m  ./membench
#Time-line mode
likwid-perfctr -C S0:0 -g L3 -t 0.5s ./membench 
