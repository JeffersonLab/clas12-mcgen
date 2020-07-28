#!/bin/zsh

source /group/clas12/packages/setup.sh
module load clas12/pro
make -j4 2> errors.txt
echo
echo

export CLASDIS_PDF=$PWD/clasdis/pdf
export CLASPYTHIA_DECLIST=$PWD/claspyth/pdf
export CLASDVCS_PDF=$PWD/dvcsgen
export DISRAD_PDF=$PWD/inclusive-dis-rad
export DataKYandOnePion=$PWD/genKYandOnePion/data
export TCSGEN_DIR=$PWD/TCSGen

generators=(clasdis claspyth dvcsgen genKYandOnePion inclusive-dis-rad JPsiGen TCSGen)

declare -A executableN
declare -A outputExist

for g in $generators
	do
	eName=$g/$g
	eOut=$g".dat"
	echo testing:  $g
	executableN[$g]=":red_circle:"
	outputExist[$g]=":red_circle:"
	if test -f "$eName"; then
		executableN[$g]=":white_check_mark:"
		echo $eName" exists. testing --docker and --trig 10 options"
		$g/$g --docker --trig 10 > /dev/null
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
echo "name | executable name | output ok"
echo "---- | --------------- | -------"
for g in $generators
	do
	echo $g "|" $executableN[$g] "|" $outputExist[$g]
done
echo
echo

