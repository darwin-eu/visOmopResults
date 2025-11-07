test_that("Function returns a ggplot object", {

  get_labs <- function(x) x$labels
  if ("get_labs" %in% getNamespaceExports("ggplot2")) {
    get_labs <- ggplot2::get_labs
  }

  has_no_legend_labels <- function(plot) {
    labels <- get_labs(plot)
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
    facet = c("age_group", "sex"))

  expect_no_error(p)

  expect_true(has_no_legend_labels(p))

  #  test plotly
  p <- scatterPlot(
    result = result,
    x = "cohort_name",
    y = "mean",
    line = TRUE,
    point = TRUE,
    ribbon = FALSE,
    type = "plotly",
    facet = c("age_group", "sex"))
  expect_true(class(p)[1] == "plotly")

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
  )

  expect_no_error(p_box)

  expect_false(has_no_legend_labels(p_box))
  expect_true(p_box$theme$axis.title.y$size == 11)
  expect_true(get_labs(p_box)$label1 == "min")

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
    )
  )
  labels <- get_labs(p)
  expect_true(labels$label1 == "age_group")
  expect_true(labels$label2 == "mean")
  expect_true(labels$label3 == "cohort_name")

  p <- scatterPlot(
    result,
    x = "sex",
    line = TRUE,
    point = TRUE,
    ribbon = TRUE,
    y =  "mean",
    ymin = character(),
    ymax = character(),
    facet = character(),
    colour = "cohort_name",
    label = c("age_group", "mean", "cohort_name")
  )
  expect_true(all(!c("ymin", "ymax") %in% names(p$labels)))

  result <- mockSummarisedResult() |>
    dplyr::filter(variable_name == "age")

  p_bar <- barPlot(
    result = result,
    x = "cohort_name",
    y = "mean",
    facet = c("age_group", "sex"),
    label = c("cohort_name"),
    style = "darwin")

  expect_no_error(p_bar)
  expect_true(has_no_legend_labels(p_bar))
  expect_true(get_labs(p_bar)$label1 == "cohort_name")

  p_bar <- barPlot(
    result = result,
    x = "cohort_name",
    y = "mean",
    colour = c("age_group", "sex"),
    label = c("cohort_name"),
    style = NULL)

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
    scatterPlot(
      result,
      style = "nostyle")
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
  expect_true(ggplot2::is_ggplot(output_plot))

  expect_warning(
    output_plot <- boxPlot(
      x = "sex",
      result = result
    ),
    "result object is empty, returning empty plot."
  )
  expect_true(ggplot2::is_ggplot(output_plot))

  expect_warning(
    output_plot <- barPlot(
      result = result,
      x = "cdm_name",
      y = "variable_level"
    ),
    "result object is empty, returning empty plot."
  )
  expect_true(ggplot2::is_ggplot(output_plot))
})
test_that("test global style", {
  setGlobalPlotOptions(style = "darwin")
  result <- mockSummarisedResult() |>
    dplyr::filter(variable_name == "age")
  p <- scatterPlot(
    result = result,
    x = "cohort_name",
    y = "mean",
    line = TRUE,
    point = TRUE,
    ribbon = FALSE,
    facet = c("age_group", "sex"))
  expect_true("#003399" == p$theme$strip.background$fill)
  p <- scatterPlot(
    result = result,
    x = "cohort_name",
    y = "mean",
    line = TRUE,
    point = TRUE,
    ribbon = FALSE,
    facet = c("age_group", "sex"),
    style = "default")
  expect_true("#e1e1e1" == p$theme$strip.background$fill)
  options(visOmopResults.plotStyle = NULL)
})
