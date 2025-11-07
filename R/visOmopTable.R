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

#' Generate a formatted table from a `<summarised_result>`
#'
#' @param result A `<summarised_result>` object.
#' @param header A vector specifying the elements to include in the header.
#' The order of elements matters, with the first being the topmost header.
#' Elements in header can be:
#'  - Any of the columns returned by `tableColumns(result)` to create a header
#' for these columns.
#'  - Any other input to create an overall header.
#' @param settingsColumn A character vector with the names of settings to
#' include in the table. To see options use `settingsColumns(result)`.
#' @param hide Columns to drop from the output table. By default, `result_id` and
#' `estimate_type` are always dropped.
#'
#' @inheritParams tableDoc
#'
#' @return A formatted table of the class selected in "type" argument.
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
#'     header = c("cohort_name"),
#'     rename = c("Database name" = "cdm_name"),
#'     groupColumn = strataColumns(result)
#'   )
#' result |>
#'   visOmopTable(
#'     estimateName = c(
#'       "N%" = "<count> (<percentage>)",
#'       "N" = "<count>",
#'       "Mean (SD)" = "<mean> (<sd>)"
#'     ),
#'     header = c("cohort_name"),
#'     rename = c("Database name" = "cdm_name"),
#'     groupColumn = strataColumns(result),
#'     type = "reactable"
#'   )
#'
visOmopTable <- function(result,
                         estimateName = character(),
                         header = character(),
                         settingsColumn = character(),
                         groupColumn = character(),
                         rename = character(),
                         type = NULL,
                         hide = character(),
                         columnOrder = character(),
                         factor = list(),
                         style = NULL,
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
        dplyr::any_of(c(visOmopResults::additionalColumns(result), settingsColumn)),
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
    style = style,
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
    na = "\u2013",
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
    cli::cli_inform("Dropping the following from `columnOrder` as they are not part of the table: {newOrder[!newOrder %in% currentOrder]}")
    newOrder <- base::intersect(newOrder, currentOrder)
  }
  newOrder <- c(newOrder, "result_id", "estimate_type", "estimate_value")
  notIn <- base::setdiff(currentOrder, newOrder)
  if (length(notIn) > 0) {
    cli::cli_inform("{.strong {notIn}} {?is/are} missing in `columnOrder`, will be added last.")
    newOrder <- c(newOrder, notIn)
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
