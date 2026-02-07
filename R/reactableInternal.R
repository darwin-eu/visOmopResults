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

reactableInternal <- function(x,
                              delim = "\n",
                              style = styleRT(),
                              groupColumn = NULL,
                              groupOrder = NULL) {

  # Eliminate prefixes
  colnames(x) <- gsub("\\[header\\]|\\[header_level\\]|\\[header_name\\]|\\[column_name\\]", "", colnames(x))

  # groupColumn
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
  } else {
    nameGroup <- NULL
  }

  # get headers
  out <- getReactableHeaders(x, delim)

  # add defaults
  style <- defaultReactable() |>
    purrr::imap(\(x, nm) {
      if (nm %in% names(style)) {
        style[[nm]]
      } else {
        x
      }
    })

  # reactable
  reactable::reactable(
    data = out$data,
    columnGroups = out$columnGroups, # for headers
    groupBy = nameGroup, # groupColumn
    defaultColDef = style$defaultColDef, # Default settings for all columns, unless overridden in columns
    defaultColGroup = style$defaultColGroup, # Default settings for all column groups.
    defaultSortOrder = style$defaultSortOrder,
    defaultSorted = style$defaultSorted,
    defaultPageSize = style$defaultPageSize,
    defaultExpanded = style$defaultExpanded,
    highlight = style$highlight,
    outlined = style$outlined,
    bordered = style$bordered,
    borderless = style$borderless,
    striped = style$striped,
    theme = style$theme,
    searchable = TRUE, # no export
    showPageSizeOptions = TRUE, # no export
    rownames = FALSE # no export
  )
}

getReactableHeaders <- function(x, delim) {
  headers <- strsplit(colnames(x), delim, fixed = TRUE)
  len <- purrr::map(headers, \(x){length(x)}) |> unlist()
  if (any(len > 2)) {
    cli::cli_warn(c(
      "x" = "Only 1-level headers (that is, separated by one delimiter) allowed for `reactable`.",
      "i" = "Returnning a table without splitted headers."
    ))
    delim <- NULL
  }
  if (all(len == 1)) {
    colGroups <- NULL
  } else {
    # Identify columns with group headers
    grouped_headers <- headers[len == 2]

    grouped_columns <- purrr::map_chr(grouped_headers, 2)
    colnames(x)[len == 2] <- grouped_columns

    # Construct colGroups
    group_names <- purrr::map_chr(grouped_headers, 1)
    colGroups <- lapply(unique(group_names), function(g) {
      cols <- grouped_columns[group_names == g]
      reactable::colGroup(name = g, columns = cols)
    })
  }

  return(return(list(data = x, columnGroups = colGroups)))
}
