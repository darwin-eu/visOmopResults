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

datatableStyleInternal <- function(styleName) {
  styles <- list(
    "default" = list(
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
    )
  )
  if (!styleName %in% names(styles)) {
    cli::cli_inform(c("i" = "{styleName} does not correspon to any of our defined styles. Returning default style."))
    styleName <- "default"
  }
  return(styles[[styleName]])
}

reactableStyleInternal <- function(styleName) {
  styles <- list(
    "default" = list(
      "defaultColDef" = reactable::colDef(
        sortable = TRUE,
        filterable = TRUE,
        resizable = TRUE,
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
    )
  )
  if (!styleName %in% names(styles)) {
    cli::cli_inform(c("i" = "{styleName} does not correspon to any of our defined styles. Returning default style."))
    styleName <- "default"
  }
  return(styles[[styleName]])
}


flextableStyleInternal <- function(styleName) {
  styles <- list(
    "default" = list(
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
    ),
    "darwin" = list(
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
    )
  )
  if (!styleName %in% names(styles)) {
    cli::cli_inform(c("i" = "{styleName} does not correspon to any of our defined styles. Returning default style."))
    styleName <- "default"
  }
  return(styles[[styleName]])
}

gtStyleInternal <- function(styleName) {
  styles <- list (
    "default" = list(
      "header" = list(
        gt::cell_fill(color = "#c8c8c8"),
        gt::cell_text(weight = "bold", align = "center"),
        gt::cell_borders(color = "White")
      ),
      "header_name" = list(
        gt::cell_fill(color = "#d9d9d9"),
        gt::cell_text(weight = "bold", align = "center"),
        gt::cell_borders(color = "White")
      ),
      "header_level" = list(
        gt::cell_fill(color = "#e1e1e1"),
        gt::cell_text(weight = "bold", align = "center"),
        gt::cell_borders(color = "White")
      ),
      "column_name" = list(
        gt::cell_text(weight = "bold", align = "center"),
        gt::cell_borders(color = "White")
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
    ),
    "darwin" = list(
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
    )
  )
  if (!styleName %in% names(styles)) {
    cli::cli_inform(c("i" = "{styleName} does not correspon to any of our defined styles. Returning default style."))
    styleName <- "default"
  }
  return(styles[[styleName]])
}
