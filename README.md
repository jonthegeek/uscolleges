
<!-- README.md is generated from README.Rmd. Please edit that file -->
uscolleges
==========

The uscolleges package provides a tidy version of the most recent College Scorecards from the US Department of Education.

Installation
------------

You can install the development version from [GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("jonthegeek/uscolleges")
```

Example
-------

``` r
library(dplyr)
library(ggplot2)
uscolleges::uscolleges %>% 
  filter(location.lon > -130, location.lon < 0, location.lat > 20) %>% 
  ggplot() + 
    aes(x = location.lon, y = location.lat) + 
    geom_point()
```

<img src="man/figures/README-example-1.png" width="100%" />
