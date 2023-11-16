#!/bin/bash

d=$(dirname $(realpath ${BASH_SOURCE[0]}))
n=32

if [ "$1" == "-h" ]
then
    echo "build-deps.sh [log4cpp/lhapdf/gsl/libxml2/pythia6]"
    exit
fi

if [ "$#" -eq 0 ] || [ "$1" == "log4cpp" ]
then
    # LOG4CPP ::::::::::::::::::::::::::::::::::::::::::::
    wget https://sourceforge.net/projects/log4cpp/files/log4cpp-1.1.x%20%28new%29/log4cpp-1.1/log4cpp-1.1.4.tar.gz
    tar -xzvf log4cpp-1.1.4.tar.gz
    cd log4cpp
    ./configure --prefix=$d || exit 1
    make -j $n || exit 1
    make -j $n install || exit 1
    cd -
fi
if [ "$#" -eq 0 ] || [ "$1" == "lhapdf" ]
then
    # LHAPDF :::::::::::::::::::::::::::::::::::::::::::::
    wget 'https://lhapdf.hepforge.org/downloads/?f=LHAPDF-6.5.4.tar.gz' -O LHAPDF-6.5.4.tar.gz
    tar -xzvf LHAPDF-6.5.4.tar.gz
    cd LHAPDF-6.5.4
    ./configure --prefix=$d --disable-python || exit 1
    make -j $n || exit 1
    make -j $n install || exit 1
    cd -
#fi
#if [ "$#" -eq 0 ] || [ "$1" == "gsl" ]
#then
    # GSL ::::::::::::::::::::::::::::::::::::::::::::::::
    # seems very standard on linux distributions, use system install instead
    #wget https://ftp.gnu.org/gnu/gsl/gsl-2.7.tar.gz
    #tar -xzvf gsl-2.7.tar.gz
    #cd gsl-2.7
    #./configure --prefix=$d
    #make -j $n || exit 1
    #make -j $n install || exit 1
    #cd -
fi
if [ "$#" -eq 0 ] || [ "$1" == "libxml2" ]
then
    # LIBXML2 ::::::::::::::::::::::::::::::::::::::::::::
    # the standard URL finds bad mirrors, so we use a particular mirror:
    wget http://mirror.umd.edu/gnome/sources/libxml2/2.11/libxml2-2.11.0.tar.xz
    tar -xJvf libxml2-2.11.0.tar.xz
    cd libxml2-2.11.0
    ./configure --prefix=$d --without-python || exit 1
    make -j $n || exit 1
    make -j $n install || exit 1
    cd -
fi
if [ "$#" -eq 0 ] || [ "$1" == "pythia6" ]
then
    # PYTHIA :::::::::::::::::::::::::::::::::::::::::::::
    wget https://root.cern/download/pythia6.tar.gz
    tar -xzvf pythia6.tar.gz
    cd pythia6
    sed -i 's/^char /extern char /' ./pythia6_common_address.c
    sed -i 's/^int /extern int /' ./pythia6_common_address.c
    sed -i 's/^extern int pyuppr/int pyuppr /' ./pythia6_common_address.c
    ./makePythia6.linuxx8664 || exit 1
    cp libPythia6.so $d/lib
    cd -
fi

