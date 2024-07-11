#!/usr/bin/env tcsh
echo '[+++++++++++] module use'
module use /cvmfs/oasis.opensciencegrid.org/jlab/hallb/clas12/sw/modulefiles
echo '[+++++++++++] module avail'
module avail --no-pager
echo '[+++++++++++] module load clas12'
module load clas12
echo '[+++++++++++] module list'
module list
echo '[+++++++++++++++++++++++++++++++++] done loading modules'
