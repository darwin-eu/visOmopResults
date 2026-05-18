# Copyright 2025 DARWIN EU®
#
# This file is part of visOmopResults
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

#' Create a scatter plot visualisation from a data frame or a
#' `<summarised_result>` object.
#'
#' @inheritParams plotDoc
#'
#' @return A plot object.
#'
#' @export
#'
#' @examples
#' result <- mockSummarisedResult() |>
#'   dplyr::filter(variable_name == "age")
#'
#' scatterPlot(
#'   result = result,
#'   x = "cohort_name",
#'   y = "mean",
#'   line = TRUE,
#'   point = TRUE,
#'   ribbon = FALSE,
#'   facet = age_group ~ sex)
#'
scatterPlot <- function(result,
                        x,
                        y,
                        line,
                        point,
                        ribbon,
                        ymin = NULL,
                        ymax = NULL,
                        facet = NULL,
                        colour = NULL,
                        style = NULL,
                        type = NULL,
                        group = colour,
                        label = character()) {
  # check and prepare input
  type <- validateType(type = type, obj = "plot")
  style <- validateStyle(style = style, obj = "plot", type = type)
  omopgenerics::assertTable(result)
  omopgenerics::assertLogical(line, length = 1, call = call)
  omopgenerics::assertLogical(point, length = 1, call = call)
  omopgenerics::assertLogical(ribbon, length = 1, call = call)
  omopgenerics::assertCharacter(x, minNumCharacter = 1)
  omopgenerics::assertCharacter(y, minNumCharacter = 1)
  omopgenerics::assertCharacter(ymin, null = TRUE)
  omopgenerics::assertCharacter(ymax, null = TRUE)
  validateFacet(facet)
  omopgenerics::assertCharacter(colour, null = TRUE)
  omopgenerics::assertCharacter(group, null = TRUE)
  omopgenerics::assertCharacter(label, null = TRUE)

  # empty
  if (nrow(result) == 0) {
    cli::cli_warn(c("!" = "result object is empty, returning empty plot."))
    return(emptyPlot())
  }

  est <- c(x, y, ymin, ymax, asCharacterFacet(facet), colour, group, label)

  # check that all data is present
  checkInData(result, unique(est))

  # get estimates
  result <- cleanEstimates(result, est)

  # tidy result
  result <- tidyResult(result)

  # warn multiple values
  result |>
    warnMultipleValues(cols = list(
      x = x, facet = asCharacterFacet(facet), colour = colour, group = group))

  # prepare result
  cols = list(
    x = x, y = y, ymin = ymin, ymax = ymax, colour = colour, group = group,
    fill = colour
  )
  cols <- addLabels(cols, label)
  result <- prepareColumns(result, cols)

  # get aes
  aes <- getAes(cols)
  yminymax <- length(ymin) > 0 & length(ymax) > 0

  # make plot
  p <- ggplot2::ggplot(data = result, mapping = aes)
  if (line) p <- p + ggplot2::geom_line(linewidth = 0.75)
  if (yminymax) p <- p + ggplot2::geom_errorbar(width = 0, linewidth = 0.6)
  if (point) p <- p + ggplot2::geom_point(size = 2)
  if (ribbon & yminymax) {
    p <- p +
      ggplot2::geom_ribbon(alpha = .3, color = NA, show.legend = FALSE)
  }
  if(length(facet) > 0){
    p <- plotFacet(p, facet)
  }

  p <- p +
    ggplot2::labs(
      x = styleLabel(x),
      fill = styleLabel(colour),
      colour = styleLabel(colour),
      y = styleLabel(y)
    ) +
    ggplot2::theme(legend.position = hideLegend(colour)) +
    themeVisOmop(style = style)

  if (type == "plotly") {
    p <- plotly::ggplotly(p)
  }

  return(p)
}

