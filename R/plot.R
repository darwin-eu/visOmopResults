
#' Create a scatter plot visualisation from a summarised result object.
#'
#' `r lifecycle::badge("experimental")`
#'
#' @param result A summarised result object.
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
#' plotScatter(
#'   result = result,
#'   x = "cohort_name",
#'   y = "mean",
#'   line = TRUE,
#'   point = TRUE,
#'   ribbon = FALSE,
#'   facet = age_group ~ sex)
#' }
#'
plotScatter <- function(result,
                        x,
                        y,
                        line,
                        point,
                        ribbon,
                        ymin = NULL,
                        ymax = NULL,
                        facet = NULL,
                        colour = NULL,
                        group = colour) {
  rlang::check_installed("ggplot2")

  # check and prepare input
  omopgenerics::assertLogical(line, length = 1, call = call)
  omopgenerics::assertLogical(point, length = 1, call = call)
  omopgenerics::assertLogical(ribbon, length = 1, call = call)
  omopgenerics::assertTable(result, class = "data.frame")

  # prepare result
  result <- tidyResult(result)
  cols = list(
    x = x, y = y, ymin = ymin, ymax = ymax, facet = facet, colour = colour,
    group = group)
  result <- prepareColumns(result = result, cols = cols)

  # get aes
  aes <- getAes(cols)
  yminymax <- !is.null(ymin) & !is.null(ymax)

  # make plot
  p <- ggplot2::ggplot(data = result, mapping = aes)
  if (line) p <- p + ggplot2::geom_line()
  if (yminymax) p <- p + ggplot2::geom_errorbar()
  if (point) p <- p + ggplot2::geom_point()
  if (ribbon & yminymax) {
    p <- p +
      ggplot2::geom_ribbon(alpha = .3, color = NA, show.legend = FALSE)
  }
  p <- plotFacet(p, facet) +
    ggplot2::labs(
      x = styleLabel(x),
      fill = styleLabel(colour),
      colour = styleLabel(colour)
    ) +
    ggplot2::theme(
      legend.position = hideLegend(colour)
    )

  return(p)
}

#' Create a box plot visualisation from a summarised_result object.
#'
#' `r lifecycle::badge("experimental")`
#'
#' @param result A summarised result object.
#' @param lower Estimate name for the lower quantile of the box.
#' @param middle Estimate name for the middle line of the box.
#' @param upper Estimate name for the upper quantile of the box.
#' @param ymin Estimate name for the lower limit of the bars.
#' @param ymax Estimate name for the upper limit of the bars.
#' @param facet Variables to facet by, a formula can be provided to specify
#' which variables should be used as rows and which ones as columns.
#' @param colour Columns to use to determine the colors.
#'
#' @return A ggplot2 object.
#' @export
#'
plotBoxplot <- function(result,
                        lower = "q25",
                        middle = "median",
                        upper = "q75",
                        ymin = "min",
                        ymax = "max",
                        facet = NULL,
                        colour = NULL) {
  rlang::check_installed("ggplot2")
  # check and prepare input
  result <- prepareInput(
    result = result, x = NULL, facet = facet, colour = colour, lower = lower,
    middle = middle, upper = upper, ymin = ymin, ymax = ymax)

  idCols <- attr(result, "ids_cols")
  colourColumn <- idCols["colour"] |> unname()
  xColumn <- idCols["x"] |> unname()
  x <- attr(result, "x")

  aes <- "ggplot2::aes(x = .data${xColumn}, middle = .data[['{middle}']],
    lower = .data[['{lower}']], upper = .data[['{upper}']],
    colour = .data${colourColumn}, ymin = .data[['{ymin}']],
    ymax = .data[['{ymax}']])" |>
    glue::glue() |>
    rlang::parse_expr() |>
    eval()

  ylab <- styleLabel(unique(result$variable_name))
  clab <- styleLabel(colour)
  xlab <- styleLabel(x)

  p <- ggplot2::ggplot(data = result, mapping = aes) +
    ggplot2::geom_boxplot(stat = "identity")
  p <- plotFacet(p, facet) +
    ggplot2::labs(y = ylab, colour = clab, x = xlab) +
    ggplot2::theme(
      legend.position =  hideLegend(colour)
    )

  return(p)
}

