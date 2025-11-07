test_that("check utilities", {
  expect_error(validateSummarisedResult(1))
})
test_that("helper table functions", {
  expect_equal(names(tableOptions()), c(
    'decimals', 'decimalMark', 'bigMark', 'keepNotFormatted', 'useFormatOrder',
    'delim', 'includeHeaderName', 'includeHeaderKey', 'na', 'title',
    'subtitle', 'caption', 'groupAsColumn', 'groupOrder', 'merge'
  ))

  expect_true(all(c("tibble", "flextable", "gt") %in% tableType()))
})
