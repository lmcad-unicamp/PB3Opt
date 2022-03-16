# PB3Opt - Profile-Based Biased Bayesian Optimization

PB3Opt implements Cloud Configuration Bayesian Search. This repository also implements the follows approaches:

* BO-6rnd-EIdef
* BO-6rnd-EIbiased
* BO-6sel-EIdef
* Ranking Search

In this context, we implement five modes (BO1, RS, BO3, BO4, BO5). Thus, we have that:

* BO1 is the BO default (BO-6rnd-EIdef)
* BO3 is the BO-6sel-EIdef
* BO4 is the PB3Opt
* BO5 is the BO-6rnd-EIbiased
* RS is the Ranking Search

Besides that, we implement two objective funcionst (OBJ1 and OBJ2). Where, OBJ1 is about experimentation cost and OBJ2 is about experimentation time. We also implement OBJ3 for experimentation cost with PI and OBJ4 for experimentation time with PI.

## Usage

Use the [GPyOpt library](https://github.com/lmcad-unicamp/GPyOpt) with Python 3.8. After installing GPyOpt, you can easily use it using the following commands:

```
usage: main.py [-h] [-df DFNAME] [-dfi DFINAME] [-dfapp DFAPPNAME] [-o OUTPUT]
               [-m MODE] [-obj OBJECTIVE] [-i INITIAL] [-n ITERATIONS] [-p]
               [-v] [-t]

Cloud Configuration Bayesian Search.

optional arguments:
  -h, --help            show this help message and exit
  -df DFNAME, --dfname DFNAME
                        Dataset file name (default: dataset.csv)
  -dfi DFINAME, --dfiname DFINAME
                        Instances dataset file name (default: instances.csv)
  -dfapp DFAPPNAME, --dfappname DFAPPNAME
                        App dataset file name (default: dataset-app.csv)
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
python main.py -df csvs/dataset-treino.csv -dfi csvs/instances.csv -dfapp csvs/dataset-apps-treino.csv 
  -n 0 -obj OBJ2 -m BO4 -i 6 -o novo/ -v --train -p
```

## LICENSE

This project is being developed at the Institute of Computing - Unicamp as part of @thaisacs master dissertation.
You are free to use this code under the [MIT LICENSE](https://choosealicense.com/licenses/mit/).
