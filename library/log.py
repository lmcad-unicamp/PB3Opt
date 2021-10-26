#!/usr/bin/python3

import statistics 

class Log:
    def __init__(self):
        print('      _                 _                           _     ')
        print('  ___| | ___  _   _  __| |  ___  ___  __ _ _ __ ___| |__  ')
        print(' / __| |/ _ \| | | |/ _` | / __|/ _ \/ _` | \'__/ __| \'_ \ ')
        print('| (__| | (_) | |_| | (_| | \__ \  __/ (_| | | | (__| | | |')
        print(' \___|_|\___/ \__,_|\__,_| |___/\___|\__,_|_|  \___|_| |_|')
        print('                                                          ')
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
