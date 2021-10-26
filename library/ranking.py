#!/usr/bin/python3

import pandas as pd
import numpy as np

# ------------------------------------------------------------------------------------

def get_price_name(cluster, instances):
    query = instances[instances['name'] == cluster]
    if(len(query) == 0):
        return 0
    return float(query['price'])

def get_cost_list(BenchName, BenchInput, dataset, instances):
    query = dataset[(dataset['app_name'] == BenchName) & (dataset['input'] == BenchInput)]
    cluster_list = []
    cost_list = []
    for index, row in query.iterrows():
        p = get_price_name(row['cluster'], instances)
        c = ((float(row['total_time'])/60)/60)*p
        if(c < 0):
            c = 1000
        cluster_list.append(row['cluster'])
        cost_list.append(c)
    return pd.DataFrame({'cluster': cluster_list, 'cost': cost_list})

def sort_clusters(key, dataset, instances):
    clusters = dataset['cluster'].unique()
    for i in range(1,len(clusters)):
        j = i - 1
        buffer = clusters[i]
        aux1 = instances[instances['name'] == clusters[i]][key].iloc[0]
        aux2 = instances[instances['name'] == clusters[j]][key].iloc[0]
        while(j >= 0 and float(aux1) < float(aux2)):
            clusters[j+1] = clusters[j]
            j -= 1
            aux2 = instances[instances['name'] == clusters[j]][key].iloc[0]
            clusters[j+1] = buffer
    return clusters.tolist()

def get_app_rank(BenchName, BenchInput, dataset, instances):
    count_app = 0
    my_index = 1
    clusters = sort_clusters('price', dataset, instances)
    rank_list = np.zeros(len(clusters))
    my_list = get_cost_list(BenchName, BenchInput, dataset, instances)
    my_list = my_list.sort_values('cost')
    for index, row in my_list.iterrows():
        b = clusters.index(row['cluster'])
        rank_list[b] += my_index
        my_index += 1
        count_app += 1
    #for i in range(len(rank_list)):
    #    rank_list[i] = (len(clusters)-rank_list[i]) + 1
    return rank_list

def get_rank(c, dataset, instances, X, y):
    clusters = sort_clusters('price', dataset, instances)
    rank_list = np.zeros(len(clusters))
    count_app = 0
    apps = X['name'].unique()
    for index in range(len(apps)):
        if(c == y[index]):
            app = apps[index].split('-')[0]
            i = apps[index].split('-')[1]
            my_list = get_cost_list(app, i, dataset, instances)
            my_list = my_list.sort_values('cost')
            my_index = 1
            for index, row in my_list.iterrows():
                b = clusters.index(row['cluster'])
                rank_list[b] += my_index
                my_index += 1
            count_app += 1
    for i in range(len(rank_list)):
        rank_list[i] = rank_list[i]/count_app
    return clusters, rank_list
    
#def run_rank():
#    global instances, dataset, target
#
#    instances = pd.read_csv(InstancesFile, index_col=False, sep=',')
#    dataset = pd.read_csv(DatasetFile, index_col=False, sep=',')
#    t = pd.read_csv(DatasetTargetFile, index_col=False, sep=',')
#    
#    print('classe,cluster,rank')
#    classes = target['target'].unique()
#    for c in [1, 2, 3, 4]:
#        clusters, rank = get_rank(c)
#        for x in range(len(clusters)):
#            print(str(c)+','+clusters[x]+','+str(rank[x]))
