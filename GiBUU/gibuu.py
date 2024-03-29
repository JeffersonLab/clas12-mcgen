import os
import sys
import argparse
import tempfile
import subprocess

config_template = os.path.dirname(__file__)+'/gibuu_template.opt'

target_choices = {
    'p' : {'A':'1','Z':'1','pdfset':'3000000','numEnsem':'6000','lenPert':'15','shadow':'T','nuclPDF':'1','useJetSetVec':'T'},
    'D' : {'A':'2','Z':'1','pdfset':'3000300','numEnsem':'5000','lenPert':'20','shadow':'F','nuclPDF':'0','useJetSetVec':'F'},
    'He': {'A':'4','Z':'2','pdfset':'3000600','numEnsem':'4000','lenPert':'40','shadow':'T','nuclPDF':'1','useJetSetVec':'T'},
    'Li': {'A':'6','Z':'3','pdfset':'3000900','numEnsem':'3000','lenPert':'60','shadow':'T','nuclPDF':'1','useJetSetVec':'T'},
    'Be': {'A':'8','Z':'4','pdfset':'3001200','numEnsem':'2000','lenPert':'80','shadow':'T','nuclPDF':'1','useJetSetVec':'T'},
    'C' : {'A':'12','Z':'6','pdfset':'3001500','numEnsem':'1000','lenPert':'120','shadow':'T','nuclPDF':'1','useJetSetVec':'T'},
    'N' : {'A':'14','Z':'7','pdfset':'3001800','numEnsem':'1000','lenPert':'120','shadow':'T','nuclPDF':'1','useJetSetVec':'T'},
    'Al': {'A':'27','Z':'13','pdfset':'3002100','numEnsem':'500','lenPert':'250','shadow':'T','nuclPDF':'1','useJetSetVec':'T'},
    'Ca': {'A':'40','Z':'20','pdfset':'3002400','numEnsem':'300','lenPert':'360','shadow':'T','nuclPDF':'1','useJetSetVec':'T'},
    'Fe': {'A':'56','Z':'28','pdfset':'3002700','numEnsem':'100','lenPert':'560','shadow':'T','nuclPDF':'1','useJetSetVec':'T'},
    'Cu': {'A':'63','Z':'29','pdfset':'3003000','numEnsem':'100','lenPert':'560','shadow':'T','nuclPDF':'1','useJetSetVec':'T'},
    'Ag': {'A':'108','Z':'47','pdfset':'3003300','numEnsem':'100','lenPert':'1500','shadow':'T','nuclPDF':'1','useJetSetVec':'T'},
    'Sn': {'A':'118','Z':'50','pdfset':'3003600','numEnsem':'100','lenPert':'2000','shadow':'T','nuclPDF':'1','useJetSetVec':'T'},
    'Xe': {'A':'131','Z':'54','pdfset':'3003900','numEnsem':'100','lenPert':'3000','shadow':'T','nuclPDF':'1','useJetSetVec':'T'},
    'Au': {'A':'200','Z':'79','pdfset':'3004200','numEnsem':'100','lenPert':'4000','shadow':'T','nuclPDF':'1','useJetSetVec':'T'},
    'Pb': {'A':'207','Z':'82','pdfset':'3004500','numEnsem':'100','lenPert':'4000','shadow':'T','nuclPDF':'1','useJetSetVec':'T'}
}

cli = argparse.ArgumentParser()
cli.add_argument('-ebeam', required=True, help='beam energy in GeV', type=float)
cli.add_argument('-targ', required=True, choices=target_choices.keys())
cli.add_argument('-tgzpos', required=True, help='Target z position', type=float)
cli.add_argument('-tgzlen', required=True, help='Target z length', type=float)
cli.add_argument('-tgrad', required=True, help='Target Radius', type=float)
cli.add_argument('-kt', required=True, help='kt value', type=float)
cli.add_argument('-seed', default=0, help='RNG seed, defaults to timestamp', type=int)
cli.add_argument('-docker', default=False, action='store_true')
args = cli.parse_args(sys.argv[1:])

target = argparse.Namespace(**(target_choices[args.targ]))

buuDir = '.'

substitutions = {
    'numEnsembles' : target.numEnsem,
    'length_perturbative' : target.lenPert,
    'target_Z' : target.Z,
    'target_A' : target.A,
    'NNN' : args.targ,
    #'iExperiment=' : '4',
    #'EXPT' : 'clas11',
    'path_To_Input' : f'\'{buuDir}\'',
    'shadow' : target.shadow,
    'SEED' : str(args.seed),
    'useJetSetVec' : target.useJetSetVec,
    'NuclearPDFtype' : target.nuclPDF,
    'MSTP(51)' : target.pdfset,
    'PARP(91)' : str(args.kt),
    'PARP(92)' : str(args.kt),
    'Ebeam' : str(args.ebeam)
}

def get_config(substitutions):
    with open(config_template,'r') as f:
        for line in f.readlines():
            for k,v in substitutions.items():
                line = line.strip().replace(k,str(v))
            yield line

with open('./gibuu.opt','w') as config_file:
    config = list(get_config(substitutions))
    config_file.write(('\n'.join(config)))
    config_file.flush()
    #print(subprocess.check_output(['cat',config_file.name]))
    #cmd=['GiBUU.x','<',config_file.name]
    #print(' '.join(cmd))

