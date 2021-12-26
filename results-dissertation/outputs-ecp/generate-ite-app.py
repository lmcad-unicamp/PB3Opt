#!/usr/bin/python

from matplotlib import pyplot as plt
import os
import numpy as np
import statistics 
import argparse

# -------------------------------------------------------------------------------------

N = 30
Imput = ''
subpath = ''

# -------------------------------------------------------------------------------------
parser = argparse.ArgumentParser(description='Cloud Configuration Bayesian Search Analisys.\n')

parser.add_argument('-i',
        '--input',
        type=str,
        help='Input Files Path (default: output/)',
        default='output/')
parser.add_argument('-o',
        '--outname',
        type=str,
        help='Output File Name (default: output.out)',
        default='output.out')
parser.add_argument('-c',
        '--cost',
        type=bool,
        help='Is cost mode: True or False (default: False)',
        default=False)
parser.add_argument('-hd',
        '--head',
        type=bool,
        help='Dump head: True or False (default: False)',
        default=False)
parser.add_argument(
        '-t',
        '--target',
        type=int, help='Target Number (default: 0)',
        default=0)

# -------------------------------------------------------------------------------------

def get_all_files(path):
    files = []
    for f1 in os.listdir(path):
        for f2 in os.listdir(path+'/'+f1):
            if('info' not in path+'/'+f1+'/'+f2 and 'laghos' in f2):
                files.append(path+'/'+f1+'/'+f2)
    return files

def get_optima(f):
    f_new = f + '.info'
    file_op = open(f_new, 'r')
    lines = file_op.readlines()
    for l in lines:
        if('Optima:' in l):
            buffer = (l.split('=')[2]).split(',')[0]
            return float(buffer)
        
def get_array(f):
    outs = np.zeros(N)
    file_op = open(f, 'r')
    lines = file_op.readlines()
    for l in lines:
        if(not 'Iteration' in l):
            l = l.replace('\n', '')
            buffer = l.split('\t')
            if(len(buffer) > 1):
                ite = int(float(buffer[0]))
                if(ite >= N+1):
                    break
                value = float(buffer[1])
                outs[ite - 1] = value
    file_op.close()
    return outs

def process(f, target):
    f_new = f
    best = []
    name = f.split('/')[2]
    bo = name.split('.')[2]
    app = name.split('.')[0]
    results = get_array(f_new)
    opt = get_optima(f_new)
    mi = results[0]
    mi = round(mi, 6)/round(opt, 6)
    ite = 1
    for v in results:
        vn = v/opt
        vn = round(v, 6)/round(opt, 6)
        if(vn < mi and vn > 0):
            mi = vn
        best.append(mi-1)
        print(str(ite) + ',' + str(target) + ',' + str(bo) + ','  + str(app) + ','  + str(mi))
        ite += 1

def process_cost(f, target):
    f_new = f
    best = []
    name = f.split('/')[2]
    bo = name.split('.')[2]
    app = name.split('.')[0]
    results = get_array(f_new)
    opt = get_optima(f_new)
    mi = results[0]
    mi = round(mi, 6)/round(opt, 6)
    ite = 1
    sum = 0
    for v in results:
        vn = v/opt
        vn = round(v, 6)/round(opt, 6)
        #if(vn < mi and vn > 0):
        #    mi = vn
        #best.append(mi-1)
        sum += vn
        print(str(ite) + ',' + str(target) + ',' + str(bo) + ','  + str(app) + ','  + str(sum))
        ite += 1
    #return best

# -------------------------------------------------------------------------------------

def main():
    global Input, subpath

    args           = parser.parse_args()
    Input          = args.input
    OutputFile     = args.outname
    CostMode       = args.cost

    apps = []
    files = get_all_files(Input)
    if(args.head):
        print('ite,target,bo,name,best')
    for app in files:
        if(not CostMode):
            process(app, args.target)
        else:
            process_cost(app, args.target)

if __name__ == '__main__':
    main()
