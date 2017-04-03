Zika_Asia_2017
====================

This repository contains code used in the following paper.

Siraj AS, Perkins TA. (2017) Assessing the population at risk of Zika in Asia – is the emergency really over? (In review)

All code contained within this repository is released under the [CRAPL v0.1 License](http://matt.might.net/articles/crapl/). Because of the large sizes of many files used in the paper, we have included only a subset of data.


====================

### code/models folder

The scripts in this folder are used to fit relationships between seroprevalence from the 13 sites described in Table 1 and the covariates (i.e., temperature, economic index, Aedes aegypti occurrence probability) under mechanistic model formulation. The outputs of this model are projected attack rates following the first wave of the epidemic. These scripts were run in the following order and made use of both a personal laptop (Mac OSX) and the University of Notre Dame's Center for Research Computing cluster http://crc.nd.edu.

* `runjob.pbs` calls `script.R`, which calls the files below
* `0_relationship_R0_AR.R`
* `1_params_random_draws.R`
* `2_fit_attackrate_random_draws.R`
* `3_schematics_curve.R`

### code/maps folder

The scripts in this folder produce the maps and numbers in Figures 1. These scripts were run in the following order and made use of both a personal laptop (Mac OSX) and the University of Notre Dame's Center for Research Computing cluster http://crc.nd.edu.

* `0_numfunctions.R`
* `1_covariates.R`
* `run2job.pbs` calls `2_fit_attackrates_seroprev_crc.R`
* `run3job.pbs` calls `3_output_grids_crc.R`
* `run4job.pbs` calls `4_min_max_mean_1st_round.R`
* `run5job.pbs` calls `5_min_max_mean_2nd_round.R`
* `run6job.pbs` calls `6_min_max_mean_surface.R`
* `run7job.pbs` calls `7_median_1st_round.R`
* `8_median_surface.R`
* `9_country_summary.py`


### data folder

Data included here pertain to the 13 sites listed in Table S1 from which we obtained seroprevalence estimates, a generalized additive model object that describes the relationship between temperature and adult female Aedes aegypti mortality from Brady et al. (2013).


### generated folder

Files included here contain 1,000 replicates of parameterizations of the mechanistic model, and the covariates used in the model.


### outputs folder

The file included here contains the country-level sums of total infections (used in Figure 1) and infections among childbearing women.


### maps folder

This folder contains files that can be used to access raster data shown in the maps in Figures 1. The numbers in each 5x5 km grid cell are only pertinent to that grid cell, and totals across multiple grid cells cannot be interpreted as sums across larger areas. The reason is that, for example, the map of median attack rates contains each grid cell's median across 1,000 replicates rather than a reflection of what might somehow be considered a median spatial layer of attack rates across all grid cells. By contrast, distributions of country- and continent-level totals in Figure 1 reflect each such quantity calculated in each of the 1,000 replicates and then examined as a distribution.

