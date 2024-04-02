#' Get a tidy visualization of a summarised_result object
#'
#' @param x A summarised_result.
#' @param splitGroup If TRUE it will split the group name-level column pair.
#' @param splitStrata If TRUE it will split the group name-level column pair.
#' @param splitAdditional If TRUE it will split the group name-level column pair.
#' @param pivotEstimatesBy Names from which pivot wider the estimate values. If
#' NULL the table will not be pivotted.
#' @param nameStyle Name style (glue package specifications) to customise names
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
#' result <- mockSummarisedResult()
#'
#' result |> tidy()
#'
tidy.summarised_result <- function(x,
                                   splitGroup = TRUE,
                                   splitStrata = TRUE,
                                   splitAdditional = TRUE,
                                   pivotEstimatesBy = "estimate_name",
                                   nameStyle = NULL,
                                   ...) {
  # initial checks
  assertTibble(x, columns = pivotEstimatesBy)
  assertLogical(splitGroup, length = 1)
  assertLogical(splitStrata, length = 1)
  assertLogical(splitAdditional, length = 1)
  assertCharacter(pivotEstimatesBy, null = TRUE)
  assertCharacter(nameStyle, null = TRUE)

  # setting names
  setNames <- x$estimate_name[x$variable_name == "settings"]
  # pivot settings
  x_out <- x |> pivotSettings()
  # split
  if (splitGroup) {
    x_out <- x_out |> splitGroup()
  }
  if (splitStrata) {
    x_out <- x_out |> splitStrata()
  }
  if (splitAdditional) {
    x_out <- x_out |> splitAdditional()
  }
  # pivot estimates
  x_out <- x_out |>
    pivotEstimates(pivotEstimatesBy = pivotEstimatesBy, nameStyle = nameStyle)
  # move settings
  if (length(setNames) > 0) {
    x_out <- x_out |>
      dplyr::relocate(dplyr::all_of(setNames), .after = dplyr::last_col())
  }
  return(x_out)
}
