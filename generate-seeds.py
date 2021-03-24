#!/usr/bin/env python3

# generate-seeds.py -h
# generate-seeds.py generate
# generate-seeds.py read -row 128

import os,sys,time,random,argparse

MAXSEEDS = 1000
FILEPATH = 'random-seeds.txt'

cli = argparse.ArgumentParser(description='Random Number Seed Manager')
subcli = cli.add_subparsers(dest='command')
cli.add_argument('--filename',metavar='PATH',help='path to seed file (default='+FILEPATH+')',default=FILEPATH)

cli_gen = subcli.add_parser('generate')
cli_read = subcli.add_parser('read')
cli_read.add_argument('--row',metavar='#',help='row number in seed file',type=int,required=True)

args = cli.parse_args()

if args.command == 'generate':
  random.seed(int(time.time()*1e6))
  fd = os.open(FILEPATH,os.O_WRONLY|os.O_CREAT)
  with os.fdopen(fd,'w') as f:
    for i in range(MAXSEEDS):
      # maximum signed 32-bit int
      f.write('%d\n'%random.randint(1e9,0x7FFFFFFF))

else:
  if args.row<0 or args.row>=MAXSEEDS:
    print('Row must be between 0 and '+str(MAXSEEDS-1)+' inclusive.')
    sys.exit(1)
  with open(FILEPATH,'r') as f:
    for row,line in enumerate(f.readlines()):
      if args.row == row:
        print(line.strip())
        sys.exit(0)


