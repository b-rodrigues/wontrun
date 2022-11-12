test_that("get_sources_for_selected_packages", {

  reference <- readr::read_csv("view_bayesian_sources.csv",
                               show_col_types = FALSE)

  view_bayesian <- readr::read_csv("view_bayesian.csv",
                                   show_col_types = FALSE)

  out <- get_sources_for_selected_packages(view_bayesian)

  expect_equal(reference, out)

})
