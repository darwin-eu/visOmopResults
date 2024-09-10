test_that("filterSettings", {
  result <- omopgenerics::emptySummarisedResult()

  expect_no_error(result1 <- result |>
                    filterSettings(result_type == "omock")
  )

  expect_identical(result, result1)

  result <- mockSummarisedResult()
  expect_identical(
    result,
    result |> filterSettings(result_type == "mock_summarised_result")
  )
  expect_warning(
    result0 <- result |> filterSettings(variable_does_not_exist == TRUE)
  )
  expect_true(nrow(result0) == 0)

})
