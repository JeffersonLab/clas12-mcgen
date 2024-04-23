A recipe for building GiBUU with LHAPDF support and other cleanups, plus a configuration wrapper script and LUND converter.

## Prerequisites
1. c++17
1. LHAPDF
1. ROOT
1. python3
1. wget

## Building
1. make

_Note, LHAPDF will be built with the [Makefile above](../Makefile), if necessary._

## Running

Requirements:
* Write access to $PWD
* $GIBUU environment variable set to this directory

Usage:
* See `gibuu -h`
 
Here's what it does:
1. generates a GiBUU configuration file based on command-line options and [this template](gibuu_template.opt)
1. runs `GiBUU.x` proper
1. runs `gibuu2lund` to generate `./gibuu.dat`

## See Also
* https://gibuu.hepforge.org/
* https://github.com/alaoui-ah/GiBUU/tree/main/run_gibuu
