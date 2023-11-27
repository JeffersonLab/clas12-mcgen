#!/bin/bash
#
# NAB:  Modified from /apps/root/6.26.10
#

export CXX=`which g++`
export CC=`which gcc`

GCC_VERSION=$(gcc --version | head -1 | awk '{print$3}')
ROOT_VERSION=6.28.06
NTHREADS=16
DRYRUN=0 
INSTALL_DIR=

while getopts "v:p:j:dh" opt
do
    case $opt in
        v) ROOT_VERSION=$OPTARG ;;
        p) INSTALL_DIR=$OPTARG ;;
        j) NTHREADS=$OPTARG ;;
        d) DRYRUN=1 ;;
        h) echo "Usage: build-root.sh [-d] [-v version] [-p prefix] [-j threads]" && exit 0 ;;
        ?) echo "Usage: build-root.sh [-d] [-v version] [-p prefix] [-j threads]" && exit 1 ;;
    esac
done

# Choose output locations:
STUB=$ROOT_VERSION-$GCC_VERSION
LOG_FILE=./$STUB.log
SOURCE_DIR=./$STUB.src
BUILD_DIR=./$STUB.build
[ "$INSTALL_DIR" = "" ] && INSTALL_DIR=./$STUB
echo "ROOT_VERSION:  $ROOT_VERSION"
echo "SOURCE DIR:    $SOURCE_DIR"
echo "BUILD DIR:     $BUILD_DIR"
echo "INSTALL DIR:   $INSTALL_DIR"

# Pythia library location (as created by build-deps.sh):
PYTHIA_LIB=$(dirname $(realpath ${BASH_SOURCE[0]}))/lib/libPythia6.so

# Check stuff and abort:
[ $DRYRUN -ne 0 ] && exit
[ -e $SOURCE_DIR ] && echo ERROR:  source directory already exists: root-$SOURCE_DIR.src && exit 1
[ -e $BUILD_DIR ] && echo ERROR:  build directory already exists: $BUILD_DIR && exit 2
[ -e $INSTALL_DIR ] && echo ERROR:  install directory already exists: $INSTALL_DIR && exit 3
[ -e $PYTHIA_LIB ] && echo ERROR:  pythia6 library does not exist: $PYTHIA_LIB && exit 4
[ -e $LOG_FILE ] && echo ERROR:  log file already exists: $LOG_FILE && exit 5

# Echo all commands and abort if any return non-zero exit code:
set -x -e
touch $LOG_FILE

# Download:
wget https://root.cern/download/root_v$ROOT_VERSION.source.tar.gz |& tee -a $LOG_FILE || exit 96
tar xzf root_v$ROOT_VERSION.source.tar.gz |& tee -a $LOG_FILE
mv root-$ROOT_VERSION $SOURCE_DIR |& tee -a $LOG_FILE || exit 97

# Configure:
cmake -S $SOURCE_DIR -B $BUILD_DIR \
 -DCMAKE_CXX_STANDARD=17 -DCMAKE_INSTALL_INSTALL_DIR=$INSTALL_DIR -Dbuiltin_glew=ON \
 -Dpythia6=ON -DPYTHIA6_LIBRARY=$PYTHIA_LIB \
 |& tee -a $LOG_FILE || exit 98

# Build:
cmake --build $BUILD_DIR --target install -- -j$NTHREADS |& tee -a $LOG_FILE || exit 99

# Install Pythia in ROOT's lib:
cp -f $d/lib/libPythia6.so $INSTALL_DIR/lib

echo '\n\n###############################################'
echo "SUCCESS - INSTALL DIR:   $INSTALL_DIR"
echo '###############################################'

