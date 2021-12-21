#!/usr/bin/python3

import pandas as pd
import numpy as np
from enum import Enum
from numpy.random import seed
import GPyOpt
import GPy
from GPyOpt.acquisitions.base import AcquisitionBase
from GPyOpt.acquisitions.EI import AcquisitionEI
from GPyOpt.methods import BayesianOptimization
from numpy.random import seed
import matplotlib.pyplot as plt

# --------------------------------------------------------------------------------------------

# Input parameters
instances = []
dataset = []
clusters = []
ranking = []
order = []
ModeBO = 0
ObjBO = 0
verbose = False
plot = False

# Bench parameters
BenchName = ''
BenchInput = ''
BenchTarget = 0

# --------------------------------------------------------------------------------------------

class AcquisitionNew(AcquisitionBase):
    analytical_gradient_prediction = False
    def __init__(
            self,
            model,
            space,
            optimizer=None,
            cost_withGradients=None,
            jitter=0.01):
        super(AcquisitionNew, self).__init__(model, space, optimizer)
        self.jitter = jitter
        self.EI = AcquisitionEI(model, space, optimizer, cost_withGradients)

    def distance_improvement(self, x, ei):
        global clusters, ModeBO

        dis_x = []
        prob = np.zeros(len(x))

        for i in range(len(x)):
            c = clusters[int(x[i][0])]
            r = ranking[order.index(c)]
            prob[i] = r

        for i in range(len(x)):
            prob[i] = max(prob) - prob[i] + 1

        p = prob/len(clusters)
        for i in range(len(x)):
            if(ModeBO == Mode.BO2):
                dis_x.append(p[i]*ei[i][0] + ei[i][0])
            else:
                dis_x.append([p[i]*ei[i][0]])

        return np.array(dis_x)

    def acquisition_function(self, x):
        global ModeBO
        acqu_x = np.zeros((x.shape[0],1))       
        acqu_x = self.EI.acquisition_function(x)
        if(ModeBO == Mode.BO1 or ModeBO == Mode.BO3):
            return acqu_x
        dis_x = self.distance_improvement(x, acqu_x)
        return dis_x

    def acquisition_function_withGradients(self,x):
        print('gradients')
        acqu_x      = np.zeros((x.shape[0],1))
        acqu_x_grad = np.zeros(x.shape)
        acqu_x, acqu_x_grad = self.EI.acquisition_function_withGradients(x)
        return acqu_x, acqu_x_grad

# --------------------------------------------------------------------------------------------

class Mode(Enum):
    BO1 = 0
    BO2 = 1
    BO3 = 2
    BO4 = 3
    BO5 = 4

def get_mode(mode_str):
    if(mode_str == 'BO1'):   # BO Default
        return Mode.BO1
    elif(mode_str == 'BO2'): # BO with classification
        return Mode.BO2
    elif(mode_str == 'BO3'): # BO Default (initials)
        return Mode.BO3
    elif(mode_str == 'BO4'): # BO with classification v2
        return Mode.BO4
    elif(mode_str == 'BO5'): # BO with classification v2 without initials
        return Mode.BO5

class OBJ(Enum):
    OBJ1 = 0
    OBJ2 = 1
    OBJ3 = 2
    OBJ4 = 3

def get_obj(obj_str):
    if(obj_str == 'OBJ1'):   # Total Time
        return OBJ.OBJ1
    elif(obj_str == 'OBJ2'): # Total Cost
        return OBJ.OBJ2
    elif(obj_str == 'OBJ3'): # Total Time 5PI
        return OBJ.OBJ3
    elif(obj_str == 'OBJ4'): # Total Cost 5PI
        return OBJ.OBJ4

# --------------------------------------------------------------------------------------------

#def plot_initials(X_initial, Y_initial):
#    global clusters, nodes
#    i = 0
#    y = np.zeros((len(clusters) * len(nodes)))
#    for x in range(len(clusters)):
#        for n in range(len(nodes)):
#            point = list([[x,n]])
#            y[i] = objective(point)
#            i += 1
#    plt.scatter(range(len(clusters)*len(nodes)), y)
#    plt.plot(range(len(clusters)*len(nodes)), y)
#    for i in range(len(X_initial)):
#        p = X_initial[i]
#        y = objective([p])
#        plt.scatter(p[0]*len(nodes) + p[1], y, marker='o', c = 'red')
#    plt.show()
#    return

