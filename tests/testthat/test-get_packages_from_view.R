test_that("get_packages_from_view", {

  view_bayesian <- get_packages_from_view("Bayesian", "2022-01-01")

  reference <- readr::read_csv("view_bayesian.csv",
                               col_types = "cDcl")

  expect_equal(view_bayesian, reference)
})
