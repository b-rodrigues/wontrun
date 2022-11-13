
<!-- README.md is generated from README.Rmd. Please edit that file -->

# {wontrun}

<!-- badges: start -->
<!-- badges: end -->

The goal of retrex is to make it easy to run examples from archived
package source on current versions of packages in order to test
RETRocompatibility of EXamples and ultimately evaluate reproducibility
of code.

## Installation

`{retrex}` is not available on CRAN, but you can install the development
version of retrex like so:

``` r
# install.packages("devtools")
devtools::install_github("b-rodrigues/wontrun", ref = "master")
```

## Example

This is a basic example which shows you how to solve a common problem:

``` r
library(wontrun)
```

``` r
aer_sources <- get_archived_sources("AER")
```

``` r
aer_sources
#> # A tibble: 25 × 5
#>    name  version   url                                 last_modified       size 
#>    <chr> <chr>     <chr>                               <dttm>              <chr>
#>  1 AER   AER_0.2-1 https://cran.r-project.org/src/con… 2008-05-05 00:22:00 2.4M 
#>  2 AER   AER_0.2-2 https://cran.r-project.org/src/con… 2008-05-05 11:43:00 2.4M 
#>  3 AER   AER_0.9-0 https://cran.r-project.org/src/con… 2008-05-28 23:21:00 2.4M 
#>  4 AER   AER_1.0-0 https://cran.r-project.org/src/con… 2008-08-26 12:53:00 2.6M 
#>  5 AER   AER_1.0-1 https://cran.r-project.org/src/con… 2008-10-22 13:15:00 2.6M 
#>  6 AER   AER_1.1-0 https://cran.r-project.org/src/con… 2009-02-05 19:44:00 2.6M 
#>  7 AER   AER_1.1-1 https://cran.r-project.org/src/con… 2009-03-08 15:32:00 2.6M 
#>  8 AER   AER_1.1-2 https://cran.r-project.org/src/con… 2009-03-19 15:59:00 2.6M 
#>  9 AER   AER_1.1-3 https://cran.r-project.org/src/con… 2009-05-22 00:31:00 2.6M 
#> 10 AER   AER_1.1-4 https://cran.r-project.org/src/con… 2009-09-23 22:49:00 2.7M 
#> # … with 15 more rows
```

``` r
aer_runs <- aer_sources %>%
  wontrun(ncpus = 6, years = 2008)
```

``` r
summary_wontrun(aer_runs)
#> # A tibble: 7 × 2
#>   classes                                               total
#>   <chr>                                                 <int>
#> 1 simpleWarning-warning-condition                           2
#> 2 defunctError-error-condition                              3
#> 3 deprecatedWarning-warning-condition                       4
#> 4 simpleError-error-condition                               4
#> 5 packageNotFoundError-error-condition                      9
#> 6 packageStartupMessage-simpleMessage-message-condition    16
#> 7 list                                                     65
```
