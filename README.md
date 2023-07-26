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
- ```makePretty(mean, lower, upper, sig = "%.1f")```\
*Description:*\
```makePretty()``` converts three columns of data into a string formatted for use in papers and tables, i.e. ##.# (##.#, ##.#)
*Arguments:*\
```mean```: A numeric, mean\
```lower```: A numeric, 95% CI lower bound\
```upper```: A numeric, 95% CI upper bound\
```sig```: Optional character vector of format strings indicating the formatting, by default is a a precision value with 1 decimal point ("%.1f")
- ```table_prevalence(svyobj, pivot, label = NULL, sig = "%.1f")```\
*Description:*\
```table_prevalence()``` is a wrapper that provides the estimated prevalences of different levels in a categorical variable, for use in classic "Table 1"\
*Arguments:*\
```svyobj```: A survey object generated from ```as_survey_design()``` or ```svydesign()``` \
```pivot```: The name of the variable being pivoted around\
```label```: Optional name to use as the label, by default is the same variable name as pivot\
```sig```: Optional character vector of format strings indicating the formating, by default "%.1f"


## NTD Estimation <span id="NTDs"></span>
```NTD_estimates.R``` contains several functions used for estimating NTD prevalences using RBC folate concentrations.

### Included functions:
- ```RBC_molloy_convert(RBC)```\
  A simple function that can be used in vectorized notations. Input are RBC folate concentrations using the Pfeiffer assay (NHANES from 2011 and on) and converts to RBC folate concentrations using the Molloy assay.
- ```RBC_estimate_mean_variance(RBC)```\
  A function that inputs a vector of RBC folate concentrations and provides the unweighted quantiles (to be used in non-NHANES cases only)
- ```RBC_mean_variance_quantsOnly(data, pcts, quants)```\
  A function that provides the parameters of an RBC folate concentrations distribution based upon available quantiles
- ```NTD_estimate(RBC, nsamp = 10000)```\
  Provides an an estimated NTD risk given a single RBC folate concentration; by default will give NTDs per 10,000
- ```NTD_estimate_pop(RBC_params, nsamp = 10000, npop = 100000, censor = "Both") ```\
  Provides the estimated NTD risk of a population from the parameters calculated using ```RBC_mean_variance_quantsOnly()```. ```nsamp``` is the total sample for number of NTDs (default is 10,000); ```npop``` is the number of times to run the simulation (default is 100,000); ```censor``` can be ```"Lower"```, ```"Upper"```, or ```"Both"``` and indicates if the simulation will censor data at the floor (Lower) or ceiling (Upper) of extreme RBC folate concentration values.
- ```NTD_estimate_pop2(RBC_params1, RBC_params2, nsamp = 10000, npop = 100000, censor = "Both")```
  Provides the estimated NTD risk of 2 separate subpopulations provided their parameters, calculated using ```RBC_mean_variance_quantsOnly()```, provides the estimated difference in NTDs and its uncertainty interval