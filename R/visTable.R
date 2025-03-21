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

#' Generate a formatted table from a `<data.table>`
#'
#'
#' @param result A table to format.
#' @param estimateName A named list of estimate names to join, sorted by
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
#' converts them to sentence case. Use `rename` to customise specific column names.
#'
#' @param rename A named vector to customise column names, e.g.,
#' c("Database name" = "cdm_name"). The function will rename all column names
#' not specified here into a tidy* format.
#' @param type The desired format of the output table. See `tableType()` for
#' allowed options.
#' @param hide Columns to drop from the output table.
#' @param .options A named list with additional formatting options.
#' `visOmopResults::tableOptions()` shows allowed arguments and their default values.
#'
#' @return A tibble, gt, or flextable object.
#'
#' @description
#' This function combines the functionalities of `formatEstimateValue()`,
#' `formatEstimateName()`, `formatHeader()`, and `formatTable()`
#' into a single function. While it does not require the input table to be
#' a `<summarised_result>`, it does expect specific fields to apply some
#' formatting functionalities.
#'
#' @export
#'
#' @examples
#' result <- mockSummarisedResult()
#' result |>
#'   visTable(
#'     estimateName = c("N%" = "<count> (<percentage>)",
#'                      "N" = "<count>",
#'                      "Mean (SD)" = "<mean> (<sd>)"),
#'     header = c("Estimate"),
#'     rename = c("Database name" = "cdm_name"),
#'     groupColumn = c("strata_name", "strata_level"),
#'     hide = c("additional_name", "additional_level", "estimate_type", "result_type")
#'   )

visTable <- function(result,
                     estimateName = character(),
                     header = character(),
                     groupColumn = character(),
                     rename = character(),
                     type = "gt",
                     hide = character(),
                     .options = list()) {
  # initial checks
  omopgenerics::assertTable(result)
  omopgenerics::assertChoice(type, choices = tableType(), length = 1)
  omopgenerics::assertCharacter(hide, null = TRUE)
  omopgenerics::assertCharacter(header, null = TRUE)
  rename <- validateRename(rename, result)
  groupColumn <- validateGroupColumn(groupColumn, colnames(result), rename = rename)
  # .options
  omopgenerics::assertList(.options, named = TRUE)
  .options <- defaultTableOptions(.options)
  if (length(header) > 0) {
    neededCols <- validateHeader(result, header, hide)
    hide <- neededCols$hide
  }
  checkVisTableInputs(header, groupColumn, hide)

  if (nrow(result) == 0) return(emptyTable(type = type))

  # format estimate values and names
  if ("estimate_value" %in% colnames(result)) {
    if (!any(c("estimate_name", "estimate_type") %in% colnames(result))) {
      cli::cli_inform("`estimate_name` and `estimate_type` must be present in `result` to apply `formatEstimateValue()`.")
    } else {
      result <- result |>
        visOmopResults::formatEstimateValue(
          decimals = .options$decimals,
          decimalMark = .options$decimalMark,
          bigMark = .options$bigMark
        )
    }
  }
  if (length(estimateName) > 0) {
    if (!any(c("estimate_name", "estimate_value") %in% colnames(result))) {
      cli::cli_inform("`estimate_name` and `estimate_value` must be present in `result` to apply `formatEstimateName()`.")
    } else {
      result <- result |>
        visOmopResults::formatEstimateName(
          estimateName = estimateName,
          keepNotFormatted = .options$keepNotFormatted,
          useFormatOrder = .options$useFormatOrder
        )
    }
  }

  # rename and hide columns
  dontRename <- c("estimate_value")
  dontRename <- dontRename[dontRename %in% colnames(result)]
  estimateValue <- renameInternal("estimate_value", rename)
  rename <- rename[!rename %in% dontRename]
  # rename headers
  header <- purrr::map(header, renameInternal, cols = colnames(result), rename = rename) |> unlist()
  # rename group columns
  if (length(groupColumn[[1]]) > 0) {
    groupColumn[[1]] <- purrr::map(groupColumn[[1]], renameInternal, rename = rename) |> unlist()
  }
  # rename result
  result <- result |>
    dplyr::select(!dplyr::any_of(hide)) |>
    dplyr::rename_with(
      .fn = ~ renameInternal(.x, rename = rename),
      .cols = !dplyr::all_of(c(dontRename))
    )


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

  if (type == "tibble") {
    class(result) <- class(result)[!class(result) %in% c("summarised_result", "omop_result")]
  } else {
    result <- result |>
      formatTable(
        type = type,
        delim = .options$delim,
        style = .options$style,
        na = .options$na,
        title = .options$title,
        subtitle = .options$subtitle,
        caption = .options$caption,
        groupColumn = groupColumn,
        groupAsColumn = .options$groupAsColumn,
        groupOrder = .options$groupOrder,
        merge = .options$merge
      )
  }
  return(result)
}

formatToSentence <- function(x) {
  stringr::str_to_sentence(gsub("_", " ", gsub("&&&", "and", x)))
}

#' Returns an empty table
#'
#' @param type The desired format of the output table. See `tableType()` for
#' allowed options.
#'
#' @return An empty table of the class specified in `type`
#'
#' @export
#'
#' @examples
#' emptyTable(type = "flextable")
#'
emptyTable <- function(type = "gt") {
  omopgenerics::assertChoice(type, choices = tableType())
  empty <- dplyr::tibble()
  switch (type,
    "gt" = empty |> gt::gt(),
    "flextable" = empty |> dplyr::mutate("Table has no data" = NA) |> flextable::flextable(cwidth = 1.5),
    "tibble" = empty
  )
}

