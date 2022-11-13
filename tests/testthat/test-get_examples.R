test_that("get_examples", {
  ctv_econ_sources_tests <- readr::read_csv("ctv_econ_sources_tests.csv",
                                            show_col_types = FALSE)

  files_to_check <- get_examples(ctv_econ_sources_tests, test = TRUE) %>%
    sort()

  reference <- readRDS("get_examples_reference.rds") %>%
    sort()

  expect_equal(files_to_check, reference)

  })
