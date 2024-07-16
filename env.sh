
if [[ "$0" =~ "zsh" ]]; then
  d=$(cd $(dirname ${(%):-%N}) && pwd -P)
else
  d=$(cd $(dirname ${BASH_SOURCE[0]:-$0}) && pwd -P)
fi

export PATH=$d/bin:${PATH}
export LD_LIBRARY_PATH=$d/lib:$d/lib64:${LD_LIBRARY_PATH}
export PYTHONPATH=$d/lib64/python3.9/site-packages:${PYTHONPATH}

export CLASDIS_PDF=$d/clasdis/pdf
export CLASPYTHIA_DECLIST=$d/claspyth
export CLASDVCS_PDF=$d/dvcsgen
export DISRAD_PDF=$d/inclusive-dis-rad
export DataKYandOnePion=$d/genKYandOnePion/data
export TCSGEN_DIR=$d/TCSGen
export TWOPEG_DATA_DIR=$d/twopeg
export C12ELSPECTRO=$d/clas12-elSpectro
export ELSPECTRO=${C12ELSPECTRO}/elSpectro
export CLAS_PARMS=$d/onepigen
export GENIE=$d/genie/genie
export GIBUU=$d/gibuu
export GENEPI=$d/genepi

export PYTHIA8DATA=$d/share/Pythia8/xmldoc

export LHAPDF_DATA_PATH=/cvmfs/sft.cern.ch/lcg/external/lhapdfsets/current:$d/share/LHAPDF

