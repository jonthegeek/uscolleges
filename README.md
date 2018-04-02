# uscolleges

The uscolleges package provides a tidy version of the most recent College Scorecards from the US Department of Education.

## Installation

You can install the development version from [GitHub](https://github.com/) with:

``` r
devtools::install_github("jonthegeek/uscolleges")
```
## Example

``` r
# Warning: This data.frame contains 7,593 observations of 622 variables.
ggplot2::ggplot(uscolleges::uscolleges) + ggplot2::aes(x = location.lon, y = location.lat) + ggplot2::geom_point()
```

