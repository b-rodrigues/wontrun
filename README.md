
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

Get the archived sources for the `{dplyr}` package:

``` r
library(wontrun)
dplyr_sources <- get_archived_sources("dplyr")
```

This is what this looks like:

``` r
dplyr_sources
#> # A tibble: 39 × 5
#>    name  version       url                             last_modified       size 
#>    <chr> <chr>         <chr>                           <dttm>              <chr>
#>  1 dplyr dplyr_0.1.1   https://cran.r-project.org/src… 2014-01-29 21:24:00 530K 
#>  2 dplyr dplyr_0.1.2   https://cran.r-project.org/src… 2014-02-24 16:36:00 533K 
#>  3 dplyr dplyr_0.1.3   https://cran.r-project.org/src… 2014-03-15 00:36:00 535K 
#>  4 dplyr dplyr_0.1     https://cran.r-project.org/src… 2014-01-16 22:53:00 2.7M 
#>  5 dplyr dplyr_0.2     https://cran.r-project.org/src… 2014-05-21 08:20:00 577K 
#>  6 dplyr dplyr_0.3.0.1 https://cran.r-project.org/src… 2014-10-08 05:21:00 629K 
#>  7 dplyr dplyr_0.3.0.2 https://cran.r-project.org/src… 2014-10-11 07:43:00 628K 
#>  8 dplyr dplyr_0.3     https://cran.r-project.org/src… 2014-10-04 06:39:00 629K 
#>  9 dplyr dplyr_0.4.0   https://cran.r-project.org/src… 2015-01-08 11:12:00 870K 
#> 10 dplyr dplyr_0.4.1   https://cran.r-project.org/src… 2015-01-14 07:15:00 870K 
#> # … with 29 more rows
```

Let’s also choose how many cores we want to use to run the examples, as
this is a time-consuming operation:

``` r
cl <- 6
```

We can now run the examples contained in the archived packages with the
`wontrun()` function:

``` r
# By default, wontrun() will only consider the earliest package in a given year
dplyr_runs <- wontrun(dplyr_sources, ncpus = cl)
```

The package provides a `decode_wontrun()` function to summarise the
results:

``` r
decode_wontrun(dplyr_runs)
#> # A tibble: 5,328 × 7
#>    name  version   last_modified       scripts_pa…¹ runs         classes message
#>    <chr> <chr>     <dttm>              <chr>        <list>       <chr>   <chr>  
#>  1 dplyr dplyr_0.1 2014-01-16 22:53:00 /tmp/Rtmp8X… <named list> list    ""     
#>  2 dplyr dplyr_0.1 2014-01-16 22:53:00 /tmp/Rtmp8X… <pckgStrM>   packag… "Loadi…
#>  3 dplyr dplyr_0.1 2014-01-16 22:53:00 /tmp/Rtmp8X… <smplErrr>   simple… "could…
#>  4 dplyr dplyr_0.1 2014-01-16 22:53:00 /tmp/Rtmp8X… <pckgStrM>   packag… "Loadi…
#>  5 dplyr dplyr_0.1 2014-01-16 22:53:00 /tmp/Rtmp8X… <pckgStrM>   packag… "Loadi…
#>  6 dplyr dplyr_0.1 2014-01-16 22:53:00 /tmp/Rtmp8X… <lfcycl_s>   lifecy… "src_s…
#>  7 dplyr dplyr_0.1 2014-01-16 22:53:00 /tmp/Rtmp8X… <named list> list    ""     
#>  8 dplyr dplyr_0.1 2014-01-16 22:53:00 /tmp/Rtmp8X… <pckgStrM>   packag… "Loadi…
#>  9 dplyr dplyr_0.1 2014-01-16 22:53:00 /tmp/Rtmp8X… <smplErrr>   simple… "could…
#> 10 dplyr dplyr_0.1 2014-01-16 22:53:00 /tmp/Rtmp8X… <pckgStrM>   packag… "Loadi…
#> # … with 5,318 more rows, and abbreviated variable name ¹​scripts_paths
```

## Thanks

- Thanks to [Dirk
  Eddelbuettel](https://twitter.com/eddelbuettel/status/1588149491772923907?s=20&t=aRcs1VTwn1861biBikjdiA)
  for the idea!
- Thanks to
  [Deemah](https://fediscience.org/@dmi3kno/109296599193965025) for
  suggesting the name of the package!
- Thanks to [Jenny
  Bryan](https://twitter.com/JennyBryan/status/1590788394405498880?s=20&t=aRcs1VTwn1861biBikjdiA)
  for suggesting using `{callr}` which I use in this package.
- Thanks to [David
  Hood](https://mastodon.nz/@thoughtfulnz/109330296529120658) for
  suggesting the term *code longevity*.
- and thanks to [everyone on
  Mastodon](https://fosstodon.org/@brodriguesco/109330164860035432) for
  the helpful discussions!
