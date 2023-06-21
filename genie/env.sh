
d=$(dirname $(realpath ${BASH_SOURCE[0]}))

. $d/build/build/root-6.26.10-gcc9.2.0/bin/thisroot.sh

export PATH=/apps/gcc/9.2.0/bin:${PATH}
export LD_LIBRARY_PATH=/apps/gcc/9.2.0/lib:/apps/gcc/9.2.0/lib64:${LD_LIBRARY_PATH}

export GENIE=$d/genie
export PATH=$d/bin:${PATH}
export LD_LIBRARY_PATH=$d/lib:${LD_LIBRARY_PATH}

