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

#' Create a scatter plot visualisation from a `<summarised_result>` object
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

#' Create a box plot visualisation from a `<summarised_result>` object
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

#' Create a bar plot visualisation from a `<summarised_result>` object
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
plotFacet <- function(p, facet) {
  if (length(facet) > 0) {
    if (is.character(facet)) {
      p <- p + ggplot2::facet_wrap(facets = facet)
    } else {
      p <- p + ggplot2::facet_grid(facet)
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

