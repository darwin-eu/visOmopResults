
#' Create a plot visualisation from a summarised result object.
#'
#' @param result A summarised result object.
#' @param x Column or estimate name that is used as x variable.
#' @param y Column or estimate name that is used as y variable
#' @param line Whether to plot a line using `geom_line`.
#' @param points Whether to plot points using `geom_point`.
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
#'   facet = age_group ~ sex)
#' }
#'
plotScatter <- function(result,
                        x,
                        y,
                        line = TRUE,
                        points = TRUE,
                        ymin = NULL,
                        ymax = NULL,
                        facet = NULL,
                        colour = NULL,
                        group = colour) {
  rlang::check_required("ggplot2")
  # check and prepare input
  omopgenerics::assertLogical(line, length = 1, call = call)
  omopgenerics::assertLogical(points, length = 1, call = call)
  result <- prepareInput(
    result = result, x = x, y = y, facet = facet, colour = colour, ymin = ymin,
    ymax = ymax, group = group)

  idCols <- attr(result, "ids_cols")
  colourColumn <- idCols["colour"] |> unname()
  facetColumn <- idCols["facet"] |> unname()
  groupColumn <- idCols["group"] |> unname()
  xColumn <- idCols["x"] |> unname()

  aes <- "ggplot2::aes(x = .data${xColumn}, y = .data[['{y}']], colour = .data${colourColumn}, group = .data${groupColumn}"
  if (!is.null(ymin)) aes <- paste0(aes, ", ymin = .data[['{ymin}']]")
  if (!is.null(ymax)) aes <- paste0(aes, ", ymax = .data[['{ymax}']]")
  aes <- paste0(aes, ")") |>
    glue::glue() |>
    rlang::parse_expr() |>
    eval()

  p <- ggplot2::ggplot(data = result, mapping = aes)
  if (line) p <- p + ggplot2::geom_line()
  if (!is.null(ymin) & !is.null(ymax)) p <- p + ggplot2::geom_errorbar()
  if (points) p <- p + ggplot2::geom_point()

  p <- plotFacet(p, facet)

  return(p)
}

#' Create a ggplot2 box plot from a summarised_result object.
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
  rlang::check_required("ggplot2")
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

  ylab <- result$variable_name |>
    unique() |>
    stringr::str_to_sentence()
  clab <- colour |>
    stringr::str_replace_all(pattern = "_", replacement = " ") |>
    stringr::str_to_sentence() |>
    paste0(collapse = " - ")
  xlab <- x |>
    stringr::str_replace_all(pattern = "_", replacement = " ") |>
    stringr::str_to_sentence() |>
    paste0(collapse = " - ")

  p <- ggplot2::ggplot(data = result, mapping = aes) +
    ggplot2::geom_boxplot(stat = "identity")
  p <- plotFacet(p, facet) +
    ggplot2::labs(y = ylab, colour = clab, x = xlab)

  return(p)
}

#' Create a plot visualisation from a summarised result object.
#'
#' @param result A summarised result object.
#' @param x Column or estimate name that is used as x variable.
#' @param y Column or estimate name that is used as y variable
#' @param ymin Lower limit of error bars, if provided is plot using
#' `geom_errorbar`.
#' @param ymax Upper limit of error bars, if provided is plot using
#' `geom_errorbar`.
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
                        ymax = NULL,
                        ymin = NULL,
                        facet = NULL,
                        colour = NULL) {
  rlang::check_required("ggplot2")
  result <- prepareInput(
    result = result, x = x, y = y, facet = facet, colour = colour, ymin = ymin,
    ymax = ymax)

  idCols <- attr(result, "ids_cols")
  colourColumn <- idCols["colour"] |> unname()
  facetColumn <- idCols["facet"] |> unname()
  xColumn <- idCols["x"] |> unname()

  aes <- "ggplot2::aes(x = .data${xColumn}, y = .data[['{y}']], colour = .data${colourColumn}, fill = .data${colourColumn}"
  if (!is.null(ymin)) aes <- paste0(aes, ", ymin = .data[['{ymin}']]")
  if (!is.null(ymax)) aes <- paste0(aes, ", ymax = .data[['{ymax}']]")
  aes <- paste0(aes, ")") |>
    glue::glue() |>
    rlang::parse_expr() |>
    eval()

  p <- ggplot2::ggplot(data = result, mapping = aes) +
    ggplot2::geom_col()
  if (!is.null(ymin) & !is.null(ymax)) p <- p + ggplot2::geom_errorbar()
  p <- plotFacet(p, facet)

  return(p)
}

