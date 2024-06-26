A recipe for building [GiBUU](https://gibuu.hepforge.org/) with [LHAPDF](https://lhapdf.hepforge.org/) support and other cleanups, plus a [configuration wrapper script](./gibuu) and [LUND converter](./gibuu2lund.cxx).

Here's a [presentation from a NPWG meeting on GiBUU](https://clasweb.jlab.org/Hall-B/npwg/images/1/11/Gibuu_jlab-AE.pdf).

## Prerequisites
1. c++17
1. LHAPDF
1. ROOT
1. python3
1. wget

## Building
1. make

Note, this includes a few automatic patches:
1. Symlinking LHAPDF libraries, which will be built with the [Makefile above](../Makefile) if necessary, to a special directory inside GiBUU.
2. Adding a dummy Fortran routine, also for LHAPDF support.
3. Increasing character array lengths to support long filesystem paths.
4. "Fixing" ROOT version detection (probably broke with recent ROOT versions).

## Running
### Requirements
* Write access to `$PWD`
* `$GIBUU` environment variable set to this directory
### Usage
Required options:
```
  --targ {p,D,He,Li,Be,C,N,Al,Ca,Fe,Cu,Ag,Sn,Xe,Au,Pb}
                        target nucleus
  --ebeam EBEAM         beam energy (GeV)
  --kt KT               kt value (GeV)
```
See `gibuu -h` for full options.
###What it does
1. generates a GiBUU configuration file based on command-line options and [this template](gibuu_template.opt)
1. runs `GiBUU.x` proper
1. runs `gibuu2lund` to generate `./gibuu.dat`

## See Also
* https://gibuu.hepforge.org/
* https://lhapdf.hepforge.org/
* https://github.com/alaoui-ah/GiBUU/tree/main/run_gibuu
