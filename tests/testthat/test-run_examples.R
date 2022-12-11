paths <- "tests/testthat/test-run_examples_files/"

scripts_paths <- list.files(paths,
                            all.files = TRUE,
                            recursive = TRUE)

scripts_df <- scripts_paths %>%
  as_tibble() %>%
  mutate(scripts_paths = paste0(paths, value),
         name = "base",
         script = value)

test_that("run_examples for base", {
  result <- run_examples(scripts_df,
                         base = TRUE,
                         ncpus = 4,
                         setup = FALSE,
                         script_path_create = FALSE,
                         wontrun_lib = "~/six_to/wontrun_lib")

  expected <- readRDS("~/six_to/wontrun/tests/testthat/run_examples_for_base_result.Rds")

  expect_identical(result, expected)

})

scripts_df <- scripts_paths %>%
  as_tibble() %>%
  mutate(scripts_paths = paste0(paths, value),
         name = "stepfun",
         script = value)

test_that("run_examples for stats", {
  result <- run_examples(scripts_df,
                         base = TRUE,
                         ncpus = 4,
                         setup = FALSE,
                         script_path_create = FALSE,
                         wontrun_lib = "~/six_to/wontrun_lib")

  expected <- readRDS("~/six_to/wontrun/tests/testthat/run_examples_for_base_result.Rds") %>%
    mutate(fix = "Replaced packages for {stats}") 

  expect_identical(result, expected)

})

scripts_df <- scripts_paths %>%
  as_tibble() %>%
  mutate(scripts_paths = paste0(paths, value),
         name = "mle",
         script = value)

test_that("run_examples for stats", {
  result <- run_examples(scripts_df,
                         base = TRUE,
                         ncpus = 4,
                         setup = FALSE,
                         script_path_create = FALSE,
                         wontrun_lib = "~/six_to/wontrun_lib")

  expected <- readRDS("~/six_to/wontrun/tests/testthat/run_examples_for_base_result.Rds") %>%
    mutate(fix = "Replaced packages for {stats4}") 

  expect_identical(result, expected)

})
