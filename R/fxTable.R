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

#' Creates a flextable object from a dataframe
#'
#' @noRd
#'
fxTableInternal <- function(x,
                            delim = "\n",
                            style = "default",
                            na = "\u2013",
                            title = NULL,
                            subtitle = NULL,
                            caption = NULL,
                            groupColumn = NULL,
                            groupAsColumn = FALSE,
                            groupOrder = NULL,
                            merge = NULL) {

  flextable::set_flextable_defaults(table.layout = "autofit")

  # na
  if (!is.null(na)) {
    x <- x |>
      dplyr::mutate(
        dplyr::across(dplyr::where(~ is.numeric(.x)), ~ as.character(.x)),
        dplyr::across(colnames(x), ~ dplyr::if_else(is.na(.x), na, .x))
      )
  }

  # Flextable
  if (length(groupColumn[[1]]) == 0) {
    # Header id's
    spanCols_ids <- which(grepl("\\[header\\]|\\[header_level\\]|\\[header_name\\]|\\[column_name\\]", colnames(x)))
    spanners <- strsplit(colnames(x)[spanCols_ids[1]], delim) |> unlist()
    header_rows <- which(grepl("\\[header\\]", spanners))
    header_name_rows <- which(grepl("\\[header_name\\]", spanners))
    header_level_rows <- which(grepl("\\[header_level\\]", spanners))

    # Eliminate prefixes
    colnames(x) <- gsub("\\[header\\]|\\[header_level\\]|\\[header_name\\]|\\[column_name\\]", "", colnames(x))

    # flextable
    flex_x <- x |>
      flextable::flextable() |>
      flextable::separate_header(split = delim)

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
      spanners <- strsplit(colnames(x)[spanCols_ids[1]], delim) |> unlist()
      header_rows <- which(grepl("\\[header\\]", spanners))
      header_name_rows <- which(grepl("\\[header_name\\]", spanners))
      header_level_rows <- which(grepl("\\[header_level\\]", spanners))

      # Eliminate prefixes
      colnames(x) <- gsub("\\[header\\]|\\[header_level\\]|\\[header_name\\]|\\[column_name\\]", "", colnames(x))

      flex_x <- x |>
        flextable::flextable() |>
        flextable::merge_v(j = nameGroup) |>
        flextable::separate_header(split = delim)
    } else {
      # to get same grouping output as gt
      x <- x |>
        dplyr::select(!dplyr::all_of(nameGroup)) |>
        split(x |> dplyr::pull(nameGroup))
      x <- purrr::imap(x, \(value, name){
        dplyr::bind_rows(
          dplyr::tibble(!!colnames(value)[1] := name),
          value
        )
      }) |>
        dplyr::bind_rows()
      # Header id's
      spanCols_ids <- which(grepl("\\[header\\]|\\[header_level\\]|\\[header_name\\]|\\[column_name\\]", colnames(x)))
      spanners <- strsplit(colnames(x)[spanCols_ids[1]], delim) |> unlist()
      header_rows <- which(grepl("\\[header\\]", spanners))
      header_name_rows <- which(grepl("\\[header_name\\]", spanners))
      header_level_rows <- which(grepl("\\[header_level\\]", spanners))
      # Eliminate prefixes
      colnames(x) <- gsub("\\[header\\]|\\[header_level\\]|\\[header_name\\]|\\[column_name\\]", "", colnames(x))
      flex_x <- x |>
        flextable::flextable() |>
        flextable::separate_header(split = delim)
      groupIndices <- getGroupIndices(flex_x$body$dataset)
      flex_x <- flex_x |> flextable::merge_h_range(i = groupIndices, j1 = 1, j2 = ncol(x), part = "body")
    }
  }

  # Headers
  if (length(header_rows) > 0 & "header" %in% names(style)) {
    flex_x <- flex_x |>
      flextable::style(
        part = "header", i = header_rows, j = spanCols_ids, pr_t = style$header$text,
        pr_c = style$header$cell, pr_p = style$header$paragraph
      )
  }
  if (length(header_name_rows) > 0 & "header_name" %in% names(style)) {
    flex_x <- flex_x |>
      flextable::style(
        part = "header", i = header_name_rows, j = spanCols_ids, pr_t = style$header_name$text,
        pr_c = style$header_name$cell, pr_p = style$header_name$paragraph
      )
  }
  if (length(header_level_rows) > 0 & "header_level" %in% names(style)) {
    flex_x <- flex_x |>
      flextable::style(
        part = "header", i = header_level_rows, j = spanCols_ids, pr_t = style$header_level$text,
        pr_c = style$header_level$cell, pr_p = style$header_level$paragraph
      )
  }
  if ("column_name" %in% names(style)) {
    flex_x <- flex_x |>
      flextable::style(
        part = "header", j = which(!1:ncol(x) %in% spanCols_ids),
        pr_t = style$column_name$text, pr_c = style$column_name$cell, pr_p = style$column_name$paragraph
      )
  }

  # body
  flex_x <- flex_x |>
    flextable::style(
      part = "body", pr_t = style$body$text,
      pr_p = style$body$paragraph, pr_c = style$body$cell
    )

  # Merge columns
  if (!is.null(merge)) { # style while merging rows
    flex_x <- fxMergeRows(flex_x, merge, nameGroup)
  }

  # Other options:
  # caption
  if (!is.null(caption)) {
    flex_x <- flex_x |>
      flextable::set_caption(caption = caption)
  }
  # title + subtitle
  if (!is.null(title) & !is.null(subtitle)) {
    flex_x <- flex_x |>
      flextable::add_header_lines(values = subtitle) |>
      flextable::add_header_lines(values = title) |>
      flextable::style(
        part = "header", i = 1, pr_t = style$title$text,
        pr_p = style$title$paragraph, pr_c = style$title$cell
      ) |>
      flextable::style(
        part = "header", i = 2, pr_t = style$subtitle$text,
        pr_p = style$subtitle$paragraph, pr_c = style$subtitle$cell
      )
  }
  # title
  if (!is.null(title) & is.null(subtitle)) {
    flex_x <- flex_x |>
      flextable::add_header_lines(values = title) |>
      flextable::style(
        part = "header", i = 1, pr_t = style$title$text,
        pr_p = style$title$paragraph, pr_c = style$title$cell
      )
  }
  # group label
  if (length(groupColumn[[1]]) != 0) {
    if (!groupAsColumn) {
      nonNaIndices <- getGroupIndices(flex_x$body$dataset)
      flex_x <- flex_x |>
        flextable::style(
          part = "body",
          i = nonNaIndices,
          pr_t = style$group_label$text,
          pr_p = style$group_label$paragraph,
          pr_c = style$group_label$cell
        ) |>
        flextable::border( # correct group level right border
          i = nonNaIndices,
          j = 1:(length(flex_x$body$dataset)-1),
          border.right = officer::fp_border(color = "transparent"),
          part = "body"
        )
    } else {
      flex_x <- flex_x |>
        flextable::style(
          part = "body",
          j = which(colnames(flex_x$body$dataset) %in% nameGroup),
          pr_t = style$group_label$text,
          pr_p = style$group_label$paragraph,
          pr_c = style$group_label$cell
        )
    }
  }

  # Standardise table
  flex_x <- flex_x |>
    flextable::padding(padding = 3, part = "all") |>
    flextable::hline_top(border = style$body$cell$border.bottom, part = "all") |>
    flextable::vline_left(border = style$body$cell$border.bottom, part = "all") |>
    flextable::vline_right(border = style$body$cell$border.bottom, part = "all") |>
    flextable::set_table_properties(layout = "autofit", width = 1)

  return(flex_x)
}

