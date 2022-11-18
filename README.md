
<!-- README.md is generated from README.Rmd. Please edit that file -->

# wontrun <img src="man/figures/logo.png" align="right" class="logo"/>

<!-- badges: start -->
<!-- badges: end -->

The goal of `{wontrun}` is to test the longevity of old code for the R
programming language by making it easy to run examples from archived
package sources on current versions of packages.

## Installation

`{wontrun}` is not available on CRAN, but you can install the
development version like so:

``` r
# install.packages("devtools")
devtools::install_github("b-rodrigues/wontrun", ref = "master")
```

## Example

This is a basic example which shows you how to solve a common problem:

``` r
library(wontrun)
cl <- parallel::detectCores()-2
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
  wontrun(ncpus = cl, years = 2008)
```

``` r
summary_wontrun(aer_runs)
#> # A tibble: 6 × 2
#>   classes                                               total
#>   <chr>                                                 <int>
#> 1 simpleWarning-warning-condition                           2
#> 2 defunctError-error-condition                              3
#> 3 simpleError-error-condition                               4
#> 4 packageStartupMessage-simpleMessage-message-condition     6
#> 5 packageNotFoundError-error-condition                     23
#> 6 list                                                     65
```

## Thanks

- Thanks to [Dirk
  Eddelbuettel](https://twitter.com/eddelbuettel/status/1588149491772923907?s=20&t=aRcs1VTwn1861biBikjdiA)
  for the idea!
- Thanks to
  [Deemah](https://fediscience.org/@dmi3kno/109296599193965025) for
  suggesting the name of the package and making the logo!
- Thanks to [Jenny
  Bryan](https://twitter.com/JennyBryan/status/1590788394405498880?s=20&t=aRcs1VTwn1861biBikjdiA)
  for suggesting using `{callr}` which I use in this package.
- Thanks to [David
  Hood](https://mastodon.nz/@thoughtfulnz/109330296529120658) for
  suggesting the term *code longevity*.
- and thanks to [everyone on
  Mastodon](https://fosstodon.org/@brodriguesco/109330164860035432) for
  the helpful discussions!
