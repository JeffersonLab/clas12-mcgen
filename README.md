The generators in this repository will be available in the official CLAS12 Docker/Singularity containers for offsite (e.g. OSG) simulation jobs.

To clone this repo:

`git clone  --recurse-submodules git@github.com:JeffersonLab/clas12-mcgen.git`


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

