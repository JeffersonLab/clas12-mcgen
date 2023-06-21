# Just a recipe for building GENIE.

## Prerequesites
1. GSL, not included because it seems to be standard in package managers, e.g., `yum install gsl-devel`
    * Looks like libxml2 is also standard, but currently include in the build procedure below 
2. Reasonably modern `gcc` and `cmake`

## Build Procedure
1. Download and build the genie-specific dependencies:
 
   `make deps`

2. Download and build ROOT with Pythia6 support (built in the previous step):

   `make root ROOTSYS=/path/to/new/ROOT/installation`

3. Build genie:

   `source ROOTSYS/bin/thisroot.sh`

   `source env.sh`

   `make genie`

