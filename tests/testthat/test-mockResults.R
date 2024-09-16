test_that("mock summarised result", {
  expect_no_error(omopgenerics::validateResultArguemnt(mockSummarisedResult()))
  expect_true(mockSummarisedResult() |> inherits("summarised_result"))
})
