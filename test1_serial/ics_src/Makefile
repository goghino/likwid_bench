#
# Usage:
#	make		# run benchmark on the local machine or on cluster compute node
#			# operated by SLURM
#
.PRECIOUS:	%.gp %.xxx %.out

#generic: generic.ps
generic: membench

membench: membench.c
	gcc -O3 -o membench membench.c

membench-likwid: membench.c
	gcc -O3 -DLIKWID_PERFMON -L$LIKWID_LIB -I$LIKWID_INCLUDE membench.c -o  membench -llikwid 

clean:
	make generic.clean

%.ps: membench %.gp
	sbatch ./run_membench.sh $*
	module load gnuplot
	gnuplot %.gp

%.gp: gnuplot.template
	sed -e '/sarlacc/	s//$*/' gnuplot.template > $*.gp

%.clean:
	rm -f $*.ps $*.gp $*.xxx *.out membench

tar:
	cd ../; tar cf membench.tar membench/*

