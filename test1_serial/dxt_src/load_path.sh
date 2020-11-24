#/bin/bash!

/bin/bash -c "echo LIKWID_LIB=$(dirname $(which likwid-perfctr))/../lib/"
/bin/bash -c "echo LIKWID_INCLUDE=$(dirname $(which likwid-perfctr))/../include/"

