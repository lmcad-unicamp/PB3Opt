#!/usr/bin/python3

import pandas as pd
import random
import numpy as np
import os
import matplotlib.pyplot as plt
from sklearn.preprocessing import StandardScaler
from sklearn.model_selection import KFold
from sklearn.decomposition import PCA
from library.classifier import Classifier
from sklearn.cluster import KMeans
from library import ranking
from library.log import Log
from library import ranksearch
from library import utils
from library import bosearch
from scipy import spatial

# --------------------------------------------------------------------------------------------

class CloudSearch:
    def __init__(self, args):
        self.DatasetFile = args.searchspace
        self.InstancesFile = args.virtualmachine
        self.OutputPath = args.output
        self.AppsFile = args.wprofile
        self.instances = pd.read_csv(self.InstancesFile, index_col=False, sep=',')
        self.dataset = pd.read_csv(self.DatasetFile, index_col=False, sep=',')
        self.dfApps = pd.read_csv(self.AppsFile, index_col=False, sep=',')
        self.verbose = args.verbose
        self.iterations = args.iterations
        self.initial = args.initial
        self.plot = args.plot
        self.df = None
        self.mode = args.mode
        self.train = args.train
        self.objective = args.objective
        self.log = Log()
        self.log.printArgs(args)

    def runAnalisses(self, r_app, r, order):
        return 1 - spatial.distance.cosine(r_app, r)
        my_mins = utils.get_top_list(5, r_app)
        c_mins = utils.get_top_list(5, r)

        b = 0
    
        for my_index in my_mins:
            for c_index in c_mins:
                if(c_index == my_index):
                    return 1
    
        return b

    def getAnalisses(self, r_app, r, order):
        return 1 - spatial.distance.cosine(r_app, r)
        my_mins = utils.get_top_list(5, r_app)
        c_mins = utils.get_top_list(5, r)

        b = 0
    
        for my_index in my_mins:
            for c_index in c_mins:
                if(c_index == my_index):
                    return b+1
    
        return b

    def getInitials(self, order):
        points = []
        points.append(order.index('n1-standard-1-1'))
        points.append(order.index('n1-standard-1-8'))
        points.append(order.index('n1-standard-8-1'))
        points.append(order.index('n1-standard-1-32'))
        points.append(order.index('n1-standard-32-1'))
        points.append(order.index('n1-standard-16-16'))
        return np.array(points)

    def plotBiplot(self, score, coeff):
        xs = score[:,0]
        ys = score[:,1]
        n = coeff.shape[0]
        plt.figure(figsize=(10,8), dpi=100)
        plt.scatter(xs, ys)

        for i in range(n):
            plt.arrow(0, 0, coeff[i,0], coeff[i,1], color = 'k', 
                    alpha = 0.9,linestyle = '-',linewidth = 1.5, overhang=0.2)
            plt.text(coeff[i,0]* 1.15, coeff[i,1] * 1.15, 
                    "F"+str(i+1), color = 'k', ha = 'center', va = 'center',fontsize=10)

        plt.xlabel("PC{}".format(1), size=14)
        plt.ylabel("PC{}".format(2), size=14)
        limx= int(xs.max()) + 1
        limy= int(ys.max()) + 1
        plt.xlim([-limx,limx])
        plt.ylim([-limy,limy])
        plt.grid()
        plt.tick_params(axis='both', which='both', labelsize=14)
        plt.show()

    def plotScreePlot(self):
        scaler = StandardScaler()
        dfDrop = np.array(self.dfApps.drop('name', axis=1))
        scaledDf = scaler.fit_transform(dfDrop)
        scaledDf = pd.DataFrame(scaledDf)
        pca = PCA().fit(scaledDf)
        X_new = pca.fit_transform(scaledDf)
        #self.plotBiplot(X_new[:,0:2], np.transpose(pca.components_[0:2, :]))

        f = plt.figure()
        plt.axvline(x=3, label='line at x = {}'.format(3), c='r', linestyle='dashed')
        plt.legend(['x = 3'])
        plt.plot(range(1, len(np.cumsum(pca.explained_variance_ratio_))+1),
               np.cumsum(pca.explained_variance_ratio_), 'ko-')
        plt.xlabel('Número de Componentes')
        plt.ylabel('Variância Cumulativa Explicada');
        plt.grid()
        plt.show()
        f.savefig("pca-2.pdf", bbox_inches='tight')
        PC_values = np.arange(pca.n_components_) + 1

        f = plt.figure()
        plt.axhline(y=1, label='line at y = {}'.format(3), c='r', linestyle='dashed')
        plt.legend(['y = 1'])
        plt.plot(PC_values, pca.explained_variance_, 'ko-', linewidth=2)
        plt.xlabel('Componente Principal')
        plt.ylabel('Autovalor')
        plt.grid()
        plt.show()
        f.savefig("pca-1.pdf", bbox_inches='tight')
    
    def runPCA(self):
        scaler = StandardScaler()
        dfDrop = np.array(self.dfApps.drop('name', axis=1))
        scaledDf = scaler.fit_transform(dfDrop)
        scaledDf = pd.DataFrame(scaledDf)
        pca = PCA(n_components=3)
        Xpca = pca.fit_transform(scaledDf)
        self.df = pd.DataFrame(Xpca)
        self.df['name'] = self.dfApps['name']

    def getAppTarget(self, target, op, r_app, X_train, y_train, k):
        if(op == 0):
            return target
        elif(op == 1):
            target -= 1
            if(target < 0):
                target = 3
            return target
        elif(op == 2):
            return random.randint(0, k-1)
        elif(op == 3):
            min = 10
            target = 0
            for c in range(k):
                order, rank = ranking.get_rank(c, self.dataset, self.instances, X_train, y_train)
                b = self.getAnalisses(r_app, rank, order)
                if(b < min):
                    target = c
                    min = b
            return target
        elif(op == 4):
            max = 0
            target = 0
            for c in range(k):
                order, rank = ranking.get_rank(c, self.dataset, self.instances, X_train, y_train)
                b = self.getAnalisses(r_app, rank, order)
                if(b > max):
                    target = c
                    max = b
            return target
        elif(op == 5):
            for c in range(4):
                order, rank = ranking.get_rank(c, self.dataset, self.instances, X_train, y_train)
                b = analisses(r_app, rank, order)
                if(b == 1):
                    return c
            return target

    def create_dir(self, path):
        try:
            os.mkdir(path)
        except OSError as error:
            if(self.verbose):
                self.log.printError(error)

    def runFold(self, rnum, path, k, X_train, y_train, X_test, y_test):
        args = {
                'benchname': None,
                'benchinput': None,
                'instname': self.InstancesFile,
                'dfname': self.DatasetFile,
                'ranking': [],
                'ranking_order': [],
                'obj': self.objective,
                'mode': self.mode,
                'outname': path,
                'initial': self.initial,
                'iterations': self.iterations,
                'verbose': self.verbose,
                'plot': self.plot
        }
        acc = []
        for i in range(len(X_test)):
            name = X_test.iloc[i]['name']
            my_name = name.split('-')[0]
            my_input = name.split('-')[1]

            r_app = ranking.get_app_rank(my_name, my_input, self.dataset, self.instances)
            target = self.getAppTarget(y_test[i], 4, r_app, X_train, y_train, k)
            order, rank = ranking.get_rank(target, self.dataset, self.instances, X_train, y_train)
            b = self.runAnalisses(r_app, rank, order)

            args['benchname'] = my_name
            args['benchinput'] = my_input
            args['ranking'] = rank
            args['ranking_order'] = order
            acc.append(b)
            
            if(args['mode'] == 'RS'):
                ranksearch.run_rs(args)
            else:
                bosearch.run_bo(args, rnum)

        return acc

    def runTest(self, rnum, path, k, X_train, y_train, X_test, y_test):
        args = {
                'benchname': None,
                'benchinput': None,
                'instname': self.InstancesFile,
                'dfname': self.DatasetFile,
                'ranking': [],
                'ranking_order': [],
                'obj': self.objective,
                'mode': self.mode,
                'outname': path,
                'initial': self.initial,
                'iterations': self.iterations,
                'verbose': self.verbose,
                'plot': self.plot
        }
        acc = []

        for i in range(len(X_test)):
            name = X_test.iloc[i]['name']
            my_name = name.split('-')[0]
            my_input = name.split('-')[1]

            print(my_name, my_input)
            r_app = ranking.get_app_rank(my_name, my_input, self.dataset, self.instances)
            target = self.getAppTarget(y_test[i], 0, r_app, X_train, y_train, k)
            order, rank = ranking.get_rank(target, self.dataset, self.instances, X_train, y_train)
            b = self.runAnalisses(r_app, rank, order)

            args['benchname'] = my_name
            args['benchinput'] = my_input
            args['ranking'] = rank
            args['ranking_order'] = order
            acc.append(b)

            if(args['mode'] == 'RS'):
                ranksearch.run_rs(args)
            else:
                bosearch.run_bo(args, rnum)

        return acc

    def runSearch(self, k):
        random_n = 5
        times = 1
        acc_g = []
        if(self.train):
            for rnum in random.sample(range(0, 100), random_n):
                kf = KFold(n_splits=k, shuffle=True, random_state=rnum)
                fold = 1
                for train_index, test_index in kf.split(self.df):
                    path = self.OutputPath + '-' + str(times) + '-' + str(fold) + '/'
                    self.create_dir(path)
                    X_train = self.df.iloc[train_index]
                    X_test = self.df.iloc[test_index]

                    if(self.verbose):
                        print(len(X_train))
                        print(len(X_test))

                    model = Classifier(rnum)
                    auto_k, y_train, y_test = model.run(X_train, X_test)
                    acc = self.runFold(rnum, path, auto_k, X_train, y_train, X_test, y_test)
                    if(self.verbose):
                        self.log.printFold(times, fold, acc)
                        self.log.printK(auto_k)
                    acc_g.append(sum(acc)/len(acc))
                    fold += 1
                times += 1
            self.log.printAccuracy(acc_g)
        else:
            for rnum in random.sample(range(0, 100), random_n):
                path = self.OutputPath + '-' + str(times) + '/'
                self.create_dir(path)
                X_test = self.df.head(26)
                X_train = self.df.tail(38)
                model = Classifier(rnum)
                if(self.plot):
                    model.plotDF(X_train, X_test)
                auto_k, y_train, y_test = model.run(X_train, X_test)
                acc = self.runTest(rnum, path, auto_k, X_train, y_train, X_test, y_test)
                self.log.printAccuracy(acc)
                if(self.verbose):
                    #self.log.print(times, acc)
                    self.log.printAccuracy(acc)
                    self.log.printK(auto_k)
                acc_g.append(sum(acc)/len(acc))
                times += 1
            self.log.printAccuracy(acc_g)
