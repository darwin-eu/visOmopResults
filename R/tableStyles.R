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

datatableStyleInternal <- function(styleName, asExpr = FALSE) {
  if (!styleName %in% c("default")) {
    cli::cli_inform(c("i" = "{styleName} does not correspon to any of our defined styles for datatable. Returning default style."))
    styleName <- "default"
  }

  if (styleName == "default") {
    style <- list(
      "caption" = 'caption-side: bottom; text-align: center;',
      "scrollX" = TRUE,
      "scrollY" = 400,
      "scroller" = TRUE,
      "deferRender" = TRUE,
      "scrollCollapse" = TRUE,
      "fixedColumns" = list(leftColumns = 0, rightColumns = 0),
      "fixedHeader" = TRUE,
      "pageLength" = 10,
      "lengthMenu" = c(5, 10, 20, 50, 100),
      "filter" = "bottom",
      "searchHighlight" = TRUE,
      "rownames" = FALSE
    ) |>
      rlang::expr()
  }

  if (isFALSE(asExpr)) {
    style <- style |> rlang::eval_tidy()
  }

  return(style)
}

reactableStyleInternal <- function(styleName, asExpr = FALSE) {
  if (!styleName %in% c("default")) {
    cli::cli_inform(c("i" = "{styleName} does not correspon to any of our defined styles for reactable. Returning default style."))
    styleName <- "default"
  }

  if (styleName == "default") {
    style <- list(
      "defaultColDef" = reactable::colDef(
        sortable = TRUE,
        resizable = TRUE,
        filterable = TRUE,
        headerStyle = list(textAlign = "center")
      ),
      "defaultColGroup" = reactable::colGroup(
        headerStyle = list(textAlign = "center")
      ),
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

  if (isFALSE(asExpr)) {
    style <- style |> rlang::eval_tidy()
  }

  return(style)
}


flextableStyleInternal <- function(styleName, asExpr = FALSE) {
  if (!styleName %in% c("default", "darwin")) {
    cli::cli_inform(c("i" = "{styleName} does not correspon to any of our defined styles. Returning default style."))
    styleName <- "default"
  }

  if (styleName == "default") {
    style <- list(
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
        "text" = officer::fp_text(bold = TRUE),
        "cell" = officer::fp_cell( border = officer::fp_border(color = "gray"))
      ),
      "group_label" = list(
        "cell" = officer::fp_cell(
          background.color = "#e9e9e9",
          border = officer::fp_border(color = "gray")
        ),
        "text" = officer::fp_text(bold = TRUE)
      ),
      "title" = list(
        "text" = officer::fp_text(bold = TRUE, font.size = 15),
        "paragraph" = officer::fp_par(text.align = "center"),
        "cell" = officer::fp_cell( border = officer::fp_border(color = "gray"))
      ),
      "subtitle" = list(
        "text" = officer::fp_text(bold = TRUE, font.size = 12),
        "paragraph" = officer::fp_par(text.align = "center"),
        "cell" = officer::fp_cell( border = officer::fp_border(color = "gray"))
      ),
      "body" = list(
        "cell" = officer::fp_cell(
          background.color = "transparent",
          border = officer::fp_border(color = "gray")
        )
      )
    ) |>
      rlang::expr()
  }
  if (styleName == "darwin") {
    style <- list(
      "header" = list(
        "cell" = officer::fp_cell(
          background.color = "#003399",
          border = officer::fp_border(color = "#003399")
        ),
        "text" = officer::fp_text(bold = TRUE, color = "white", font.size = 11)
      ),
      "header_name" = list(
        "cell" = officer::fp_cell(
          background.color = "#003399",
          border = officer::fp_border(color = "#003399")
        ),
        "text" = officer::fp_text(bold = TRUE, color = "white", font.size = 11, font.family = "calibri")
      ),
      "header_level" = list(
        "cell" = officer::fp_cell(
          background.color = "#003399",
          border = officer::fp_border(color = "#003399"),
        ),
        "text" = officer::fp_text(bold = TRUE, color = "white", font.size = 11, font.family = "calibri")
      ),
      "column_name" = list(
        "cell" = officer::fp_cell(
          background.color = "#003399",
          border = officer::fp_border(color = "#003399"),
        ),
        "text" = officer::fp_text(bold = TRUE, color = "white", font.size = 11, font.family = "calibri")
      ),
      "group_label" = list(
        "cell" = officer::fp_cell(
          background.color = "#003399",
          border = officer::fp_border(color = "#003399", width = 0.5)
        ),
        "text" = officer::fp_text(bold = TRUE, color = "white", font.size = 9, font.family = "calibri")
      ),
      "title" = list(
        "text" = officer::fp_text(bold = TRUE, font.size = 15, font.family = "calibri"),
        "paragraph" = officer::fp_par(text.align = "center")
      ),
      "subtitle" = list(
        "text" = officer::fp_text(bold = TRUE, font.size = 12, font.family = "calibri"),
        "paragraph" = officer::fp_par(text.align = "center")
      ),
      "body" = list(
        "cell" = officer::fp_cell(border = officer::fp_border(color = "#003399", width = 0.5)),
        "text" = officer::fp_text(font.size = 9, font.family = "calibri")
      )
    ) |>
      rlang::expr()
  }

  if (isFALSE(asExpr)) {
    style <- style |> rlang::eval_tidy()
  }

  return(style)
}

gtStyleInternal <- function(styleName, asExpr = FALSE) {
  if (!styleName %in% c("default", "darwin")) {
    cli::cli_inform(c("i" = "{styleName} does not correspon to any of our defined styles. Returning default style."))
    styleName <- "default"
  }

  if (styleName == "default") {
    style <- list(
      "header" = list(
        gt::cell_fill(color = "#c8c8c8"),
        gt::cell_text(weight = "bold", align = "center")
      ),
      "header_name" = list(
        gt::cell_fill(color = "#d9d9d9"),
        gt::cell_text(weight = "bold", align = "center")
      ),
      "header_level" = list(
        gt::cell_fill(color = "#e1e1e1"),
        gt::cell_text(weight = "bold", align = "center")
      ),
      "column_name" = list(
        gt::cell_text(weight = "bold", align = "center")
      ),
      "group_label" = list(
        gt::cell_fill(color = "#e9e9e9"),
        gt::cell_text(weight = "bold")
      ),
      "title" = list(
        gt::cell_text(weight = "bold", size = 15, align = "center")
      ),
      "subtitle" = list(
        gt::cell_text(weight = "bold", size = 12, align = "center")
      ),
      "body" = list()
    ) |>
      rlang::expr()
  }
  if (styleName == "darwin") {
    style <- list(
      "header" = list(
        gt::cell_fill(color = "#003399"),
        gt::cell_text(weight = "bold", color = "white", align = "center", font = "Calibri", size = 11)
      ),
      "header_name" = list(
        gt::cell_fill(color = "#003399"),
        gt::cell_text(weight = "bold", color = "white", align = "center", font = "Calibri", size = 11)
      ),
      "header_level" = list(
        gt::cell_fill(color = "#003399"),
        gt::cell_text(color = "white", weight = "bold", align = "center", font = "Calibri", size = 11)
      ),
      "column_name" = list(
        gt::cell_fill(color = "#003399"),
        gt::cell_text(weight = "bold", color = "white", align = "center", font = "Calibri", size = 11)
      ),
      "group_label" = list(
        gt::cell_fill(color = "#003399"),
        gt::cell_borders(color = "#003399"),
        gt::cell_text(weight = "bold", color = "white", font = "Calibri", size = 9)
      ),
      "title" = list(gt::cell_text(weight = "bold", font = "Calibri", size = 15, align = "center")),
      "subtitle" = list(
        gt::cell_text(weight = "bold", size = 12, font = "Calibri", align = "center")
      ),
      body = list(
        gt::cell_borders(color = "#003399", weight = 0.5),
        gt::cell_text(font = "calibri", size = 9)
        )
    ) |>
      rlang::expr()
  }

  if (isFALSE(asExpr)) {
    style <- style |> rlang::eval_tidy()
  }

  return(style)
}

tinytableStyleInternal <- function(styleName, asExpr = FALSE) {
  if (!styleName %in% c("default", "darwin")) {
    cli::cli_inform(c("i" = "{styleName} does not correspon to any of our defined styles. Returning default style."))
    styleName <- "default"
  }

  if (styleName == "default") {
    style <- list(
      "header" = list(
        "bold" = TRUE, background = "#c8c8c8", line = "lbtr", line_color = "gray"
      ),
      "header_name" = list(
        "bold" = TRUE, background = "#c8c8c8", line = "lbtr", line_color = "gray"
      ),
      "header_level" = list(
        "bold" = TRUE, background = "#e1e1e1", line = "lbtr", line_color = "gray"
      ),
      "column_name" = list(
        "bold" = TRUE, line = "lbtr", line_color = "gray"
      ),
      "group_label" = list(
        "bold" = TRUE, background = "#e9e9e9", line = "lbtr", line_color = "gray"
      ),
      "body" = list(line = "lbtr", line_color = "gray")
    ) |>
      rlang::expr()
  }
  if (styleName == "darwin") {
    style <- list(
      "header" = list(
        "bold" = TRUE, background = "#003399", line = "lbtr", line_color = "#003399", color = "white"
      ),
      "header_name" = list(
        "bold" = TRUE, background = "#003399", line = "lbtr", line_color = "#003399", color = "white"
      ),
      "header_level" = list(
        "bold" = TRUE, background = "#003399", line = "lbtr", line_color = "#003399", color = "white"
      ),
      "column_name" = list(
        "bold" = TRUE, background = "#003399", line = "lbtr", line_color = "#003399", color = "white"
      ),
      "group_label" = list(
        "bold" = TRUE, background = "#003399", line = "lbtr", line_color = "#003399", color = "white"
      ),
      "body" = list(line = "lbtr", line_color = "#003399")
    ) |>
      rlang::expr()
  }

  if (isFALSE(asExpr)) {
    style <- style |> rlang::eval_tidy()
  }

  return(style)
}
