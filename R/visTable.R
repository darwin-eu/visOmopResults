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
#' @param header A vector specifying the elements to include in the header.
#' The order of elements matters, with the first being the topmost header.
#' The vector elements can be column names or labels for overall headers.
#' The table must contain an `estimate_value` column to pivot the headers.
#' @param hide Columns to drop from the output table.
#'
#' @inheritParams tableDoc
#'
#' @return A formatted table of the class selected in "type" argument.
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
                     type = NULL,
                     hide = character(),
                     style = NULL,
                     .options = list()) {
  # initial checks
  type <- validateType(type = type, obj = "table")
  omopgenerics::assertTable(result)
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

  if (nrow(result) == 0) return(emptyTable(type = type, style = style))

  # format estimate values and names
  if ("estimate_value" %in% colnames(result)) {
    if (type %in% c("reactable", "datatable") & length(estimateName) == 0) {
      result <- result |>
        dplyr::mutate(estimate_value = as.numeric(.data$estimate_value))
    } else if (!any(c("estimate_name", "estimate_type") %in% colnames(result))) {
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

  result <- result |>
    formatTable(
      type = type,
      delim = .options$delim,
      style = style,
      na = .options$na,
      title = .options$title,
      subtitle = .options$subtitle,
      caption = .options$caption,
      groupColumn = groupColumn,
      groupAsColumn = .options$groupAsColumn,
      groupOrder = .options$groupOrder,
      merge = .options$merge
    )

  return(result)
}

formatToSentence <- function(x) {
  stringr::str_to_sentence(gsub("_", " ", gsub("&&&", "and", x)))
}

#' Returns an empty table
#'
#' @inheritParams tableDoc
#'
#' @return An empty table of the class specified in `type`
#'
#' @export
#'
#' @examples
#' emptyTable(type = "flextable")
#'
emptyTable <- function(type = NULL, style = NULL) {
  # input check
  type <- validateType(type = type, obj = "table")
  style <- validateStyle(style = style, obj = "table", type = type)

  empty <- dplyr::tibble()
  switch (type,
          "gt" = empty |> gt::gt(),
          "flextable" = empty |> dplyr::mutate("Table has no data" = NA) |> flextable::flextable(cwidth = 1.5),
          "tibble" = empty,
          "tinytable" = dplyr::tibble("Table has no data" = "-") |> tinytable::tt(),
          "reactable" = empty |> dplyr::mutate("Table has no data" = NA) |> reactable::reactable(),
          "datatable" = empty |> dplyr::mutate("Table has no data" = NA) |> DT::datatable())
}

