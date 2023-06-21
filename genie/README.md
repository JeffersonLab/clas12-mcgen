Just a recipe for building GiBUU.

1. Build the genie-specific dependencies:
 
   `make deps`

2. Build ROOT with pythia6 support:

   `make root ROOTSYS=/path/to/new/ROOT/installation`

3. Build genie:

   `source ROOTSYS/bin/thisroot.sh`

   `source env.sh`

   `make genie`

