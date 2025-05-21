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

#' Additional table formatting options for `visOmopTable()` and `visTable()`
#'
#' @description
#' This function provides a list of allowed inputs for the `.option` argument in
#' `visOmopTable()` and `visTable()`, and their corresponding default values.
#'
#' @return A named list of default options for table customisation.
#'
#' @export
#'
#' @examples
#' tableOptions()
#'
tableOptions <- function() {
  return(defaultTableOptions(NULL))
}

#' Supported predefined styles for formatted tables
#'
#' @param type Character string specifying the formatted table class.
#' See `tableType()` for supported classes. Default is "gt".
#' @param style Supported predefined styles. Currently: "default" and "darwin".
#'
#' @return A code expression for the selected style and table type.
#'
#' @export
#'
#' @examples
#' tableStyle("gt")
#' tableStyle("flextable")
#'
tableStyle <- function(type = "gt", style = "default") {
  omopgenerics::assertChoice(type, c("gt", "flextable", "datatable", "reactable"), length = 1)
  omopgenerics::assertChoice(style, c("default", "darwin"), length = 1)
  if (style == "darwin" & type %in% c("datatable", "reactable")) {
    cli::cli_abort("`darwin` style is only available for `gt` and `flextable`.")
  }
  if (type == "gt") {
    if (style == "default") {
      list(
        "header" = list(gt::cell_fill(color = "#c8c8c8"),
                        gt::cell_text(weight = "bold", align = "center")),
        "header_name" = list(gt::cell_fill(color = "#d9d9d9"),
                             gt::cell_text(weight = "bold", align = "center")),
        "header_level" = list(gt::cell_fill(color = "#e1e1e1"),
                              gt::cell_text(weight = "bold", align = "center")),
        "column_name" = list(gt::cell_text(weight = "bold", align = "center")),
        "group_label" = list(gt::cell_fill(color = "#e9e9e9"),
                             gt::cell_text(weight = "bold")),
        "title" = list(gt::cell_text(weight = "bold", size = 15, align = "center")),
        "subtitle" = list(gt::cell_text(weight = "bold", size = 12, align = "center")),
        "body" = list()
      ) |>
        rlang::expr()
    } else if (style == "darwin") {
      list(
        "header" = list(
          gt::cell_fill(color = "#003399"),
          gt::cell_text(weight = "bold", color = "white", align = "center")
        ),
        "header_name" = list(
          gt::cell_fill(color = "#003399"),
          gt::cell_text(weight = "bold", color = "white", align = "center")
        ),
        "header_level" = list(
          gt::cell_fill(color = "#003399"),
          gt::cell_text(color = "white", weight = "bold", align = "center")
        ),
        "column_name" = list(
          gt::cell_fill(color = "#003399"),
          gt::cell_text(weight = "bold", color = "white", align = "center")
        ),
        "group_label" = list(
          gt::cell_fill(color = "#4a64bd"),
          gt::cell_borders(color = "#003399"),
          gt::cell_text(weight = "bold", color = "white")
        ),
        "title" = list(gt::cell_text(weight = "bold", size = 15, align = "center")),
        "subtitle" = list(
          gt::cell_text(weight = "bold", size = 12, align = "center")
        ),
        body = list(gt::cell_borders(color = "#003399"))
      ) |>
        rlang::expr()
    }
  } else if (type == "flextable") {
    if (style == "default") {
      list(
        "header" = list(
          "cell" = officer::fp_cell(background.color = "#c8c8c8"),
          "text" = officer::fp_text(bold = TRUE)
        ),
        "header_name" = list(
          "cell" = officer::fp_cell(background.color = "#d9d9d9"),
          "text" = officer::fp_text(bold = TRUE)
        ),
        "header_level" = list(
          "cell" = officer::fp_cell(background.color = "#e1e1e1"),
          "text" = officer::fp_text(bold = TRUE)
        ),
        "column_name" = list(
          "text" = officer::fp_text(bold = TRUE)
        ),
        "group_label" = list(
          "cell" = officer::fp_cell(
            background.color = "#e9e9e9",
            border = officer::fp_border(color = "gray")
          ),
          "text" = officer::fp_text(bold = TRUE)
        ),
        "title" = list(
          "text" = officer::fp_text(bold = TRUE, font.size = 15)
        ),
        "subtitle" = list(
          "text" = officer::fp_text(bold = TRUE, font.size = 12)
        ),
        "body" = list()
      ) |>
        rlang::expr()

    } else if (style == "darwin") {
      list(
        "header" = list(
          "cell" = officer::fp_cell(
            background.color = "#003399",
            border = officer::fp_border(color = "white")
          ),
          "text" = officer::fp_text(bold = TRUE, color = "white")
        ),
        "header_name" = list(
          "cell" = officer::fp_cell(
            background.color = "#003399",
            border = officer::fp_border(color = "white")
          ),
          "text" = officer::fp_text(bold = TRUE, color = "white")
        ),
        "header_level" = list(
          "cell" = officer::fp_cell(
            background.color = "#003399",
            border = officer::fp_border(color = "white"),
          ),
          "text" = officer::fp_text(bold = TRUE, color = "white")
        ),
        "column_name" = list(
          "cell" = officer::fp_cell(
            background.color = "#003399",
            border = officer::fp_border(color = "white"),
          ),
          "text" = officer::fp_text(bold = TRUE, color = "white")
        ),
        "group_label" = list(
          "cell" = officer::fp_cell(
            background.color = "#4a64bd",
            border = officer::fp_border(color = "#003399")
          ),
          "text" = officer::fp_text(bold = TRUE, color = "white")
        ),
        "title" = list(
          "text" = officer::fp_text(bold = TRUE, font.size = 15)
        ),
        "subtitle" = list(
          "text" = officer::fp_text(bold = TRUE, font.size = 12)
        ),
        "body" = list(
          "cell" = officer::fp_cell(border = officer::fp_border(color = "#003399"))
        )
      ) |>
        rlang::expr()
    }

  } else if (type == "datatable") {
    list(
      "caption" = 'caption-side: bottom; text-align: center;',
      "scrollX" = TRUE,
      "scrollY" = 400,
      "scroller" = TRUE,
      "deferRender" = TRUE,
      "scrollCollapse" = TRUE,
      "fixedColumns" = list(leftColumns = 1, rightColumns = 1),
      "fixedHeader" = TRUE,
      "pageLength" = 10,
      "lengthMenu" = c(5, 10, 20, 50, 100),
      "filter" = "bottom",
      "searchHighlight" = TRUE,
      "rownames" = FALSE
    ) |>
      rlang::expr()
  } else if (type == "reactable") {
    list(
      "defaultColDef" = reactable::colDef(
        sortable = TRUE,
        filterable = TRUE,
        resizable = TRUE
      ),
      "defaultColGroup" = NULL,
      "defaultSortOrder" = "asc",
      "defaultSorted" = NULL,
      "defaultPageSize" = 10,
      "defaultExpanded" = TRUE,
      "highlight" = TRUE,
      "outlined" = FALSE,
      "bordered" = FALSE,
      "borderless" = FALSE,
      "striped" = TRUE,
      "theme" = NULL
    ) |>
      rlang::expr()
  }
}


