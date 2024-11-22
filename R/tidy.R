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
#' `r lifecycle::badge("experimental")`
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
