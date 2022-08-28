          ____  ____ _____  ___        _     
         |  _ \| __ )___ / / _ \ _ __ | |_   
         | |_) |  _ \ |_ \| | | | '_ \| __| 
         |  __/| |_) |__) | |_| | |_) | |_   
         |_|   |____/____/ \___/| .__/ \__|  
                                |_|          
The Profile-Based Biased Bayesian Optimization (PB3Opt) implements Cloud Configuration Bayesian Search. 

## DETAILS

This repository also implements the following approaches:

* **BO-6rnd-EIdef**: Bayesian optimization using the default Expected Improvement (EI) function to pick the point to be observed and the Gaussian process as the probabilistic model.
Besides that, it starts with six random points;
* **BO-6rnd-EIbiased**: Bayesian optimization using our biased Expected Improvement (EI) function to pick the point to be observed and the Gaussian process as the probabilistic model. Besides that, it starts with the six strategic computer clusters points as starting points;
* **BO-6sel-EIdef**: Bayesian optimization equals BO-6rnd-EIdef, however, it starts with six strategic computer clusters as starting points; and
* **Ranking Search**: Search for the optimal computer cluster on the list defined by the average-ranking of the group that the workload was predicted to. In this case, the observations are performed according to the order of computer clusters in the average-ranking of the group.

In this context, we implemented five modes (BO1, RS, BO3, BO4, BO5). Thus, we have that:

* BO1 is the BO default (BO-6rnd-EIdef)
* BO3 is the BO-6sel-EIdef
* BO4 is the PB3Opt
* BO5 is the BO-6rnd-EIbiased
* RS is the Ranking-Search

Besides that, we implemented two objective functions (OBJ1 and OBJ2). Where, OBJ1 is about experimentation cost and OBJ2 is about experimentation time. We also implemented OBJ3 for experimentation cost with PI and OBJ4 for experimentation time with PI.

## DATASETS

Our datasets are available in the csvs/ path. Each dataset file is explaned below:

* **instance.csv**: Computer clusters instance type file.
* **dataset-treino.csv**: Search space of train dataset.
* **dataset-teste.csv**: Search space of all dataset.
* **dataset-apps-treino.csv**: Workload-Profile dataset of train dataset.
* **dataset-apps-teste.csv**: Workload-Profile dataset of all dataset.
* **dataset-teste-pi.csv**: Search space of test dataset with paramount iteration.
* **dataset-apps-pi-treino.csv**: Workload-Profile dataset of train dataset with paramount iteration.
* **dataset-apps-pi-teste.csv**: Workload-Profile dataset of all dataset with paramount iteration.

# USAGE

Use the [GPy](https://github.com/SheffieldML/GPy) and [GPyOpt library](https://github.com/lmcad-unicamp/GPyOpt) with Python 3.8. After installing GPy and GPyOpt, you can easily use it using the following commands:

```
usage: python3 main.py [-h] [-ss SEARCHSPACE] [-vm VIRTUALMACHINE] [-wp WPROFILE] [-o OUTPUT] [-m MODE] [-obj OBJECTIVE] [-i INITIAL] [-n ITERATIONS] [-p]
               [-v] [-t]

Cloud Configuration Bayesian Search.

optional arguments:
  -h, --help            show this help message and exit
  -ss SEARCHSPACE, --searchspace SEARCHSPACE
                        Search space dataset file name (default: csvs/dataset-treino.csv)
  -vm VIRTUALMACHINE, --virtualmachine VIRTUALMACHINE
                        Instances (virtual machines) dataset file name
                        (default: csvs/instances.csv)
  -wp WPROFILE, --wprofile WPROFILE
                        Workload-Profile dataset file name (default: csvs/dataset-apps-treino.csv)
  -o OUTPUT, --output OUTPUT
                        Output Path Name (default: output/)
  -m MODE, --mode MODE  BO Mode (default: BO1)
  -obj OBJECTIVE, --objective OBJECTIVE
                        Objective (default: OBJ1)
  -i INITIAL, --initial INITIAL
                        Number of Initial Random Guesses (default: 1)
  -n ITERATIONS, --iterations ITERATIONS
                        Number of Guesses (default: 12)
  -p, --plot            Plot data
  -v, --verbose         Print Iteration Results
  -t, --train           Run training mode

```

An example of use would be:

```
python3 main.py -ss csvs/dataset-treino.csv -vm csvs/instances.csv -wp csvs/dataset-apps-treino.csv -n 0 -obj OBJ2 -m BO4 -i 6 -o novo/ -v --train -p
```

## LICENSE

This project is being developed at the Institute of Computing - Unicamp as part of @thaisacs master dissertation.
You are free to use this code under the [MIT LICENSE](https://choosealicense.com/licenses/mit/).
