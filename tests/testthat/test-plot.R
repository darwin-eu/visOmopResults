test_that("Function returns a ggplot object", {

  has_no_legend_labels <- function(plot) {
    labels <- plot$labels
    is.null(labels$fill) && is.null(labels$colour)
  }

  result <- mockSummarisedResult() |>
    dplyr::filter(variable_name == "age")
  p <- scatterPlot(
    result = result,
    x = "cohort_name",
    y = "mean",
    line = TRUE,
    point = TRUE,
    ribbon = FALSE,
    facet = c("age_group", "sex")) +
    themeVisOmop()

  expect_no_error(p)

  expect_true(has_no_legend_labels(p))

  result <- mockSummarisedResult() |>
    dplyr::filter(variable_name == "age") |>
    pivotEstimates() |>
    dplyr::mutate(q25 = mean - sd, q75 = mean + sd, min = mean - 2*sd, max = mean + 2*sd) |>
    tidyr::pivot_longer(
      c("mean", "sd", "q25", "q75", "min", "max"),
      names_to = "estimate_name",
      values_to = "estimate_value") |>
    dplyr::mutate(
      estimate_type = "numeric",
      estimate_value = as.character(.data$estimate_value)) |>
    omopgenerics::newSummarisedResult()


  p_box <- boxPlot(
    result,
    x = "variable_name",
    lower = "q25",
    middle = "mean",
    upper = "q75",
    ymin = "min",
    ymax = "max",
    facet = age_group ~ sex,
    colour = "cohort_name",
    label = "min"
    ) +
    themeVisOmop(fontsizeRef = 10, legendPosition = "bottom")

  expect_no_error(p_box)

  expect_false(has_no_legend_labels(p_box))
  expect_true(p_box$theme$axis.title.y$size == 10)
  expect_true(p_box$theme$legend.position == "bottom")
  expect_true(p_box$labels$label1 == "min")

  expect_no_error(
    p <- scatterPlot(
      result,
      x = "sex",
      line = TRUE,
      point = TRUE,
      ribbon = TRUE,
      y =  "mean",
      ymin = "q25",
      ymax = "q75",
      facet = "age_group",
      colour = "cohort_name",
      label = c("age_group", "mean", "cohort_name")
    ) +
      themeVisOmop()
  )
  expect_true(p$labels$label1 == "age_group")
  expect_true(p$labels$label2 == "mean")
  expect_true(p$labels$label3 == "cohort_name")

  result <- mockSummarisedResult() |>
    dplyr::filter(variable_name == "age")

  p_bar <- barPlot(
    result = result,
    x = "cohort_name",
    y = "mean",
    facet = c("age_group", "sex"), label = c("cohort_name")) +
    themeVisOmop()

  expect_no_error(p_bar)
  expect_true(has_no_legend_labels(p_bar))
  expect_true(p_bar$labels$label1 == "cohort_name")

  expect_message(
    result |>
      dplyr::union_all(
        result |>
          dplyr::mutate('variable_name' = 'age2')
      ) |>
      barPlot(
        x = "cohort_name",
        y = "mean",
        facet = c("age_group", "sex"))
  )

  expect_message(
    scatterPlot(
      result,
      x = "sex",
      line = TRUE,
      point = TRUE,
      ribbon = FALSE,
      y =  "mean",
      facet = "age_group")
  )

  expect_error(
    scatterPlot(
      result,
      x = "sex",
      y =  "xxx",
      line = TRUE,
      point = TRUE,
      ribbon = FALSE,
      facet = "age_group")
  )

  expect_error(
    mockSummarisedResult() |>
      dplyr::filter(
        .data$variable_name == "age",
        .data$estimate_name %in% c("mean", "sd")
      ) |>
      boxPlot(x = "variable_name")
  )

})

test_that("Empty result object returns warning", {

  result <- omopgenerics::emptySummarisedResult()

  expect_warning(
    output_plot <- scatterPlot(
      result,
      x = "sex",
      line = TRUE,
      point = TRUE,
      ribbon = FALSE,
      y =  "mean",
      facet = "age_group"),
    "result object is empty, returning empty plot."
  )

  expect_warning(
    output_plot <- boxPlot(
      x = "sex",
      result = result
    ),
    "result object is empty, returning empty plot."
  )

  expect_warning(
    output_plot <- barPlot(
      result = result,
      x = "cdm_name",
      y = "variable_level"
    ),
    "result object is empty, returning empty plot."
  )

})
