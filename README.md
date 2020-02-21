The generators in this repository will be available in the official CLAS12 Docker/Singularity containers for offsite (e.g. OSG) simulation jobs.

To clone this repo:

`git clone  --recurse-submodules git@github.com:JeffersonLab/clas12-mcgen.git`

# Requirements

- A github repository, ideally inside https://github.com/JeffersonLab
- A README in each github describing the generator and its options, and packages requirement
- A working build system 
- An executable with the same name as the github repository name, installed at the top level dir
- If libraries are needed, they should be put inside a lib directory, at the top level dir
- If necessary, an environment variable with the same name as the repository name where the executable will look for data


# Generators 

name                 | summary description          | maintainer        | email             | requirements met
-------------------- | ---------------------------- | ----------------- | ----------------- | ---------------------
clasdis-nocernlib    |   SIDIS MC based on PEPSI    | Harut Avakian     |  avakian@jlab.org | :red_circle: executable and environment variable name
claspyth-nocernlib   | PYTHIA                       | Harut Avakian     |  avakian@jlab.org | :red_circle: executable and environment variable name
dvcsgen              | DVCS/pi0/eta generator based on GPD and PDF parameterizations  | Harut Avakian     |  avakian@jlab.org | :red_circle: executable and environment variable name
genKYandOnePion      |  :red_circle: no description | Valerii Klimenko  |  valerii@jlab.org | :red_circle: executable and environment variable name
inclusive-dis-rad    | :red_circle: no description  | Harut Avakian     |  avakian@jlab.org | :red_circle: executable and environment variable name
TCSGen               | Timelike Compton Scattering  | Rafayel Paremuzyan | rafopar@jlab.org | :red_circle: executable and environment variable name


### emails

ungaro@jlab.org, baltzell@jlab.org, avakian@jlab.org, valerii@jlab.org, rafopar@jlab.org

---

## Updating a generator

Each generator is linked to a particular commit of its github repository.
If you are the maintainer of a package and made changes since that commit that you want to include here, please send email to:

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


