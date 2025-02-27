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

#' Formats estimate_name and estimate_value column
#'
#' @param result A `<summarised_result>`.
#' @param estimateName Named list of estimate name's to join, sorted by
#' computation order. Indicate estimate_name's between <...>.
#' @param keepNotFormatted Whether to keep rows not formatted.
#' @param useFormatOrder Whether to use the order in which estimate names
#' appear in the estimateName (TRUE), or use the order in the
#' input dataframe (FALSE).
#'
#' @description
#' Formats estimate_name and estimate_value columns by changing the name of the
#' estimate name and/or joining different estimates together in a single row.
#'
#' @return A `<summarised_result>` object.
#'
#' @export
#'
#' @examples
#' result <- mockSummarisedResult()
#' result |>
#'   formatEstimateName(
#'     estimateName = c(
#'       "N (%)" = "<count> (<percentage>%)", "N" = "<count>"
#'     ),
#'     keepNotFormatted = FALSE
#'   )
#'
formatEstimateName <- function(result,
                               estimateName = NULL,
                               keepNotFormatted = TRUE,
                               useFormatOrder = TRUE) {
  # initial checks
  omopgenerics::assertTable(result, columns = c("estimate_name", "estimate_value"))
  estimateName <- validateEstimateName(estimateName)
  omopgenerics::assertLogical(keepNotFormatted, length = 1)
  omopgenerics::assertLogical(useFormatOrder, length = 1)

  # format estimate
  if (!is.null(estimateName)) {
    resultFormatted <- formatEstimateNameInternal(
      result = result, format = estimateName,
      keepNotFormatted = keepNotFormatted, useFormatOrder = useFormatOrder
    )
  } else {
    resultFormatted <- result
  }

  return(resultFormatted)
}

formatEstimateNameInternal <- function(result, format, keepNotFormatted, useFormatOrder) {
  # if no format no action is performed
  if (length(format) == 0) {
    return(result)
  }
  # correct names
  if (is.null(names(format))) {
    nms <- rep("", length(format))
  } else {
    nms <- names(format)
  }
  nms[nms == ""] <- gsub("<|>", "", format[nms == ""])
  # format
  ocols <- colnames(result)
  cols <- ocols[
    !ocols %in% c("estimate_name", "estimate_type", "estimate_value")
  ]

  if (nrow(result) == 0) {
    cli::cli_warn(c("!" = "Empty summarised results provided."))
    return(result)
  } else {
    result <- result |>
      dplyr::mutate("formatted" = FALSE, "id" = dplyr::row_number()) |>
      dplyr::mutate(group_id = min(.data$id), .by = dplyr::all_of(cols))
  }

  for (k in seq_along(format)) {
    nameK <- nms[k]
    formatK <- format[k] |> unname()
    keys <- result[["estimate_name"]] |> unique()
    keysK <- regmatches(formatK, gregexpr("(?<=\\<).+?(?=\\>)", formatK, perl = T))[[1]]
    format_boolean <- all(keysK %in% keys)
    len <- length(keysK)
    if (len > 0 & format_boolean) {
      formatKNum <- getFormatNum(formatK, keysK)
      res <- result |>
        dplyr::filter(!.data$formatted) |>
        dplyr::filter(.data$estimate_name %in% .env$keysK) |>
        dplyr::filter(dplyr::n() == .env$len, .by = dplyr::all_of(cols))
      if (nrow(res) == 0) {
        if (len > 1) {
          cli::cli_warn("No combined entries in `result` for estimates {.strong {keysK}}")
        } else {
          cli::cli_warn("No entries in `result` for estimate {.strong {keysK}}")
        }
      } else {
        res <- res |>
          dplyr::mutate("id" = min(.data$id), .by = dplyr::all_of(cols))
        resF <- res |>
          dplyr::select(-"estimate_type") |>
          tidyr::pivot_wider(
            names_from = "estimate_name", values_from = "estimate_value"
          ) |>
          evalName(formatKNum, keysK) |>
          dplyr::mutate(
            "estimate_name" = nameK,
            "formatted" = TRUE,
            "estimate_type" = "character"
          ) |>
          dplyr::select(dplyr::all_of(c(ocols, "id", "group_id", "formatted")))
        result <- result |>
          dplyr::anti_join(
            res |> dplyr::select(dplyr::all_of(c(cols, "estimate_name"))),
            by = c(cols, "estimate_name")
          ) |>
          dplyr::union_all(resF)
      }
    } else {
      if (len > 0) {
        cli::cli_inform(c("i" = "{formatK} has not been formatted."))
      } else {
        cli::cli_inform(c("i" = "{formatK} does not contain an estimate name indicated by <...>."))
      }
    }
  }
  #useFormatOrder
  if (useFormatOrder) {
    new_order <- dplyr::tibble(estimate_name = nms, format_id = 1:length(nms)) |>
      dplyr::union_all(
        result |>
          dplyr::select("estimate_name") |>
          dplyr::distinct() |>
          dplyr::filter(!.data$estimate_name %in% nms) |>
          dplyr::mutate(format_id = length(format) + dplyr::row_number())
      )
    result <- result |>
      dplyr::left_join(new_order, by = "estimate_name")
    result <- result[order(result$group_id, result$format_id, decreasing = FALSE),] |>
      dplyr::select(-c("id", "group_id", "format_id"))
  } else {
    result <- result |>
      dplyr::arrange(.data$id) |>
      dplyr::select(-"id", -"group_id")
  }
  # keepNotFormated
  if (!keepNotFormatted) {
    result <- result |> dplyr::filter(.data$formatted)
  }

  result <- result |> dplyr::select(-"formatted")

  return(result)
}
getFormatNum <- function(format, keys) {
  ik <- 1
  for (k in seq_along(keys)) {
    format <- gsub(
      pattern = paste0("<", keys[k], ">"), replacement = paste0("#", ik, "#"), x = format
    )
    ik <- ik + 1
  }
  return(format)
}
evalName <- function(result, format, keys) {

  for (k in seq_along(keys)) {
    format <- gsub(
      pattern = paste0("#", k, "#"),
      replacement = paste0("#x#.data[[\"", keys[k], "\"]]#x#"),
      x = format
    )
  }

  format <- strsplit(x = format, split = "#x#") |> unlist()
  format <- format[format != ""]

  id <- !startsWith(format, ".data")
  format[id] <- paste0("\"", format[id], "\"")
  format <- paste0(format, collapse = ", ")
  format <- paste0("paste0(", format, ")")

  result <- result |>
    dplyr::mutate(
      "estimate_value" =
        dplyr::case_when(
          dplyr::if_any(dplyr::all_of(keys), \(x) x == "-") ~ "-",
          dplyr::if_any(dplyr::all_of(keys), ~ is.na(.x)) ~ NA_character_,
          .default = eval(parse(text = format))
        )
    )

  if(any(c("percentage", "mean", "sd", "min", "max", "median", "q25", "q75") %in% keys)){
    result <- result |>
      dplyr::mutate("estimate_value" = dplyr::if_else(grepl("<", .data[[keys[1]]]), .data[[keys[1]]], .data$estimate_value))
  }
  return(result)
}