getNonNaIndices <- function(x, nameGroup) {
  which(!is.na(x[[nameGroup]]))
}
getGroupIndices <- function(tab) {
  tab <- dplyr::as_tibble(tab)
  which(rowSums(is.na(tab[, -1])) == ncol(tab) - 1)
}

fxMergeRows <- function(fx_x, merge, groupColumn) {
  colNms <- colnames(fx_x$body$dataset)
  if (merge[1] == "all_columns") {
    if (length(groupColumn) == 0) {
      merge <- colNms
    } else {
      merge <- colNms[!colNms %in% groupColumn]
    }
  }

  # Sort columns to merge
  ind <- match(merge, colNms)
  names(ind) <- merge
  merge <- names(sort(ind))

  # Fill group column values (carry forward NAs) if groupColumn exists in data
  groupCol <- NULL
  if (length(groupColumn) > 0 && groupColumn %in% colNms) {
    groupCol <- lapply(groupColumn, function(col) {
      vals <- as.character(fx_x$body$dataset[[col]])
      for (k in seq(2, length(vals))) {
        if (is.na(vals[k])) vals[k] <- vals[k - 1]
      }
      vals
    })
    groupCol <- as.data.frame(do.call(cbind, groupCol),
                              stringsAsFactors = FALSE)
    colnames(groupCol) <- groupColumn
  }

  n_rows <- nrow(fx_x$body$dataset)

  # Loop along cols to merge
  for (k in seq_along(merge)) {
    col <- merge[k]
    col_idx <- ind[k]

    mergeCol <- as.character(fx_x$body$dataset[[col]])
    mergeCol[is.na(mergeCol)] <- "__NA__"

    merge_with_prev <- rep(FALSE, n_rows)

    for (i in seq(2, n_rows)) {
      # Condition 1: consequtive rows with same value
      same_val <- (mergeCol[i] == mergeCol[i - 1])

      # Condition 2: previous column was also merged at this row boundary
      if (k > 1) {
        prev_merged <- prevMergeWithPrev  # logical from previous iteration
        # row i merges with i-1 in prev col if prev_merged[i] is TRUE
        prev_col_merged <- prev_merged[i]
      } else {
        prev_col_merged <- TRUE  # no constraint from a previous column
      }

      # Condition 3: group column matches (if applicable)
      if (!is.null(groupCol)) {
        same_group <- all(groupCol[i, ] == groupCol[i - 1, ])
      } else {
        same_group <- TRUE
      }

      merge_with_prev[i] <- same_val && prev_col_merged && same_group
    }

    # Save for next iteration
    prevMergeWithPrev <- merge_with_prev

    # Merge
    i <- 2L
    while (i <= n_rows) {
      if (merge_with_prev[i]) {
        # Start of a merge span: find how far it extends
        span_start <- i - 1L
        span_end <- i
        while (span_end + 1L <= n_rows && merge_with_prev[span_end + 1L]) {
          span_end <- span_end + 1L
        }
        fx_x <- fx_x |>
          flextable::merge_at(
            i = span_start:span_end,
            j = col_idx,
            part = "body"
          )
        i <- span_end + 1L
      } else {
        i <- i + 1L
      }
    }
  }
  return(fx_x)
}
