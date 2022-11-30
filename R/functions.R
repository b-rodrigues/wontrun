#' Generates an R script with the examples from an Rd file.
#' @param path_to_rd String. Path to Rd file you wish to convert to a script
#' @param rm_dont_run Boolean. Should scripts with \dontrun tag be ignored? Defaults to TRUE.
#' @importFrom stringr str_extract str_replace
#' @importFrom tools Rd2ex
#' @return Side-effect. No returned object, writes a script on disk.
#' @export
#' @details
#' This function is a wrapper around `tools::Rd2ex()` tht extracts the examples from Rd files included in
#' the man/ folder of source packages and writes them to disk, next to the Rd files.
#' @examples
#' get_archived_sources("AER")
generate_script_from_help <- function(path_to_rd, rm_dont_run = TRUE){

  # Get root of package, with man/
  folder_root <- stringr::str_extract(path_to_rd,
                                      "^(.*?man\\/)")

  # Detect if resulting script file has a \dontrun tag
  # if yes, remove just ignore it. This is a bit overkill, because
  # in cases where there's this tag alongside valid examples, they 
  # all get ignored. I still expect this to happen rarely though.
  if({
    readLines(path_to_rd) %>%
      stringr::str_detect("dontrun") %>%
      any()
  }){
    return(NULL)
  } else {

  # Replace man/ with scripts/
  scripts_path <- stringr::str_replace(folder_root, "man", "scripts")

  # Check if scripts/ exists. If not, create it
  if (!dir.exists(scripts_path)){
    dir.create(scripts_path)
  } else {
    NULL
  }

  # Create path to save script to scripts/
  script_path <- stringr::str_replace(path_to_rd, "man", "scripts")
  script_path <- stringr::str_replace(script_path, "\\.Rd", "\\.R")

  # By default, stages = "render", which executes \Sexpr macros
  # this was problematic because code would get executed and fail
  # even if it was outside examples (see dplyr 0.8's combine.Rd for example)
  tools::Rd2ex(path_to_rd, script_path, stages = "build")

  }

}

#' Creates a tibble with the urls to the archived sources of a package
#' @param package String. Name of the package to query
#' @importFrom rvest read_html html_nodes html_table
#' @importFrom purrr pluck
#' @importFrom janitor clean_names
#' @importFrom dplyr filter mutate select
#' @importFrom lubridate ymd_hm
#' @importFrom stringr str_remove_all
#' @return A tibble of 4 columns, `name`, `url`, `last_modified`, `size`
#' @export
#' @details
#' The returned table is the same as the html table that can be found in the CRAN
#' archive url of a package, for instance \url{https://cran.r-project.org/src/contrib/Archive/AER/}.
#' The `url` column is added to make it easier to download a source package.
#' This function is used by `get_sources_for_selected_packages()`.
#' @examples
#' \dontrun{
#' get_archived_sources("AER")
#' }
get_archived_sources <- function(package){

  root_url <- "https://cran.r-project.org/src/contrib/Archive/"

  package_archive_url <- paste0(root_url, package)

  package_archive_url %>%
    read_html() %>%
    html_nodes("table") %>%
    html_table() %>%
    pluck(1) %>%
    clean_names() %>%
    filter(name != "Parent Directory",
           last_modified != "",
           size != "-") %>%
    mutate(last_modified = ymd_hm(last_modified),
           url = paste0(root_url, package, "/", name)) %>%
    select(version = name, url, last_modified, size) %>%
    mutate(version = str_remove_all(version, "\\.tar\\.gz"),
           name = package) %>%
    select(name, everything())
}


#' Check if installed version of package is latest
#' @param package String. Package name.
#' @importFrom pkgsearch cran_package
#' @return Side-effect. Raises a warning if package is outdated.
#' @details
#' This function uses `pkgsearch::cran_package()` to check whether the installed version of a package is the latest available on CRAN. Useful to alert the user.
#' @examples
#' \dontrun{
#' check_package_version("AER")
#' }
check_package_version <- function(package){

  current_version <- pkgsearch::cran_package(package)$Version

  installed_version <- packageVersion(package)

  if(current_version != installed_version){
    warning(paste0("Installed version of ", package, " is not the latest available version on CRAN. You might want to update ", package, "."))

  }

}

