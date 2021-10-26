#!/usr/bin/python3

from matplotlib import markers
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
from enum import Enum
from numpy.random import seed
import math

import GPyOpt
import GPy

from GPyOpt.acquisitions.base import AcquisitionBase
from GPyOpt.acquisitions.EI import AcquisitionEI
from GPyOpt.methods import BayesianOptimization

# -------------------------------------------------------------------

# Input parameters
instances = []
dataset = []
dataset_t = []
dataset_r = []
clusters = []
X_Initial = []
Y_Initial = []
ObjBO = 0
verbose = True

# Bench parameters
BenchName = ''
BenchInput = ''
BenchTarget = 0

# Plot settings
fig, ax = plt.subplots()

#-------------------------------------------------------------------

class OBJ(Enum):
    OBJ1 = 0
    OBJ2 = 1
    OBJ3 = 2
    OBJ4 = 3

def get_obj(obj_str):
    if(obj_str == 'OBJ1'): # Total Time
        return OBJ.OBJ1
    elif(obj_str == 'OBJ2'): # Total Cost
        return OBJ.OBJ2
    elif(obj_str == 'OBJ3'): # Total Time 5PI
        return OBJ.OBJ5
    elif(obj_str == 'OBJ4'): # Total Cost 5PI
        return OBJ.OBJ6

#-------------------------------------------------------------------

def plot_domain():
    global clusters
    d = np.zeros(len(clusters))
    for x in range(0, len(clusters)):
        point = list([[x]])
        d[x] = objective(point)
    print(np.where(d == np.amin(d)))
    ax.set_ylabel("f(x)")
    ax.set_xlabel("GC Cluster (sorted)")
    plt.plot(d)
    ax.set_title(BenchName+'-'+BenchInput)

def get_optima():
    global clusters, verbose, BenchName, BenchInput
    y = list()
    points = list()
    for x in range(len(clusters)):
        point =list([[x]])
        points.append(point)
        y.append(objective(point))
    min_y = min(y)
    im = y.index(min_y)
    ix = points[im]
    return ix, y[im]

def get_cluster_name(point):
    global clusters
    name = clusters[int(point[0][0])]
    return name

def get_ttime_max():
    global BenchName, BenchInput
    query = dataset[(dataset['app_name'] == BenchName) & (dataset['input'] == BenchInput)]
    minfo = query.loc[query['total_time'].idxmax()]
    mcluster = minfo['cluster']
    mtime = float(minfo['total_time'])
    return mtime, mcluster

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

def get_5pitime(x):
    global BenchName, BenchInput
    cluster = get_cluster_name(x)
    query = dataset[(dataset['app_name'] == BenchName) & (dataset['input'] == BenchInput)]
    query = query[query['cluster'] == cluster]
    if(len(query) == 0):
        return 0
    ttime = float(query['pi_5'])
    if(ttime <= 0):
        return 0
    return ttime

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

def get_price(x):
    cluster = get_cluster_name(x)
    query = instances[instances['name'] == cluster]
    if(len(query) == 0):
        return 0
    return float(query['price'])

def get_price_name(cluster):
    query = instances[instances['name'] == cluster]
    if(len(query) == 0):
        return 0
    return float(query['price'])

def objective1(x):
    global clusters
    runtime = get_runtime(x)
    if(runtime == 0):
        return get_ttime_max()
    return (runtime/60)/60

def objective2(x):
    runtime = get_runtime(x)
    price = get_price(x)
    if(runtime == 0):
        return get_cost_max()
    return ((runtime/60)/60)*price

def objective3(x):
    runtime = get_5pitime(x)
    if(runtime == 0):
        return 100000
    return (runtime/60)/60

def objective4(x):
    runtime = get_5pitime(x)
    price = get_price(x)
    if(runtime == 0):
        return 100000
    return ((runtime/60)/60)*price

def objective(x):
    global ObjBO, verbose
    #if(verbose):
    #    print(x)
    if(ObjBO == OBJ.OBJ1):
        return objective1(x)
    elif(ObjBO == OBJ.OBJ2):
        return objective2(x)
    elif(ObjBO == OBJ.OBJ3):
        return objective3(x)
    elif(ObjBO == OBJ.OBJ4):
        return objective4(x)

def get_vcpus(cluster):
    return int(cluster.split('-')[2])*int(cluster.split('-')[3])

def sort_clusters(clusters):
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

def set_obj():
    global BenchTarget, clusters, dataset_t
    clusters = get_all_clusters()

def get_initials():
    global clusters
    points = []
    points.append(np.where(clusters == 'n1-standard-1-1')[0])
    points.append(np.where(clusters == 'n1-standard-1-8')[0])
    points.append(np.where(clusters == 'n1-standard-1-32')[0])
    points.append(np.where(clusters == 'n1-standard-8-1')[0])
    points.append(np.where(clusters == 'n1-standard-32-1')[0])
    points.append(np.where(clusters == 'n1-standard-16-16')[0])
    return np.array(points)

# -------------------------------------------------------------------

def run_rs(args):
    global BenchName, BenchInput, instances, dataset, ranking, order, plot, ObjBO
    InstancesFile  = args['instname']
    DatasetFile    = args['dfname']
    BenchName      = args['benchname']
    BenchInput     = args['benchinput']
    ranking        = args['ranking']
    order          = args['ranking_order']
    initial        = args['initial'] # 1, 4, 8, 16, 32, 50
    ObjBO          = get_obj(args['obj'])
    OutputPath     = args['outname']
    PlotName       = OutputPath + 'rs' + '-' + BenchName + '-' + BenchInput
    OutputFile     = OutputPath + BenchName + '-' + BenchInput + '.out.' + 'rs'
    ite            = args['iterations']

    instances = pd.read_csv(InstancesFile, index_col=False, sep=',')
    dataset = pd.read_csv(DatasetFile, index_col=False, sep=',')

    set_obj()
    initials = get_initials()

    d = {'rank': ranking, 'cluster': order}
    df = pd.DataFrame(d)
    query = df.sort_values(['rank'])

    count = 1
    best_f = 1000
    best_x = 0

    f = open(OutputFile, 'w')
    for x in initials:
        if(objective([x]) < best_f):
                best_x = x[0]
                best_f = objective([x])
        f.write(str(count) + '\t' + str(objective([x])) + '\t' + str(x[0]) + '\n')
        count += 1
    
    for index, row in query.iterrows():
        c = row['cluster']
        n = np.where(clusters == c)[0][0]
        if(n not in initials):
            f.write(str(count) + '\t' + str(objective([[n]])) + '\t' + str(n) + '\n')
            count += 1
        if(count > ite):
            break

    ix, y = get_optima()
    f = open(OutputFile + '.info', 'w')
    f.write('Optima: name=%s, y=%f, x=%d\n' % (clusters[ix[0][0]], y, ix[0][0]))
    f.write('Best found: x=%s, y=%f\n' % (clusters[int(best_x)], best_f))

    get_optima()
    f = open(OutputFile + '.info', 'w')

if __name__ == '__main__':
    main()
