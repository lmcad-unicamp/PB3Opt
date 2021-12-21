#!/usr/bin/python3

import numpy as np
import pandas as pd
import seaborn as sns
import matplotlib.pyplot as plt
from sklearn.cluster import KMeans
from math import sqrt

class Classifier:
    def __init__(self, random_state):
        self.model = None
        self.random_state = random_state

    def predict(self, X):
        return self.model.predict(X)

    def runElbow(self, X, auto_k):
        Sum_of_squared_distances = []
        K = range(2,11)
        for k in K:
            km = KMeans(n_clusters=k)
            km = km.fit(X)
            Sum_of_squared_distances.append(km.inertia_)
        plt.axvline(x=auto_k, label='line at x = {}'.format(3), c='r', linestyle='dashed')
        plt.legend(['x = '+str(auto_k)])
        plt.plot([K[0], K[len(K) - 1]],
                [Sum_of_squared_distances[0],
                Sum_of_squared_distances[len(Sum_of_squared_distances)-1]], c='r')
        plt.plot(K, Sum_of_squared_distances, 'ko-')
        plt.xlabel('K')
        plt.ylabel('Soma das distâncias ao quadrado')
        plt.grid()
        f = plt.figure()
        f.savefig("elbow.pdf", bbox_inches='tight')

    def runKKMeans(self, X, k):
        sns.set()
        model = KMeans(n_clusters=k, random_state=self.random_state)
        model.fit(X)
        y_kmeans = model.predict(X)
        labels = ['Classe 1', 'Classe 2', 'Classe 3', 'Classe 4', 'Centroide']
        t = pd.DataFrame(X.copy())
        t['cluster'] = y_kmeans
        f = plt.figure()
        ax = sns.scatterplot(x=0, y=1, hue="cluster", data=t, palette='deep', s=50);
        centers = model.cluster_centers_
        ax.scatter(centers[:, 0], centers[:, 1], c='black', s=20, alpha=0.6, label='center');
        #h,l = ax.get_legend_handles_labels()
        #ax.legend(h, labels) 
        #plt.xlabel('Componente Principal 1')
        #plt.ylabel('Componente Principal 2')
        #f.savefig("kmeans.pdf", bbox_inches='tight')

    def runKMeans(self, df, k):
        X = np.array(df.drop('name', axis=1))
        model = KMeans(n_clusters=k, random_state=self.random_state)
        model.fit(X)
        y_kmeans = model.predict(X)
        labels = ['Classe 1', 'Classe 2', 'Classe 3', 'Classe 4', 'Classe 5', 'Classe 6','Centroide']
        t = df.copy()
        t['cluster'] = y_kmeans
        f = plt.figure()
        ax = sns.scatterplot(x=0, y=1, hue="cluster", data=t, palette='deep', s=50);
        for i in range(len(y_kmeans)):
            ax.annotate(df['name'].iloc[i], (X[i,0], X[i,1]),  fontsize=8)

        centers = model.cluster_centers_
        ax.scatter(centers[:, 0], centers[:, 1], c='black', s=20, alpha=0.9, label='center', marker='x');

        h,l = ax.get_legend_handles_labels()
        ax.legend(h, labels) 

        plt.grid()
        ax.set_axisbelow(True)
        plt.xlabel('Componente Principal 1')
        plt.ylabel('Componente Principal 2')
        f.savefig("kmeans.pdf", bbox_inches='tight')

    def plotDF(self, df, df2):
        zeros = []
        for i in range(len(df)):
            zeros.append(0)

        ones = []
        for i in range(len(df2)):
            ones.append(1)

        f = plt.figure()
        X = np.array(df.drop('name', axis=1))

        t = df.copy()
        t['cluster'] = zeros

        t2 = df2.copy()
        t2['cluster'] = ones

        t3 = t2.append(t)
        print(t2)
        print(t)

        #ax = sns.scatterplot(x=0, y=1, hue="cluster", data=t, palette='deep', s=50);

        ax = sns.scatterplot(x=0, y=1, hue="cluster", data=t3, palette='deep', s=50);

        X = np.array(df2.drop('name', axis=1))
        for i in range(len(df2)):
            ax.annotate(df2['name'].iloc[i], (X[i,0], X[i,1]),  fontsize=8)

        X = np.array(df.drop('name', axis=1))
        for i in range(len(df)):
            ax.annotate(df['name'].iloc[i], (X[i,0], X[i,1]),  fontsize=8)

        labels = ['Conjunto de Treino', 'Conjunto de Teste']
        h,l = ax.get_legend_handles_labels()
        ax.legend(h, labels, loc='lower right') 

        plt.xlabel('Componente Principal 1')
        plt.ylabel('Componente Principal 2')
        plt.grid()
        ax.set_axisbelow(True)
        f.savefig("kmeans.pdf", bbox_inches='tight')

    def calculate_wcss(self, data):
        wcss = []
        k_range = range(2,11)
        for k in k_range:
            kmeans = KMeans(n_clusters=k, random_state=self.random_state)
            kmeans.fit(X=data)
            wcss.append(kmeans.inertia_)
        return wcss

    def get_opt_k(self, X):
        wcss = self.calculate_wcss(X)
        x1, y1 = 2, wcss[0]
        x2, y2 = 20, wcss[len(wcss)-1]
        distances = []

        for i in range(len(wcss)):
            x0 = i+2
            y0 = wcss[i]
            numerator = abs((y2-y1)*x0 - (x2-x1)*y0 + x2*y1 - y2*x1)
            denominator = sqrt((y2 - y1)**2 + (x2 - x1)**2)
            distances.append(numerator/denominator)

        return distances.index(max(distances)) + 2

    def fit(self, X):
        k = self.get_opt_k(X)
        #self.runKKMeans(X, k)
        self.model = KMeans(n_clusters=k, random_state=self.random_state).fit(X)
        return k

    def run(self, X_train, X_test):
        train_drop = np.array(X_train.drop('name', axis=1))
        test_drop = np.array(X_test.drop('name', axis=1))
        k = self.fit(train_drop)
        y_train = self.predict(train_drop)
        y_test = self.predict(test_drop)
        return k, y_train, y_test
