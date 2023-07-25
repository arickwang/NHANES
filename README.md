# NHANES
A repository of helpful code to streamline NHANES related analyses

- [Necessary Packages](#Packages)
- [Helper functions](#HelperFunctions)


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

- ```makePretty(mean, lower, upper, sig)```\
  A simple function that can be used in vectorized notation that takes three columns (a mean, lower CI, upper CI) and an optional significant figure (default = 1 decimal point) and returns the numbers as a formatted string to be used in papers & tables
