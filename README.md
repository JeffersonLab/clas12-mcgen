This repository is the collection of generators available in the CLAS12 Docker/Singularity containers for offsite (e.g. OSG) simulation jobs.  These generators are also available for use on JLab machines via the [CLAS12 environment](https://clasweb.jlab.org/wiki/index.php/CLAS12_Software_Environment_@_JLab) module `mcgen`.

# Current Generators 

name                 | description                                                    | maintainer
-------------------- | -------------------------------------------------------------- | ------------------
[clasdis]            | SIDIS MC based on PEPSI LUND MC                                | Harut Avakian
[claspyth]           | SIDIS full event generator based on PYTHIA                     | Harut Avakian
[dvcsgen]            | DVCS/pi0/eta generator based on GPD and PDF parameterizations  | Harut Avakian
[genKYandOnePion]    | KY, pi0P and pi+N                                              | Valerii Klimenko
[inclusive-dis-rad]  | Inclusive electron and optionally radiative photon using PDFs  | Harut Avakian
[tcsgen]             | Timelike Compton Scattering                                    | Rafayel Paremuzyan
[jpsigen]            | J/Psi                                                          | Rafayel Paremuzyan
[twopeg]             | pi+pi- electroproduction off protons                           | Iuliia Skorodumina
[clas12-elspectro]   | General electroproduction final states                         | Derek Glazier
[MCEGENpiN_radcorr]  | Exclusive single pion electroproduction based on MAID          | Maksim Davydov
[deep-pipi-gen]      | Deep double pion production                                    | Dilini Bulumulla
[genepi]             | Photon and meson electroproduction                             | Noémie Pilleuxi
GiBUU                | not supported on OSG yet, pending configuration wrapper script |
GENIE                | not supported on OSG yet, pending configuration wrapper script |

# Adding or Modifying a Generator

1. Create a github repository for your source code, ideally inside https://github.com/JeffersonLab
2. Make sure to include the README.md describing the generator, its options, and requirements
3. Have a working build system (for example a Makefile)
4. Satisfy the additional requirements described below
5. Send email to Mauri (`ungaro at jlab.org`) or Nathan (`baltzell at jlab.org`) with the repository address and the git tag to use

# Requirements

- C/C++ or Fortran with a working GNU make or cmake build system compliant with GCC no less than 9.0
- All python should be python3-compatible
- An executable with the same name as the github repository name, installed at the top level directory
- If shared libraries are needed, the build system should put them inside a top level "lib" directory
- Required environment variables should be described in the repository's README.md
- Have a command-line option to set the output file name, or default to the same name as the exectuable + `.dat`. For example, the output of clasdis must be clasdis.dat
- The follow command-line arguments are always passed to all generators on OSG:
  - `--trig #` must be honored and used to specify the number of events to generate.
  - `--docker` must be accepted as a valid argument and can be ignored or used for setting conditions for OSG.
  - `--seed #` must be accepted as a valid argument and can be ignored or used to initialize the event generator's RNG.  Its value is a 32-bit RNG seed based on system clock with microsecond precision.  If `--seed` is ignored, the generator is responsible for choosing unique random seeds, without preserving state between jobs, which can be done from a millisecond or better precision system clock.
- A git tag to reference for including the generator as a submodule into this repository.  Note [versions.json](versions.json) stores the current verisions for insertion into the data stream.

### Test of Requirements

We use this command line to check if the runtime requirements are met:

```
GENERATOR_NAME --trig 10 --docker --seed 1448577483
```

That should produce a file `GENERATOR_NAME.dat` in the current working directory.

The script `requirements.zsh` will compile all the generators, check for their executable names, run them with their environment and the above options, and check for the output file, and then output the table in the next section.

### Requirements Summary

name | compilation and executable name | CLI options | runs in container w/ output
---- | ------------------------------- | --------------------- | -----------------
clasdis | :white_check_mark: | :white_check_mark: | :white_check_mark: |
claspyth | :white_check_mark: | :white_check_mark: | :white_check_mark: |
dvcsgen | :white_check_mark: | :white_check_mark: | :white_check_mark: |
genKYandOnePion | :white_check_mark: | :white_check_mark: | :white_check_mark: |
inclusive-dis-rad | :white_check_mark: | :white_check_mark: | :white_check_mark: |
JPsiGen | :white_check_mark: | :white_check_mark: | :white_check_mark: |
TCSGen | :white_check_mark: | :white_check_mark: | :white_check_mark: |
twopeg | :white_check_mark: | :white_check_mark: | :white_check_mark: |
clas12-elSpectro | :white_check_mark: | :white_check_mark: | :white_check_mark: |
MCEGENpiN_radcorr | :white_check_mark: | :white_check_mark: | :white_check_mark: |
deep-pipi-gen | :white_check_mark: | :white_check_mark: | :white_check_mark: |
genepi | :white_check_mark: | :white_check_mark: | :white_check_mark: |

# Maintanance

To clone this repo:
```
git clone  --recurse-submodules https://github.com/JeffersonLab/clas12-mcgen.git
git checkout <tagversion>
```
To compile on JLab machines:
```
source /group/clas12/packages/setup.sh
module load gcc
module load cmake
module load root
make -j8
```
To compile in the singularity container on JLab machines:
```
module load singularity
singularity shell --home ${PWD}:/srv --pwd /srv --bind /cvmfs --contain --ipc --pid --cleanenv /cvmfs/singularity.opensciencegrid.org/jeffersonlab/clas12software:production
source /srv/root-6.22.06-build/bin/thisroot.sh
make -j8
```
To test builds on CVMFS in the singularity container:
```
singularity shell --home ${PWD}:/srv --pwd /srv --bind /cvmfs --contain --ipc --pid --cleanenv /cvmfs/singularity.opensciencegrid.org/jeffersonlab/clas12software:production
source /etc/profile.d/modules.sh
source /cvmfs/oasis.opensciencegrid.org/jlab/hallb/clas12/soft/setup.sh
module load root mcgen
```
_Starting with some later versions of ROOT, if it is moved after it's built, then linking against it doesn't always appear to work.  Hopefully there is some way to address that properly, meanwhile the `$ROOTSYS` above must be where it was originally built (e.g. cannot be its final destination on CVMFS).  A centos8 build of ROOT is available at `/work/clas12/users/baltzell/Linux_Centos8...` that can be used for building clas12-mcgen in singularity.  Its exact path in the container must be `/srv/root-6.22.06-build`!_

*Similarly, some generators (clas12-elSpectro) that leverage ROOT do not work at runtime if moved after compilation.  A workaround for that is setting `$ROOT_INCLUDE_PATH`, and that is done in the CVMFS environment module for clas12-mcgen.*

*Maybe ROOT should be built with --prefix specified and installed and then it would be easily copiable.  Try that next time.  Another option is chroot.*

### Dependencies/Requirements

1. ROOT with MathMore and Minuit2
2. cmake >= 2.9
3. gcc >= 8.0
4. On OSX, `brew install findutils`

### Notes on Updating Submodules

To update to the latest commit in one submodule:
```
git submodule update --remote --merge ./inclusive-dis-rad/
```
Or for all submodules:
```
git submodule update --remote --merge .
```
To update to a particular commit or tag in a submodule:
```
cd ./inclusive-dis-rad
git checkout bb9025c
git checkout v1.0
```
If that submodule has its own submodules, then, in addition need to:
```
git submodule update --recursive
```
In all cases above, you'd need to subsequently commit (and push) the changes.

### To add a submodule:
```
git submodule add submoduleRepo.git
```
If the submodule has its own submodules, this is necessary:
```
git submodule --init --recursive path
```
### To remove a submodule:
```
git submodule deinit -f path/to/submodule
rm -rf .git/modules/path/to/submodule
git rm -f path/to/submodule
```


[clasdis]: https://github.com/jeffersonlab/clasdis 
[claspyth]: https://github.com/jeffersonlab/claspyth
[dvcsgen]: https://github.com/jeffersonlab/dvcsgen
[genKYandOnePion]: https://github.com/ValeriiKlimenko/genKYandOnePion
[inclusive-dis-rad]: https://github.com/jeffersonlab/inclusive-dis-rad
[tcsgen]: https://github.com/jeffersonlab/tcsgen
[jpsigen]: https://github.com/jeffersonlab/jpsigen
[twopeg]: https://github.com/skorodumina/twopeg
[clas12-elspectro]: https://github.com/dglazier/clas12-elspectro/
[MCEGENpiN_radcorr]: https://github.com/Maksaska/MCEGENpiN_radcorr 
[deep-pipi-gen]: https://github.com/jeffersonlab/deep-pipi-gen
[genepi]: https://github.com/N-Plx/genepi
