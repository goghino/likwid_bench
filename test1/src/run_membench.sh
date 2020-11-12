#!/bin/bash -l

#SBATCH --job-name=membench
#SBATCH --time=00:30:00
#SBATCH --nodes=1
#SBATCH --output=membench-%j.out
#SBATCH --error=membench-%j.err



#likwid-perfctr -C S0:1 -g BRANCH -g L3 -O  -o likwid_res ./membench

#for i in {1..2} do
	likwid-perfctr -C S0:0 -g L3 -m ./membench > res/res.txt
#done
