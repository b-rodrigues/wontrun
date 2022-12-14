% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/functions.R
\name{setup_wontrun}
\alias{setup_wontrun}
\title{Set up a separate library with the required packages to run examples}
\usage{
setup_wontrun(script_path, wontrun_lib, ...)
}
\arguments{
\item{script_path}{Path to a script. This script will get analyzed for dependencies}

\item{wontrun_lib}{Path to the wontrun library. This library will be used to run the examples.}

\item{...}{Further arguments passed down to install.packages()}
}
\description{
Set up a separate library with the required packages to run examples
}
\details{
This function will look for, and download, the required packages to run the examples from the
archived packages. It is best to not use the default user library to download and install
these packages in, so it is advised to specify a separate library using the `wontrun_lib` argument.
It is also required to install the wontrun package into this library. For this, use the following
command:
withr::with_libpaths(
  wontrun_lib,
  devtools::install_github("b-rodrigues/wontrun", ref = "master",
  upgrade = "never")
  )
}
