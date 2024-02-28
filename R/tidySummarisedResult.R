#' Formats the estimate_value column
#'
#' @param result A summarised_result.
#' @param split Whether to split all name/level column pairs or not.
#' @param settings "pivot" to pivot settings as columns, "remove" to remove them
#' from the table, or "keep" to keep them in the table.
#' @param pivotEstimates TRUE for pivotting estimates as columns.
#'
#' @return A tibble.
#'
#' @description
#' Provides tools for obtaining for tidying a summarised_result object.
#'
#'
#' @export
#'
#' @examples
#' result <- mockSummarisedResult()
#'
#' result |> formatEstimateValue(decimals = 1)
#'
#' result |> formatEstimateValue(decimals = c(integer = 0, numeric = 1))
#'
#' result |>
#'   formatEstimateValue(decimals = c(numeric = 1, count = 0))

tidySummarisedResult <- function(result,
                                 split = TRUE,
                                 settings = "pivot",
                                 pivotEstimates = TRUE) {
  # initial checks


}
