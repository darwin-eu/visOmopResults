
#' Create a scatter plot visualisation from a `<summarised_result>` object
#'
#' `r lifecycle::badge("experimental")`
#'
#' @param result A `<summarised_result>` object.
#' @param x Column or estimate name that is used as x variable.
#' @param y Column or estimate name that is used as y variable
#' @param line Whether to plot a line using `geom_line`.
#' @param point Whether to plot points using `geom_point`.
#' @param ribbon Whether to plot a ribbon using `geom_ribbon`.
#' @param ymin Lower limit of error bars, if provided is plot using
#' `geom_errorbar`.
#' @param ymax Upper limit of error bars, if provided is plot using
#' `geom_errorbar`.
#' @param facet Variables to facet by, a formula can be provided to specify
#' which variables should be used as rows and which ones as columns.
#' @param colour Columns to use to determine the colors.
#' @param group Columns to use to determine the group.
#' @param label Character vector with the columns to display interactively in
#' `plotly`.
#'
#' @return A plot object.
#'
#' @export
#'
#' @examples
#' \donttest{
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
#' }
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
                        group = colour,
                        label = character()) {

  rlang::check_installed("ggplot2")

  # check and prepare input
  omopgenerics::assertTable(result)
  omopgenerics::assertLogical(line, length = 1, call = call)
  omopgenerics::assertLogical(point, length = 1, call = call)
  omopgenerics::assertLogical(ribbon, length = 1, call = call)
  omopgenerics::assertCharacter(x)
  omopgenerics::assertCharacter(y, length = 1)
  omopgenerics::assertCharacter(ymin, length = 1, null = TRUE)
  omopgenerics::assertCharacter(ymax, length = 1, null = TRUE)
  validateFacet(facet)
  omopgenerics::assertCharacter(colour, null = TRUE)
  omopgenerics::assertCharacter(group, null = TRUE)
  omopgenerics::assertCharacter(label, null = TRUE)

  # empty
  if (nrow(result) == 0) {
    cli::cli_warn(c("!" = "result object is empty, returning empty plot."))
    return(ggplot2::ggplot())
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
  yminymax <- !is.null(ymin) & !is.null(ymax)

  # make plot
  p <- ggplot2::ggplot(data = result, mapping = aes)
  if (line) p <- p + ggplot2::geom_line(size = 0.75)
  if (yminymax) p <- p + ggplot2::geom_errorbar(width = 0, size = 0.6)
  if (point) p <- p + ggplot2::geom_point(size = 2)
  if (ribbon & yminymax) {
    p <- p +
      ggplot2::geom_ribbon(alpha = .3, color = NA, show.legend = FALSE)
  }
  if(!is.null(facet)){
    p <- plotFacet(p, facet)
  }

  p <- p +
    ggplot2::labs(
      x = styleLabel(x),
      fill = styleLabel(colour),
      colour = styleLabel(colour),
      y = styleLabel(y)
    ) +
    ggplot2::theme(legend.position = hideLegend(colour))

  return(p)
}

#' Create a box plot visualisation from a `<summarised_result>` object
#'
#' `r lifecycle::badge("experimental")`
#'
#' @param result A `<summarised_result>` object.
#' @param x Columns to use as x axes.
#' @param lower Estimate name for the lower quantile of the box.
#' @param middle Estimate name for the middle line of the box.
#' @param upper Estimate name for the upper quantile of the box.
#' @param ymin Estimate name for the lower limit of the bars.
#' @param ymax Estimate name for the upper limit of the bars.
#' @param facet Variables to facet by, a formula can be provided to specify
#' which variables should be used as rows and which ones as columns.
#' @param colour Columns to use to determine the colors.
#' @param label Character vector with the columns to display interactively in
#' `plotly`.
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
                    label = character()) {

  rlang::check_installed("ggplot2")

  # initial checks
  omopgenerics::assertTable(result)
  omopgenerics::assertCharacter(x)
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
    return(ggplot2::ggplot())
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
  yminymax <- !is.null(ymin) & !is.null(ymax)

  p <- ggplot2::ggplot(data = result, mapping = aes) +
    ggplot2::geom_boxplot(stat = "identity")
  if(!is.null(facet)){
    p <- plotFacet(p, facet)
  }

  p <- p +
    ggplot2::labs(
      x = styleLabel(x),
      fill = styleLabel(colour),
      colour = styleLabel(colour)
    ) +
    ggplot2::theme(legend.position = hideLegend(colour))

  return(p)
}

#' Create a bar plot visualisation from a `<summarised_result>` object
#'
#' `r lifecycle::badge("experimental")`
#'
#' @param result A `<summarised_result>` object.
#' @param x Column or estimate name that is used as x variable.
#' @param y Column or estimate name that is used as y variable
#' @param facet Variables to facet by, a formula can be provided to specify
#' which variables should be used as rows and which ones as columns.
#' @param colour Columns to use to determine the colors.
#' @param label Character vector with the columns to display interactively in
#' `plotly`.
#'
#' @return A plot object.
#' @export
#'
#' @examples
#' \donttest{
#' result <- mockSummarisedResult() |> dplyr::filter(variable_name == "age")
#'
#' barPlot(
#'   result = result,
#'   x = "cohort_name",
#'   y = "mean",
#'   facet = c("age_group", "sex"),
#'   colour = "sex")
#' }
#'
barPlot <- function(result,
                    x,
                    y,
                    facet = NULL,
                    colour = NULL,
                    label = character()) {

  rlang::check_installed("ggplot2")

  # initial checks
  omopgenerics::assertTable(result)
  omopgenerics::assertCharacter(x)
  omopgenerics::assertCharacter(y, length = 1)
  validateFacet(facet)
  omopgenerics::assertCharacter(colour, null = TRUE)
  omopgenerics::assertCharacter(label, null = TRUE)

  # empty
  if (nrow(result) == 0) {
    cli::cli_warn(c("!" = "result object is empty, returning empty plot."))
    return(ggplot2::ggplot())
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
  p <- ggplot2::ggplot(data = result, mapping = aes) +
    ggplot2::geom_col()
  if(!is.null(facet)){
    p <- plotFacet(p, facet)
  }

  p <- p +
    ggplot2::labs(
      x = styleLabel(x),
      fill = styleLabel(colour),
      colour = styleLabel(colour),
      y = styleLabel(y)
    ) +
    ggplot2::theme(legend.position = hideLegend(colour))

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
  colsClean <- cols[!unlist(lapply(cols, is.null))]
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
  if (!is.null(facet)) {
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
  if (!is.null(x) && all(x != "") && length(x) > 0) {
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
