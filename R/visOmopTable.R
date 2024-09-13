#' Format a summarised_result object into a gt, flextable or tibble object
#'
#' @param result A summarised_result.
#' @param formatEstimateName Named list of estimate name's to join, sorted by
#' computation order. Indicate estimate_name's between <...>.
#' @param header A vector containing which elements should go into the header
#' in order (`cdm_name`, `group`, `strata`, `additional`,
#' `variable`, `estimate`, and `settings`).
#' @param groupColumn Columns to use as group labels. By default the name of the
#' new group will be the column names separated by "_". To specify a new
#' grouping name enter a named list such as:
#' list(`newGroupName` = c("variable_name", "variable_level"))
#' @param split A vector containing the name-level groups to split ("group",
#' "strata", "additional"), or an empty character vector to not split.
#' @param type Type of desired formatted table, possibilities: "gt",
#' "flextable", "tibble".
#' @param renameColumns Named vector to customise column names, for instance:
#' c("Database name" = "cdm_name")). By default column names are transformed to
#' sentence case.
#' @param showMinCellCount If TRUE, suppressed estimates will be indicated with
#' "<\{minCellCount\}", otherwise the default na defined in `.options` will
#' be used.
#' @param minCellCount `r lifecycle::badge("deprecated")` Suppression of
#' estimates when counts < minCellCount should be done before with
#' `ompogenerics::suppress()`.
#' @param hide Columns to drop from the output table.
#' @param .options Named list with additional formatting options.
#' visOmopResults::optionsTable() shows allowed arguments and
#' their default values.
#'
#' @return A tibble, gt, or flextable object.
#'
#'
#' @export
#'
#' @examples
#' mockSummarisedResult() |>
#' visOmopTable(
#'   formatEstimateName = c("N%" = "<count> (<percentage>)",
#'                          "N" = "<count>",
#'                          "Mean (SD)" = "<mean> (<sd>)"),
#'   header = c("group"),
#'   split = c("group","strata",  "additional")
#' )
#'
visOmopTable <- function(result,
                         formatEstimateName = character(),
                         header = character(),
                         groupColumn = character(),
                         type = "gt",
                         renameColumns = character(),
                         settingsColumns = character(),
                         showMinCellCount = TRUE,
                         hide = character(),
                         .options = list(),
                         split = lifecycle::deprecated(),
                         minCellCount = lifecycle::deprecated()) {

  if (lifecycle::is_present(minCellCount)) {
    lifecycle::deprecate_stop("0.3.0", "visOmopTable(minCellCount)")
  }
  if (lifecycle::is_present(split)) {
    lifecycle::deprecate_warn("0.4.0", "visOmopTable(split)")
  }

  # Tidy results
  result <- omopgenerics::validateResultArguemnt(result)
  resultTidy <- tidySummarisedResult(result, settingsColumns = settingsColumns, pivotEstimatesBy = NULL)

  # .options
  .options <- defaultTableOptions(.options)

  # Backward compatibility ---> to be deleted in the future
  omopgenerics::assertCharacter(header, null = TRUE)
  omopgenerics::assertCharacter(hide, null = TRUE)
  settingsColumns <- validateSettingsColumns(settingsColumns, result) # to remove > 0.4.0
  bc <- backwardCompatibility(header, hide, result, settingsColumns) # to remove > 0.4.0
  header <- bc$header # to remove > 0.4.0
  hide <- bc$hide # to remove > 0.4.0
  if ("variable_level" %in% header) {
    resultTidy <- resultTidy |>
      dplyr::mutate(dplyr::across(dplyr::starts_with("variable"), ~ dplyr::if_else(is.na(.x), .options$na, .x)))
  }

  # initial checks and preparation
  renameColumns <- validateRenameColumns(renameColumns, result)
  if (!"cdm_name" %in% renameColumns) renameColumns <- c(renameColumns, "CDM name" = "cdm_name")
  groupColumn <- validateGroupColumn(groupColumn, resultTidy, sr = TRUE, formatName = TRUE)
  showMinCellCount <- validateShowMinCellCount(showMinCellCount, settings(result))
  # default SR hide columns
  hide <- c(hide, "result_id", "estimate_type") |> unique()
  checkFormatTableInputs(header, groupColumn, hide)

  # showMinCellCount
  if (showMinCellCount) {
    if ("min_cell_count" %in% settingsColumns) {
      resultTidy <- resultTidy |>
        dplyr::mutate(estimate_value = dplyr::if_else(
          is.na(.data$estimate_value), paste0("<", base::format(.data$min_cell_count, big.mark = ",")), .data$estimate_value
        ))
    } else {
      resultTidy <- resultTidy |>
        dplyr::left_join(
          settings(result) |> dplyr::select("result_id", "min_cell_count"),
          by = "result_id"
        ) |>
        dplyr::mutate(estimate_value = dplyr::if_else(
          is.na(.data$estimate_value), paste0("<", base::format(.data$min_cell_count, big.mark = ",")), .data$estimate_value
        )) |>
        dplyr::select(!"min_cell_count")
    }
  }

  tableOut <- formatTable(
    result = resultTidy,
    formatEstimateName = formatEstimateName,
    header = header,
    groupColumn = groupColumn,
    type = type,
    renameColumns = renameColumns,
    hide = hide,
    .options = .options
  )

  return(tableOut)
}

formatToSentence <- function(x) {
  stringr::str_to_sentence(gsub("_", " ", gsub("&&&", "and", x)))
}

defaultTableOptions <- function(userOptions) {
  defaultOpts <- list(
    decimals = c(integer = 0, percentage = 2, numeric = 2, proportion = 2),
    decimalMark = ".",
    bigMark = ",",
    keepNotFormatted = TRUE,
    useFormatOrder = TRUE,
    delim = "\n",
    includeHeaderName = TRUE,
    includeHeaderKey = TRUE,
    style = "default",
    na = "-",
    title = NULL,
    subtitle = NULL,
    caption = NULL,
    groupAsColumn = FALSE,
    groupOrder = NULL,
    colsToMergeRows = "all_columns"
  )

  for (opt in names(userOptions)) {
    defaultOpts[[opt]] <- userOptions[[opt]]
  }

  return(defaultOpts)
}

#' Additional arguments for the function visOmopTable
#'
#' @description
#' It provides a list of allowed inputs for .option argument in
#' visOmopTable and their given default value.
#'
#'
#' @return The default .options named list.
#'
#' @export
#'
#' @examples
#' {
#' optionsTable()
#' }
#'
#'
optionsTable <- function() {
  return(defaultTableOptions(NULL))
}

backwardCompatibility <- function(header, hide, result, settingsColumns) {

  if (all(is.na(result$variable_level)) & "variable" %in% header) {
    colsVariable <- c("variable_name")
    hide <- c(hide, "variable_level")
  } else {
    colsVariable <- c("variable_name", "variable_level")
  }

  header <- purrr::map(header, function(x) {
    switch(x,
           cdm_name = "cdm_name",
           group = groupColumns(result),
           strata = strataColumns(result),
           additional = additionalColumns(result),
           variable = colsVariable,
           estimate = c("estimate_name"),
           settings = settingsColumns)
  }) |> unlist()

  return(list(hide = hide, header = header))
}
