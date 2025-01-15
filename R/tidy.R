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

#' Get a custom tidy visualization of a `<summarised_result>` object
#'
#' @param result A `<summarised_result>`.
#' @param splitGroup If TRUE it will split the group name-level column pair.
#' @param splitStrata If TRUE it will split the group name-level column pair.
#' @param splitAdditional If TRUE it will split the group name-level column pair.
#' @param settingsColumn Settings to be added as columns, by default all
#' settings will be added. If NULL or empty character vector, no settings will
#' be added.
#' @param pivotEstimatesBy Names from which pivot wider the estimate values. If
#' NULL the table will not be pivotted.
#' @param nameStyle Name style (glue package specifications) to customise names
#' when pivotting estimates. If NULL standard tidyr::pivot_wider formatting will
#' be used.
#'
#' @return A tibble.
#'
#' @description
#' Provides tools for obtaining a tidy version of a `<summarised_result>` object.
#'
#'@noRd
tidySummarisedResult <- function(result,
                                 splitGroup = TRUE,
                                 splitStrata = TRUE,
                                 splitAdditional = TRUE,
                                 settingsColumn = settingsColumns(result),
                                 pivotEstimatesBy = "estimate_name",
                                 nameStyle = NULL) {
  # initial checks
  result <- omopgenerics::validateResultArgument(result = result)
  pivotEstimatesBy <- validatePivotEstimatesBy(pivotEstimatesBy = pivotEstimatesBy)
  settingsColumn <- validateSettingsColumn(settingsColumn = settingsColumn, result = result)
  omopgenerics::assertCharacter(x = nameStyle, null = TRUE)
  omopgenerics::assertLogical(
    x = c(splitGroup, splitStrata, splitAdditional), length = 3
  )

  # split
  if (isTRUE(splitGroup)) result <- result |> splitGroup()
  if (isTRUE(splitStrata)) result <- result |> splitStrata()
  if (isTRUE(splitAdditional)) result <- result |> splitAdditional()

  # pivot estimates and add settings
  result <- result |>
    visOmopResults::addSettings(settingsColumn = settingsColumn) |>
    pivotEstimates(pivotEstimatesBy = pivotEstimatesBy, nameStyle = nameStyle) |>
    dplyr::relocate(dplyr::any_of(settingsColumn), .after = dplyr::last_col())

  return(result)
}
