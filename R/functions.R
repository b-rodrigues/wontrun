#' Generates an R script with the examples from an Rd file.
#' @param path_to_rd String. Path to Rd file you wish to convert to a script
#' @importFrom stringr str_extract str_replace
#' @importFrom tools Rd2ex
#' @return Side-effect. No returned object, writes a script on disk.
#' @export
#' @details
#' This function is a wrapper around `tools::Rd2ex()` tht extracts the examples from Rd files included in
#' the man/ folder of source packages and writes them to disk, next to the Rd files.
#' @examples
#' get_archived_sources("AER")
generate_script_from_help <- function(path_to_rd){

  # Get root of package, with man/
  folder_root <- stringr::str_extract(path_to_rd,
                                      "^(.*?man\\/)")

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

  tools::Rd2ex(path_to_rd, script_path)
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
#' dontrun{
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
    mutate(version = str_remove_all(version, "\\.tar\\.gz"))
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
#' @importFrom purrr map
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

  p_gas <- purrr::possibly(get_archived_sources, otherwise = NULL)
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
#' @return Side-effect. No returned object, writes a Rd files to disk.
#' @details
#' This function returns a data frame with a column `name` giving the name
#' of a package, `version` giving its version, `url` the download url
#' `last_modified` the date on which the package was last modified on CRAN
#' and `size`, the size of the package
get_example <- function(name, version, url, clean = TRUE){

  path_tempfile <- tempfile(fileext = ".tar.gz")

  path_tempdir <- tempdir()

  message("Downloading package ", version)
    download.file(url,
                  destfile = path_tempfile,
                  quiet = TRUE)

  exdir_path <- paste0(path_tempdir, "wontrun_download/", name, "/", version)

  untar(path_tempfile, exdir = exdir_path, extras = "--strip-components=1")

  if(clean){

    files_to_delete <- list.files(exdir_path,
                                  full.names = TRUE) %>%
      setdiff(paste0(path_tempdir, "wontrun_download/", name, "/", version, "/man"))

    unlink(files_to_delete,
           recursive = TRUE)
  }

  rds_paths <- list.files(paste0(exdir_path, "/man"), full.names = TRUE)

  purrr::map(rds_paths,
             generate_script_from_help)

  exdir_path

}


#' Downloads Rd from an archived source package
#' @param sources_df Data frame. A data frame as returned by `get_sources_for_selected_packages()`
#' @param clean Boolean, defaults to TRUE. If TRUE, only keeps man/ folder containing the documentaton. If FALSE, keeps entire package.
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
get_examples <- function(sources_df, clean = TRUE){
  sources_df |>
    mutate(exdir_path = pmap_chr(list(name, version, url), get_example, clean))

}

#' @export
run_examples <- function(sources_df_with_path){

  chatty_source <- function(name, script){
    print(paste0("Running", script))
    withr::with_package(name, source(script))
  }

  run_script <- function(name, script){
    print(cat("Loading ", name, "\n", "and running ", script))
    callr::r(function(x, y){
      withr::with_package(x, source(y))},
      args = list(x = name, y = script)
    )
  }

  p_run_script <- purrr::possibly(run_script, otherwise = NULL)

 # sources_df_with_path <- sources_df_with_path %>%
  sources_df_with_path %>%
    mutate(exdir_script_path = paste0(exdir_path, "/scripts")) %>%
    dplyr::group_by(name) %>%
    mutate(scripts_paths = list(
             list.files(exdir_script_path, full.names = TRUE))
           ) %>%
    dplyr::ungroup() %>%
    unnest(cols = c(scripts_paths)) %>%
    mutate(runs = purrr::map2(
                           name,
                           scripts_paths,
                           p_run_script))

 # scripts_path <- list.files(paste0(exdir_path, "/scripts"), full.names = TRUE)
 # purrr::map(scripts_path, replace_with_pload)


}