#' Create a box plot visualisation from a data frame or a
#' `<summarised_result>` object.
#'
#' @inheritParams plotDoc
#'
#' @return A ggplot2 object.
#' @export
#'
#' @examples
#' dplyr::tibble(year = "2000", q25 = 25, median = 50, q75 = 75, min = 0, max = 100) |>
#'   boxPlot(x = "year")
#'
boxPlot <- function(result,
                    x,
                    lower = "q25",
                    middle = "median",
                    upper = "q75",
                    ymin = "min",
                    ymax = "max",
                    facet = NULL,
                    colour = NULL,
                    style = NULL,
                    type = NULL,
                    label = character()) {
  # initial checks
  type <- validateType(type = type, obj = "plot")
  style <- validateStyle(style = style, obj = "plot", type = type)
  omopgenerics::assertTable(result)
  omopgenerics::assertCharacter(x, minNumCharacter = 1)
  omopgenerics::assertCharacter(lower, length = 1)
  omopgenerics::assertCharacter(middle, length = 1)
  omopgenerics::assertCharacter(upper, length = 1)
  omopgenerics::assertCharacter(ymin, length = 1)
  omopgenerics::assertCharacter(ymax, length = 1)
  validateFacet(facet)
  omopgenerics::assertCharacter(colour, null = TRUE)
  omopgenerics::assertCharacter(label, null = TRUE)

  # empty
  if (nrow(result) == 0) {
    cli::cli_warn(c("!" = "result object is empty, returning empty plot."))
    return(emptyPlot())
  }

  est <- c(x, lower, middle, upper, ymin, ymax, asCharacterFacet(facet), colour, label)

  # check that all data is present
  checkInData(result, est)

  # subset to estimates of use
  result <- cleanEstimates(result, est)
  ylab <- unique(suppressWarnings(result$variable_name))

  # tidy result
  result <- tidyResult(result)

  # warn multiple values
  result |>
    warnMultipleValues(cols = list(
      x = x, facet = asCharacterFacet(facet), colour = colour))

  # prepare result
  col <- omopgenerics::uniqueId(exclude = colnames(result))
  result <- result |>
    dplyr::mutate(!!col := dplyr::row_number())

  cols = list(
    x = x, lower = lower, middle = middle, upper = upper,
    ymin = ymin, ymax = ymax, colour = colour, group = col)
  cols <- addLabels(cols, label)
  result <- prepareColumns(result, cols)

  # get aes
  aes <- getAes(cols)
  yminymax <- length(ymin) > 0 & length(ymax) > 0

  p <- ggplot2::ggplot(data = result, mapping = aes) +
    ggplot2::geom_boxplot(stat = "identity", position = "dodge2")
  if(length(facet) > 0){
    p <- plotFacet(p, facet)
  }

  p <- p +
    ggplot2::labs(
      x = styleLabel(x),
      colour = styleLabel(colour)
    ) +
    ggplot2::theme(legend.position = hideLegend(colour)) +
    themeVisOmop(style = style)

  if (type == "plotly") {
    p <- plotly::ggplotly(p)
  }

  return(p)
}

