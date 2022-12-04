test_that("test source2", {
  head_renert <- withr::with_temp_libpaths({
    source2("script_source2.R", install_deps = TRUE)
  }, action = "replace")
  expected <- read.csv("head_renert.csv")

  expect_equal(head_renert$value, expected, ignore_attr = TRUE)
})
