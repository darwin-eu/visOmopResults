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
})
