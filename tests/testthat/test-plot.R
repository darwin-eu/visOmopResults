test_that("Function returns a ggplot object", {

  result <- mockSummarisedResult() |>
    dplyr::filter(variable_name == "age")

  expect_no_error(
    plotScatter(
      result = result,
      x = "cohort_name",
      y = "mean",
      facet = c("age_group", "sex"))
  )

  result <- mockSummarisedResult() |>
    dplyr::filter(variable_name == "age") |>
    pivotEstimates() |>
    dplyr::mutate(q25 = mean - sd, q75 = mean + sd, min = mean - 2*sd, max = mean + 2*sd) |>
    tidyr::pivot_longer(
      c("mean", "sd", "q25", "q75", "min", "max"),
      names_to = "estimate_name",
      values_to = "estimate_value") |>
    dplyr::mutate(estimate_type = "numeric") |>
    omopgenerics::newSummarisedResult()

  expect_no_error(
    plotBoxplot(
      result,
      lower = "q25",
      middle = "mean",
      upper = "q75",
      ymin = "min",
      ymax = "max",
      facet = age_group ~ sex,
      colour = "cohort_name")
  )
})
