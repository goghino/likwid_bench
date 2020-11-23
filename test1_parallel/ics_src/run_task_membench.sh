#!/bin/bash -l

#SBATCH --job-name=membench
#SBATCH --time=00:30:00
#SBATCH --nodes=1
#SBATCH --ntasks=10
#SBATCH --output=task_res/test_parallel.out
#SBATCH --error=task_res/test_parallel.err
#SBATCH --exclusive



#Time-line mode
srun likwid-perfctr -C S0:0 -g L3 -t 0.5s  ./membench & 

wait
