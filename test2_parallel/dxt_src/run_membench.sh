#!/bin/sh

#SBATCH --job-name=membench
#SBATCH --time=00:30:00
#SBATCH --nodelist=STACK-CALC1
#SBATCH -p high
#SBATCH -o ./res/L3/out/slurm-%A_%a.out
#SBATCH -e ./res/L3/err/slurm-%A_%a.err 
#SBATCH --array=0-9

echo "Core $SLURM_ARRAY_TASK_ID"
likwid-perfctr -C S0:$SLURM_ARRAY_TASK_ID -g L3 -t 0.5s  ./membench

