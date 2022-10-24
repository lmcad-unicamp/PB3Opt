          ____  ____ _____  ___        _     
         |  _ \| __ )___ / / _ \ _ __ | |_   
         | |_) |  _ \ |_ \| | | | '_ \| __| 
         |  __/| |_) |__) | |_| | |_) | |_   
         |_|   |____/____/ \___/| .__/ \__|  
                                |_|          
The Profile-Based Biased Bayesian Optimization (PB<sup>3</sup>Opt) implements Cloud Configuration Bayesian Search using biased Expected Improvement. 

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
* BO4 is the PB<sup>3</sup>Opt
* BO5 is the BO-6rnd-EIbiased
* RS is the Ranking-Search

Besides that, we implemented two objective functions (OBJ1 and OBJ2). Where, OBJ1 is about experimentation cost and OBJ2 is about experimentation time. We also implemented OBJ3 for experimentation cost with Paramount Iterations (PI) and OBJ4 for experimentation time with PI.

### DATASETS

Our datasets are available in the csvs/ path. Each dataset file is explaned below:

* **instance.csv**: Computer clusters instance type file.
* **dataset-treino.csv**: Search space of train dataset.
* **dataset-teste.csv**: Search space of all dataset.
* **dataset-apps-treino.csv**: Workload-Profile dataset of train dataset.
* **dataset-apps-teste.csv**: Workload-Profile dataset of all dataset.
* **dataset-teste-pi.csv**: Search space of test dataset with paramount iteration.
* **dataset-apps-pi-treino.csv**: Workload-Profile dataset of train dataset with Paramount Iterations.
* **dataset-apps-pi-teste.csv**: Workload-Profile dataset of all dataset with Paramount Iterations.

## Citation

CAMACHO, Thais Aparecida Silva. PB3Opt: uma estratégia para selecionar aglomerados de computadores na nuvem computacional para cargas computacionais de alto desempenho. 2022. 1 recurso online (96 p.) Dissertação (mestrado) - Universidade Estadual de Campinas, Instituto de Computação, Campinas, SP. Disponível em: https://hdl.handle.net/20.500.12733/3945.

## Building it

To get started with PB<sup>3</sup>Opt, you need to install Python 3, [GPy](https://github.com/SheffieldML/GPy), and [GPyOpt library](https://github.com/lmcad-unicamp/GPyOpt). You can install them easily using the following commands:

```
sudo apt install python3 python3-pip
git clone git@github.com:lmcad-unicamp/GPyOpt.git
cd GPyOpt
pip3 install -r requirements.txt
sudo python3 setup.py develop
cd ..
git clone git@github.com:lmcad-unicamp/PB3Opt.git
```

## USAGE

You can use PB<sup>3</sup>Opt easily using the following commands:

```
cd PB3Opt
mkdir outputs
python3 main.py -ss csvs/dataset-treino.csv -vm csvs/instances.csv -wp csvs/dataset-apps-treino.csv -n 0 -obj OBJ2 -m BO4 -i 6 -o outputs/ -v --train -p
```

You can see details on how to use PB<sup>3</sup>Opt by running:

```
python3 main.py --help
```

## LICENSE

This project is being developed at the Institute of Computing - Unicamp as part of [@thaisacs](https://github.com/thaisacs) master dissertation.
You are free to use this code under the [MIT LICENSE](https://choosealicense.com/licenses/mit/).