prepareInput <- function(result,
                         x,
                         facet,
                         colour,
                         group = NULL,
                         ...,
                         call = parent.frame()) {
  # result <- omopgenerics::validateResult(result, call = call)
  omopgenerics::assertClass(result, class = "summarised_result", call = call)
  cols <- colnames(settings(result))
  cols <- cols[!cols %in% c(
    "result_id", "result_type", "package_name", "package_version")]
  result <- result |>
    omopgenerics::newSummarisedResult() |>
    splitAll() |>
    addSettings(columns = cols)
  optionCols <- colnames(result)
  optionCols <- optionCols[!optionCols %in% c(
    "result_id", "estimate_name", "estimate_type", "estimate_value")]

  if (rlang::is_bare_formula(facet)) {
    facet <- as.character(facet) |>
      strsplit(split = " + ", fixed = TRUE) |>
      unlist()
    facet <- facet[!facet %in% c(".", "~")]
  }

  result <- result |>
    pivotEstimates() |>
    validateGroup(x = facet, opts = optionCols, call = call) |>
    validateGroup(x = colour, opts = optionCols, call = call) |>
    validateGroup(x = group, opts = optionCols, call = call)
  diffCols <- optionCols[!optionCols %in% c(facet, colour, group)]
  names(diffCols) <- diffCols
  diffCols <- lapply(diffCols, function(var) {
      result[[var]] |> unique() |> length()
    }) |>
    unlist()
  diffCols <- names(diffCols[diffCols>1])
  if (is.null(x)) {
    x <- diffCols
  }
  result <- result |>
    validateGroup(x = x, opts = optionCols, call = call)
  diffCols <- diffCols[!diffCols %in% x]
  if (length(diffCols) > 0) {
    cli::cli_inform(c(
      "i" = "There are duplicated points, suggested to include:
      {.pkg {diffCols}} in: either {.arg facet}, {.arg colour}, {.arg group} or
      {.arg x}."))
  }

  # variables
  variables <- list(...)
  for (k in seq_along(variables)) {
    nm <- names(variables)[k]
    val <- variables[[k]]
    msg <- "{nm} must be a character that points to a column in result." |>
      glue::glue()
    omopgenerics::assertCharacter(val, length = 1, call = call, msg = msg, null = TRUE)
    if (isFALSE(val %in% colnames(result))) {
      cli::cli_inform("created column {val} as NA because it is not present in data.")
      result <- result |>
        dplyr::mutate(!!val := NA_real_)
    }
  }
  attr(result, "x") <- x

  return(result)
}
validateGroup <- function(res, x, opts, call) {
  idsCols <- attr(res, "ids_cols")
  nm <- substitute(x) |> as.character()
  id <- omopgenerics::uniqueId(exclude = colnames(res), prefix = "col_")
  if (is.null(x)) {
    res <- res |>
      dplyr::mutate(!!id := NA_character_)
  } else if (length(x) == 0) {
    res <- res |>
      dplyr::mutate(!!id := "")
  } else {
    mes <- "{nm} must be a subset of: {opts}."
    if (!is.character(x)) cli::cli_abort(mes, call = call)
    if (length(x) != length(unique(x))) cli::cli_abort(mes, call = call)
    notPresent <- x[!x %in% opts]
    if (length(notPresent) > 0) cli::cli_abort(mes, call = call)
    res <- res |>
      tidyr::unite(
        col = !!id, dplyr::all_of(x), remove = FALSE, sep = " - ")
  }
  attr(res, "ids_cols") <- c(idsCols, id |> rlang::set_names(nm))
  return(res)
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
getFacetCols <- function(facet) {
  if (is.null(facet)) {
    facet <- character()
  } else if (rlang::is_bare_formula(facet)) {
    facet <- as.character(facet) |> strsplit(split = "+")
    facet <- facet[[-1]] |> unlist() |> unique()
  }
  return(facet)
}
