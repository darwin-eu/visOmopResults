test_that("multiplication works", {
  expect_no_error(mockSummarisedResult())
  expect_true(mockSummarisedResult() |> inherits("summarised_result"))
})
