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
#' @param x A dataframe.
#' @param delim Delimiter.
#' @param style  Named list that specifies how to style the different parts of
#' the gt or flextable table generated. Accepted style entries are: title,
#' subtitle, header, header_name, header_level, column_name, group_label, and
#' body.
#' Alternatively, use "default" to get visOmopResults style, or NULL for
#' gt/flextable style.
#' Keep in mind that styling code is different for gt and flextable. To see
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
#' @return A flextable object.
#'
#' @description
#' Creates a flextable object from a dataframe using a delimiter to span
#' the header, and allows to easily customise table style.
#'
#' @return A flextable object.
#' @noRd
#'
fxTableInternal <- function(x,
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
  rlang::check_installed("flextable")
  rlang::check_installed("officer")

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

  # Basic default + merge columns
  if (!is.null(merge)) { # style while merging rows
    flex_x <- fxMergeRows(flex_x, merge, nameGroup)
  } else {
    if (!length(groupColumn) == 0) {
      # style group different
      indRowGroup <- getGroupIndices(flex_x$body$dataset)
      flex_x <- flex_x |>
        flextable::border(
          border = officer::fp_border(color = "gray"),
          part = "body"
        )
      # flextable::border(
      #   j = 1,
      #   border.left = officer::fp_border(color = "gray"),
      #   part = "body"
      # ) |>
      # flextable::border( # correct group level bottom
      #   i = nrow(flex_x$body$dataset),
      #   border.bottom = officer::fp_border(color = "gray"),
      #   part = "body"
      # )
      if (!groupAsColumn) {
        flex_x <- flex_x |>
          flextable::border( # correct group level right border
            i = getGroupIndices(flex_x$body$dataset),
            j = 1:(length(flex_x$body$dataset)-1),
            border.right = officer::fp_border(color = "transparent"),
            part = "body"
          )
      }
    } else { # style body equally
      flex_x <- flex_x |>
        flextable::border(
          border = officer::fp_border(color = "gray"),
          part = "body"
        )
    }
  }
  flex_x <- flex_x |>
    flextable::border(
      border = officer::fp_border(color = "gray", width = 1.2),
      part = "header",
      i = 1:nrow(flex_x$header$dataset)
    ) |>
    flextable::align(part = "header", align = "center") |>
    flextable::valign(part = "header", valign = "center") |>
    flextable::align(j = spanCols_ids, part = "body", align = "right") |>
    flextable::align(j = which(!1:ncol(x) %in% spanCols_ids), part = "body", align = "left")

  # Other options:
  # caption
  if (!is.null(caption)) {
    flex_x <- flex_x |>
      flextable::set_caption(caption = caption)
  }
  # title + subtitle
  if (!is.null(title) & !is.null(subtitle)) {
    if (!"title" %in% names(style)) {
      style$title <- list(
        "text" = officer::fp_text(bold = TRUE, font.size = 13),
        "paragraph" = officer::fp_par(text.align = "center")
      )
    }
    if (!"subtitle" %in% names(style)) {
      style$subtitle <- list(
        "text" = officer::fp_text(bold = TRUE, font.size = 11),
        "paragraph" = officer::fp_par(text.align = "center")
      )
    }
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
    if (!"title" %in% names(style)) {
      style$title <- list(
        "text" = officer::fp_text(bold = TRUE, font.size = 13),
        "paragraph" = officer::fp_par(text.align = "center")
      )
    }
    flex_x <- flex_x |>
      flextable::add_header_lines(values = title) |>
      flextable::style(
        part = "header", i = 1, pr_t = style$title$text,
        pr_p = style$title$paragraph, pr_c = style$title$cell
      )
  }
  # body
  flex_x <- flex_x |>
    flextable::style(
      part = "body", pr_t = style$body$text,
      pr_p = style$body$paragraph, pr_c = style$body$cell
    )
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
          part = "body", j = which(colnames(flex_x$body$dataset) %in% nameGroup),
          pr_t = style$group_label$text, pr_p = style$group_label$paragraph, pr_c = style$group_label$cell
        )
    }
  }

  flex_x <- flex_x |>
    flextable::border_outer(
      part = "all",
      border = officer::fp_border(color = flex_x$body$styles$cells$border.color.top$data[1,1], width = 2)
    )

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

  # Fill group column if necessary
  indColGroup <- NULL
  indRowGroup <- NULL

  if (!length(groupColumn) == 0) {
    if (groupColumn %in% colNms) {
      groupCol <- fx_x$body$dataset |>
        dplyr::select(dplyr::all_of(groupColumn)) |>
        dplyr::mutate(dplyr::across(dplyr::everything(), as.character))

      groupColsMatrix <- as.matrix(groupCol)

      indRowGroup <- which(rowSums(!is.na(groupColsMatrix)) > 0)
      filledGroupColsList <- lapply(groupColumn, function(col) {
        groupCol <- as.character(fx_x$body$dataset[[col]])
        for (k in 2:length(groupCol)) {
          if (is.na(groupCol[k])) {
            groupCol[k] <- groupCol[k - 1]
          }
        }
        return(groupCol)
      })
      groupColsMatrix <- do.call(cbind, filledGroupColsList)

      groupCol <- as.data.frame(groupColsMatrix, stringsAsFactors = FALSE)

      indColGroup <- which(colnames(fx_x$body$dataset) %in% groupColumn)
    }
  }


  for (k in seq_along(merge)) {

    if (k > 1) {
      prevMerged <- mergeCol
      prevId <- prevMerged == dplyr::lag(prevMerged) & prevId
    } else {
      prevId <- rep(TRUE, nrow(fx_x$body$dataset))
    }

    col <- merge[k]
    mergeCol <- fx_x$body$dataset[[col]]
    mergeCol[is.na(mergeCol)] <- "this is NA"

    if (length(groupColumn) != 0) {
      if (groupColumn %in% colNms) {
        id <- which(groupCol == dplyr::lag(groupCol) & mergeCol == dplyr::lag(mergeCol) & prevId)
      } else {
        id <- which(mergeCol == dplyr::lag(mergeCol) & prevId)
      }
    } else {
      id <- which(mergeCol == dplyr::lag(mergeCol) & prevId)
    }

    # Apply merging and borders
    if (length(id) > 0) {
      fx_x <- fx_x |>
        flextable::compose(
          i = id, j = ind[k],
          flextable::as_paragraph(flextable::as_chunk(""))
        )
    }
    fx_x <- fx_x |>
      flextable::border(
        i = which(!1:nrow(fx_x$body$dataset) %in% id),
        j = ind[k],
        border.top = officer::fp_border(color = "gray"),
        part = "body"
      )
  }

  # Style the rest of the table
  fx_x <- fx_x |>
    flextable::border(
      j = which(!1:ncol(fx_x$body$dataset) %in% c(ind, indColGroup)),
      border.top = officer::fp_border(color = "gray"),
      part = "body"
    ) |>
    flextable::border(
      j = 1:ncol(fx_x$body$dataset),
      border.right = officer::fp_border(color = "gray"),
      part = "body"
    ) |>
    flextable::border(
      j = 1,
      border.left = officer::fp_border(color = "gray"),
      part = "body"
    ) |>
    flextable::border( # Correct bottom border
      i = nrow(fx_x$body$dataset),
      border.bottom = officer::fp_border(color = "gray"),
      part = "body"
    )

  if (!length(groupColumn) == 0) {
    if (groupColumn %in% colNms) {
      fx_x <- fx_x |>
        flextable::border(
          j = indColGroup,
          i = indRowGroup,
          border = officer::fp_border(color = "gray"),
          part = "body"
        )
    }
  }

  if (!length(groupColumn) == 0) {
    if (!groupColumn %in% colNms) {
      fx_x <- fx_x |>
        flextable::border(
          j = 1,
          i = getGroupIndices(fx_x$body$dataset),
          border = officer::fp_border(color = "gray"),
          part = "body"
        ) |>
        flextable::border(
          i = getGroupIndices(fx_x$body$dataset),
          j = 1:(length(fx_x$body$dataset)-1),
          border.right = officer::fp_border(color = "transparent"),
          part = "body"
        )
    }
  }

  return(fx_x)
}
