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
source /cvmfs/oasis.opensciencegrid.org/jlab/hallb/clas12/sw/setup.sh
module load root mcgen
```
<!--_Starting with some later versions of ROOT, if it is moved after it's built, then linking against it doesn't always appear to work.  Hopefully there is some way to address that properly, meanwhile the `$ROOTSYS` above must be where it was originally built (e.g. cannot be its final destination on CVMFS).  A centos8 build of ROOT is available at `/work/clas12/users/baltzell/Linux_Centos8...` that can be used for building clas12-mcgen in singularity.  Its exact path in the container must be `/srv/root-6.22.06-build`!_

*Similarly, some generators (clas12-elSpectro) that leverage ROOT do not work at runtime if moved after compilation.  A workaround for that is setting `$ROOT_INCLUDE_PATH`, and that is done in the CVMFS environment module for clas12-mcgen.*

*Maybe ROOT should be built with --prefix specified and installed and then it would be easily copiable.  Try that next time.  Another option is chroot.*
-->
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
