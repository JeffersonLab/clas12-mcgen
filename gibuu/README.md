# Just a recipe for building GiBUU.

(And fixing its build system for linking against a ROOT built with modern C++ support)

## Prerequisites
1. `wget`
2. ROOT
3. Reasonably modern `gcc`

## Build Procedure
* `make`

## Notes from Rhidian

To run GiBUU you simply need to run the following command:

`./${path_to_GiBUU_Executable}/GiBUU.x <${path_to_jobcard}/${jobcard}`

* `${path_to_GiBUU_Executable}` is where your gibuu executbale is located
* `${path_to_jobcard}` is the path to your job card
* `${jobcard}` is what you feed gibuu for your simulation

Examples of the gibuu job cards will be provided, but can also be found in `GiBUU/release2021/testRun/jobCards/ `
