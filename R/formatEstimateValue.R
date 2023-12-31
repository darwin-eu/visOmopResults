
#' Format estimate_value column of summarised_result and compared_result
#' object.
#'
#' @param result A summarised_result or compared_result.
#' @param decimals Number of decimals per estimate_type.
#' @param decimalMark Decimal separator mark.
#' @param thousandsMark Thousand and millions separator mark.
#'
#' @export
#'
#' @examples
#' \donttest{
#' x <- 1
#' }
#'
formatEstimateValue <- function(result,
                                decimals = c(
                                  integer = 0, numeric = 2, percentage = 1,
                                  proportion = 3
                                ),
                                decimalMark = ".",
                                thousandsMark = ",") {
  omopgenerics::resultColumns("summarised_result")
}
