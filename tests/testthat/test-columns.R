test_that("test columns in mock", {
  # group columns
  expect_identical(
    mockSummarisedResult() |> groupColumns(),
    c("cohort_name")
  )
  expect_identical(
    mockSummarisedResult() |> groupColumns(overall = FALSE),
    c("cohort_name")
  )
  expect_identical(
    mockSummarisedResult() |> groupColumns(overall = TRUE),
    c("cohort_name")
  )

  # strata columns
  expect_identical(
    mockSummarisedResult() |> strataColumns(),
    c("age_group", "sex")
  )
  expect_identical(
    mockSummarisedResult() |> strataColumns(overall = FALSE),
    c("age_group", "sex")
  )
  expect_identical(
    mockSummarisedResult() |> strataColumns(overall = TRUE),
    c("overall", "age_group", "sex")
  )

  # additional columns
  expect_identical(
    mockSummarisedResult() |> additionalColumns(),
    character()
  )
  expect_identical(
    mockSummarisedResult() |> additionalColumns(overall = FALSE),
    character()
  )
  expect_identical(
    mockSummarisedResult() |> additionalColumns(overall = TRUE),
    c("overall")
  )
})
