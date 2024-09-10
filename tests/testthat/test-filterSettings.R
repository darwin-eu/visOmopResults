test_that("filterSettings", {
  result <- omopgenerics::emptySummarisedResult()

  expect_no_error(result1 <- result |>
                    filterSettings(result_type == "omock")
  )


  expect_identical(result, result1)


})
