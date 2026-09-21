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

test_that("alluvial and sankey plots", {

  get_labs <- function(x) x$labels
  if ("get_labs" %in% getNamespaceExports("ggplot2")) {
    get_labs <- ggplot2::get_labs
  }

  # Alluvial ----
  result <- dplyr::tibble(
    treatment_1 = c("A", "A", "A", "B", "B", "B", "C", "C"),
    treatment_2 = c("A", "A", "B", "A", "B", "B", "B", "C"),
    treatment_3 = c("A", "B", "B", "A", "A", "B", "B", "C"),
    count       = c(22, 3, 5, 7, 3, 17, 4, 12)
  )

  # basic 2-axis call
  expect_no_error(
    p <- alluvialPlot(
      result = result,
      x = c("treatment_1", "treatment_2"),
      y = "count"
    )
  )
  expect_true(ggplot2::is_ggplot(p))

  # 3 axes
  expect_no_error(
    p <- alluvialPlot(
      result = result,
      x = c("treatment_1", "treatment_2", "treatment_3"),
      y = "count"
    )
  )
  expect_true(ggplot2::is_ggplot(p))

  # colour as single variable
  expect_no_error(
    p <- alluvialPlot(
      result = result,
      x = c("treatment_1", "treatment_2", "treatment_3"),
      y = "count",
      colour = "treatment_1"
    )
  )
  expect_true(!is.null(get_labs(p)$fill))
  expect_true(get_labs(p)$fill == "Treatment 1")

  # colour as multiple variables (united)
  expect_no_error(
    p <- alluvialPlot(
      result = result,
      x = c("treatment_1", "treatment_2", "treatment_3"),
      y = "count",
      colour = c("treatment_1", "treatment_2")
    )
  )
  expect_true(get_labs(p)$fill == "Treatment 1 treatment 2")

  # facet
  result_facet <- dplyr::bind_rows(
    result |> dplyr::mutate(sex = "Female"),
    result |> dplyr::mutate(sex = "Male")
  )
  expect_no_error(
    p <- alluvialPlot(
      result = result_facet,
      x = c("treatment_1", "treatment_2", "treatment_3"),
      y = "count",
      facet = "sex"
    )
  )
  expect_true(ggplot2::is_ggplot(p))

  # style
  expect_no_error(
    p <- alluvialPlot(
      result = result,
      x = c("treatment_1", "treatment_2"),
      y = "count",
      style = "darwin"
    )
  )

  # plotly
  expect_true(
    class(alluvialPlot(
      result = result,
      x = c("treatment_1", "treatment_2"),
      y = "count",
      type = "plotly"
    ))[1] == "plotly"
  )

  # errors
  expect_error(
    alluvialPlot(result = result, x = "treatment_1", y = "count")
  )
  expect_error(
    alluvialPlot(result = result, x = c("treatment_1", "nonexistent"), y = "count")
  )
  expect_error(
    alluvialPlot(result = result, x = c("treatment_1", "treatment_2"), y = "nonexistent")
  )
  expect_error(
    alluvialPlot(result = result, x = c("treatment_1", "treatment_2"), y = "count", style = "nostyle")
  )

  result <- dplyr::tibble(
    treatment_1 = character(),
    treatment_2 = character(),
    count       = numeric()
  )
  expect_warning(
    p <- alluvialPlot(
      result = result,
      x = c("treatment_1", "treatment_2"),
      y = "count"
    )
  )
  expect_true(ggplot2::is_ggplot(p))

  # # Sankey ----
  # sankey_data <- dplyr::tribble(
  #   ~from, ~to,  ~transition, ~freq,
  #   "A",   "A",  1,           40,
  #   "A",   "B",  1,           20,
  #   "B",   "A",  1,           10,
  #   "B",   "B",  1,           30,
  #   "A",   "A",  2,           30,
  #   "A",   "B",  2,           20,
  #   "B",   "A",  2,           15,
  #   "B",   "B",  2,           35
  # )
  #
  # expect_no_error(
  #   p <- sankeyPlot(
  #     result = sankey_data |> dplyr::filter(transition == 1),
  #     from   = "from",
  #     to     = "to",
  #     y      = "freq"
  #   )
  # )
  # expect_true(ggplot2::is_ggplot(p))
  #
  # # multiple transitions
  # expect_no_error(
  #   p <- sankeyPlot(
  #     result     = sankey_data,
  #     from       = "from",
  #     to         = "to",
  #     y          = "freq",
  #     transition = "transition"
  #   )
  # )
  # expect_true(ggplot2::is_ggplot(p))
  #
  # # colours
  # expect_no_error(
  #   p <- sankeyPlot(
  #     result = sankey_data,
  #     from   = "from",
  #     to     = "to",
  #     y      = "freq",
  #     colour = c("from", "to")
  #   )
  # )
  # # In sankey, fill label is styled
  # expect_identical(get_labs(p)$fill, "From and To")
  #
  # # Faceting
  # sankey_facet <- dplyr::bind_rows(
  #   sankey_data |> dplyr::mutate(group = "Group 1"),
  #   sankey_data |> dplyr::mutate(group = "Group 2")
  # )
  # expect_no_error(
  #   p <- sankeyPlot(
  #     result = sankey_facet,
  #     from   = "from",
  #     to     = "to",
  #     y      = "freq",
  #     facet  = "group",
  #     transition = "transition"
  #   )
  # )
  # expect_true(ggplot2::is_ggplot(p))
  #
  # # errors
  # expect_error(
  #   sankeyPlot(sankey_data, from = "wrong", to = "to", y = "freq")
  # )
  # expect_error(
  #   sankeyPlot(sankey_data, from = "from", to = "to", y = "wrong")
  # )
  #
  # # empty result
  # expect_warning(
  #   p <- sankeyPlot(
  #     result = sankey_data |> dplyr::filter(freq > 1000),
  #     from   = "from",
  #     to     = "to",
  #     y      = "freq"
  #   ),
  #   "result object is empty"
  # )
  # expect_true(ggplot2::is_ggplot(p))
})

