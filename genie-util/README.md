A clas12 wrapper script and LUND converter for GENIE.

_Note, GENIE requires a large startup time for calculations that (should) get reused across many jobs._

## See also
* https://github.com/GENIE-MC/Generator

## Prerequesites
1. GSL, not included because it seems to be standard in package managers, e.g., `yum install gsl-devel`, and a local install caused issues with ROOT's XRootD build
    * Looks like libxml2 is also standard, but currently include in the build procedure below 
2. `wget`
3. Reasonably modern `gcc` and `cmake`

## Notes from Rhidian

Before running genie, please see Nathan's notes on getting genie started and sourcing the relevant/required environments!

/////////////////////////////////////////////////////////////////////////////////

To run genie you need to first generate a spline file (.xml) which contains the cross sections for generating your genie events later on. This is because, to the best of my knowledge, genie does not output cross sections or weights in the event tree. To make the .xml file run the following command:

`gmkspl -p ${probe} -n ${nEvents} -t ${target} -e ${Energy} -o ${output_name}.xml --tune ${tune} --event-generator-list EM`

* `${probe}` is the pdg of the incident beam, e.g. 11 for electron
* `${nEvents}` I recommend 250
* `${target}` should be provided by the following key:

* L: strange number (0 for stable nuclei)
* ZZZ: 3-digit atomic number
* AAA: 3-digit mass number
* I: isomer number (0 for ground-state nuclei)

Relevant targets for RGM:
| Hydrogen (1H) |   t   | L | ZZZ | AAA | I |
|---------------|-------|---|-----|-----|---|
| Deuteron (2H) | -t 10 | 0 | 001 | 002 | 0 |
| Helium-4      | -t 10 | 0 | 002 | 004 | 0 |
| Carbon-12     | -t 10 | 0 | 006 | 012 | 0 |
| Calcium-40    | -t 10 | 0 | 020 | 040 | 0 |
| Calcium-48    | -t 10 | 0 | 020 | 048 | 0 |
| Argon-40      | -t 10 | 0 | 018 | 040 | 0 |
| Sn-120        | -t 10 | 0 | 050 | 120 | 0 |

`${Energy}` is incident beam energy
`${output_name}` is output file name
`${tune}` genie parameter tuning e.g. `G18_10a_02_11a` (there are others available and can be seen through genie webpage https://hep.ph.liv.ac.uk/~costasa/genie/index.html

NOTE: This usually takes quite a few hours!

/////////////////////////////////////////////////////////////////////////////////

After generating the spline file, we can then generate events using genie. Run the following command to generate events in genie:

`gevgen -n ${nEvents} -e ${Energy} -p ${probe} -t ${target} --tune ${tune} --event-generator-list EM --seed ${seed} --cross-sections ${spline_file}.xml -o ${output}.ghep.root`

* `${seed}` is a random number
* `${spline_file}` is your .xml file with your cross sections
* `${output}` is your output file

/////////////////////////////////////////////////////////////////////////////////

After generating events, you can run the following command to produce a browse-able root file, which is in a more familiar format for most users:

`gntpc -i ${input}.ghep.root -o ${output}.gst.root -f gst`

`${input}` is your input .ghep.root file
`${output}` is your output .gst.root file

/////////////////////////////////////////////////////////////////////////////////

You will also need to convert your cross section file from a .xml file to a .root file so you can view the cross sections in a histogram. To do so run the following command:

`gspl2root -f ${spline_file}.xml --event-generator-list EM -p ${probe} -t ${target} -o {output_spline}.root --tune ${tune}`

`${output_spline}` is the output spline file in .root format

