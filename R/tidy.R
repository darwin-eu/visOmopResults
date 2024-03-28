#' Get a tidy visualization of a summarised_result object
#'
#' @param result A summarised_result.
#' @param splitGroup If TRUE it will split the group name-level column pair.
#' @param splitStrata If TRUE it will split the group name-level column pair.
#' @param splitAdditional If TRUE it will split the group name-level column pair.
#' @param pivotEstimatesBy Names from which pivot wider the estimate values. If
#' NULL the table will not be pivotted.
#' @param nameStyle Name style (glue package specifications) to customize names
#' when pivotting estimates. If NULL standard tidyr::pivot_wider formatting will
#' be used.
#' @param ... For compatibility (not used).
#'
#' @return A tibble.
#'
#' @description
#' `r lifecycle::badge("experimental")`
#' Provides tools for obtaining a tidy version of a summarised_result object. If
#' the summarised results object contains settings, these will be transformed
#' into columns.
#'
#' @export
#'
#' @examples
#' result <- mockSummarisedresult()
#'
#' result |> tidy()
#'
tidy.summarised_result <- function(result,
                                   splitGroup = TRUE,
                                   splitStrata = TRUE,
                                   splitAdditional = TRUE,
                                   pivotEstimatesBy = "estimate_name",
                                   nameStyle = NULL,
                                   ...) {
  # initial checks
  assertTibble(result, columns = pivotEstimatesBy)
  assertLogical(splitGroup, length = 1)
  assertLogical(splitStrata, length = 1)
  assertLogical(splitAdditional, length = 1)
  assertCharacter(pivotEstimatesBy, null = TRUE)
  assertCharacter(nameStyle, null = TRUE)

  # setting names
  setNames <- result$estimate_name[result$variable_name == "settings"]
  # pivot settings
  result_out <- result |> pivotSettings()
  # split
  if (splitGroup) {
    result_out <- result_out |> splitGroup()
  }
  if (splitStrata) {
    result_out <- result_out |> splitStrata()
  }
  if (splitAdditional) {
    result_out <- result_out |> splitAdditional()
  }
  # pivot estimates
  result_out <- result_out |>
    pivotEstimates(pivotEstimatesBy = pivotEstimatesBy, nameStyle = nameStyle)
  # move settings
  if (length(setNames) > 0) {
    result_out <- result_out |>
      dplyr::relocate(dplyr::all_of(setNames), .after = dplyr::last_col())
  }
  return(result_out)
}


