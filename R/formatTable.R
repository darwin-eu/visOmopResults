#' Format a table into a gt, flextable or tibble object.
#'
#' `r lifecycle::badge("experimental")`
#'
#' @param result A summarised_result.
#' @param formatEstimateName Named list of estimate name's to join, sorted by
#' computation order. Indicate estimate_name's between <...>.
#' @param header
#' @param groupColumn Columns to use as group labels. By default the name of the
#' new group will be the column names separated by "_". To specify a new
#' grouping name enter a named list such as:
#' list(newGroupName = c("variable_name", "variable_level"))
#' @param type Type of desired formatted table, possibilities: "gt",
#' "flextable", "tibble".
#' @param renameColumns Named vector to customise column names, for instance:
#' c("Database name" = "cdm_name")). By default, "_" are removed from column
#' names and converted to sentence case.
#' @param hide Columns to drop from the output table.
#' @param .options Named list with additional formatting options.
#' visOmopResults::optionsTable() shows allowed arguments and
#' their default values.
#'
#' @return A tibble, gt, or flextable object.
#'
#' @description
#' This function combines the functionalities of `formatEstimateValue()`,
#' `formatEstimateName()`, `formatHeader()`, `gtTable()`, and `fxTable()`
#' into a single function.
#'
#' @export
#'
#' @examples
#'

formatTable <- function(result,
                        formatEstimateName = character(),
                        header = character(),
                        groupColumn = character(),
                        type = "gt",
                        renameColumns = character(),
                        hide = character(), # result_id and estimate_type sempre eliminats (si hi son)
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
  checkFormatTableInputs(header, groupColumn, hide)

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
  groupColumn[[1]] <- purrr::map(groupColumn[[1]], renameColumnsInternal, rename = renameColumns) |> unlist()

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
