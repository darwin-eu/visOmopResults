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

#' Creates a tinytable object from a dataframe
#'
#' @param x A dataframe.
#' @param delim Delimiter.
#' @param style  Named list that specifies how to style the different parts of
#' the gt or tinytable table generated. Accepted style entries are: title,
#' subtitle, header, header_name, header_level, column_name, group_label, and
#' body.
#' Alternatively, use "default" to get visOmopResults style, or NULL for
#' gt/tinytable style.
#' Keep in mind that styling code is different for gt and tinytable. To see
#' the "deafult" gt style code use `tableStyle()`.
#' @param na How to display missing values.
#' @param title Title of the table, or NULL for no title.
#' @param subtitle Subtitle of the table, or NULL for no subtitle.
#' @param caption Caption for the table, or NULL for no caption. Text in
#' markdown formatting style (e.g. `*Your caption here*` for caption in
#' italics).
#' @param groupColumn Specifies the columns to use for group labels.
#' By default, the new group name will be a combination of the column names,
#' joined by "_". To assign a custom group name, provide a named list such as:
#' list(`newGroupName` = c("variable_name", "variable_level"))
#' @param groupAsColumn Whether to display the group labels as a column
#' (TRUE) or rows (FALSE).
#' @param groupOrder Order in which to display group labels.
#' @param merge Names of the columns to merge vertically
#' when consecutive row cells have identical values. Alternatively, use
#' "all_columns" to apply this merging to all columns, or use NULL to indicate
#' no merging.
#'
#' @return A tinytable object.
#'
#' @description
#' Creates a tinytable object from a dataframe using a delimiter to span
#' the header, and allows to easily customise table style.
#'
#' @return A tinytable object.
#' @noRd
#'
tinytableInternal <- function(x,
                              delim = "\n",
                              style = "default",
                              na = "-",
                              title = NULL,
                              subtitle = NULL,
                              caption = NULL,
                              groupColumn = NULL,
                              groupAsColumn = FALSE,
                              groupOrder = NULL,
                              merge = NULL) {

  # Package checks
  rlang::check_installed("tinytable")

  # checks
  if (length(title) != 0 | length(subtitle) != 0) {
    cli::cli_inform("`title` and `subtitle` are not supported for tinytable.")
  }

  # na
  if (!is.null(na)) {
    x <- x |>
      dplyr::mutate(
        dplyr::across(dplyr::where(~ is.numeric(.x)), ~ as.character(.x)),
        dplyr::across(colnames(x), ~ dplyr::if_else(is.na(.x), na, .x))
      )
  }

  group_i_index <- NULL # for styling body when no horizontal groupping

  # tinytable
  if (length(groupColumn[[1]]) == 0) {
    # Header id's
    spanCols_ids <- which(grepl("\\[header\\]|\\[header_level\\]|\\[header_name\\]|\\[column_name\\]", colnames(x)))
    spanners <- strsplit(colnames(x)[spanCols_ids[1]], delim) |> unlist() |> rev()
    header_rows <- which(grepl("\\[header\\]", spanners))
    header_name_rows <- which(grepl("\\[header_name\\]", spanners))
    header_level_rows <- which(grepl("\\[header_level\\]", spanners))

    # Eliminate prefixes
    colnames(x) <- gsub("\\[header\\]|\\[header_level\\]|\\[header_name\\]|\\[column_name\\]", "", colnames(x))

    # tinytable
    tiny_x <- x |>
      tinytable::tt(caption = caption) |>
      tinytable::group_tt(j = delim)  |>
      mergeColumnsTinytable(x, delim, merge)
    nameGroup <- NULL

  } else {
    nameGroup <- names(groupColumn)
    x <- x |>
      tidyr::unite(
        !!nameGroup, groupColumn[[1]], sep = "; ", remove = TRUE, na.rm = TRUE
      )
    groupLevel <- unique(x[[nameGroup]])
    if (!is.null(groupOrder)) {
      if (any(!groupLevel %in% groupOrder)) {
        cli::cli_abort(c(
          "x" = "`groupOrder` supplied does not match the group variable created based on `groupName`.",
          "i" = "Group variables to use in `groupOrder` are the following: {groupLevel}"
        ))
      } else {
        groupLevel <- groupOrder
      }
    }
    x <- x |>
      dplyr::mutate(!!nameGroup := factor(.data[[nameGroup]], levels = groupLevel)) |>
      dplyr::arrange_at(nameGroup) |>
      dplyr::relocate(dplyr::all_of(nameGroup))

    if (groupAsColumn) {
      # Header id's
      spanCols_ids <- which(grepl("\\[header\\]|\\[header_level\\]|\\[header_name\\]|\\[column_name\\]", colnames(x)))
      spanners <- strsplit(colnames(x)[spanCols_ids[1]], delim) |> unlist() |> rev()
      header_rows <- which(grepl("\\[header\\]", spanners))
      header_name_rows <- which(grepl("\\[header_name\\]", spanners))
      header_level_rows <- which(grepl("\\[header_level\\]", spanners))

      # Eliminate prefixes
      colnames(x) <- gsub("\\[header\\]|\\[header_level\\]|\\[header_name\\]|\\[column_name\\]", "", colnames(x))

      tiny_x <- x |>
        tinytable::tt(caption = caption) |>
        tinytable::group_tt(j = delim)

      # Merge
      if (any(merge == "all_columns")) {
        tiny_x <- mergeColumnsTinytable(tiny_x, x, delim, merge)
      } else {
        # Merge everything else:
        merge <- unique(c(nameGroup, merge))
        tiny_x <- mergeColumnsTinytable(tiny_x, x, delim, merge)
      }

      # style group label
      tiny_x <- do.call(tinytable::style_tt, c(list(tiny_x, j = 1, i = 1:nrow(x)), style$group_label))

    } else {

      # Prepare groupColumn
      group_i_index <- x[[nameGroup]]
      x[[nameGroup]] <- NULL

      # Header id's
      spanCols_ids <- which(grepl("\\[header\\]|\\[header_level\\]|\\[header_name\\]|\\[column_name\\]", colnames(x)))
      spanners <- strsplit(colnames(x)[spanCols_ids[1]], delim) |> unlist() |> rev()
      header_rows <- which(grepl("\\[header\\]", spanners))
      header_name_rows <- which(grepl("\\[header_name\\]", spanners))
      header_level_rows <- which(grepl("\\[header_level\\]", spanners))

      # Eliminate prefixes
      colnames(x) <- gsub("\\[header\\]|\\[header_level\\]|\\[header_name\\]|\\[column_name\\]", "", colnames(x))

      # Prep merge
      if (any(merge == "all_columns")) {
        merge <- setdiff(colnames(x), nameGroup)
      } else {
        merge <- setdiff(merge, nameGroup)
      }

      # Create tinytable
      tiny_x <- x |>
        tinytable::tt(caption = caption) |>
        tinytable::group_tt(j = delim) |>
        tinytable:: group_tt(i = group_i_index) |>
        mergeColumnsTinytable(x, delim, merge, group_i_index)

      # Style group label
      tiny_x <- do.call(tinytable::style_tt, c(list(tiny_x, i = "groupi"), style$group_label))
    }
  }

  # Style headers
  if (length(header_rows) > 0) {
    tiny_x <- do.call(tinytable::style_tt, c(list(tiny_x, i = 1-header_rows, j = spanCols_ids), style$header))
  }
  if (length(header_level_rows) > 0) {
    tiny_x <- do.call(tinytable::style_tt, c(list(tiny_x, i = 1-header_level_rows, j = spanCols_ids), style$header_level))
  }
  if (length(header_name_rows) > 0) {
    tiny_x <- do.call(tinytable::style_tt, c(list(tiny_x, i = 1-header_name_rows, j = spanCols_ids), style$header_name))
  }

  # style column names and body
  bodyColStart <- 1
  if (groupAsColumn == TRUE & length(nameGroup) != 0)  bodyColStart <- 2
  tiny_x <- do.call(tinytable::style_tt, c(list(tiny_x, i = 0), style$column_name))
  tiny_x <- do.call(tinytable::style_tt, c(list(tiny_x, i = 1:(nrow(tiny_x@data) + length(levels(tiny_x@group_index_i)) + 1), j = bodyColStart:ncol(tiny_x@data)), style$body))
}