#' Create a bar plot visualisation from a summarised result object.
#'
#' `r lifecycle::badge("experimental")`
#'
#' @param result A summarised result object.
#' @param x Column or estimate name that is used as x variable.
#' @param y Column or estimate name that is used as y variable
#' @param facet Variables to facet by, a formula can be provided to specify
#' which variables should be used as rows and which ones as columns.
#' @param colour Columns to use to determine the colors.
#'
#' @return A plot object.
#' @export
#'
#' @examples
#' \donttest{
#' result <- mockSummarisedResult() |> dplyr::filter(variable_name == "age")
#'
#' plotBarplot(
#'   result = result,
#'   x = "cohort_name",
#'   y = "mean",
#'   facet = c("age_group", "sex"))
#' }
#'
plotBarplot <- function(result,
                        x,
                        y,
                        facet = NULL,
                        colour = NULL) {
  rlang::check_installed("ggplot2")
  result <- prepareInput(
    result = result, x = x, y = y, facet = facet, colour = colour)

  idCols <- attr(result, "ids_cols")
  colourColumn <- idCols["colour"] |> unname()
  facetColumn <- idCols["facet"] |> unname()
  xColumn <- idCols["x"] |> unname()

  aes <- "ggplot2::aes(x = .data${xColumn}, y = .data[['{y}']], colour = .data${colourColumn}, fill = .data${colourColumn})" |>
    glue::glue() |>
    rlang::parse_expr() |>
    eval()

  p <- ggplot2::ggplot(data = result, mapping = aes) +
    ggplot2::geom_col()


  colour <- styleLabel(colour)

  p <- plotFacet(p, facet) +
    ggplot2::labs(x = styleLabel(x),
                  fill = colour,
                  colour = colour) +
    ggplot2::theme(
      legend.position =  hideLegend(colour)
    )

  return(p)
}

tidyResult <- function(result) {
  if (inherits(result, "summarised_result")) {
    result <- tidy(result) |>
      dplyr::select(!dplyr::any_of("result_id"))
  }
  return(result)
}
prepareColumns <- function(result,
                           cols,
                           call = parent.frame()) {
  opts <- colnames(result)
  if ("facet" %in% names(cols)) {
    cols$facet <- NULL
  }
  varNames <- names(cols)
  newNames <- omopgenerics::uniqueId(n = length(cols), exclude = opts)
  for (k in seq_along(cols)) {
    result <- prepareColumn(
      result = result, newName = newNames[k], cols = cols[k],
      varName = varNames[k], opts = opts, call = call
    )
  }

  return(result)
}
prepareColumn <- function(result,
                          newName,
                          cols,
                          varName,
                          opts,
                          call) {
  if (is.null(cols)) {
    return(
      result |>
        dplyr::mutate(!!newName := NA_real_)
    )
  }
  if (!is.character(cols) || !all(cols %in% opts)) {
    cli::cli_abort(c("x" = "{varName} is not a column in result."), call = call)
  }
  if (length(cols) == 1) {
    result <- result |>
      dplyr::mutate(!!newName := .data[[cols]])
  } else {
    result <- result |>
      tidyr::unite(
        col = !!newName, dplyr::all_of(cols), remove = FALSE, sep = " - ")
  }
  return(result)
}
getAes <- function(cols) {
  vars <- names(cols)
  paste0(
    "ggplot2::aes(",
    glue::glue("{vars} = .data${vars}") |>
      stringr::str_c(collapse = ", "),
    ")"
  ) |>
    rlang::parse_expr() |>
    rlang::eval_tidy()
}
warnMultipleColumns <- function(result) {
  cols <- colnames(result) |>
    rlang::set_names() |>
    purrr::map_lgl(\(x) length(unique(result[[x]])) > 1)
  cols <- names(cols[cols])
  if (length(cols) > 0) {
    cli::cli_inform(c(
      "i" = "There are duplicated points, suggested to include {.pkg {cols}} in:
      either {.var facet}, {.var colour}, {.var group} or {.var x}."))
  }
  invisible(NULL)
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
styleLabel <- function(x) {
  #length(x) > 0 remove the character(0)
  if (!is.null(x) && x != "" && length(x) > 0) {
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
