#!/usr/bin/python3

import statistics 

class Log:
    def __init__(self):
        print('----------------------------------------------------------')
        print('          ____  ____ _____  ___        _     ')
        print('         |  _ \| __ )___ / / _ \ _ __ | |_   ')
        print('         | |_) |  _ \ |_ \| | | | \'_ \| __| ')
        print('         |  __/| |_) |__) | |_| | |_) | |_   ')
        print('         |_|   |____/____/ \___/| .__/ \__|  ')
        print('                                |_|          ')
        print('----------------------------------------------------------')

    def printArgs(self, args):
        print('    Dataset:\t', args.dfname)
        print('  Instances:\t', args.dfiname)
        print('Application:\t', args.dfappname)
        print('     Output:\t', args.output)
        print(' Iterations:\t', args.iterations)
        print('    Initial:\t', args.initial)
        print('  Objective:\t', args.objective)
        print('       Mode:\t', args.mode)
        print('    Verbose:\t', args.verbose)
        print('       Plot:\t', args.plot)
        print('----------------------------------------------------------')

    def printFold(self, times, fold, acc):
        print(times, fold)
        acc_v = round(sum(acc)/len(acc), 3)
        print('Accuracy: ', acc_v)

    def printError(self, error):
        print('[error]: ', error)
        print('----------------------------------------------------------')

    def printK(self, k):
        print('k: ', k)
        print('----------------------------------------------------------')

    def printAccuracy(self, acc):
        print('Accuracy: ', sum(acc)/len(acc), statistics.stdev(acc))
        print('----------------------------------------------------------')
