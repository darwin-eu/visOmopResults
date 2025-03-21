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

#' Format a `<summarised_result>` object into a gt, flextable, or tibble object
#'
#' @param result A `<summarised_result>` object.
#' @param estimateName A named list of estimate names to join, sorted by
#' computation order. Use `<...>` to indicate estimate names.
#' @param header A vector specifying the elements to include in the header.
#' The order of elements matters, with the first being the topmost header.
#' Elements in header can be:
#'  - Any of the columns returned by `tableColumns(result)` to create a header
#' for these columns.
#'  - Any other input to create an overall header.
#' @param settingsColumn A character vector with the names of settings to
#' include in the table. To see options use `settingsColumns(result)`.
#' @param groupColumn Columns to use as group labels, to see options use
#' `tableColumns(result)`. By default, the name of the new group will be the
#' tidy* column names separated by ";". To specify a custom group name, use a
#' named list such as:
#' list("newGroupName" = c("variable_name", "variable_level")).
#'
#' *tidy: The tidy format applied to column names replaces "_" with a space and
#' converts to sentence case. Use `rename` to customise specific column names.
#'
#' @param rename A named vector to customise column names, e.g.,
#' c("Database name" = "cdm_name"). The function renames all column names
#' not specified here into a tidy* format.
#' @param type The desired format of the output table. See `tableType()` for
#' allowed options.
#' @param hide Columns to drop from the output table. By default, `result_id` and
#' `estimate_type` are always dropped.
#' @param columnOrder Character vector establishing the position of the columns
#' in the formatted table. Columns in either header, groupColumn, or hide will
#' be ignored.
#' @param factor A named list where names refer to columns (see available columns
#' in `tableColumns()`) and list elements are the level order of that column
#' to arrange the results. The column order in the list will be used for
#' arranging the result.
#' @param showMinCellCount If `TRUE`, suppressed estimates will be indicated with
#' "<\{min_cell_count\}", otherwise, the default `na` defined in `.options` will be
#' used.
#' @param .options A named list with additional formatting options.
#' `visOmopResults::tableOptions()` shows allowed arguments and their default values.
#'
#' @return A tibble, gt, or flextable object.
#'
#' @description
#' This function combines the functionalities of `formatEstimateValue()`,
#' `estimateName()`, `formatHeader()`, and `formatTable()`
#' into a single function specifically for `<summarised_result>` objects.
#'
#' @export
#'
#' @examples
#' result <- mockSummarisedResult()
#' result |>
#'   visOmopTable(
#'     estimateName = c("N%" = "<count> (<percentage>)",
#'                      "N" = "<count>",
#'                      "Mean (SD)" = "<mean> (<sd>)"),
#'     header = c("group"),
#'     rename = c("Database name" = "cdm_name"),
#'     groupColumn = strataColumns(result)
#'   )
visOmopTable <- function(result,
                         estimateName = character(),
                         header = character(),
                         settingsColumn = character(),
                         groupColumn = character(),
                         rename = character(),
                         type = "gt",
                         hide = character(),
                         columnOrder = character(),
                         factor = list(),
                         showMinCellCount = TRUE,
                         .options = list()) {
  # Tidy results
  result <- omopgenerics::validateResultArgument(result)
  showMinCellCount <- validateShowMinCellCount(showMinCellCount, settings(result))
  if (showMinCellCount) {
    result <- result |> formatMinCellCount()
  }
  # Backward compatibility ---> to be deleted in the future
  omopgenerics::assertCharacter(header, null = TRUE)
  omopgenerics::assertCharacter(hide, null = TRUE)
  settingsColumn <- validateSettingsColumn(settingsColumn, result)
  bc <- backwardCompatibility(header, hide, result, settingsColumn, groupColumn)
  header <- bc$header
  hide <- bc$hide
  groupColumn <- bc$groupColumn
  if (length(header) > 0) {
    neededCols <- validateHeader(result, header, hide, settingsColumn, TRUE)
    hide <- neededCols$hide
    settingsColumn <- neededCols$settingsColumn
  }
  resultTidy <- tidySummarisedResult(result, settingsColumn = settingsColumn, pivotEstimatesBy = NULL)

  # Checks
  factor <- validateFactor(factor, resultTidy)

  # .options
  .options <- defaultTableOptions(.options)

  if ("variable_level" %in% header) {
    resultTidy <- resultTidy |>
      dplyr::mutate(dplyr::across(dplyr::starts_with("variable"), ~ dplyr::if_else(is.na(.x), .options$na, .x)))
  }

  # initial checks and preparation
  rename <- validateRename(rename, resultTidy)
  if (!"cdm_name" %in% rename) rename <- c(rename, "CDM name" = "cdm_name")
  groupColumn <- validateGroupColumn(groupColumn, colnames(resultTidy), sr = result, rename = rename)
  # default SR hide columns
  hide <- c(hide, "result_id", "estimate_type") |> unique()
  checkVisTableInputs(header, groupColumn, hide)

  if (length(factor) > 0) {
    factorExp <- getFactorExp(factor)
    resultTidy <- resultTidy |>
      dplyr::mutate(!!!factorExp) |>
      dplyr::arrange(dplyr::across(dplyr::all_of(names(factor))))
  }

  if (length(columnOrder) == 0) {
    resultTidy <- resultTidy |>
      dplyr::relocate(
        c(visOmopResults::additionalColumns(result), settingsColumn),
        .before = "estimate_name"
      )
  } else {
    columnOrder <- getColumnOrder(colnames(resultTidy), columnOrder, header, groupColumn[[1]], hide)
    resultTidy <- resultTidy |>
      dplyr::select(dplyr::any_of(columnOrder))
  }

  tableOut <- visTable(
    result = resultTidy,
    estimateName = estimateName,
    header = header,
    groupColumn = groupColumn,
    type = type,
    rename = rename,
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
    merge = "all_columns"
  )

  for (opt in names(userOptions)) {
    defaultOpts[[opt]] <- userOptions[[opt]]
  }

  return(defaultOpts)
}

