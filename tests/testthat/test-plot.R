test_that("Function returns a ggplot object", {
  result <- mockSummarisedResult() |>
  dplyr::filter(variable_name == "Medications",
  strata_name == "overall")
  graphs <- plotfunction(result, plotStyle = "barplot")
  expect_true(ggplot2::is.ggplot(graphs))
})
