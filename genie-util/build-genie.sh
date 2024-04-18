#!/bin/bash

d=$(dirname $(realpath ${BASH_SOURCE[0]}))
n=16

# echo commands and abort if anything gives not-zero exit code:
set -x -e

git clone -b R-3_04_00 --depth 1 https://github.com/GENIE-MC/Generator.git genie

export GENIE=$(realpath genie)

cd $GENIE

./configure \
 --prefix=$d --disable-profiler --disable-validation-tools \
 --disable-doxygen --disable-cernlib --disable-lhapdf5 --enable-lhapdf6 \
 --enable-flux-drivers --enable-geom-drivers --enable-dylibversion --enable-nucleon-decay \
 --enable-test --enable-mueloss --enable-t2k --enable-fnal --enable-atmo \
 --disable-masterclass --disable-debug --with-optimiz-level=O2 \
 --with-pythia6-lib=$d/lib --with-lhapdf6-inc=$d/include --with-lhapdf6-lib=$d/lib \
 --with-libxml2-inc=$d/include/libxml2 --with-libxml2-lib=$d/lib \
 --with-log4cpp-inc=$d/include --with-log4cpp-lib=$d/lib

make -j $n

make -j $n install

