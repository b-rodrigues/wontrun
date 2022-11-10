#' Number of packages in CRAN Task Views, per view
#'
#' @format A data frame with 515 rows and 3 columns
#' \describe{
#'   \item{view}{CRAN Task view.}
#'   \item{as_of}{A date. Number of packages as of this date.}
#'   \item{total_packages}{Total packages available in the view.}
#' }
"n_packages_time"

#' A sample of packages from the 'Econometrics' view as of 2010.
#'
#' @format A data frame with 10 rows and 7 columns
#' \describe{
#'   \item{view}{CRAN Task view, only 'Econometrics' here.}
#'   \item{name}{A date. Number of packages as of this date.}
#'   \item{version}{Package version.}
#'   \item{url}{Download url.}
#'   \item{last_modified}{Date at which the package was last modified.}
#'   \item{size}{Size of the source tarball.}
#' }
"sources_ctv_econ"
