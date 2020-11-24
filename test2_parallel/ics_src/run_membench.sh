#!/bin/sh

#SBATCH --job-name=membench
#SBATCH --time=00:30:00
#SBATCH --nodelist=icsnode21
#SBATCH -o ./res/out/slurm-%A_%a.out
#SBATCH -e ./res/err/slurm-%A_%a.err 
#SBATCH --array=0-2

echo "Core $SLURM_ARRAY_TASK_ID"
likwid-perfctr -C S0:$SLURM_ARRAY_TASK_ID -g L3 -t 0.5s  ./membench 

