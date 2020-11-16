#!/bin/zsh

# the script must be run at jlab

source /group/clas12/packages/setup.sh
module load gcc/9.2.0
module load root

make -j10 2> errors.txt
echo
echo
export LD_LIBRARY_PATH=$PWD/lib:$LD_LIBRARY_PATH
export PATH=$PWD/bin:$PATH

export CLASDIS_PDF=$PWD/clasdis/pdf
export CLASPYTHIA_DECLIST=$PWD/claspyth
export CLASDVCS_PDF=$PWD/dvcsgen
export DISRAD_PDF=$PWD/inclusive-dis-rad
export DataKYandOnePion=$PWD/genKYandOnePion/data
export TCSGEN_DIR=$PWD/TCSGen
export TWOPEG_DATA_DIR=$PWD/twopeg

generators=(clasdis claspyth dvcsgen genKYandOnePion inclusive-dis-rad JPsiGen TCSGen twopeg)

declare -A executableN
declare -A outputExist

for g in $generators
	do
	eName=bin/$g
	eOut=$g".dat"
	echo testing:  $g
	executableN[$g]=":red_circle:"
	outputExist[$g]=":red_circle:"
	if test -f "$eName"; then
		executableN[$g]=":white_check_mark:"
		echo $eName" exists. testing --docker and --trig 10 options"
		bin/$g --docker --trig 10 --seed 123 > $g".log"
		echo checking for output $eOut
		if test -f "$eOut"; then
			echo $eOut" exists. "$g is good
			outputExist[$g]=":white_check_mark:"
		fi
		echo
	fi
done
echo
echo
echo "name | compilation and executable name | options and output ok | runs in container "
echo "---- | ------------------------------- | --------------------- | ----------------- "
for g in $generators
	do
	echo $g "|" $executableN[$g] "|" $outputExist[$g] "|" ":red_circle:" "|"
done
echo
echo