#' Get a tibble with current available packages on CRAN
#' @param ... Arguments passed down to `available.packages()`
#' @importFrom janitor clean_names
#' @importFrom tibble as_tibble
#' @return A tibble of 17 columns
#' @export
#' @details
#' This function is a simple wrapper around `available.packages()`
#' @examples
#' \dontrun{
#' get_available_packages()
#' }
get_available_packages <- function(...){

  as_tibble(available.packages(...)) %>%
    janitor::clean_names()

}

#' Get a tibble of packages from a CRAN Task View
#' @param view String. View of interest
#' @param date String, format: '2015-01-01'. Queries MRAN to download state of the view at given date
#' @importFrom ctv ctv
#' @importFrom tibble as_tibble
#' @importFrom lubridate ymd
#' @return A tibble of 2 columns
#' @export
#' @details
#' This function is a simple wrapper around `ctv::ctv()`.
#' @examples
#' \dontrun{
#' get_packages_from_view("Econometrics")
#' get_packages_from_view("Bayesian", "2022-01-01")
#' }
get_packages_from_view <- function(view, date = "2015-01-01"){
  ctv::ctv(view = view,
           repos = paste0("https://cran.microsoft.com/snapshot/",
                          date)) %>%
    pluck("packagelist") %>%
    as_tibble() %>%
    mutate(as_of = ymd(date),
           view = view,
           name = as.character(name)) %>%
    select(view, as_of, everything()) 
}

#' Get a tibble of source urls for a selection of packages
#' @param view_df A data frame as returned by `get_packages_from_view()`
#' @importFrom dplyr mutate select rename
#' @importFrom tidyr unnest
#' @importFrom purrr map possibly
#' @return A tibble of 5 columns.
#' @export
#' @details
#' This function returns a data frame with a column `name` giving the name
#' of a package, `version` giving its version, `url` the download url
#' `last_modified` the date on which the package was last modified on CRAN
#' and `size`, the size of the package
#' @examples
#' \dontrun{
#' ctv_econ <- get_packages_from_view("Econometrics", date = "2015-01-01")
#' get_sources_for_selected_packages(ctv_econ)
#' }
get_sources_for_selected_packages <- function(view_df){

  p_gas <- possibly(get_archived_sources, otherwise = NULL)

  view_df %>%
    mutate(sources = map(name, p_gas)) %>%
    select(-any_of("core")) %>%
    unnest(cols = c(sources))

}

#' Downloads doc files from an archived source package, and generates an R script from it.
#' @param name String. Name of the packages.
#' @param version String. Version of the package to download.
#' @param url String. Link to archived package tar file.
#' @param clean Boolean, defaults to TRUE. If TRUE, only keeps man/ folder containing the documentaton. If FALSE, keeps entire package.
#' @param exdir String. Path to directory to save examples. Defaults to NULL, so a temporary directory gets used.
#' @importFrom purrr keep map
#' @return Side-effect. No returned object, writes a Rd files to disk.
#' @details
#' This function returns a data frame with a column `name` giving the name
#' of a package, `version` giving its version, `url` the download url
#' `last_modified` the date on which the package was last modified on CRAN
#' and `size`, the size of the package
get_example <- function(name, version, url, clean = TRUE, exdir = NULL){

  path_tempfile <- tempfile(fileext = ".tar.gz")

  path_tempdir <- tempdir()

  message("Downloading package ", version)
    download.file(url,
                  destfile = path_tempfile,
                  quiet = TRUE)

  if(is.null(exdir)){
    exdir_path <- paste0(path_tempdir, "wontrun_download/", name, "/", version)
  } else {
    if (!dir.exists(exdir)){
      dir.create(exdir)
    }
    exdir_path <- paste0(exdir, "/wontrun_download/", name, "/", version)
  }

  untar(path_tempfile, exdir = exdir_path, extras = "--strip-components=1")

  if(clean){

    files_to_delete <- list.files(exdir_path,
                                  full.names = TRUE) %>%
      setdiff(paste0(path_tempdir, "/wontrun_download/", name, "/", version, "/man"))

    unlink(files_to_delete,
           recursive = TRUE)
  }

  rds_paths <- list.files(paste0(exdir_path, "/man"), full.names = TRUE)

  # need to remove paths that are pointing to .Rd files (for example dplyr 0.7.5
  # has a `figures` folder in `man/` which causes a bug


  rds_paths <- rds_paths %>%
    keep(\(x)(grepl("\\.Rd$", x))) 

  map(rds_paths,
      generate_script_from_help)

  exdir_path

}