def plot_domain(PlotName):
    global clusters
    fig = plt.figure()
    ax = fig.add_subplot(111)
    d = np.zeros(len(clusters))
    for x in range(0, len(clusters)):
        point = list([[x]])
        d[x] = objective(point)
    print(np.where(d == np.amin(d)))
    ax.set_ylabel("f(x)")
    ax.set_xlabel("Aglomerado de Computadores (x)")
    plt.plot(d)
    ax.set_title(BenchName+'-'+BenchInput)
    plt.grid()
    ax.set_axisbelow(True)
    fig.savefig(PlotName+'-domain.pdf')

def get_optima():
    global clusters, BenchName, BenchInput
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

def get_pi_max():
    global BenchName, BenchInput
    query = dataset[(dataset['app_name'] == BenchName) & (dataset['input'] == BenchInput)]
    cmax = 0
    for index, row in query.iterrows():
        p = get_price_name(row['cluster'])
        c = ((float(row['pi_5'])/60)/60)*p
        if(c > cmax):
            cmax = c
    return cmax*2

def get_5pitime(x):
    global BenchName, BenchInput
    cluster = get_cluster_name(x)
    query = dataset[(dataset['app_name'] == BenchName) & (dataset['input'] == BenchInput)]
    print(cluster)
    query = query[query['cluster'] == cluster]
    if(len(query) == 0):
        return 0
    ttime = float(query['pi_5'])
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
        return get_pi_max()
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

def get_domain():
    global clusters
    domain = [
        {'name': 'machine','type': 'discrete','domain': range(0, len(clusters))},
    ]
    return domain

def set_obj():
    global clusters
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

# --------------------------------------------------------------------------------------------

def run_bo(args, my_seed):
    global BenchName, BenchInput, instances, dataset, ObjBO, ModeBO, ranking, order, plot, verbose
    InstancesFile  = args['instname']
    DatasetFile    = args['dfname']
    BenchName      = args['benchname']
    BenchInput     = args['benchinput']
    ModeBO         = get_mode(args['mode'])
    ObjBO          = get_obj(args['obj'])
    ranking        = args['ranking']
    order          = args['ranking_order']
    initial        = args['initial'] # 1, 4, 8, 16, 32, 50
    OutputPath     = args['outname']
    ite            = args['iterations']
    plot           = args['plot']
    verbose        = args['verbose']
    PlotName       = OutputPath + args['mode'] + '-' + BenchName + '-' + BenchInput
    OutputFile     = OutputPath + BenchName + '-' + BenchInput + '.out.' + (args['mode']).lower()
    
    instances = pd.read_csv(InstancesFile, index_col=False, sep=',')
    dataset = pd.read_csv(DatasetFile, index_col=False, sep=',')

    seed(my_seed)
    set_obj()
    domain = get_domain()

    objective_model = GPyOpt.core.task.SingleObjective(objective)
    model = GPyOpt.models.GPModel(optimize_restarts=5, exact_feval=True, verbose=False, sparse=False)
    space = GPyOpt.Design_space(space = domain, store_noncontinuous=True)
    aquisition_optimizer = GPyOpt.optimization.AcquisitionOptimizer(space=space, optimizer='lbfgs')
    initial_design = GPyOpt.experiment_design.initial_design('random', space, initial)
    acquisition = AcquisitionNew(
            model,
            space,
            optimizer=aquisition_optimizer)
    evaluator = GPyOpt.core.evaluators.Sequential(acquisition)

    if(ModeBO == Mode.BO1 or ModeBO == Mode.BO5):
        bo = GPyOpt.methods.ModularBayesianOptimization(
                model,
                space,
                objective_model,
                acquisition,
                evaluator,
                initial_design,
                de_duplication=True)
    else:
        initials = get_initials()
        bo = GPyOpt.methods.ModularBayesianOptimization(
                model,
                space,
                objective_model,
                acquisition,
                evaluator,
                X_init=initials,
                de_duplication=True)

    bo.run_optimization(max_iter = ite, evaluations_file=OutputFile)

    ix, y = get_optima()
    f = open(OutputFile + '.info', 'w')
    f.write('Optima: name=%s, y=%f, x=%d\n' % (clusters[ix[0][0]], y, ix[0][0]))
    f.write('Best found: x=%s, y=%f\n' % (clusters[int(bo.x_opt[0])], bo.fx_opt))

    if(plot):
        plot_domain(PlotName)        
        bo.plot_convergence(filename=PlotName+'-conv.pdf')
        bo.plot_acquisition(filename=PlotName+'-acq.pdf')
