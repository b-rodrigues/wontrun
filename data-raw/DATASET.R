## code to prepare `DATASET` dataset goes here

library(wontrun)
library(dplyr)
library(lubridate)
library(ctv)

# First, let's get the CTVs:

available_ctvs <- names(available.views())

# Let's now define the periods of interest:

dates <- purrr::cross_df(
                  list(
                    "years" = seq(2015, 2022),
                    "months" = c("-01-01", "-06-01")
                  )) %>%
  mutate(dates = paste0(years, months)) %>%
  pull(dates)

# Let's get the packages from the CTVs at these dates:

# To avoid errors
possibly_gpv <- purrr::possibly(get_packages_from_view, otherwise = NULL)

ctvs_through_time <- dates %>%
  map(.,
      function(x)(map(available_ctvs,
               ~possibly_gpv(view = ., date = x))))

n_packages_time <- ctvs_through_time %>%
  bind_rows() %>%
  group_by(view, as_of) %>%
  summarise(total_packages = n_distinct(name),
            .groups = "drop") %>%
  mutate(as_of = lubridate::ymd(as_of))

usethis::use_data(n_packages_time, overwrite = TRUE)
