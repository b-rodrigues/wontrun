test_that("generate_script_from_help works", {
  generate_script_from_help("gmm.Rd")
  reference <- readLines("gmm_reference.R")
  new <- readLines("gmm.R")
  expect_equal(reference, new)
})
