test_that("mock summarised result", {
  expect_no_error(validateResult(mockSummarisedResult()))
  expect_true(mockSummarisedResult() |> inherits("summarised_result"))
})
