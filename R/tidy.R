#' Get a custom tidy visualization of a `<summarised_result>` object
#'
#' @param result A `<summarised_result>`.
#' @param splitGroup If TRUE it will split the group name-level column pair.
#' @param splitStrata If TRUE it will split the group name-level column pair.
#' @param splitAdditional If TRUE it will split the group name-level column pair.
#' @param settingsColumns Settings to be added as columns, by default all
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
                                 settingsColumns =colnames(settings(result)),
                                 pivotEstimatesBy = "estimate_name",
                                 nameStyle = NULL) {
  # initial checks
  result <- omopgenerics::validateResultArguemnt(result = result)
  pivotEstimatesBy <- validatePivotEstimatesBy(pivotEstimatesBy = pivotEstimatesBy)
  settingsColumns <- validateSettingsColumns(settingsColumns = settingsColumns, result = result)
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
    visOmopResults::addSettings(settingsColumns = settingsColumns) |>
    pivotEstimates(pivotEstimatesBy = pivotEstimatesBy, nameStyle = nameStyle) |>
    dplyr::relocate(dplyr::any_of(settingsColumns), .after = dplyr::last_col())

  return(result)
}

#' Turn a `<summarised_result>` object into a tidy tibble
#'
#' @param x A `<summarised_result>`.
#' @param ... For compatibility (not used).
#'
#' @return A tibble.
#'
#' @description
#' `r lifecycle::badge("experimental")`
#' Provides tools for obtaining a tidy version of a `<summarised_result>` object.
#' This tidy version will include the settings as columns, `estimate_value` will
#' be pivotted into columns using `estimate_name` as names, and group, strata,
#' and additional will be splitted.
#' If you want to customise these tidy operations, please use
#' `tidySummarisedResult()`.
#'
#' @export
#'
#' @examples
#' result <- mockSummarisedResult()
#' result |> tidy()

tidy.summarised_result <- function(x, ...) {
  # checks
  if (length(list(...)) > 0) {
    cli::cli_warn(
      c("This function only accepts a summarised_result object as an input.",
        ">" = "If you want to customise the tidy version of your summarised_result
        object, use {.strong `tidySummarisedResult()`}.")
    )
    return(tidySummarisedResult(x, ...))
  }

  setNames <- colnames(settings(x))
  setNames <- setNames[setNames != "result_id"]

  x <- x |>
    addSettings() |>
    pivotEstimates() |>
    splitAll() |>
    dplyr::relocate(dplyr::all_of(setNames), .after = dplyr::last_col()) |>
    dplyr::select(!"result_id")

  return(x)
}
