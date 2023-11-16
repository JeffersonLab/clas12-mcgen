
d=$(dirname $(realpath ${BASH_SOURCE[0]}))

export GENIE=$d/genie
export PATH=$d/bin:${PATH}
export LD_LIBRARY_PATH=$d/lib:${LD_LIBRARY_PATH}

