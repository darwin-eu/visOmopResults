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

#' Creates a flextable or gt object from a dataframe
#'
#' @param x A dataframe.
#' @param type The desired format of the output table. See `tableType()` for
#' allowed options. If "tibble", no formatting will be applied.
#' @param delim Delimiter.
#' @param style Named list that specifies how to style the different parts of
#' the gt or flextable table generated. Accepted style entries are: title,
#' subtitle, header, header_name, header_level, column_name, group_label, and
#' body.
#' Alternatively, use "default" to get visOmopResults style, or NULL for
#' gt/flextable style.
#' Keep in mind that styling code is different for gt and flextable.
#' Additionally, "datatable" and "reactable" have their own style functions.
#' To see style options for each table type use `tableStyle()`.
#' @param na How to display missing values. Not used for "datatable" and
#' "reactable".
#' @param title Title of the table, or NULL for no title. Not used for
#' "datatable".
#' @param subtitle Subtitle of the table, or NULL for no subtitle. Not used for
#' "datatable" and "reactable".
#' @param caption Caption for the table, or NULL for no caption. Text in
#' markdown formatting style (e.g. `*Your caption here*` for caption in
#' italics). Not used for "reactable".
#' @param groupColumn Specifies the columns to use for group labels.
#' By default, the new group name will be a combination of the column names,
#' joined by "_". To assign a custom group name, provide a named list such as:
#' list(`newGroupName` = c("variable_name", "variable_level"))
#' @param groupAsColumn Whether to display the group labels as a column
#' (TRUE) or rows (FALSE). Not used for "datatable" and "reactable"
#' @param groupOrder Order in which to display group labels. Not used for
#' "datatable" and "reactable".
#' @param merge Names of the columns to merge vertically when consecutive row
#' cells have identical values. Alternatively, use "all_columns" to apply this
#' merging to all columns, or use NULL to indicate no merging. Not used for
#' "datatable" and "reactable".
#'
#' @return A flextable object.
#'
#' @description
#' Creates a flextable object from a dataframe using a delimiter to span
#' the header, and allows to easily customise table style.
#'
#' @examples
#' # Example 1
#' mockSummarisedResult() |>
#'   formatEstimateValue(decimals = c(integer = 0, numeric = 1)) |>
#'   formatHeader(
#'     header = c("Study strata", "strata_name", "strata_level"),
#'     includeHeaderName = FALSE
#'   ) |>
#'   formatTable(
#'     type = "flextable",
#'     style = "default",
#'     na = "--",
#'     title = "fxTable example",
#'     subtitle = NULL,
#'     caption = NULL,
#'     groupColumn = "group_level",
#'     groupAsColumn = TRUE,
#'     groupOrder = c("cohort1", "cohort2"),
#'     merge = "all_columns"
#'   )
#'
#' # Example 2
#' mockSummarisedResult() |>
#'   formatEstimateValue(decimals = c(integer = 0, numeric = 1)) |>
#'   formatHeader(header = c("Study strata", "strata_name", "strata_level"),
#'               includeHeaderName = FALSE) |>
#'   formatTable(
#'     type = "gt",
#'     style = list("header" = list(
#'       gt::cell_fill(color = "#d9d9d9"),
#'       gt::cell_text(weight = "bold")),
#'       "header_level" = list(gt::cell_fill(color = "#e1e1e1"),
#'                             gt::cell_text(weight = "bold")),
#'       "column_name" = list(gt::cell_text(weight = "bold")),
#'       "title" = list(gt::cell_text(weight = "bold"),
#'                      gt::cell_fill(color = "#c8c8c8")),
#'       "group_label" = gt::cell_fill(color = "#e1e1e1")),
#'     na = "--",
#'     title = "gtTable example",
#'     subtitle = NULL,
#'     caption = NULL,
#'     groupColumn = "group_level",
#'     groupAsColumn = FALSE,
#'     groupOrder = c("cohort1", "cohort2"),
#'     merge = "all_columns"
#'   )
#'
#' @return A flextable or gt object.
#'
#' @export
#'
formatTable <- function(x,
                        type = "gt",
                        delim = "\n",
                        style = "default",
                        na = "-",
                        title = NULL,
                        subtitle = NULL,
                        caption = NULL,
                        groupColumn = NULL,
                        groupAsColumn = FALSE,
                        groupOrder = NULL,
                        merge = NULL
) {
  # Input checks
  omopgenerics::assertChoice(type, choices = tableType(), length = 1)
  omopgenerics::assertTable(x)
  omopgenerics::assertCharacter(na, length = 1, null = TRUE)
  omopgenerics::assertCharacter(title, length = 1, null = TRUE)
  omopgenerics::assertCharacter(subtitle, length = 1, null = TRUE)
  omopgenerics::assertCharacter(caption, length = 1, null= TRUE)
  omopgenerics::assertLogical(groupAsColumn, length = 1)
  omopgenerics::assertCharacter(groupOrder, null = TRUE)
  delim <- validateDelim(delim)
  groupColumn <- validateGroupColumn(groupColumn, colnames(x))
  merge <- validateMerge(x, merge, groupColumn[[1]])
  style <- validateStyle(style, type)
  if (is.null(title) & !is.null(subtitle)) {
    cli::cli_abort("There must be a title for a subtitle.")
  }
  if (dplyr::is.grouped_df(x)) {
    x <- x |> dplyr::ungroup()
    cli::cli_inform("`x` will be ungrouped.")
  }

  # format
  if (type == "gt") {
    x <- x |>
      gtTableInternal(
        delim = delim,
        style = style,
        na = na,
        title = title,
        subtitle = subtitle,
        caption = caption,
        groupColumn = groupColumn,
        groupAsColumn = groupAsColumn,
        groupOrder = groupOrder,
        merge = merge
      )
  } else if (type == "flextable") {
    x <- x |>
      fxTableInternal(
        delim = delim,
        style = style,
        na = na,
        title = title,
        subtitle = subtitle,
        caption = caption,
        groupColumn = groupColumn,
        groupAsColumn = groupAsColumn,
        groupOrder = groupOrder,
        merge = merge
      )
  } else if (type == "datatable") {
    x <- x |>
      datatableInternal(
        delim = delim,
        style = style,
        caption = caption,
        groupColumn = groupColumn
      )
  } else if (type == "reactable") {
    x <- x |>
      reactableInternal(
        delim = delim,
        style = style,
        groupColumn = groupColumn
      )
  }
  return(x)
}