#' Create a bar plot visualisation from a data frame or a
#' `<summarised_result>` object.
#'
#' @inheritParams plotDoc
#'
#' @return A plot object.
#' @export
#'
#' @examples
#' result <- mockSummarisedResult() |> dplyr::filter(variable_name == "age")
#'
#' barPlot(
#'   result = result,
#'   x = "cohort_name",
#'   y = "mean",
#'   facet = c("age_group", "sex"),
#'   colour = "sex")
#'
barPlot <- function(result,
                    x,
                    y,
                    width = NULL,
                    just = 0.5,
                    position = "dodge",
                    facet = NULL,
                    colour = NULL,
                    style = NULL,
                    type = NULL,
                    label = character()) {
  # initial checks
  type <- validateType(type = type, obj = "plot")
  style <- validateStyle(style = style, obj = "plot", type = type)
  omopgenerics::assertTable(result)
  omopgenerics::assertCharacter(x, minNumCharacter = 1)
  omopgenerics::assertCharacter(y, minNumCharacter = 1)
  validateFacet(facet)
  omopgenerics::assertCharacter(colour, null = TRUE)
  omopgenerics::assertCharacter(label, null = TRUE)
  omopgenerics::assertChoice(position, c("stack", "dodge"))

  # empty
  if (nrow(result) == 0) {
    cli::cli_warn(c("!" = "result object is empty, returning empty plot."))
    return(emptyPlot())
  }

  est <- c(x, y, asCharacterFacet(facet), colour, label)

  # check that all data is present
  checkInData(result, est)

  # subset to estimates of use
  result <- cleanEstimates(result, est)

  # tidy result
  result <- tidyResult(result)

  # warn multiple values
  result |>
    warnMultipleValues(cols = list(
      x = x, facet = asCharacterFacet(facet), colour = colour))

  # prepare result
  cols = list(x = x, y = y, colour = colour, fill = colour)
  cols <- addLabels(cols, label)
  result <- prepareColumns(result, cols)

  # get aes
  aes <- getAes(cols)

  # create plot
  args <- list(width = width, just = just, position = position) |>
    # eliminate warning about nulls
    purrr::compact()
  p <- ggplot2::ggplot(data = result, mapping = aes) +
    do.call(what = ggplot2::geom_col, args = args)
  if(length(facet) > 0){
    p <- plotFacet(p, facet)
  }

  p <- p +
    ggplot2::labs(
      x = styleLabel(x),
      fill = styleLabel(colour),
      colour = styleLabel(colour),
      y = styleLabel(y)
    ) +
    ggplot2::theme(legend.position = hideLegend(colour)) +
    themeVisOmop(style = style)

  if (type == "plotly") {
    p <- plotly::ggplotly(p)
  }

  return(p)
}