backwardCompatibility <- function(header, hide, result, settingsColumn, groupColumn) {
  if (all(is.na(result$variable_level)) & "variable" %in% header) {
    colsVariable <- c("variable_name")
    hide <- c(hide, "variable_level")
  } else {
    colsVariable <- c("variable_name", "variable_level")
  }

  cols <- list(
    "group" = groupColumns(result),
    "strata" = strataColumns(result),
    "additional" = additionalColumns(result),
    "variable" = colsVariable,
    "estimate" = "estimate_name",
    "settings" = settingsColumn,
    "group_name" = character(),
    "strata_name" = character(),
    "additional_name" = character()
  )
  cols$group_level <- cols$group
  cols$strata_level <- cols$strata
  cols$additional_level <- cols$additional

  header <- correctColumnn(header, cols)

  if (is.list(groupColumn)) {
    groupColumn <- purrr::map(groupColumn, \(x) correctColumnn(x, cols))
  } else if (is.character(groupColumn)) {
    groupColumn <- correctColumnn(groupColumn, cols)
  }

  return(list(hide = hide, header = header, groupColumn = groupColumn))
}

correctColumnn <- function(col, cols) {
  purrr::map(col, \(x) if (x %in% names(cols)) cols[[x]] else x) |>
    unlist() |>
    unique()
}

getColumnOrder <- function(currentOrder, newOrder, header, group, hide) {
  # initial check
  if (any(!newOrder %in% currentOrder)) {
    cli::cli_warn("Dropping the following from `columnOrder` as they are not part of the table: {newOrder[!newOrder %in% currentOrder]}")
  }
  # group
  if (length(group) != 0) {
    newOrder <- c(newOrder, group[group %in% currentOrder])
  }
  # hide
  if (length(hide) != 0) {
    newOrder <- c(newOrder, hide[hide %in% currentOrder])
  }
  # header
  if (length(header) != 0) {
    newOrder <- c(newOrder, header[header %in% currentOrder])
  }
  # estimate_value
  newOrder <- c(newOrder, "estimate_value")
  newOrder <- unique(newOrder)
  # final check
  if (length(newOrder) != length(currentOrder)) {
    cli::cli_abort("Please make sure `columnOrder` argument contains all the table columns. Missing columns to allocate a position are: {currentOrder[!currentOrder %in% newOrder]}")
  }
  return(newOrder)
}

getFactorExp <- function(factor) {
  expr <- c()
  for (nm in names(factor)) {
    chars <- glue::glue("'{factor[[nm]]}'") |> paste0(collapse = ", ")
    expr <- c(expr, glue::glue("factor({nm}, levels = c({chars}))"))
  }
  expr |> rlang::parse_exprs() |> rlang::set_names(names(factor))
}