#' Supported table classes
#'
#' @description
#' This function returns the supported table classes that can be used in the
#' `type` argument of `visOmopTable()`, `visTable()`, and `formatTable()`
#' functions.
#'
#' @return A character vector of supported table types.
#'
#' @export
#'
#' @examples
#' tableType()
#'
tableType <- function() {
  c("gt", "flextable", "tibble", "datatable", "reactable")
}


#' Columns for the table functions
#'
#' @description
#' Names of the columns that can be used in the input arguments for the table
#' functions.
#'
#' @param result A `<summarised_result>` object.
#'
#' @return A character vector of supported columns for tables.
#'
#' @export
#'
#' @examples
#' result <- mockSummarisedResult()
#' tableColumns(result)
#'
tableColumns <- function(result) {
  result <- omopgenerics::validateResultArgument(result)
  return(
    c("cdm_name", groupColumns(result), strataColumns(result), "variable_name",
      "variable_level", "estimate_name", additionalColumns(result),
      settingsColumns(result))
  )
}


#' Columns for the plot functions
#'
#' @description
#' Names of the columns that can be used in the input arguments for the plot
#' functions.
#'
#' @param result A `<summarised_result>` object.
#'
#' @return A character vector of supported columns for plots.
#'
#' @export
#'
#' @examples
#' result <- mockSummarisedResult()
#' plotColumns(result)
#'
plotColumns <- function(result) {
  result <- omopgenerics::validateResultArgument(result)
  return(c(tidyColumns(result)))
}