test_that("test theming of plots", {
  extractColours <- function(p, type = "colour") {
    built <- ggplot2::ggplot_build(p)
    lapply(built$data, function(layer_data) {
      cols <- intersect(type, names(layer_data))
      unlist(layer_data[cols])
    }) |>
      unlist() |>
      unique() |>
      purrr::keep(\(x) !is.na(x) & x != "NA")

  }

  style <- tempfile(fileext = ".yml")

  colors <- c('#3db28c', '#a84c6f', '#29235c', '#7db356', '#f98e2b', '#475da7', '#addad9') |>
    toupper()

  brand <- system.file("brand", "default.yml", package = "visOmopResults") |>
    brand.yml::read_brand_yml()
  brand$defaults$visOmopResults$plot$color_palette <- colors
  yaml::write_yaml(x = brand, file = style)

  # no change
  p <- barPlot(
    result = dplyr::tibble(
      x = 1:5,
      y = 2 * x,
      col = sprintf("%03i", x)
    ),
    x = "x",
    y = "y"
  )
  expect_no_error(p <- p + themeVisOmop(style = style))
  expect_true(length(extractColours(p)) == 0)

  # 5 colurs
  p <- barPlot(
    result = dplyr::tibble(
      x = 1:5,
      y = 2 * x,
      col = sprintf("%03i", x)
    ),
    x = "x",
    y = "y",
    colour = "col"
  )
  expect_no_error(p <- p + themeVisOmop(style = style))
  expect_identical(extractColours(p), sortHue(colors[1:5], colors[1]))

  # expand palette to 20 colours
  p <- barPlot(
    result = dplyr::tibble(
      x = 1:20,
      y = 2 * x,
      col = sprintf("%03i", x)
    ),
    x = "x",
    y = "y",
    colour = "col"
  )
  expect_no_error(p <- p + themeVisOmop(style = style))
  expect_true(colors[1] %in% extractColours(p))

  # color from palette works
  brand$defaults$visOmopResults$plot$color_palette <- c('my_blue', "#880808")
  brand$color$palette$my_blue <- "#0000FF"
  yaml::write_yaml(x = brand, file = style)

  p <- barPlot(
    result = dplyr::tibble(
      x = 1:2,
      y = 2 * x,
      col = sprintf("%03i", x)
    ),
    x = "x",
    y = "y",
    colour = "col"
  )
  expect_no_error(p <- p + themeVisOmop(style = style))
  expect_true(all(c("#0000FF", "#880808") %in% extractColours(p)))

  # different fill and colour
  brand <- system.file("brand", "default.yml", package = "visOmopResults") |>
    brand.yml::read_brand_yml()
  brand$defaults$visOmopResults$plot$color_palette <- c("#FF0000", "#00FF00")
  brand$defaults$visOmopResults$plot$fill_palette <- c("#0000FF", "#FFFF00")
  yaml::write_yaml(x = brand, file = style)

  p <- ggplot2::ggplot(
    dplyr::tibble(x = 1:2, y = 1:2, g = c("a", "b")),
    ggplot2::aes(x = x, y = y, colour = g, fill = g)
  ) +
    ggplot2::geom_col() +
    themeVisOmop(style = style)

  expect_true("#0000FF" %in% extractColours(p, "fill"))
  expect_true("#FF0000" %in% extractColours(p, "colour"))

  # named continuous palette works
  continuousStyle <- validateStyle(style = "default", obj = "plot", type = "ggplot")
  continuousStyle$continuous_colour <- "viridis"
  p <- ggplot2::ggplot(
    dplyr::tibble(x = 1:2, y = 1:2),
    ggplot2::aes(x = x, y = y, colour = x)
  ) +
    ggplot2::geom_point() +
    themeVisOmop(style = continuousStyle)

  expect_no_error(ggplot2::ggplot_build(p))
  expect_identical(p$theme$palette.colour.continuous, "viridis")

  # palette functions work without being converted to a scale
  functionStyle <- validateStyle(style = "default", obj = "plot", type = "ggplot")
  functionStyle$discrete_colour <- grDevices::colorRampPalette(c("#FF0000", "#0000FF"))
  p <- ggplot2::ggplot(
    dplyr::tibble(x = 1:2, y = 1:2, g = c("a", "b")),
    ggplot2::aes(x = x, y = y, colour = g)
  ) +
    ggplot2::geom_point() +
    themeVisOmop(style = functionStyle)

  expect_no_error(ggplot2::ggplot_build(p))
  expect_true(all(c("#FF0000", "#0000FF") %in% extractColours(p)))

  # palette expressions work when provided directly in a YAML file
  expressionStyle <- tempfile(fileext = ".yml")
  expressionStyleLines <- readLines(
    system.file("brand", "default.yml", package = "visOmopResults")
  )
  legendPositionLine <- which(grepl("legend_position", expressionStyleLines))
  expressionStyleLines[legendPositionLine] <- paste0(
    expressionStyleLines[legendPositionLine],
    "\n      discrete_colour: grDevices::colorRampPalette(c(\"#FF0000\", \"#0000FF\"))"
  )
  writeLines(expressionStyleLines, expressionStyle)

  p <- ggplot2::ggplot(
    dplyr::tibble(x = 1:2, y = 1:2, g = c("a", "b")),
    ggplot2::aes(x = x, y = y, colour = g)
  ) +
    ggplot2::geom_point() +
    themeVisOmop(style = expressionStyle)

  expect_no_error(ggplot2::ggplot_build(p))
  expect_true(all(c("#FF0000", "#0000FF") %in% extractColours(p)))

  unlink(style)
  unlink(expressionStyle)
})
