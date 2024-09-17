#' Generate a formatted table from a data.table
#'
#' @param result A table to format.
#' @param formatEstimateName A named list of estimate names to join, sorted by
#' computation order. Use `<...>` to indicate estimate names. This argument
#' requires that the table has `estimate_name` and `estimate_value` columns.
#' @param header A vector specifying the elements to include in the header.
#' The order of elements matters, with the first being the topmost header.
#' The vector elements can be column names or labels for overall headers.
#' The table must contain an `estimate_value` column to pivot the headers.
#' @param groupColumn Columns to use as group labels. By default, the name of the
#' new group will be the tidy* column names separated by ";". To specify a custom
#' group name, use a named list such as:
#' list("newGroupName" = c("variable_name", "variable_level")).
#'
#' *tidy: The tidy format applied to column names replaces "_" with a space and
#' converts them to sentence case. Use `renameColumns` to customize specific column names.
#'
#' @param renameColumns A named vector to customize column names, e.g.,
#' c("Database name" = "cdm_name"). The function will rename all column names
#' not specified here into a tidy* format.
#' @param type The desired format of the output table. Options are: "gt",
#' "flextable", or "tibble".
#' @param hide Columns to drop from the output table.
#' @param .options A named list with additional formatting options.
#' `visOmopResults::optionsTable()` shows allowed arguments and their default values.
#'
#' @return A tibble, gt, or flextable object.
#'
#' @description
#' This function combines the functionalities of `formatEstimateValue()`,
#' `formatEstimateName()`, `formatHeader()`, `gtTable()`, and `fxTable()`
#' into a single function. While it does not require the input table to be
#' a `summarised_result`, it does expect specific fields to apply formatting.
#'
#' @export
#'
#' @examples
#' result <- mockSummarisedResult()
#' result |>
#'   visTable(
#'     formatEstimateName = c("N%" = "<count> (<percentage>)",
#'                            "N" = "<count>",
#'                            "Mean (SD)" = "<mean> (<sd>)"),
#'     header = c("Estimate"),
#'     renameColumns = c("Database name" = "cdm_name"),
#'     groupColumn = c("strata_name", "strata_level"),
#'     hide = c("additional_name", "additional_level", "estimate_type", "result_type")
#'   )

visTable <- function(result,
                        formatEstimateName = character(),
                        header = character(),
                        groupColumn = character(),
                        renameColumns = character(),
                        type = "gt",
                        hide = character(),
                        .options = list()) {
  # initial checks
  omopgenerics::assertTable(result)
  omopgenerics::assertChoice(type, choices = c("gt", "flextable", "tibble"), length = 1)
  omopgenerics::assertCharacter(hide, null = TRUE)
  omopgenerics::assertCharacter(header, null = TRUE)
  renameColumns <- validateRenameColumns(renameColumns, result)
  groupColumn <- validateGroupColumn(groupColumn, result, formatName = TRUE)
  # .options
  .options <- defaultTableOptions(.options)
  # default hide columns
  # hide <- c(hide, "result_id", "estimate_type")
  checkvisTableInputs(header, groupColumn, hide)

  # format estimate values and names
  result <- result |>
    visOmopResults::formatEstimateValue(
      decimals = .options$decimals,
      decimalMark = .options$decimalMark,
      bigMark = .options$bigMark
    ) |>
    visOmopResults::formatEstimateName(
      estimateNameFormat = formatEstimateName,
      keepNotFormatted = .options$keepNotFormatted,
      useFormatOrder = .options$useFormatOrder
    )

  # rename and hide columns
  dontRename <- c("estimate_value")
  dontRename <- dontRename[dontRename %in% colnames(result)]
  estimateValue <- renameColumnsInternal("estimate_value", renameColumns)
  renameColumns <- renameColumns[!renameColumns %in% dontRename]
  result <- result |>
    dplyr::select(!dplyr::any_of(hide)) |>
    dplyr::rename_with(
      .fn = ~ renameColumnsInternal(.x, rename = renameColumns),
      .cols = !dplyr::all_of(c(dontRename))
    )
  # rename headers
  header <- purrr::map(header, renameColumnsInternal, rename = renameColumns) |> unlist()
  if (length(groupColumn[[1]]) > 0) {
    groupColumn[[1]] <- purrr::map(groupColumn[[1]], renameColumnsInternal, rename = renameColumns) |> unlist()
  }

  # format header
  if (length(header) > 0) {
    result <- result |>
      visOmopResults::formatHeader(
        header = header,
        delim = .options$delim,
        includeHeaderName = .options$includeHeaderName,
        includeHeaderKey = .options$includeHeaderKey
      )
  } else if ("estimate_value" %in% colnames(result)) {
    result <- result |> dplyr::rename(!!estimateValue := "estimate_value")
  }

  if (type == "gt") {
    result <- result |>
      visOmopResults::gtTable(
        delim = .options$delim,
        style = .options$style,
        na = .options$na,
        title = .options$title,
        subtitle = .options$subtitle,
        caption = .options$caption,
        groupColumn = groupColumn,
        groupAsColumn = .options$groupAsColumn,
        groupOrder = .options$groupOrder,
        colsToMergeRows = .options$colsToMergeRows
      )
  } else if (type == "flextable") {
    result <- result |>
      visOmopResults::fxTable(
        delim = .options$delim,
        style = .options$style,
        na = .options$na,
        title = .options$title,
        subtitle = .options$subtitle,
        caption = .options$caption,
        groupColumn = groupColumn,
        groupAsColumn = .options$groupAsColumn,
        groupOrder = .options$groupOrder,
        colsToMergeRows = .options$colsToMergeRows
      )
  } else if (type == "tibble") {
    class(result) <- class(result)[!class(result) %in% c("summarised_result", "omop_result")]
  }

  return(result)
}

renameColumnsInternal <- function(x, rename, toSentence = TRUE) {
  newNames <- character()
  for (xx in x) {
    if (isTRUE(xx %in% rename)) {
      newNames <- c(newNames, names(rename[rename == xx]))
    } else if (toSentence) {
      newNames <- c(newNames, formatToSentence(xx))
    } else {
      newNames <- c(newNames, xx)
    }
  }
  return(newNames)
}
