#!/bin/sh

#SBATCH --job-name=membench
#SBATCH --time=00:30:00
#SBATCH --nodelist=icsnode29
#SBATCH -o ./res/out/slurm-%A_%a.out
#SBATCH -e ./res/err/slurm-%A_%a.err 
#SBATCH --array=0-2


likwid-perfctr -C S0:0 -g L3 -t 0.5s  ./membench 