#' Create a sankey plot visualisation from a data frame or a
#' `<summarised_result>` object.
#'
#' @inheritParams plotDoc
#' @param from A character string with the name of the column containing the
#'   source node of each transition (where the flow starts).
#' @param to A character string with the name of the column containing the
#'   destination node of each transition (where the flow ends).
#' @param y A character string with the name of the column containing the
#'   flow weight (e.g. counts or frequencies). For plots with multiple
#'   transitions, flows must be conserved — the total arriving at a node must
#'   equal the total leaving it.
#' @param transition A character string with the name of the column identifying
#'   which transition step each row belongs to (e.g. 1, 2, 3 for first,
#'   second and third transition). If `NULL` (default), a single transition is
#'   assumed.
#'
#' @return A plot object.
#' @noRd
#'
#' @examples
#' # single transition
#' result <- dplyr::tribble(
#'   ~from, ~to,  ~freq,
#'   "A",   "A",  40,
#'   "A",   "B",  20,
#'   "B",   "A",  10,
#'   "B",   "B",  30
#' )
#'
#' sankeyPlot(
#'   result = result,
#'   from   = "from",
#'   to     = "to",
#'   y      = "freq"
#' )
#'
#' # multiple transitions — flows must be conserved at each intermediate node
#' result <- dplyr::tribble(
#'   ~from, ~to,  ~transition, ~freq,
#'   "A",   "A",  1,           40,
#'   "A",   "B",  1,           20,
#'   "B",   "A",  1,           10,
#'   "B",   "B",  1,           30,
#'   "A",   "A",  2,           30,
#'   "A",   "B",  2,           20,
#'   "B",   "A",  2,           15,
#'   "B",   "B",  2,           35
#' )
#'
#' sankeyPlot(
#'   result     = result,
#'   from       = "from",
#'   to         = "to",
#'   y          = "freq",
#'   transition = "transition",
#'   colour     = "from"
#' )
#'
#' # example with 3 nodes:
#' result <- dplyr::tribble(
#' ~from, ~to,  ~freq,
#'   "A",   "A",  40,
#'   "A",   "B",  20,
#'   "A",   "C",  10,
#'   "B",   "A",  10,
#'   "B",   "B",  30,
#'   "B",   "C",  5,
#'   "C",   "A",  5,
#'   "C",   "B",  8,
#'   "C",   "C",  22
#' )
#'
#' sankeyPlot(
#'   result = result,
#'   from   = "from",
#'   to     = "to",
#'   y      = "freq",
#'   colour = "from"
#' )
sankeyPlot <- function(result,
                       from,
                       to,
                       y,
                       transition = NULL,
                       colour = from,
                       facet = NULL,
                       style = NULL,
                       type = NULL) {

  rlang::check_installed("ggsankeyfier")

  type  <- validateType(type = type, obj = "plot")
  style <- validateStyle(style = style, obj = "plot", type = type)
  omopgenerics::assertTable(result)
  omopgenerics::assertCharacter(from, length = 1, minNumCharacter = 1)
  omopgenerics::assertCharacter(to, length = 1, minNumCharacter = 1)
  omopgenerics::assertCharacter(y, length = 1, minNumCharacter = 1)
  omopgenerics::assertCharacter(transition, length = 1, null = TRUE)
  validateFacet(facet)
  omopgenerics::assertCharacter(colour, null = TRUE)

  if (nrow(result) == 0) {
    cli::cli_warn(c("!" = "result object is empty, returning empty plot."))
    return(emptyPlot())
  }

  est <- unique(c(from, to, y, asCharacterFacet(facet), colour))
  checkInData(result, est)
  result <- cleanEstimates(result, est)
  result <- tidyResult(result)

  # if no transition column, treat all rows as a single transition
  # transition would be in additional in case of summarised result???
  if (is.null(transition)) {
    result <- result |> dplyr::mutate(transition = 1L)
    transition <- "transition"
  }

  colourLabel <- styleLabel(colour)  # before pipeline overwrites colour

  # transform to ggsankeyfier format:
  nodeLevels <- unique(result |> dplyr::pull(from))

  ggsankeyfierResult <- result |>
    dplyr::group_by(dplyr::across(dplyr::any_of(c(asCharacterFacet(facet))))) |>
    dplyr::mutate(edge_id = dplyr::row_number()) |>
    dplyr::ungroup() |>
    tidyr::unite("colour", dplyr::all_of(colour), remove = FALSE, na.rm = TRUE) |>
    tidyr::pivot_longer(
      cols      = dplyr::all_of(c(from, to)),
      names_to  = "connector",
      values_to = "node"
    ) |>
    dplyr::mutate(
      stage = factor(dplyr::if_else(
        .data$connector == from,
        .data[[transition]],
        .data[[transition]] + 1L
      )),
      connector = dplyr::if_else(.data$connector == from, "from", "to"),
      node      = factor(.data$node)
    )

  # prepare result
  cols = list(x = "stage", y = y, fill = "colour", group = "node", connector = "connector", edge_id = "edge_id", label = "node")
  result <- prepareColumns(ggsankeyfierResult, cols)
  aes <- getAes(cols)

  style   <- themeVisOmop(style = style)
  fontFamily <- style$plot_font_family

  pos <- ggsankeyfier::position_sankey(v_space = "auto", align = "justify", n_width = 0.15, order = "as_is", scale_height = TRUE)

  p <- ggsankeyfierResult |>
    singleSankey(aes, pos, fontFamily, colourLabel, style)

  if (length(facet) > 0) {
    p <- plotFacet(p, facet, scales = "free")
  }

  if (type == "plotly") {
    p <- plotly::ggplotly(p)
  }

  return(p)
}

