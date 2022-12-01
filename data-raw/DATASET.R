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

ctv_econ <- get_packages_from_view("Econometrics", date = "2015-01-01")
econ_source <- get_sources_for_selected_packages(ctv_econ)

set.seed(1234)
sources_ctv_econ <- econ_source %>%
  filter(year(last_modified) == 2010) %>%
  group_by(name) %>%
  filter(last_modified == max(last_modified)) %>%
  ungroup() %>%
  select(-as_of) %>%
  sample_n(10)

usethis::use_data(sources_ctv_econ, overwrite = TRUE)

library(tidyverse)
library(janitor)

r0 <- "https://cran.r-project.org/src/base/R-0/"
r1 <- "https://cran.r-project.org/src/base/R-1/"
r2 <- "https://cran.r-project.org/src/base/R-2/"
r3 <- "https://cran.r-project.org/src/base/R-3/"
r4 <- "https://cran.r-project.org/src/base/R-4/"

exdir_path <- "/home/cbrunos/six_to/r_docs"

get_archived_rs <- function(r0){
  read_html(r0) %>%
    html_nodes("table") %>%
    html_table() %>%
    pluck(1) %>%
    clean_names() %>%
    filter(name != "Parent Directory",
           last_modified != "",
           size != "-") %>%
    mutate(last_modified = ymd_hm(last_modified),
           url = paste0(r0, name)) %>%
    separate(name, into = c("name", "version"), sep = "-") %>%
    select(name, version, url, last_modified, size) %>%
    get_examples(clean = FALSE, exdir = exdir_path)
}

get_archived_rs(r0)
get_archived_rs(r1)
get_archived_rs(r2)
get_archived_rs(r3)
get_archived_rs(r4)

# delete unneeded files
all_files <- list.files(paste0(exdir_path, "/wontrun_download/R/"),
             full.names = TRUE,
             all.files = TRUE,
             recursive = TRUE)

files_to_delete <- all_files %>%
  discard(~grepl("src/library/.*/man/",.))

unlink(files_to_delete,
       recursive = TRUE)

# delete empty directories that remain
system("find /home/cbrunos/six_to/r_docs/wontrun_download/R/ -empty -type d -delete")
file.copy(from = current_files, to = new_files, 
          overwrite = recursive, recursive = FALSE, copy.mode = TRUE)

file.copy(
  "/home/cbrunos/six_to/r_docs/wontrun_download/R/0.49.tgz/src/library/",
  "/home/cbrunos/six_to/r_docs/wontrun_download/R/0.49.tgz/",
  recursive = TRUE , copy.mode = TRUE
            )

folder_paths <- list.files(paste0(exdir_path, "/wontrun_download/R/"),
           full.names = TRUE)

library(magrittr)

file_copy <- function(from, exdir, ...){
  file.copy(from = paste0(from, exdir), ...)
  from
}

folders <- list.files(paste0(exdir_path, "/wontrun_download/R"))

move_up_twice <- function(path_to_rversion){

  root_path <- paste0("/home/cbrunos/six_to/r_docs/wontrun_download/R/",
                      path_to_rversion,
                      "/src/library")

  folder_paths <- list.files(root_path,
                             full.names = TRUE)

  folders_to_create <- str_remove_all(folder_paths, "src/library/") %>%
    paste0("/man")

  map(folders_to_create, dir.create, recursive = TRUE)

  files_to_move <- list.files(root_path,
                              full.names = TRUE,
                              recursive = TRUE)

  files_to_move %>%
    map(~file.rename(., str_remove_all(., "src/library/")))


}

map(folders, move_up_twice)

system("find /home/cbrunos/six_to/r_docs/wontrun_download/R/ -empty -type d -delete")

folders <- list.files(paste0(exdir_path, "/wontrun_download/R"),
                      recursive = TRUE,
                      full.names = TRUE) %>%
  keep(~grepl("src", .))

unlink(folders,
       recursive = TRUE)

system("find /home/cbrunos/six_to/r_docs/wontrun_download/R/ -empty -type d -delete")

files_to_convert <- list.files(paste0(exdir_path, "/wontrun_download/R"),
                      recursive = TRUE,
                      full.names = TRUE)

p_gen <- purrr::possibly(generate_script_from_help, otherwise = NULL)

walk(files_to_convert, p_gen)
