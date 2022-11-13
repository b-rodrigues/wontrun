
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
#> Running examples...
#> Downloading package AER_0.2-1
#> Warning in parse_Rd("/tmp/RtmpMPiGPXwontrun_download/AER/AER_0.2-1/man/
#> ResumeNames.Rd", : /tmp/RtmpMPiGPXwontrun_download/AER/AER_0.2-1/man/
#> ResumeNames.Rd:70: unknown macro '\bf'
#> Warning in parse_Rd("/tmp/RtmpMPiGPXwontrun_download/AER/AER_0.2-1/man/TeachingRatings.Rd", : /tmp/RtmpMPiGPXwontrun_download/AER/AER_0.2-1/man/TeachingRatings.Rd:49: unexpected TEXT '(24), 369--376.
#> ', expecting '{'
#> Warning in parse_Rd("/tmp/RtmpMPiGPXwontrun_download/AER/AER_0.2-1/man/
#> USSeatBelts.Rd", : /tmp/RtmpMPiGPXwontrun_download/AER/AER_0.2-1/man/
#> USSeatBelts.Rd:46: unexpected TEXT '(The Review of Economics and Statistics), ',
#> expecting '{'
#> Loading  AER 
#>  and running  /tmp/RtmpMPiGPXwontrun_download/AER/AER_0.2-1/scripts/Affairs.RNULL
#> Loading  AER 
#>  and running  /tmp/RtmpMPiGPXwontrun_download/AER/AER_0.2-1/scripts/ArgentinaCPI.RNULL
#> Loading  AER 
#>  and running  /tmp/RtmpMPiGPXwontrun_download/AER/AER_0.2-1/scripts/Baltagi2002.RNULL
#> Loading  AER 
#>  and running  /tmp/RtmpMPiGPXwontrun_download/AER/AER_0.2-1/scripts/BankWages.RNULL
#> Loading  AER 
#>  and running  /tmp/RtmpMPiGPXwontrun_download/AER/AER_0.2-1/scripts/BenderlyZwick.RNULL
#> Loading  AER 
#>  and running  /tmp/RtmpMPiGPXwontrun_download/AER/AER_0.2-1/scripts/BondYield.RNULL
#> Loading  AER 
#>  and running  /tmp/RtmpMPiGPXwontrun_download/AER/AER_0.2-1/scripts/CameronTrivedi1998.RNULL
#> Loading  AER 
#>  and running  /tmp/RtmpMPiGPXwontrun_download/AER/AER_0.2-1/scripts/CartelStability.RNULL
#> Loading  AER 
#>  and running  /tmp/RtmpMPiGPXwontrun_download/AER/AER_0.2-1/scripts/CASchools.RNULL
#> Loading  AER 
#>  and running  /tmp/RtmpMPiGPXwontrun_download/AER/AER_0.2-1/scripts/ChinaIncome.RNULL
#> Loading  AER 
#>  and running  /tmp/RtmpMPiGPXwontrun_download/AER/AER_0.2-1/scripts/CigarettesB.RNULL
#> Loading  AER 
#>  and running  /tmp/RtmpMPiGPXwontrun_download/AER/AER_0.2-1/scripts/CigarettesSW.RNULL
#> Loading  AER 
#>  and running  /tmp/RtmpMPiGPXwontrun_download/AER/AER_0.2-1/scripts/CollegeDistance.RNULL
#> Loading  AER 
#>  and running  /tmp/RtmpMPiGPXwontrun_download/AER/AER_0.2-1/scripts/ConsumerGood.RNULL
#> Loading  AER 
#>  and running  /tmp/RtmpMPiGPXwontrun_download/AER/AER_0.2-1/scripts/CPS1985.RNULL
#> Loading  AER 
#>  and running  /tmp/RtmpMPiGPXwontrun_download/AER/AER_0.2-1/scripts/CPS1988.RNULL
#> Loading  AER 
#>  and running  /tmp/RtmpMPiGPXwontrun_download/AER/AER_0.2-1/scripts/CPSSW.RNULL
#> Warning: UNRELIABLE VALUE: Future ('<none>') unexpectedly generated random
#> numbers without specifying argument 'seed'. There is a risk that those random
#> numbers are not statistically sound and the overall results might be invalid.
#> To fix this, specify 'seed=TRUE'. This ensures that proper, parallel-safe random
#> numbers are produced via the L'Ecuyer-CMRG method. To disable this check, use
#> 'seed=NULL', or set option 'future.rng.onMisuse' to "ignore".
#> Loading  AER 
#>  and running  /tmp/RtmpMPiGPXwontrun_download/AER/AER_0.2-1/scripts/CreditCard.RNULL
#> Loading  AER 
#>  and running  /tmp/RtmpMPiGPXwontrun_download/AER/AER_0.2-1/scripts/dispersiontest.RNULL
#> Loading  AER 
#>  and running  /tmp/RtmpMPiGPXwontrun_download/AER/AER_0.2-1/scripts/DJFranses.RNULL
#> Loading  AER 
#>  and running  /tmp/RtmpMPiGPXwontrun_download/AER/AER_0.2-1/scripts/DoctorVisits.RNULL
#> Loading  AER 
#>  and running  /tmp/RtmpMPiGPXwontrun_download/AER/AER_0.2-1/scripts/DutchAdvert.RNULL
#> Loading  AER 
#>  and running  /tmp/RtmpMPiGPXwontrun_download/AER/AER_0.2-1/scripts/DutchSales.RNULL
#> Loading  AER 
#>  and running  /tmp/RtmpMPiGPXwontrun_download/AER/AER_0.2-1/scripts/Electricity1955.RNULL
#> Loading  AER 
#>  and running  /tmp/RtmpMPiGPXwontrun_download/AER/AER_0.2-1/scripts/Electricity1970.RNULL
#> Loading  AER 
#>  and running  /tmp/RtmpMPiGPXwontrun_download/AER/AER_0.2-1/scripts/Equipment.RNULL
#> Loading  AER 
#>  and running  /tmp/RtmpMPiGPXwontrun_download/AER/AER_0.2-1/scripts/EuroEnergy.RNULL
#> Loading  AER 
#>  and running  /tmp/RtmpMPiGPXwontrun_download/AER/AER_0.2-1/scripts/Fatalities.RNULL
#> Loading  AER 
#>  and running  /tmp/RtmpMPiGPXwontrun_download/AER/AER_0.2-1/scripts/Fertility.RNULL
#> Loading  AER 
#>  and running  /tmp/RtmpMPiGPXwontrun_download/AER/AER_0.2-1/scripts/Franses1998.RNULL
#> Loading  AER 
#>  and running  /tmp/RtmpMPiGPXwontrun_download/AER/AER_0.2-1/scripts/FrozenJuice.RNULL
#> Loading  AER 
#>  and running  /tmp/RtmpMPiGPXwontrun_download/AER/AER_0.2-1/scripts/GermanUnemployment.RNULL
#> Loading  AER 
#>  and running  /tmp/RtmpMPiGPXwontrun_download/AER/AER_0.2-1/scripts/Greene2003.RNULL
#> Loading  AER 
#>  and running  /tmp/RtmpMPiGPXwontrun_download/AER/AER_0.2-1/scripts/GrowthDJ.RNULL
#> Warning: UNRELIABLE VALUE: Future ('<none>') unexpectedly generated random
#> numbers without specifying argument 'seed'. There is a risk that those random
#> numbers are not statistically sound and the overall results might be invalid.
#> To fix this, specify 'seed=TRUE'. This ensures that proper, parallel-safe random
#> numbers are produced via the L'Ecuyer-CMRG method. To disable this check, use
#> 'seed=NULL', or set option 'future.rng.onMisuse' to "ignore".
#> Loading  AER 
#>  and running  /tmp/RtmpMPiGPXwontrun_download/AER/AER_0.2-1/scripts/GrowthSW.RNULL
#> Loading  AER 
#>  and running  /tmp/RtmpMPiGPXwontrun_download/AER/AER_0.2-1/scripts/Grunfeld.RNULL
#> Loading  AER 
#>  and running  /tmp/RtmpMPiGPXwontrun_download/AER/AER_0.2-1/scripts/Guns.RNULL
#> Loading  AER 
#>  and running  /tmp/RtmpMPiGPXwontrun_download/AER/AER_0.2-1/scripts/HealthInsurance.RNULL
#> Loading  AER 
#>  and running  /tmp/RtmpMPiGPXwontrun_download/AER/AER_0.2-1/scripts/HMDA.RNULL
#> Loading  AER 
#>  and running  /tmp/RtmpMPiGPXwontrun_download/AER/AER_0.2-1/scripts/HousePrices.RNULL
#> Loading  AER 
#>  and running  /tmp/RtmpMPiGPXwontrun_download/AER/AER_0.2-1/scripts/ivreg.fit.RNULL
#> Loading  AER 
#>  and running  /tmp/RtmpMPiGPXwontrun_download/AER/AER_0.2-1/scripts/ivreg.RNULL
#> Loading  AER 
#>  and running  /tmp/RtmpMPiGPXwontrun_download/AER/AER_0.2-1/scripts/Journals.RNULL
#> Loading  AER 
#>  and running  /tmp/RtmpMPiGPXwontrun_download/AER/AER_0.2-1/scripts/KleinI.RNULL
#> Loading  AER 
#>  and running  /tmp/RtmpMPiGPXwontrun_download/AER/AER_0.2-1/scripts/Longley.RNULL
#> Loading  AER 
#>  and running  /tmp/RtmpMPiGPXwontrun_download/AER/AER_0.2-1/scripts/ManufactCosts.RNULL
#> Loading  AER 
#>  and running  /tmp/RtmpMPiGPXwontrun_download/AER/AER_0.2-1/scripts/MarkDollar.RNULL
#> Loading  AER 
#>  and running  /tmp/RtmpMPiGPXwontrun_download/AER/AER_0.2-1/scripts/MarkPound.RNULL
#> Loading  AER 
#>  and running  /tmp/RtmpMPiGPXwontrun_download/AER/AER_0.2-1/scripts/MASchools.RNULL
#> Loading  AER 
#>  and running  /tmp/RtmpMPiGPXwontrun_download/AER/AER_0.2-1/scripts/Medicaid1986.RNULL
#> Loading  AER 
#>  and running  /tmp/RtmpMPiGPXwontrun_download/AER/AER_0.2-1/scripts/Mortgage.RNULL
#> Loading  AER 
#>  and running  /tmp/RtmpMPiGPXwontrun_download/AER/AER_0.2-1/scripts/MotorCycles.RNULL
#> Warning: UNRELIABLE VALUE: Future ('<none>') unexpectedly generated random
#> numbers without specifying argument 'seed'. There is a risk that those random
#> numbers are not statistically sound and the overall results might be invalid.
#> To fix this, specify 'seed=TRUE'. This ensures that proper, parallel-safe random
#> numbers are produced via the L'Ecuyer-CMRG method. To disable this check, use
#> 'seed=NULL', or set option 'future.rng.onMisuse' to "ignore".
#> Loading  AER 
#>  and running  /tmp/RtmpMPiGPXwontrun_download/AER/AER_0.2-1/scripts/Municipalities.RNULL
#> Loading  AER 
#>  and running  /tmp/RtmpMPiGPXwontrun_download/AER/AER_0.2-1/scripts/MurderRates.RNULL
#> Loading  AER 
#>  and running  /tmp/RtmpMPiGPXwontrun_download/AER/AER_0.2-1/scripts/NaturalGas.RNULL
#> Loading  AER 
#>  and running  /tmp/RtmpMPiGPXwontrun_download/AER/AER_0.2-1/scripts/NMES1988.RNULL
#> Loading  AER 
#>  and running  /tmp/RtmpMPiGPXwontrun_download/AER/AER_0.2-1/scripts/NYSESW.RNULL
#> Loading  AER 
#>  and running  /tmp/RtmpMPiGPXwontrun_download/AER/AER_0.2-1/scripts/OECDGas.RNULL
#> Loading  AER 
#>  and running  /tmp/RtmpMPiGPXwontrun_download/AER/AER_0.2-1/scripts/OECDGrowth.RNULL
#> Loading  AER 
#>  and running  /tmp/RtmpMPiGPXwontrun_download/AER/AER_0.2-1/scripts/OlympicTV.RNULL
#> Loading  AER 
#>  and running  /tmp/RtmpMPiGPXwontrun_download/AER/AER_0.2-1/scripts/OrangeCounty.RNULL
#> Loading  AER 
#>  and running  /tmp/RtmpMPiGPXwontrun_download/AER/AER_0.2-1/scripts/Parade2005.RNULL
#> Loading  AER 
#>  and running  /tmp/RtmpMPiGPXwontrun_download/AER/AER_0.2-1/scripts/PepperPrice.RNULL
#> Loading  AER 
#>  and running  /tmp/RtmpMPiGPXwontrun_download/AER/AER_0.2-1/scripts/PhDPublications.RNULL
#> Loading  AER 
#>  and running  /tmp/RtmpMPiGPXwontrun_download/AER/AER_0.2-1/scripts/ProgramEffectiveness.RNULL
#> Loading  AER 
#>  and running  /tmp/RtmpMPiGPXwontrun_download/AER/AER_0.2-1/scripts/PSID1976.RNULL
#> Loading  AER 
#>  and running  /tmp/RtmpMPiGPXwontrun_download/AER/AER_0.2-1/scripts/PSID1982.RNULL
#> Loading  AER 
#>  and running  /tmp/RtmpMPiGPXwontrun_download/AER/AER_0.2-1/scripts/RecreationDemand.RNULL
#> Loading  AER 
#>  and running  /tmp/RtmpMPiGPXwontrun_download/AER/AER_0.2-1/scripts/ResumeNames.RNULL
#> Warning: UNRELIABLE VALUE: Future ('<none>') unexpectedly generated random
#> numbers without specifying argument 'seed'. There is a risk that those random
#> numbers are not statistically sound and the overall results might be invalid.
#> To fix this, specify 'seed=TRUE'. This ensures that proper, parallel-safe random
#> numbers are produced via the L'Ecuyer-CMRG method. To disable this check, use
#> 'seed=NULL', or set option 'future.rng.onMisuse' to "ignore".
#> Loading  AER 
#>  and running  /tmp/RtmpMPiGPXwontrun_download/AER/AER_0.2-1/scripts/ShipAccidents.RNULL
#> Loading  AER 
#>  and running  /tmp/RtmpMPiGPXwontrun_download/AER/AER_0.2-1/scripts/SIC33.RNULL
#> Loading  AER 
#>  and running  /tmp/RtmpMPiGPXwontrun_download/AER/AER_0.2-1/scripts/SmokeBan.RNULL
#> Loading  AER 
#>  and running  /tmp/RtmpMPiGPXwontrun_download/AER/AER_0.2-1/scripts/SportsCards.RNULL
#> Loading  AER 
#>  and running  /tmp/RtmpMPiGPXwontrun_download/AER/AER_0.2-1/scripts/STAR.RNULL
#> Loading  AER 
#>  and running  /tmp/RtmpMPiGPXwontrun_download/AER/AER_0.2-1/scripts/StockWatson2007.RNULL
#> Loading  AER 
#>  and running  /tmp/RtmpMPiGPXwontrun_download/AER/AER_0.2-1/scripts/StrikeDuration.RNULL
#> Loading  AER 
#>  and running  /tmp/RtmpMPiGPXwontrun_download/AER/AER_0.2-1/scripts/summary.ivreg.RNULL
#> Loading  AER 
#>  and running  /tmp/RtmpMPiGPXwontrun_download/AER/AER_0.2-1/scripts/SwissLabor.RNULL
#> Loading  AER 
#>  and running  /tmp/RtmpMPiGPXwontrun_download/AER/AER_0.2-1/scripts/TeachingRatings.RNULL
#> Loading  AER 
#>  and running  /tmp/RtmpMPiGPXwontrun_download/AER/AER_0.2-1/scripts/TechChange.RNULL
#> Loading  AER 
#>  and running  /tmp/RtmpMPiGPXwontrun_download/AER/AER_0.2-1/scripts/tobit.RNULL
#> Loading  AER 
#>  and running  /tmp/RtmpMPiGPXwontrun_download/AER/AER_0.2-1/scripts/TradeCredit.RNULL
#> Loading  AER 
#>  and running  /tmp/RtmpMPiGPXwontrun_download/AER/AER_0.2-1/scripts/TravelMode.RNULL
#> Loading  AER 
#>  and running  /tmp/RtmpMPiGPXwontrun_download/AER/AER_0.2-1/scripts/UKInflation.RNULL
#> Loading  AER 
#>  and running  /tmp/RtmpMPiGPXwontrun_download/AER/AER_0.2-1/scripts/UKNonDurables.RNULL
#> Loading  AER 
#>  and running  /tmp/RtmpMPiGPXwontrun_download/AER/AER_0.2-1/scripts/USAirlines.RNULL
#> Warning: UNRELIABLE VALUE: Future ('<none>') unexpectedly generated random
#> numbers without specifying argument 'seed'. There is a risk that those random
#> numbers are not statistically sound and the overall results might be invalid.
#> To fix this, specify 'seed=TRUE'. This ensures that proper, parallel-safe random
#> numbers are produced via the L'Ecuyer-CMRG method. To disable this check, use
#> 'seed=NULL', or set option 'future.rng.onMisuse' to "ignore".
#> Loading  AER 
#>  and running  /tmp/RtmpMPiGPXwontrun_download/AER/AER_0.2-1/scripts/USConsump1950.RNULL
#> Loading  AER 
#>  and running  /tmp/RtmpMPiGPXwontrun_download/AER/AER_0.2-1/scripts/USConsump1979.RNULL
#> Loading  AER 
#>  and running  /tmp/RtmpMPiGPXwontrun_download/AER/AER_0.2-1/scripts/USConsump1993.RNULL
#> Loading  AER 
#>  and running  /tmp/RtmpMPiGPXwontrun_download/AER/AER_0.2-1/scripts/USCrudes.RNULL
#> Loading  AER 
#>  and running  /tmp/RtmpMPiGPXwontrun_download/AER/AER_0.2-1/scripts/USGasB.RNULL
#> Loading  AER 
#>  and running  /tmp/RtmpMPiGPXwontrun_download/AER/AER_0.2-1/scripts/USGasG.RNULL
#> Loading  AER 
#>  and running  /tmp/RtmpMPiGPXwontrun_download/AER/AER_0.2-1/scripts/USInvest.RNULL
#> Loading  AER 
#>  and running  /tmp/RtmpMPiGPXwontrun_download/AER/AER_0.2-1/scripts/USMacroB.RNULL
#> Loading  AER 
#>  and running  /tmp/RtmpMPiGPXwontrun_download/AER/AER_0.2-1/scripts/USMacroG.RNULL
#> Loading  AER 
#>  and running  /tmp/RtmpMPiGPXwontrun_download/AER/AER_0.2-1/scripts/USMacroSW.RNULL
#> Loading  AER 
#>  and running  /tmp/RtmpMPiGPXwontrun_download/AER/AER_0.2-1/scripts/USMacroSWM.RNULL
#> Loading  AER 
#>  and running  /tmp/RtmpMPiGPXwontrun_download/AER/AER_0.2-1/scripts/USMacroSWQ.RNULL
#> Loading  AER 
#>  and running  /tmp/RtmpMPiGPXwontrun_download/AER/AER_0.2-1/scripts/USMoney.RNULL
#> Loading  AER 
#>  and running  /tmp/RtmpMPiGPXwontrun_download/AER/AER_0.2-1/scripts/USProdIndex.RNULL
#> Loading  AER 
#>  and running  /tmp/RtmpMPiGPXwontrun_download/AER/AER_0.2-1/scripts/USSeatBelts.RNULL
#> Loading  AER 
#>  and running  /tmp/RtmpMPiGPXwontrun_download/AER/AER_0.2-1/scripts/USStocksSW.RNULL
#> Loading  AER 
#>  and running  /tmp/RtmpMPiGPXwontrun_download/AER/AER_0.2-1/scripts/WeakInstrument.RNULL
#> Warning: UNRELIABLE VALUE: Future ('<none>') unexpectedly generated random
#> numbers without specifying argument 'seed'. There is a risk that those random
#> numbers are not statistically sound and the overall results might be invalid.
#> To fix this, specify 'seed=TRUE'. This ensures that proper, parallel-safe random
#> numbers are produced via the L'Ecuyer-CMRG method. To disable this check, use
#> 'seed=NULL', or set option 'future.rng.onMisuse' to "ignore".
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
