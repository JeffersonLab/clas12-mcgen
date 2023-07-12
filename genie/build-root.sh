#!/bin/bash
#
# NAB:  Modified from /apps/root/6.26.10 on June 20, 2023
#

export ROOT_VERS=6.26.10
export PREFIX=.

while getopts "v:p:" opt
do
    case $opt in
        v) ROOT_VERS=$OPTARG ;;
        p) PREFIX=$(realpath $OPTARG) ;;
        ?) echo "Usage: build-root.sh [-v version] [-p prefix]" && exit 1 ;;
    esac
done

export GCC_VERS=$(gcc --version | head -1 | awk '{print$3}')
export CXX=`which g++`
export CC=`which gcc`

STUB=${ROOT_VERS}-gcc${GCC_VERS}

[ -e ${ROOT_VERS}.src ] && echo ERROR:  source directory already exists: root-${ROOT_VERS}.src && exit 1
[ -e ${STUB}.build ] && echo ERROR:  build directory already exists: ${STUB}.build && exit 2
[ -e ${PREFIX}/${STUB} ] && echo ERROR:  install directory already exists: ${PREFIX}/${STUB} && exit 3

touch ${STUB}.log

# echo all commands and abort if anything returns non-zero exit code:
set -x -e

# Download:
wget https://root.cern/download/root_v${ROOT_VERS}.source.tar.gz |& tee -a ${STUB}.log
tar xzf root_v${ROOT_VERS}.source.tar.gz |& tee -a ${STUB}.log
mv root-${ROOT_VERS} root-${ROOT_VERS}.src |& tee -a ${STUB}.log

# Configure:
d=$(dirname $(realpath ${BASH_SOURCE[0]}))
cmake -S root-${ROOT_VERS}.src -B ${STUB}.build \
 -DCMAKE_CXX_STANDARD=17 -DCMAKE_INSTALL_PREFIX=${PREFIX}/${STUB} -Dbuiltin_glew=ON \
 -Dpythia6=ON -DPYTHIA6_LIBRARY=$d/lib/libPythia6.so \
 |& tee -a ${STUB}.log
# seems extrememly standard on linux distributions, no need to use local install:
# -DGSL_DIR=$d

# Build:
cmake --build ${STUB}.build --target install -- -j32 |& tee -a ${STUB}.log

echo '\n\n###############################################'
echo ROOTSYS=${PREFIX}/${STUB}
echo '###############################################'

