# PB3Opt (Profile-Based Biased Bayesian Optimization)

PB3Opt implements Cloud Configuration Bayesian Search.

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
You are free to contact her and use this code under the [MIT LICENSE](https://choosealicense.com/licenses/mit/).
