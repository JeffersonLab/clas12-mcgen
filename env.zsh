
d="$( cd "$( dirname "${(%):-%N}" )" && pwd )"

export LD_LIBRARY_PATH=$d/lib:$LD_LIBRARY_PATH
export PATH=$d/bin:$PATH

export CLASDIS_PDF=$d/clasdis/pdf
export CLASPYTHIA_DECLIST=$d/claspyth
export CLASDVCS_PDF=$d/dvcsgen
export DISRAD_PDF=$d/inclusive-dis-rad
export DataKYandOnePion=$d/genKYandOnePion/data
export TCSGEN_DIR=$d/TCSGen
export TWOPEG_DATA_DIR=$d/twopeg
export C12ELSPECTRO=$d/clas12-elSpectro
export ELSPECTRO=$C12ELSPECTRO/elSpectro
export CLAS_PARMS=$d/onepigen

