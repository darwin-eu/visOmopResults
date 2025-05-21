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

datatableInternal <- function(x,
                              delim = "\n",
                              style = "default",
                              caption = NULL,
                              groupColumn = NULL) {

  # Package checks
  rlang::check_installed("DT")
  rlang::check_installed("htmltools")

  style <- validateStyle(style, "datatable")
  options <- style[c(
    "scrollX", "scrollY", "scrollCollapse", "pageLength", "lengthMenu",
    "searchHighlight", "scroller", "deferRender", "fixedColumns",
    "fixedHeader"
  )]
  options <- options[!sapply(options, is.null)]
  if (is.null(style$filter)) style$filter <- "none"

  # Eliminate prefixes
  colnames(x) <- gsub("\\[header\\]|\\[header_level\\]|\\[header_name\\]|\\[column_name\\]", "", colnames(x))

  # groupColumn
  if (length(groupColumn) > 0) {
    nameGroup <- names(groupColumn)
    x <- x |>
      tidyr::unite(
        !!nameGroup, groupColumn[[1]], sep = "; ", remove = TRUE, na.rm = TRUE
      ) |>
      dplyr::relocate(!!nameGroup)
    options$rowGroup = list(dataSrc = 0)
  }

  # header
  container <- getHTMLContainer(x, delim)

  # datatable
  DT::datatable(
    x,
    options = options,
    caption = if (!is.null(caption)) htmltools::tags$caption(
      style = style$caption, caption
    ) else NULL,
    filter = style$filter,
    rownames = style$rownames,
    extensions = c("FixedColumns", "FixedHeader", "Responsive", "RowGroup", "Scroller"),
    container = container
  )
}

getHTMLContainer <- function(x, delim) {
  headers <- colnames(x)
  split_headers <- stringr::str_split(headers, delim)
  # number of header levels
  max_depth <- max(sapply(split_headers, length))
  # pad single level headers
  padded_headers <- lapply(split_headers, function(header) {
    c(header, rep("", max_depth - length(header)))
  })
  header_levels <- do.call(rbind, padded_headers)

  # empty list to fill with html header code
  html_rows <- vector("list", max_depth)
  # get html by level
  for (level in 1:max_depth) {
    current_level <- header_levels[, level]
    unique_headers <- rle(current_level)
    current_row <- ""
    col_index <- 1
    # html for each header in the level
    for (i in seq_along(unique_headers$values)) {
      header <- unique_headers$values[i]
      span <- unique_headers$lengths[i]
      if (header != "") {
        rowspan <- 1
        colspan <- span
        if (level < max_depth) {
          # check next level over the spanning columns to determine rowspan
          next_level_headers <- header_levels[col_index:(col_index + span - 1), level + 1]
          if (all(next_level_headers == "")) {
            rowspan <- max_depth - level + 1
            colspan <- 1
          }
        }
        th_element <- sprintf(
          "<th%s%s style='text-align:center;'>%s</th>",
          if (rowspan > 1) sprintf(" rowspan='%d'", rowspan) else "",
          if (colspan > 1) sprintf(" colspan='%d'", colspan) else "",
          header
        )
        current_row <- paste0(current_row, th_element)
      }
      col_index <- col_index + span
    }
    html_rows[[level]] <- paste0("<tr>", current_row, "</tr>")
  }

  container <- paste(unlist(html_rows), collapse = "\n")
  container <- paste0(
    "<table class='display'>\n",
    "<thead>\n", container, "\n</thead>\n",
    "</table>"
  )

  return(container)
}