#' Create an alluvial plot visualisation from a data frame or a
#' `<summarised_result>` object.
#'
#' @inheritParams plotDoc
#' @param x A character vector of column names to use as alluvial axes, in
#' order from left to right. Must contain at least 2 elements.
#'
#' @return A plot object.
#' @export
#'
#' @examples
#' result <- dplyr::tibble(
#'   treatment_1 = c("A", "A", "A", "B", "B", "B", "C", "C"),
#'   treatment_2 = c("A", "A", "B", "A", "B", "B", "B", "C"),
#'   treatment_3 = c("A", "B", "B", "A", "A", "B", "B", "C"),
#'   count       = c(22, 3, 5, 7, 3, 17, 4, 12)
#' )
#'
#' # basic alluvial plot with 3 axes
#' alluvialPlot(
#'   result = result,
#'   x = c("treatment_1", "treatment_2", "treatment_3"),
#'   y = "count"
#' )
#'
#' # colour by first axis
#' alluvialPlot(
#'   result = result,
#'   x = c("treatment_1", "treatment_2", "treatment_3"),
#'   y = "count",
#'   colour = "treatment_1"
#' )
#'
#' # colour by multiple variables
#' alluvialPlot(
#'   result = result,
#'   x = c("treatment_1", "treatment_2", "treatment_3"),
#'   y = "count",
#'   colour = c("treatment_1", "treatment_2")
#' )
alluvialPlot <- function(result,
                         x,
                         y,
                         colour = x,
                         facet = NULL,
                         style = NULL,
                         type = NULL) {

  rlang::check_installed("ggalluvial")

  type  <- validateType(type = type, obj = "plot")
  style <- validateStyle(style = style, obj = "plot", type = type)
  omopgenerics::assertTable(result)
  omopgenerics::assertCharacter(x, minNumCharacter = 1)
  omopgenerics::assertCharacter(y, length = 1, minNumCharacter = 1)
  validateFacet(facet)
  omopgenerics::assertCharacter(colour, null = TRUE)

  if (length(x) < 2) {
    cli::cli_abort("{.var x} must contain at least 2 column names.")
  }

  if (nrow(result) == 0) {
    cli::cli_warn(c("!" = "result object is empty, returning empty plot."))
    return(emptyPlot())
  }

  est <- unique(c(x, y, asCharacterFacet(facet), colour))
  checkInData(result, est)
  result <- cleanEstimates(result, est)
  result <- tidyResult(result)

  axesNamed <- as.list(x) |> rlang::set_names(paste0("axis", seq_along(x)))
  result |>
    warnMultipleValues(cols = c(
      axesNamed,
      list(y = y, facet = asCharacterFacet(facet), colour = colour)
    ))

  # duplicate axes columns into axis1, axis2, ... — originals stay untouched
  axis_new_names <- paste0("axis", seq_along(x))
  for (k in seq_along(x)) {
    result[[axis_new_names[k]]] <- result[[x[k]]]
  }

  # prepare result
  # prepare colour column (unite if multiple variables)
  cols <- c(
    rlang::set_names(axis_new_names, axis_new_names),
    list(y = y),
    if (!is.null(colour)) list(fill = colour) else NULL
  )
  result <- prepareColumns(result, cols)
  colour <- paste0(colour, collapse = "_")
  aes <- getAes(cols)

  # style
  style <- themeVisOmop(style = style)
  font_family <- style$plot_font_family

  # axis labels: map axis1 -> original column name, cleaned up
  axis_labels <- rlang::set_names(x, axis_new_names)

  p <- ggplot2::ggplot(data = result, mapping = aes) +
    ggalluvial::geom_alluvium(
      {if (!is.null(colour))
        ggplot2::aes(fill = .data[[colour]])
        else
          ggplot2::aes()},
      alpha = 0.6
    ) +
    ggalluvial::geom_stratum(
      fill = "#f8f9fa",   # neutral fill so boxes are visible
      colour = "grey40", # lighter border
      width = 1/3        # slightly narrower strata
    ) +
    ggalluvial::stat_stratum(
      geom = "text",
      ggplot2::aes(label = ggplot2::after_stat(.data$stratum)),
      family = font_family,
      size = 3,
      fontface = "bold"
    ) +
    ggplot2::scale_x_discrete(labels = axis_labels) +
    style +
    ggplot2::labs(
      fill = styleLabel(colour),
      y = NULL
    ) +
    ggplot2::theme(legend.position = "none") +
    style +
    ggplot2::theme(
      line = ggplot2::element_blank(),
      rect = ggplot2::element_blank(),
      axis.title = ggplot2::element_blank(),
      axis.text.x = ggplot2::element_blank(),
      axis.ticks.x = ggplot2::element_blank(),
      axis.text.y = ggplot2::element_blank(),
      axis.ticks.y = ggplot2::element_blank(),
      axis.line = ggplot2::element_blank(),
      panel.grid = ggplot2::element_blank(),
      panel.background = ggplot2::element_blank(),
      panel.border = ggplot2::element_blank(),
      plot.background = ggplot2::element_blank(),
      panel.grid.major = ggplot2::element_blank(),
      legend.position = "none"
    )

  if (length(facet) > 0) {
    p <- plotFacet(p, facet, scales = "free_y")
  }

  if (type == "plotly") {
    p <- plotly::ggplotly(p)
  }

  return(p)
}

