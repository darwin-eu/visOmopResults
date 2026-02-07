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

#' Creates a gt object from a dataframe
#'
#' @noRd
#'
gtTableInternal <- function(x,
                            delim = "\n",
                            style = "default",
                            na = "\u2013",
                            title = NULL,
                            subtitle = NULL,
                            caption = NULL,
                            groupColumn = NULL,
                            groupAsColumn = FALSE,
                            groupOrder = NULL,
                            merge = NULL
) {

  # na
  if (!is.null(na)){
    x <- x |>
      dplyr::mutate(
        dplyr::across(dplyr::where(~is.numeric(.x)), ~as.character(.x)),
        dplyr::across(colnames(x), ~ dplyr::if_else(is.na(.x), na, .x))
      )
  }

  # Spanners
  if (length(groupColumn[[1]]) != 0) {
    nameGroup <- names(groupColumn)
    x <- x |>
      tidyr::unite(
        !!nameGroup, groupColumn[[1]], sep = "; ", remove = TRUE, na.rm = TRUE
      )
    groupLevel <- unique(x[[nameGroup]])
    if (!is.null(groupOrder)) {
      if (any(!groupLevel %in% groupOrder)) {
        cli::cli_abort(c(
          "x" = "`groupOrder` supplied does not macth the group variable created based on `groupName`.",
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

    gtResult <- x |>
      gt::gt(groupname_col = nameGroup, row_group_as_column = groupAsColumn) |>
      gt::tab_spanner_delim(delim = delim) |>
      gt::row_group_order(groups = groupLevel)

  } else {
    gtResult <- x |> gt::gt() |> gt::tab_spanner_delim(delim = delim)
  }

  # Header style
  spanner_ids <- gtResult$`_spanners`$spanner_id
  style_ids <- lapply(strsplit(spanner_ids, delim), function(vect){vect[[1]]}) |> unlist()

  header_id <- grepl("\\[header\\]", style_ids)
  header_name_id <- grepl("\\[header_name\\]", style_ids)
  header_level_id <- grepl("\\[header_level\\]", style_ids)

  if (length(c(header_id, header_name_id, header_level_id)) == 0) {
    columnHeader <- TRUE
    colum_header_id <-  which(grepl("\\[header\\]|\\[header_level\\]|\\[header_name\\]", colnames(x)))
  } else {
    columnHeader <- FALSE
    colum_header_id <-  numeric()
  }

  # column names in spanner
  header_level <- all(grepl("header_level", lapply(strsplit(colnames(x)[grepl("header", colnames(x))], delim), function(x) {x[length(x)]}) |> unlist()))

  if (sum(header_id) > 0 & "header" %in% names(style)) {
    gtResult <- gtResult |>
      gt::tab_style(
        style = style$header,
        locations = gt::cells_column_spanners(spanners = spanner_ids[header_id])
      )
    if (!header_level) {
      gtResult <- gtResult |>
        gt::tab_style(
          style = style$header,
          locations = gt::cells_column_labels(columns = which(grepl("\\[header\\]", colnames(x))))
        )
    }
  }
  if (sum(header_name_id) > 0 & "header_name" %in% names(style)) {
    gtResult <- gtResult |>
      gt::tab_style(
        style = style$header_name,
        locations = gt::cells_column_spanners(spanners = spanner_ids[header_name_id])
      )
  }
  if ("header_level" %in% names(style)) {
    if (sum(header_level_id) > 0) {
      gtResult <- gtResult |>
        gt::tab_style(
          style = style$header_level,
          locations = gt::cells_column_spanners(spanners = spanner_ids[header_level_id])
        )
    }
    if (header_level) {
      gtResult <- gtResult |>
        gt::tab_style(
          style = style$header_level,
          locations = gt::cells_column_labels(columns = which(grepl("\\[header_level\\]", colnames(x))))
        )
    }
  }
  if ("column_name" %in% names(style)) {
    col_name_ids <- which(!grepl("\\[header\\]|\\[header_level\\]|\\[header_name\\]", colnames(x)))
    gtResult <- gtResult |>
      gt::tab_style(
        style = style$column_name,
        locations = gt::cells_column_labels(columns = col_name_ids)
      )
    if (columnHeader & length(colum_header_id) > 0) {
      gtResult <- gtResult |>
        gt::tab_style(
          style = style$column_name,
          locations = gt::cells_column_labels(columns = colum_header_id)
        )
    }
  }

  # Eliminate prefixes
  gtResult$`_spanners`$spanner_label <- lapply(gtResult$`_spanners`$spanner_label,
                                               function(label){
                                                 gsub("\\[header\\]|\\[header_level\\]|\\[header_name\\]|\\[column_name\\]", "", label)
                                               })
  gtResult <- gtResult |> gt::cols_label_with(columns = tidyr::contains("header"),
                                              fn = ~ gsub("\\[header\\]|\\[header_level\\]", "", .))

  # Our default:
  gtResult <- gtResult |>
    gt::tab_style(
      style = gt::cell_text(align = "right"),
      locations = gt::cells_body(columns = which(grepl("\\[header\\]|\\[header_level\\]|\\[header_name\\]|\\[column_name\\]", colnames(x))))
    ) |>
    gt::tab_style(
      style = gt::cell_text(align = "left"),
      locations = gt::cells_body(columns = which(!grepl("\\[header\\]|\\[header_level\\]|\\[header_name\\]|\\[column_name\\]", colnames(x))))
    ) |>
    gt::tab_style(
      style = list(gt::cell_borders(color = "#D3D3D3")),
      locations = list(gt::cells_body(columns = 2:(ncol(x)-1)))
    )

  # Other options:
  ## na
  # if (!is.null(na)){
  #   # gtResult <- gtResult |> gt::sub_missing(missing_text = na)
  # }
  ## caption
  if(!is.null(caption)){
    gtResult <- gtResult |>
      gt::tab_caption(
        caption = gt::md(caption)
      )
  }
  ## title + subtitle
  if(!is.null(title) & !is.null(subtitle)){
    gtResult <- gtResult |>
      gt::tab_header(
        title = title,
        subtitle = subtitle
      )
    if ("title" %in% names(style)) {
      gtResult <- gtResult |>
        gt::tab_style(
          style = style$title,
          locations = gt::cells_title(groups = "title")
        )
    }
    if ("subtitle" %in% names(style)) {
      gtResult <- gtResult |>
        gt::tab_style(
          style = style$subtitle,
          locations = gt::cells_title(groups = "subtitle")
        )
    }
  }
  ## title
  if(!is.null(title)  & is.null(subtitle)){
    gtResult <- gtResult |>
      gt::tab_header(
        title = title
      )
    if ("title" %in% names(style)) {
      gtResult <- gtResult |>
        gt::tab_style(
          style = style$title,
          locations = gt::cells_title(groups = "title")
        )
    }
  }

  ## body
  if ("body" %in% names(style)) {
    gtResult <- gtResult |>
      gt::tab_style(
        style = style$body,
        locations = gt::cells_body()
      )
  }

  # Merge rows
  if (!is.null(merge)) {
    gtResult <- gtMergeRows(gtResult, merge, names(groupColumn), groupOrder)
  }

  ## group_label
  if ("group_label" %in% names(style)) {
    gtResult <- gtResult |>
      gt::tab_style(
        style = style$group_label,
        locations = gt::cells_row_groups()
      )
  }

  # match table style with style:
  gtResult <- gtResult |>
    gt::opt_table_outline(style = "solid", color = gtResult$`_styles`$styles[[1]]$cell_fill$color) |>
    gt::tab_options(table_body.border.top.color = gtResult$`_styles`$styles[[1]]$cell_fill$color, table_body.border.top.width = 3)

  return(gtResult)
}

gtMergeRows <- function(gt_x, merge, groupColumn, groupOrder) {

  colNms <- colnames(gt_x$`_data`)
  colsToExclude <- c("group_label", paste(groupColumn, collapse = "_"))

  if (merge[1] == "all_columns") {
    if (length(groupColumn) == 0) {
      merge <- colNms[!colNms %in% colsToExclude]
    } else {
      merge <- colNms[!colNms %in% c(groupColumn, colsToExclude)]
    }
  }

  # sort
  ind <- match(merge, colNms)
  names(ind) <- merge
  merge <- names(sort(ind))

  for (k in seq_along(merge)) {

    if (k > 1) {
      prevMerged <- mergeCol
      prevId <- prevMerged == dplyr::lag(prevMerged) & prevId
    } else {
      prevId <- rep(TRUE, nrow(gt_x$`_data`))
    }

    col <- merge[k]
    mergeCol <- as.character(gt_x$`_data`[[col]])
    mergeCol[is.na(mergeCol)] <- "-"

    if (length(groupColumn) == 0) {
      id <- which(mergeCol == dplyr::lag(mergeCol) & prevId)
    } else {
      groupCol <- apply(gt_x$`_data`[, groupColumn, drop = FALSE], 1, paste, collapse = "_")
      lagGroupCol <- dplyr::lag(groupCol)
      id <- which(groupCol == lagGroupCol & mergeCol == dplyr::lag(mergeCol) & prevId)
    }

    gt_x$`_data`[[col]][id] <- ""
    gt_x <- gt_x |>
      gt::tab_style(
        style = list(gt::cell_borders(style = "hidden", sides = "top")),
        locations = list(gt::cells_body(columns = col, rows = id))
      )
  }
  return(gt_x)
}
