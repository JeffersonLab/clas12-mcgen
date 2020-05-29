The generators in this repository will be available in the official CLAS12 Docker/Singularity containers for offsite (e.g. OSG) simulation jobs.

To clone / pull this repo:

`git clone  --recurse-submodules git@github.com:JeffersonLab/clas12-mcgen.git`

`git pull  --recurse-submodules`

---

# Requirements

- A github repository, ideally inside https://github.com/JeffersonLab
- A README in each github describing the generator and its options, and packages requirement
- A working build system 
- An executable with the same name as the github repository name, installed at the top level dir
- If libraries are needed, they should be put inside a lib directory, at the top level dir
- The generator output file name must be the same name as the exectuable + ".dat". For example, the output of clasdis must be clasdis.dat
- To specify the number of events, the option "--trig" must be used
- If necessary, an environment variable (name in its README) where the executable will look for data
- the optional argument --docker will be added by default to all executable. This option can be ignored or used by the executable to set conditions to run on the OSG container


# Generators 

name                 | summary description      | maintainer        | email             | requirements met
-------------------- | ------------------------ | ----------------- | ----------------- | ---------------------
clasdis              |  clas SIDIS MC based on PEPSI LUND MC                                    | Harut Avakian     |  avakian@jlab.org | :red_circle: 
claspyth             | SIDIS full event generator based on PYTHIA                               | Harut Avakian     |  avakian@jlab.org |  :red_circle: 
dvcsgen              | DVCS/pi0/eta generator based on GPD and PDF parameterizations            | Harut Avakian     |  avakian@jlab.org | :red_circle: 
genKYandOnePion      |  KY, pi0P and pi+N                                                       | Valerii Klimenko  |  valerii@jlab.org | :white_check_mark: 
inclusive-dis-rad    | generates inclusive electron and optionally radiative photon using PDFs  | Harut Avakian     |  avakian@jlab.org | :red_circle: 
tcsgen               | Timelike Compton Scattering                                              | Rafayel Paremuzyan | rafopar@jlab.org | :red_circle: 
jpsigen              | J/Psi                                                                    | Rafayel Paremuzyan | rafopar@jlab.org | :red_circle: 


### emails

ungaro@jlab.org, baltzell@jlab.org, avakian@jlab.org, valerii@jlab.org, rafopar@jlab.org

---

## Updating a generator

Each generator is linked to a particular commit of its github repository.
If you are the maintainer of a package and made changes since that commit that you want to include here, submit a PR or send email to:

ungaro@jlab.org, baltzell@jlab.org

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


