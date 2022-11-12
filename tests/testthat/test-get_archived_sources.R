test_that("get_archived_sources", {
  # only use head because this grows with 
  # time
  aer_sources <- get_archived_sources("AER") |>
    head()

  reference <- readr::read_csv("aer_sources.csv",
                               show_col_types = FALSE)

  expect_equal(aer_sources, reference)


})
