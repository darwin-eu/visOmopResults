test_that("README works", {
  expect_no_error(
    mockSummarisedResult() |>
      formatEstimateValue(
        decimals = c(integer = 0, numeric = 2, percentage = 1, proportion = 3),
        decimalMark = ".",
        bigMark = ",") |>
      formatEstimateName(
        estimateNameFormat = c("N (%)" = "<count> (<percentage>%)",
                               "N" = "<count>",
                               "Mean (SD)" = "<mean> (<sd>)"),
        keepNotFormatted = FALSE) |>
      formatHeader(header = c("Study strata", "strata_name", "strata_level"),
                 delim = "\n",
                 includeHeaderName = FALSE,
                 includeHeaderKey = TRUE) |>
      gtTable(
        delim = "\n",
        style = "default",
        na = "-",
        title = "My first gt table with VisOmopResults!",
        groupColumn = "group_level",
        groupAsColumn = FALSE,
        groupOrder = c("cohort1", "cohort2")
      )
  )
})
