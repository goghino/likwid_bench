#!/bin/sh

#SBATCH --job-name=membench
#SBATCH --time=00:30:00
#SBATCH -p high
#SBATCH --nodelist=STACK-CALC1
#SBATCH -o ./res/L3/out/slurm-%A_%a.out
#SBATCH -e ./res/L3/err/slurm-%A_%a.err 
#SBATCH --array=0-9


likwid-perfctr -C S0:0 -g L3 -t 0.5s -f ./membench