#' Downloads Rd from an archived source package
#' @param sources_df Data frame. A data frame as returned by `get_sources_for_selected_packages()`
#' @param test Boolean, defaults to FALSE. TRUE is only useful for running unit tests.
#' @param ... Further arguments passed down to get_example().
#' @return Side-effect. No returned object, writes a Rd files to disk.
#' @importFrom dplyr mutate
#' @importFrom purrr pmap_chr
#' @export
#' @examples
#' \dontrun{
#' # First, get list of packages. In this case, the ones in the "Econometrics" view as of "2015-01-01"
#' ctv_econ <- get_packages_from_view("Econometrics", date = "2015-01-01")
#'
#' # Now, get the names, versions, and urls for these packages
#' ctv_econ_sources <- get_sources_for_selected_packages(ctv_econ)
#'
#' # It is now possible to download the man/ folders of these packages with the following lines
#' get_examples(ctv_econ_sources)
#' }
get_examples <- function(sources_df, test = FALSE, ...){
  sources_df <- sources_df |>
    mutate(exdir_path = pmap_chr(list(name, version, url), get_example, ...))

  if(test){
    exdir_path <- sources_df |>
      pull(exdir_path)

    list.files(exdir_path, all.files = TRUE, recursive = TRUE)
  } else {
    return(sources_df)
  }
}


#' @importFrom purrr keep
#' @importFrom stringr str_remove_all str_trim
#' @importFrom renv dependencies
#' @export
setup_wontrun <- function(script_path, wontrun_lib, ...){

  #withr::with_libpaths(wontrun_lib,
  #                     devtools::install_github("b-rodrigues/wontrun", ref = "master",
  #                                              upgrade = "never")
  #                     )

  deps <- renv::dependencies(script_path, progress = FALSE)

  loaded_data <- readLines(script_path) %>%
    purrr::keep(~grepl("data.*,package =", .)) %>%
    stringr::str_remove_all("(.*package.*=)") %>%
    stringr::str_remove_all('\\(|\\)|\\"') %>%
    stringr::str_trim()

  packages <- c(
    "callr",
    "devtools",
    "digest",
    "furrr",
    "future",
    "globals",
    "listenv",
    "pacman",
    "parallelly",
    "processx",
    "ps",
    "renv",
    deps$Package,
    loaded_data
    )

  installed_packages <- packages %in% rownames(installed.packages(lib.loc = wontrun_lib))

  if (any(installed_packages == FALSE)) {
    install.packages(packages[!installed_packages],
                     lib = wontrun_lib,
                     ask = F,
                     dependencies = TRUE,
                     ...)
  }

}


#' @importFrom pacman p_load
#' @export
with_pload <- function(package, code){

  pacman::p_load(char = package)

  on.exit(detach(paste0("package:", package), character.only = TRUE))

  force(code)

}

