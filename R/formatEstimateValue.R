
#' Format estimate_value column of summarised_result and compared_result
#' object.
#'
#' @param result A summarised_result or compared_result.
#' @param decimals Number of decimals per estimate_type (integer, numeric,
#' percentage, proportion).
#' @param decimalMark Decimal separator mark.
#' @param bigMark Thousand and millions separator mark.
#'
#' @export
#'
#' @examples
#' \donttest{
#' result <- mockSummarisedResult()
#'
#' result |> formatEstimateValue(decimals = 1)
#'
#' result |> formatEstimateValue(decimals = c(integer = 0, numeric = 1))
#' }
#'
formatEstimateValue <- function(result,
                                decimals = c(
                                  integer = 0, numeric = 2, percentage = 1,
                                  proportion = 3
                                ),
                                decimalMark = ".",
                                bigMark = ",") {
  # initial checks
  result <- validateResult(result)
  decimals <- validateDecimals(decimals)
  checkmate::assertCharacter(decimalMark, len = 1, any.missing = FALSE)
  checkmate::assertCharacter(bigMark, len = 1, any.missing = FALSE)

  # format estimate
  result <- formatEstimateValueInternal(result, decimals, decimalMark, bigMark)

  return(result)
}

formatEstimateValueInternal <- function(result, decimals, decimalMark, bigMark) {
  for (nm in names(decimals)) {
    n <- decimals[nm] |> unname()
    id <- result[["estimate_type"]] == nm
    result$estimate_value[id] <- result$estimate_value[id] |>
      as.numeric() |>
      round(digits = n) |>
      base::format(nsmall = n, big.mark = bigMark, decimal.mark = decimalMark)
  }
  return(result)
}
