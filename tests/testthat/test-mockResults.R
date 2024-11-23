test_that("mock summarised result", {
  expect_no_error(omopgenerics::validateResultArgument(mockSummarisedResult()))
  expect_true(mockSummarisedResult() |> inherits("summarised_result"))
})