#' @importFrom callr r_vanilla
#' @importFrom rlang try_fetch
#' @importFrom future plan
#' @importFrom furrr future_map2
#' @export
run_examples <- function(sources_df_with_path,
                         ncpus,
                         setup,
                         wontrun_lib,
                         ...){


  if (!dir.exists(wontrun_lib)){
    dir.create(wontrun_lib)
  }

  run_script <- function(name, script, libpath = wontrun_lib){

    print(cat("Loading ", name, "\n", "and running ", script))
    callr::r_vanilla(function(x, y){ #x is the package, y is the source file to run
      wontrun::with_pload(x,
                 rlang::try_fetch(
                          source(y),
                          condition = function(cnd) cnd))
    },
    args = list(x = name, y = script),
    libpath = libpath
    )
  }


  future::plan(future::multisession, workers = ncpus)

 # sources_df_with_path <- sources_df_with_path %>%
  sources_df_with_path <- sources_df_with_path %>%
    mutate(exdir_script_path = paste0(exdir_path, "/scripts")) %>%
    dplyr::group_by(name) %>%
    mutate(scripts_paths = list(
             list.files(exdir_script_path, full.names = TRUE))
           ) %>%
    dplyr::ungroup() %>%
    unnest(cols = c(scripts_paths))

  if(setup){
    message("Setting up wontrun_lib")
    sources_df_with_path$scripts_paths %>%
      purrr::map(~setup_wontrun(., wontrun_lib = wontrun_lib))
    message("Done setting up wontrun_lib")
  }


  sources_df_with_path %>%
    mutate(runs = furrr::future_map2(
                           name,
                           scripts_paths,
                           run_script))


}

#' wontrun
#' @param packages_df Data frame. A data frame as returned by `get_archived_sources()`
#' @param ncpus Integer. Number of cpus to run examples in parallel.
#' @param years Integer. Year or atomic vector of years to select packages to run examples.
#' @param earliest Boolean. Select oldest package from year.
#' @return Side-effect. No returned object, writes a Rd files to disk.
#' @importFrom dplyr filter group_by ungroup mutate
#' @importFrom lubridate year
#' @importFrom rlang quo `!!`
#' @export
#' @examples
#' \dontrun{
#' aer_sources <- get_archived_sources("AER")
#' aer_runs <- aer_sources %>%
#'   wontrun(ncpus = 6, years = 2008)
#' }
wontrun <- function(packages_df,
                    ncpus = 1,
                    years = NULL,
                    earliest = TRUE,
                    setup = FALSE,
                    wontrun_lib){

  if(is.null(years)){

    years <- quo(year(last_modified))

  }

  packages_df_sources <- packages_df %>%
    #get_sources_for_selected_packages(packages_df) %>%
    filter(year(last_modified) %in% !!years)

  if(earliest){
    packages_df_sources <- packages_df_sources %>%
      group_by(name,  year(last_modified)) %>%
      filter(last_modified == min(last_modified)) %>%
      ungroup() %>%
      select(-contains("year"))
  }

  message("Running examples...")
  run_examples(
    get_examples(packages_df_sources),
    ncpus = ncpus,
    setup = setup,
    wontrun_lib = wontrun_lib
  )
}


#' Adds two columns to help decode the results of wontrun()
#' @param wontrun_df Data frame. A data frame as returned by `wontrun()`
#' @return The input tibble with 2 more columns, `classes` and `cnd_message`
#' @importFrom dplyr mutate
#' @importFrom rlang cnd_message
#' @importFrom purrr map map_chr map_lgl
#' @export
#' @examples
#' \dontrun{
#' aer_sources <- get_archived_sources("AER")
#' aer_runs <- aer_sources %>%
#'   wontrun(ncpus = 6, years = 2008)
#' decode_wontrun(aer_runs)
#' }
decode_wontrun <- function(wontrun_df){
  wontrun_df %>%
    select(name, version, last_modified, scripts_paths, runs) %>%
    mutate(scripts = stringr::str_remove_all(scripts_paths, ".*/scripts/"),
           classes = map(runs, class),
           classes = map_chr(classes,
                             ~paste0(., collapse = "-")),
           message = map_chr(runs, cnd_message)) %>%
    select(-scripts_paths)
}