mergeColumnsTinytable <- function(tiny_x, x, delim, merge = "all_columns", group_i_index = NULL) {

  colNms <- colnames(x)
  if (length(merge) == 0) return(tiny_x)
  if (merge[1] == "all_columns") merge <- colNms

  # remove numerics
  merge <- merge[!grepl(delim, merge)]
  merge <- merge[merge != "estimate_value"]

  # Sort columns to merge
  ind <- match(merge, colNms)
  names(ind) <- merge
  merge <- names(sort(ind))

  # Case horizontal groupings
  if (length(tiny_x@group_index_i) != 0) {
    x <- x |>
      split(group_i_index)
    x <- purrr::imap(x, \(value, name){
      dplyr::bind_rows(
        dplyr::tibble(!!!purrr::set_names(as.list(rep("grouping_placeholder", length(colnames(value)))), colnames(value))),
        value
      )
    }) |>
      dplyr::bind_rows()
  }

  # merging
  for (k in seq_along(merge)) {

    if (k > 1) {
      prevMerged <- mergeCol
      prevId <- prevMerged == dplyr::lag(prevMerged) & prevId
    } else {
      prevId <- rep(TRUE, nrow(x))
    }

    col <- merge[k]
    mergeCol <- x[[col]]
    id <- c(1, which(!(mergeCol == dplyr::lag(mergeCol) & prevId)))

    # apply merging:
    for (jj in seq_along(id)) {
      if (jj == length(id)) {
        rowspan <- nrow(x) - id[jj] + 1
      } else {
        rowspan <- id[jj+1] - id[jj]
      }
      if (rowspan > 1) {
        tiny_x <- tiny_x |>
          tinytable::style_tt(j = which(colNms %in% col), i = id[jj], rowspan = rowspan)
      }
    }
  }

  return(tiny_x)
}
