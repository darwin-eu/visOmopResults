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

test_that("test settingsColumn", {

  result <- mockSummarisedResult()

  set <- settingsColumns(result)

  expect_equal(set, validateSettingsAttribute(result))

  })
