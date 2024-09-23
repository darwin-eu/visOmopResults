test_that("test columns in mock", {
  # group columns
  expect_identical(
    mockSummarisedResult() |> groupColumns(),
    c("cohort_name")
  )

  # strata columns
  expect_identical(
    mockSummarisedResult() |> strataColumns(),
    c("age_group", "sex")
  )

  # additional columns
  expect_identical(
    mockSummarisedResult() |> additionalColumns(),
    character()
  )

  # tidyColumns
  expect_identical(
    colnames(tidy(mockSummarisedResult())),
    tidyColumns(mockSummarisedResult())
  )
  expect_identical(
    colnames(tidy(omopgenerics::emptySummarisedResult())),
    tidyColumns(omopgenerics::emptySummarisedResult())
  )

})

test_that("settingsColumns", {
  result <- mockSummarisedResult()

  cols <- result |>
    validateSettingsAttribute() |>
    colnames()

  cols <- cols[cols != "result_id"]

  expect_equal(settingsColumns(result), cols)
})
