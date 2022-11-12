test_that("get_sources_for_selected_packages", {

  reference <- readr::read_csv("view_bayesian_sources.csv",
                               col_types = "cDcl")

  out <- get_sources_for_selected_packages(reference)

})
