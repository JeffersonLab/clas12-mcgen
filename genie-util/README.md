A clas12 wrapper script and LUND converter for GENIE.

_Note, GENIE requires a large startup time for calculations that (should) get reused across many jobs._

## See also
* https://github.com/GENIE-MC/Generator

## Prerequesites
1. GSL, not included because it seems to be standard in package managers, e.g., `yum install gsl-devel`, and a local install caused issues with ROOT's XRootD build
    * Looks like libxml2 is also standard, but currently include in the build procedure below 
2. `wget`
3. Reasonably modern `gcc` and `cmake`