#' Returns an empty plot
#'
#' @param title Title to use in the empty plot.
#' @param subtitle Subtitle to use in the empty plot.
#' @inheritParams plotDoc
#'
#' @return An empty ggplot object
#'
#' @export
#'
#' @examples
#' emptyPlot()
#'
emptyPlot <- function(title = "No data to plot", subtitle = "", type = NULL, style = NULL) {
  # input check
  type <- validateType(type = type, obj = "plot")
  style <- validateStyle(style = style, obj = "plot", type = type)
  omopgenerics::assertCharacter(title, length = 1)
  omopgenerics::assertCharacter(subtitle, length = 1)

  p <- ggplot2::ggplot() +
    ggplot2::theme_bw() +
    ggplot2::labs(title = title, subtitle = subtitle) +
    themeVisOmop(style = style)

  if (type == "plotly") {
    p <- plotly::ggplotly(p)
  }

  return(p)
}

tidyResult <- function(result) {
  if (inherits(result, "summarised_result")) {
    result <- tidy(result) |>
      dplyr::select(!dplyr::any_of("result_id"))
  }
  return(result)
}
getAes <- function(cols) {
  colsClean <- cols[unlist(lapply(cols, length)) > 0]
  for (k in seq_along(colsClean)) {
    if (length(colsClean[[k]]) > 1) {
      colsClean[[k]] <- paste0(colsClean[[k]], collapse = "_")
    }
  }
  vars <- names(colsClean)
  paste0(
    "ggplot2::aes(",
    glue::glue("{vars} = .data${colsClean}") |>
      stringr::str_c(collapse = ", "),
    ")"
  ) |>
    rlang::parse_expr() |>
    rlang::eval_tidy()
}
plotFacet <- function(p, facet, scales = "fixed") {
  if (length(facet) > 0) {
    if (is.character(facet)) {
      p <- p + ggplot2::facet_wrap(facets = facet, scales = scales)
    } else {
      p <- p + ggplot2::facet_grid(facet, scales = scales)
    }
  }
  return(p)
}
validateFacet <- function(x, call = parent.frame()) {
  if (rlang::is_formula(x)) return(invisible(NULL))
  omopgenerics::assertCharacter(x, null = TRUE)
  return(invisible(NULL))
}
warnMultipleValues <- function(result, cols) {
  nms <- names(cols)
  cols <- unique(unlist(cols))
  vars <- result |>
    dplyr::group_by(dplyr::across(dplyr::all_of(cols))) |>
    dplyr::group_split() |>
    as.list()
  vars <- vars[purrr::map_int(vars, nrow) > 1] |>
    purrr::map(\(x) {
      x <- purrr::map(x, unique)
      names(x)[lengths(x) > 1]
    }) |>
    unlist() |>
    unique()
  if (length(vars) > 0) {
    cli::cli_inform(c(
      "!" = "Multiple values of {.var {vars}} detected, consider including them
      in either: {.var {nms}}."
    ))
  }
  return(invisible(NULL))
}
asCharacterFacet <- function(facet) {
  if (rlang::is_formula(facet)) {
    facet <- as.character(facet)
    facet <- facet[-1]
    facet <- facet |>
      stringr::str_split(pattern = stringr::fixed(" + ")) |>
      unlist()
    facet <- facet[facet != "."]
  }
  return(facet)
}
cleanEstimates <- function(result, est) {
  if ("estimate_name" %in% colnames(result)) {
    est <- unique(est)
    result <- result |>
      dplyr::filter(.data$estimate_name %in% .env$est)
  }
  return(result)
}
checkInData <- function(result, est, call = parent.frame()) {
  cols <- colnames(result)
  if (inherits(result, "summarised_result") &
      all(omopgenerics::resultColumns("summarised_result") %in% cols)) {
    cols <- tidyColumns(result)
  }
  est <- unique(est)
  notPresent <- est[!est %in% cols]
  if (length(notPresent) > 0) {
    "{.var {notPresent}} {?is/are} not present in data." |>
      cli::cli_abort(call = call)
  }
  return(invisible(NULL))
}
prepareColumns <- function(result,
                           cols,
                           call = parent.frame()) {
  opts <- colnames(result)

  colsUnite <- cols[unlist(lapply(cols, length)) > 1]
  # prepare columns
  varNames <- names(colsUnite)
  for (k in seq_along(colsUnite)) {
    result <- prepareColumn(
      result = result, cols = colsUnite[[k]], opts = opts, call = call
    )
  }

  return(result)
}
prepareColumn <- function(result,
                          cols,
                          opts,
                          call) {

  if (!is.character(cols) || !all(cols %in% opts)) {
    c("x" = "{varName} ({.var {cols}}) is not a column in result.") |>
      cli::cli_abort(call = call)
  }
  newName <- paste0(cols, collapse = "_")
  result <- result |>
    tidyr::unite(
      col = !!newName, dplyr::all_of(cols), remove = FALSE, sep = " - ")

  return(result)
}
styleLabel <- function(x) {
  if (all(x != "") && length(x) > 0) {
    x |>
      stringr::str_replace_all(pattern = "_", replacement = " ") |>
      stringr::str_to_sentence() |>
      stringr::str_flatten(collapse = ", ", last = " and ")
  } else {
    NULL
  }
}
hideLegend <- function(x) {
  if (length(x) > 0 && !identical(x, "")) "right" else "none"
}
addLabels <- function(cols, label) {
  listLabs <- list()
  for (k in seq_along(label)) {
    listLabs[[paste0("label", k)]] <- label[k]
  }
  return(c(cols, listLabs))
}

