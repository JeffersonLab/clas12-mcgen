The generators in this repository will be available in the official CLAS12 Docker/Singularity containers for offsite (e.g. OSG) simulation jobs.

To clone this repo:

`git clone  --recurse-submodules git@github.com:JeffersonLab/clas12-mcgen.git`

# Requirements

- A github repository, ideally inside jeffersonlab
- A README in each github describing the generator and its options
- An executable with the same name as the github repository name
- If necessary, an environment variable with the same name as the repository name where the executable will look for data


# Generators 

name                 | summary description          | maintainer        | email             | requirements met
-------------------- | ---------------------------- | ----------------- | ----------------- | ---------------------
clasdis-nocernlib    |   SIDIS MC based on PEPSI    | Harut Avakian     |  avakian@jlab.org | :red_circle: executable and environment variable name
claspyth-nocernlib   | PYTHIA                       | Harut Avakian     |  avakian@jlab.org | :red_circle: executable and environment variable name
dvcsgen              | :red_circle: no description  | Harut Avakian     |  avakian@jlab.org | :red_circle: executable and environment variable name
genKYandOnePion      |  :red_circle: no description | Valerii Klimenko  |  valerii@jlab.org | :red_circle: executable and environment variable name
inclusive-dis-rad    | :red_circle: no description  | Harut Avakian     |  avakian@jlab.org | :red_circle: executable and environment variable name
TCSGen               | Timelike Compton Scattering  | Rafayel Paremuzyan | rafopar@jlab.org | :red_circle: executable and environment variable name


---

### Dependencies

1. ROOT

### Notes on Updating Submodules

To update to the latest commit in one submodule:

`git submodule update --remote --merge ./inclusive-dis-rad/`

Or for all submodules:

`git submodule update --remote --merge .`

To update to a particular commit in a submodule:

* `cd ./inclusive-dis-rad`
* `git checkout bb9025c`

In all cases above, you'd need to subsequently commit (and push) the changes.




### emails

ungaro@jlab.org, baltzell@jlab.org, avakian@jlab.org, valerii@jlab.org


