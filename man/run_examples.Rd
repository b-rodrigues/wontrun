% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/functions.R
\name{run_examples}
\alias{run_examples}
\title{Runs the examples in a separate session (one for each script).}
\usage{
run_examples(
  sources_df_with_path,
  base = FALSE,
  ncpus,
  setup,
  script_path_create = TRUE,
  wontrun_lib,
  ...
)
}
\arguments{
\item{sources_df_with_path}{A data frame columns `name` (of the package), `version` (of the package), (name of) `script` and `scripts_paths` (paths to script, optional). Each row represents a script.}

\item{base}{Boolean. Are you running packages from a base install of R (`base`, `compiler`, `datasets`, `stats`, etc). Defaults to FALSE.}

\item{ncpus}{Number of cpus to use for running examples in parallel.}

\item{setup}{Should this function install missing dependencies, using `setup_wontrun`?}

\item{script_path_create}{Boolean. Should paths to scripts be generated? Use this if the input data frame does not have the `scripts_paths` column.}

\item{wontrun_lib}{Path to wontrun library set up for the project.}
}
\description{
Runs the examples in a separate session (one for each script).
}
\details{
This function is called by the `wontrun()` function, so usually, users do not need to use it.
However, should you already have a data frame with paths to individual scripts, then you should use this function to run examples
and not `wontrun()`. See the vignettes for more details.
}
