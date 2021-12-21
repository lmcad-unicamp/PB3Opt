#!/usr/bin/python

from matplotlib import pyplot as plt
import os
import numpy as np
import statistics 
import argparse
import pandas as pd

# -------------------------------------------------------------------------------------

N = 30
Imput = ''
subpath = ''

instances = []
dataset = []
clusters = []

BenchName = ''
BenchInput = ''

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

def get_price_name(cluster):
    query = instances[instances['name'] == cluster]
    if(len(query) == 0):
        return 0
    return float(query['price'])

def get_cluster_name(point):
    global clusters
    name = clusters[int(point)]
    return name

def get_cost_max():
    global BenchName, BenchInput
    query = dataset[(dataset['app_name'] == BenchName) & (dataset['input'] == BenchInput)]
    cmax = 0
    for index, row in query.iterrows():
        p = get_price_name(row['cluster'])
        c = ((float(row['total_time'])/60)/60)*p
        if(c > cmax):
            cmax = c
    return cmax*2

def get_cost_min():
    global BenchName, BenchInput
    query = dataset[(dataset['app_name'] == BenchName) & (dataset['input'] == BenchInput)]
    cmin = 100000
    for index, row in query.iterrows():
        p = get_price_name(row['cluster'])
        c = ((float(row['total_time'])/60)/60)*p
        if(c < cmin and c > 0):
            cmin = c
    return cmin

def get_vcpus(cluster):
    return int(cluster.split('-')[2])*int(cluster.split('-')[3])

def sort_clusters(clusters):
    global instances
    for i in range(1,len(clusters)):
        j = i - 1
        buffer = clusters[i]
        aux1 = instances[instances['name'] == clusters[i]]['price'].iloc[0]
        aux2 = instances[instances['name'] == clusters[j]]['price'].iloc[0]
        while(j >= 0 and float(aux1) < float(aux2)):
            clusters[j+1] = clusters[j]
            j -= 1
            aux2 = instances[instances['name'] == clusters[j]]['price'].iloc[0]
            aux2_n = (get_vcpus(clusters[j]))
        aux1_n = (get_vcpus(clusters[i]))
        aux2_n = (get_vcpus(clusters[j]))
        aux2 = instances[instances['name'] == clusters[j]]['price'].iloc[0]
        while(j >= 0 and float(aux1) == float(aux2) and float(aux1_n) < float(aux2_n)):
            clusters[j+1] = clusters[j]
            j -= 1
            aux2 = instances[instances['name'] == clusters[j]]['price'].iloc[0]
            aux2_n = (get_vcpus(clusters[j]))
        clusters[j+1] = buffer
    return clusters

def get_all_clusters():
    global dataset
    clusters = dataset['cluster'].unique()
    return sort_clusters(clusters)

def get_all_files(path):
    files = []
    for f1 in os.listdir(path):
        for f2 in os.listdir(path+'/'+f1):
            if('info' not in path+'/'+f1+'/'+f2):
                files.append(path+'/'+f1+'/'+f2)
    return files

def get_price(x):
    global instances
    cluster = get_cluster_name(x)
    query = instances[instances['name'] == cluster]
    if(len(query) == 0):
        return 0
    return float(query['price'])

def get_runtime(x):
    global BenchName, BenchInput
    cluster = get_cluster_name(x)
    query = dataset[(dataset['app_name'] == BenchName) & (dataset['input'] == BenchInput)]
    query = query[query['cluster'] == cluster]
    if(len(query) == 0):
        return 0
    ttime = float(query['total_time'])
    if(ttime <= 0):
        return 0
    return ttime

def objective(x):
    runtime = get_runtime(x)
    price = get_price(x)
    if(runtime == 0):
        return get_cost_max()
    return ((runtime/60)/60)*price

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
                cluster_id = int(float(buffer[2]))
                if(ite >= N):
                    break
                value = float(buffer[1])
                #value = objective(cluster_id)
                outs[ite - 1] = value
    file_op.close()
    return outs

def process(f, target):
    global BenchName, BenchInput
    f_new = f
    best = []
    name = f.split('/')[2]
    bo = name.split('.')[2]
    app = name.split('.')[0]
    BenchName = app.split('-')[0]
    BenchInput = app.split('-')[1]
    results = get_array(f_new)
    opt = get_cost_min()
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
    global BenchName, BenchInput
    f_new = f
    best = []
    name = f.split('/')[2]
    bo = name.split('.')[2]
    app = name.split('.')[0]
    BenchName = app.split('-')[0]
    BenchInput = app.split('-')[1]
    results = get_array(f_new)
    #opt = get_optima(f_new)
    opt = get_cost_min()
    mi = results[0]
    mi = round(mi, 6)/round(opt, 6)
    ite = 1
    sum = 0
    for v in results:
        vn = v/opt
        vn = round(v, 6)/round(opt, 6)
        sum += vn
        print(str(ite) + ',' + str(target) + ',' + str(bo) + ','  + str(app) + ','  + str(sum))
        ite += 1
    #return best

# -------------------------------------------------------------------------------------

def main():
    global Input, subpath, instances, dataset, apps, clusters

    args           = parser.parse_args()
    Input          = args.input
    OutputFile     = args.outname
    CostMode       = args.cost

    instances = pd.read_csv("../csvs/instances.csv", index_col=False, sep=',')
    dataset = pd.read_csv("../csvs/dataset-all-2.csv", index_col=False, sep=',')
    clusters = get_all_clusters()
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
