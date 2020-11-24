#!/bin/sh

#SBATCH --job-name=membench
#SBATCH --time=00:30:00
#SBATCH --nodelist=icsnode17
#SBATCH -o ./res/L3/out/slurm-%A_%a.out
#SBATCH -e ./res/L3/err/slurm-%A_%a.err 
#SBATCH --array=0-2


likwid-perfctr -C S0:0 -g MEM -t 0.5s  ./membench 

