#!/usr/bin/env python3
import os
import sys
import time
import argparse
import subprocess

#
# extracted from https://github.com/alaoui-ah/GiBUU/tree/main/run_gibuu 
#

config_template = os.getenv('GIBUU','.')+'/gibuu_template.opt'
buu_dir = os.getenv('GIBUU','.')+'/buuinput'

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

def check_executable(exe):
    try:
        subprocess.check_output(['which', exe])
        return True
    except subprocess.CalledProcessError:
        return False

def get_config(template, substitutions):
    with open(template,'r') as f:
        for line in f.readlines():
            if line.find('=') > 0:
                k = line[:line.find('=')].strip()
                if k in substitutions:
                    line = line[:line.find('=')+1]
                    line += substitutions.get(k)
            yield line.rstrip()

def run_command(cmd, dryrun):
    print(' '.join(cmd))
    if not dryrun:
        p = subprocess.Popen(cmd,stdout=subprocess.PIPE,stderr=subprocess.STDOUT,universal_newlines=True)
        for line in iter(p.stdout.readline, ''):
            if len(line.strip())>0:
                print((line.rstrip()))
        p.wait()
        return p.returncode == 0
    return True

cli = argparse.ArgumentParser()
cli.add_argument('-ebeam', required=True, help='beam energy (units=GeV)', type=float)
cli.add_argument('-targ', required=True, choices=target_choices.keys())
cli.add_argument('-kt', required=True, help='kt value (units=?)', type=float)
cli.add_argument('-seed', default=int(time.time()), help='random number generator seed (default=clock)', type=int)
cli.add_argument('-dryrun', default=False, action='store_true')
cli.add_argument('-docker', default=False, help='ignored', action='store_true')
args = cli.parse_args(sys.argv[1:])

if not os.path.isdir(buu_dir):
    print('ERROR:  could not find \'buuinput\' subdirectory in $GIBUU or .')
    sys.exit(1)

if not os.path.isfile(config_template):
    print('ERROR:  could not find \'gibuu_template.opt\' in $GIBUU or .')
    sys.exit(2)

if not check_executable('GiBUU.x'):
    print('ERROR:  could not find \'GiBUU.x\' in $PATH')
    sys.exit(3)

if not check_executable('gibuu2lund'):
    print('ERROR:  could not find \'gibuu2lund\' in $PATH')
    sys.exit(4)

target = argparse.Namespace(**(target_choices[args.targ]))

substitutions = {
    'numEnsembles' : target.numEnsem,
    'length_perturbative' : target.lenPert,
    'target_Z' : target.Z,
    'target_A' : target.A,
    'path_To_Input' : f'\'{buu_dir}\'',
    'shadow' : target.shadow,
    'SEED' : str(args.seed),
    'useJetSetVec' : target.useJetSetVec,
    'NuclearPDFtype' : target.nuclPDF,
    'MSTP(51)' : target.pdfset,
    'PARP(91)' : str(args.kt),
    'PARP(92)' : str(args.kt),
    'Ebeam' : str(args.ebeam),
    #
    # Are these for custom version of GiBUU?
    #'NNN' : args.targ,
    #'iExperiment=' : '4',
    #'EXPT' : 'clas11',
    #
}

config = list(get_config(config_template, substitutions))
config_path = './gibuu-%d.opt'%args.seed
if not args.dryrun:
    with open(config_path,'w') as config_file:
        config_file.write(('\n'.join(config)))
result = run_command(['GiBUU.x','<',config_path], args.dryrun)
result = run_command(['gibuu2lund','gibuu.txt'], args.dryrun)