singleSankey <- function(data, aes, pos, fontFamily, colourLabel, style) {
  data |>
    ggplot2::ggplot(mapping = aes) +
    ggsankeyfier::geom_sankeyedge(alpha = 0.6, position = pos, slope = 0.5) +
    ggsankeyfier::geom_sankeynode(
      position = pos,
      fill = "#f8f9fa",
      colour = "grey40"
    ) +
    ggplot2::geom_text(
      stat = ggsankeyfier::StatSankeynode,
      position = pos,
      size = 3,
      fontface = "bold",
      family   = fontFamily
    ) +
    ggplot2::labs(fill = colourLabel, y = NULL, x = NULL) +
    style +
    ggplot2::theme(
      line = ggplot2::element_blank(),
      rect = ggplot2::element_blank(),
      axis.title = ggplot2::element_blank(),
      axis.text.x = ggplot2::element_blank(),
      axis.ticks.x = ggplot2::element_blank(),
      axis.text.y = ggplot2::element_blank(),
      axis.ticks.y = ggplot2::element_blank(),
      axis.line = ggplot2::element_blank(),
      panel.grid = ggplot2::element_blank(),
      panel.background = ggplot2::element_blank(),
      panel.border = ggplot2::element_blank(),
      plot.background = ggplot2::element_blank(),
      panel.grid.major = ggplot2::element_blank(),
      legend.position = "none"
    )
}
