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
  omopgenerics::assertChoice(type, tableType(), length = 1)
  omopgenerics::assertChoice(style, c("default", "darwin"), length = 1)
  if (style == "darwin" & type %in% c("datatable", "reactable")) {
    cli::cli_abort("`darwin` style is not currently available for `datatable` and `reactable`.")
  }

  switch (type,
    "gt" = gtStyleInternal(style, asExpr = TRUE),
    "flextable" = flextableStyleInternal(style, asExpr = TRUE),
    "tibble" = NULL,
    "datatable" = datatableStyleInternal(style, asExpr = TRUE),
    "reactable" = reactableStyleInternal(style, asExpr = TRUE),
    "tinytable" = tinytableStyleInternal(style, asExpr = TRUE)
  )
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
#' @param style Named list that specifies how to style the different parts of
#' the gt or flextable table generated. Accepted style entries are: title,
#' subtitle, header, header_name, header_level, column_name, group_label, and
#' body.
#' Alternatively, use "default" to get visOmopResults style, or NULL for
#' gt/flextable style.
#' Keep in mind that styling code is different for gt and flextable.
#' Additionally, "datatable" and "reactable" have their own style functions.
#' To see style options for each table type use `tableStyle()`.
#' @param type The desired format of the output table. See `tableType()` for
#' allowed options. If "tibble", no formatting will be applied.
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

#' Set format options for all subsequent plots
#'
#' @description
#' Set format options for all subsequent plots unless state a different style in
#' a specific function
#'
#' @param style Which style to apply to the plot, options are:
#' "default", "darwin" and NULL (default ggplot style).
#' Customised styles can be achieved by modifying the returned ggplot object.
#'
#' @export
#'
#' @examples
#' setGlobalPlotOptions(style = "darwin")
#'
#' result <- mockSummarisedResult() |>
#'   dplyr::filter(variable_name == "age")
#'
#' scatterPlot(
#'   result = result,
#'   x = "cohort_name",
#'   y = "mean",
#'   line = TRUE,
#'   point = TRUE,
#'   ribbon = FALSE,
#'   facet = age_group ~ sex)
#'
setGlobalPlotOptions <- function(style = NULL) {
  options(visOmopResults.plotStyle = style)
}
