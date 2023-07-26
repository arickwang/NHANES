# NHANES
A repository of helpful code to streamline NHANES related analyses

- [Necessary Packages](#Packages)
- [Helper functions](#HelperFunctions)
- [NTD Estimation](#NTDs)


## Packages <span id="Packages"></span>
The following code snippet installs all necessary packages for complex survey analysis of NHANES

```{r}
install.packages(c("haven", "survey", "srvyr", "tidyverse"))
```

A brief summary of packages:
- ```haven```: Flexibly package that allows the import of data from various data formats, including SAS
- ```tidyverse```: A set of packages that allows for the flexible manipulation of data
- ```survey```: A package designed for complex survey analysis, accounting for a multi-stage probabilistic design
- ```srvyr```: An extension of ```survey``` that allows functions to be passed through using ```tidyverse``` piping syntax

## Helper Functions <span id="HelperFunctions"></span>
```help_functions.R``` contains several functions designed for formatting data and tables and streamlining analyses. To easily load simply run:
```{r}
source('~/filepath/help_functions.R')
```

### Included functions:
- ```makePretty(mean, lower, upper, sig = "%.1f")```
  - **Description:**\
  ```makePretty()``` converts three columns of data into a string formatted for use in papers and tables, i.e. ##.# (##.#, ##.#)
  - **Arguments:**\
  ```mean```: A numeric, mean\
  ```lower```: A numeric, 95% CI lower bound\
  ```upper```: A numeric, 95% CI upper bound\
  ```sig```: Optional character vector of format strings indicating the formatting, by default is a a precision value with 1 decimal point ("%.1f")


- ```table_prevalence(svyobj, pivot, label = NULL, sig = "%.1f")```
  - **Description:**\
  ```table_prevalence()``` is a wrapper that provides the estimated prevalences of different levels in a categorical variable, for use in classic "Table 1"
  - **Arguments:**\
  ```svyobj```: A survey object generated from ```as_survey_design()``` or ```svydesign()``` \
  ```pivot```: The name of the variable being pivoted around\
  ```label```: Optional name to use as the label, by default is the same variable name as pivot\
  ```sig```: Optional character vector of format strings indicating the formating, by default "%.1f"


## NTD Estimation <span id="NTDs"></span>
```NTD_estimates.R``` contains several functions used for estimating NTD prevalences using RBC folate concentrations.

### Included functions:
- ```RBC_molloy_convert(RBC)```
  - **Description:**\
  ```RBC_molloy_convert()``` converts RBC folate concentrations from Pfeiffer/NHANES assay to the Molloy assay.
  - **Arguments:**\
  ```RBC```: A numeric vector containing RBC folate concentrations calibrated to the Pfeiffer/NHANES assay
  
  
- ```RBC_estimate_mean_variance(RBC)```
  - **Description:**\
  ```RBC_estimate_mean_variance()``` generated the parameters describing the unweighted distribution of RBC folate concentrations to be used in models; to be used in non-weighted data only
  - **Arguments:**\
  ```RBC```: A numeric vector containing the RBC folate concentrations for the population
  
  
- ```RBC_mean_variance_quantsOnly(data, pcts, quants)```
  - **Description:**\
  ```RBC_mean_variance_quantsOnly()``` generates the parameters describing an RBC folate based off of provided quantiles (if using weighted data, from the ```survey_quantiles()```, for example), for best results, every 5th quantile from 5-95 plus the 1st and 99th quantile are used.
  - **Arguments:**\
  ```data```: a ```data.frame``` that contains the data for RBC folate concentrations at different quantiles\
  ```pcts```: The name of the variable containing the quantile values (i.e., 1, 5, 10 for the 1st, 5th, and 10th quantiles)\
  ```quants```: The name of the variable containing the RBC folate concentrations at each specified quantile, calibrated to the Molloy assay.
  
  
- ```NTD_estimate(RBC, nsamp = 10000)```
  - **Description:**\
  ```NTD_estimate()``` provides the number of simulated NTDs for a sample at a given RBC folate concentration.
  - **Arguments:**\
  ```RBC```: A value for RBC folate concentration, calibrated to the Molloy assay\
  ```nsamp```: An integer representing the sample size to provide the estimated number of NTDs in, default is 10,000
  
  
- ```NTD_estimate_pop(RBC_params, nsamp = 10000, npop = 100000, censor = "Both") ```
  - **Description:**\
  ```NTD_estimate_pop()``` models an estimated number of NTDs in a sample of size ```nsamp``` given RBC folate concentrations with a distribution of the provided parameters.
  - **Arguments:**\
  ```RBC_params```: is a vector of numeric values representing the RBC folate concentration distribution, provided by ```RBC_estimate_mean_variance()``` or ```RBC_mean_variance_quantsOnly()```.\
  ```nsamp```: An integer representing the sample size to provide the estimated number of NTDs in, default is 10,000.\
  ```npop```: An integer representing the estimated size of the population, default is 100,000.\
  ```censor```: A string with possible values ```"Lower"```, ```"Upper"```, or ```"Both"``` that indicates of the simulated RBC folate concentrations will be censored at the floor (Lower), ceiling (Upper), or both (Both) in instances of extreme RBC folate concentration values.
  
  
- ```NTD_estimate_pop2(RBC_params1, RBC_params2, nsamp = 10000, npop = 100000, censor = "Both")```
  - **Description:**\
  ```NTD_estimate_pop2()``` models the estimated number of NTDs in two separate populations with provided information on the distribution of RBC folate concentrations; provides the estimated difference in NTDs, the uncertainty interval for the difference, and an estimated p-value.
  - **Arguments:**\
  ```RBC_params1```: is a vector of numeric values representing the RBC folate concentration distribution of first population, provided by ```RBC_estimate_mean_variance()``` or ```RBC_mean_variance_quantsOnly()```.\
  ```RBC_params2```: is a vector of numeric values representing the RBC folate concentration distribution of second population\
  ```nsamp```: An integer representing the sample size to provide the estimated number of NTDs in, default is 10,000.\
  ```npop```: An integer representing the estimated size of the population, default is 100,000.\
  ```censor```: A string with possible values ```"Lower"```, ```"Upper"```, or ```"Both"``` that indicates of the simulated RBC folate concentrations will be censored at the floor (Lower), ceiling (Upper), or both (Both) in instances of extreme RBC folate concentration values.