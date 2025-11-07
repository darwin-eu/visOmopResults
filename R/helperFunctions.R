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

#' Pre-defined styles are available for tables
#'
#' @description
#' This function provides a list of pre-defined styles for tables that can then
#' be used in the `style` argument of the table functions.
#'
#' @return A character vector indicating the style names.
#'
#' @export
#'
#' @examples
#' tableStyle()
#'
tableStyle <- function() {
  defaultStyles()
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
  c("gt", "flextable", "tibble", "datatable", "reactable", "tinytable")
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

#' Set format options for all subsequent tables
#'
#' @description
#' Set format options for all subsequent tables unless state a different style
#' in a specific function
#'
#' @inheritParams tableDoc
#'
#' @export
#'
#' @examples
#' setGlobalTableOptions(style = "darwin", type = "tinytable")
#' result <- mockSummarisedResult()
#' result |>
#'   visOmopTable(
#'     estimateName = c("N%" = "<count> (<percentage>)",
#'                      "N" = "<count>",
#'                      "Mean (SD)" = "<mean> (<sd>)"),
#'     header = c("cohort_name"),
#'     rename = c("Database name" = "cdm_name"),
#'     groupColumn = strataColumns(result)
#'   )
#'  # drop global options:
#'  setGlobalTableOptions(style = NULL, type = NULL)
#'
setGlobalTableOptions <- function(style = NULL, type = NULL) {
  options(visOmopResults.tableStyle = style)
  options(visOmopResults.tableType = type)
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

#' Pre-defined styles are available for plots
#'
#' @description
#' This function provides a list of pre-defined styles for plots that can then
#' be used in the `style` argument of the plot functions.
#'
#' @return A character vector indicating the style names.
#'
#' @export
#'
#' @examples
#' plotStyle()
#'
plotStyle <- function() {
  defaultStyles()
}

#' Supported plot types
#'
#' @description
#' This function returns the supported plot types that can be used in the
#' `type` argument of the plot functions.
#'
#' @return A character vector of supported plot types.
#'
#' @export
#'
#' @examples
#' tableType()
#'
plotType <- function() {
  c("ggplot", "plotly")
}

#' Set format options for all subsequent plots
#'
#' @description
#' Set format options for all subsequent plots unless state a different style in
#' a specific function
#'
#' @inheritParams plotDoc
#'
#' @export
#'
setGlobalPlotOptions <- function(style = NULL, type = NULL) {
  options(visOmopResults.plotStyle = style)
  options(visOmopResults.plotType = type)
}
