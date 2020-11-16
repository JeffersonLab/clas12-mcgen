This repository is a collection of generators distributed to the official CLAS12 Docker/Singularity containers for offsite (e.g. OSG) simulation jobs.
The generators are linked through git submodules: each is linked to a particular commit of the generator's github repository.

---

# Adding your event generator

If you want to add your generator to the CLAS12 containers follow this steps:

1. Create a github repository for your source code, ideally inside https://github.com/JeffersonLab
2. Make sure to include the README.md describing the generator and its options, and packages requirement
3. Have a working build system (for example a Makefile)
4. Satisfy the additional requirements below.
5. Send email to ungaro@jlab.org, baltzell@jlab.org (Mauri or Nathan) with the repository address,


---

# Requirements

- An executable with the same name as the github repository name, installed at the top level dir
- The generator output file name must be the same name as the exectuable + ".dat". For example, the output of clasdis must be clasdis.dat
- To specify the number of events, the option "--trig" must be used
- The argument --docker will be added by default to all executable. This option must be ignored or it can be used by the executable to set conditions to run on the OSG container
- The argument --seed \<integer value\> will be added by default to all executable. This option must be ignored or it can be used by the executable to set the generator random seed using \<integer value\>
- If --seed is ignored, the generator is responsible for choosing unique random seeds (without preserving state between jobs), which could be done from a millisecond or better precision system clock. 

# Test of requirements

We used this criteria to check if the requirements are met:

`genName --trig 10 --docker`

This should produce a file genName.dat.

The script `requirements.sh` will compile the generators, check for the executable names, run them with their environment and the above options, 
and check for the output file. It will output a table that is parsed below in the Requirements Summary.


# Additional Notes

- If libraries are needed, they should be put inside a lib directory, at the top level dir
- If necessary, an environment variable (name in its README) where the executable will look for data

Note: if you want to use `requirements.sh` to test your latest changes to the generator, make sure you update the submodules first:

`git submodule update --remote --merge .`


If you are the maintainer of a package and made changes that you want to include here, send emails to ungaro@jlab.org, baltzell@jlab.org (Mauri or Nathan) requesting the update.


# List of Generators 

name                 | summary description      | maintainer        | email             
-------------------- | ------------------------ | ----------------- | ----------------- 
clasdis              |  clas SIDIS MC based on PEPSI LUND MC                                    | Harut Avakian      |  avakian@jlab.org 
claspyth             | SIDIS full event generator based on PYTHIA                               | Harut Avakian      |  avakian@jlab.org 
dvcsgen              | DVCS/pi0/eta generator based on GPD and PDF parameterizations            | Harut Avakian      |  avakian@jlab.org 
genKYandOnePion      |  KY, pi0P and pi+N                                                       | Valerii Klimenko   |  valerii@jlab.org  
inclusive-dis-rad    | generates inclusive electron and optionally radiative photon using PDFs  | Harut Avakian      |  avakian@jlab.org 
tcsgen               | Timelike Compton Scattering                                              | Rafayel Paremuzyan | rafopar@jlab.org 
jpsigen              | J/Psi                                                                    | Rafayel Paremuzyan | rafopar@jlab.org 
twopeg               | pi+pi- electroproduction off protons                                     | Iuliia Skorodumina | skorodum@jlab.org

# Requirements Summary

* compilation and executable name 
  - compiles
  - executable name is the same as generator
* options and output ok  
  - options --docker is used or ignored
  - --trig is used to set the number of events
  - --seed is ignored or used to set the seed (the actual usage is not tested here)
  - the output filename is the generator + .dat
* runs in container:
  - runs with --docker --trig 10 --seed 123
  - the output filename is the generator + .dat

name | compilation and executable name | options and output ok | runs in container
---- | ------------------------------- | --------------------- | -----------------
clasdis | :white_check_mark: | :white_check_mark: | :white_check_mark: |
claspyth | :white_check_mark: | :white_check_mark: | :white_check_mark: |
dvcsgen | :white_check_mark: | :white_check_mark: | :white_check_mark: |
genKYandOnePion | :white_check_mark: | :white_check_mark: | :white_check_mark: |
inclusive-dis-rad | :white_check_mark: | :white_check_mark: | :white_check_mark: |
JPsiGen | :white_check_mark: | :white_check_mark: | :white_check_mark: |
TCSGen | :white_check_mark: | :white_check_mark: | :white_check_mark: |
twopeg | :white_check_mark: | :white_check_mark: | :white_check_mark: |
### emails

ungaro@jlab.org, baltzell@jlab.org, avakian@jlab.org, valerii@jlab.org, rafopar@jlab.org, skorodum@jlab.org

---

# clas12-mcgen maintanance

To clone / pull this repo:

`git clone  --recurse-submodules https://github.com/JeffersonLab/clas12-mcgen.git`

`git pull  --recurse-submodules`

---

### Dependencies

1. ROOT

---

### Notes on Updating Submodules

To update to the latest commit in one submodule:

`git submodule update --remote --merge ./inclusive-dis-rad/`

Or for all submodules:

`git submodule update --remote --merge .`

To update to a particular commit in a submodule:

* `cd ./inclusive-dis-rad`
* `git checkout bb9025c`

In all cases above, you'd need to subsequently commit (and push) the changes.


### To add a submodule:

`git submodule add submoduleRepo.git` 


### To remove a submodule:


* `git submodule deinit -f path/to/submodule`
* `rm -rf .git/modules/path/to/submodule`
* `git rm -f path/to/submodule`


