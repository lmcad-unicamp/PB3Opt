#!/usr/bin/python3

import argparse
import random
from library.cloudsearch import CloudSearch
from library.bosearch import run_bo

# ----------------------------------------------------------------------------

parser = argparse.ArgumentParser(description='Cloud Configuration Bayesian Search.\n')
parser.add_argument(
        '-df',
        '--dfname',
        type=str, help='Dataset file name (default: dataset.csv)',
        default='dataset.csv')
parser.add_argument(
        '-dfi',
        '--dfiname',
        type=str,
        help='Instances dataset file name (default: instances.csv)',
        default='instances.csv')
parser.add_argument(
        '-dfapp',
        '--dfappname',
        type=str,
        help='App dataset file name (default: dataset-app.csv)',
        default='dataset-app.csv')
parser.add_argument(
        '-o',
        '--output',
        type=str,
        help='Output Path Name (default: output/)',
        default='output')
parser.add_argument(
        '-m',
        '--mode',
        type=str,
        help='BO Mode (default: BO1)',
        default='BO1')
parser.add_argument(
        '-obj',
        '--objective',
        type=str,
        help='Objective (default: OBJ1)',
        default='OBJ1')
parser.add_argument(
        '-i',
        '--initial',
        type=int, help='Number of Initial Random Guesses (default: 1)',
        default=1)
parser.add_argument(
        '-n',
        '--iterations',
        type=int,
        help='Number of Guesses (default: 12)',
        default=12)
parser.add_argument(
        '-p',
        '--plot',
        help='Plot data',
        action='store_true')
parser.add_argument(
        '-v',
        '--verbose',
        help='Print Iteration Results',
        action='store_true')
parser.add_argument(
        '-t',
        '--train',
        help='Run training mode',
        action='store_true')

# ----------------------------------------------------------------------------

def main():
    random.seed(0)
    args = parser.parse_args()
    cloudSearch = CloudSearch(args)
    cloudSearch.runPCA()
    cloudSearch.runSearch(5)

if __name__ == '__main__':
    main()
