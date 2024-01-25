#' Format the estimate_value column
#'
#' @param result A summarised_result or compared_result.
#' @param decimals Number of decimals per estimate type (integer, numeric,
#' percentage, proportion), estimate name, or all estimate values (introduce the
#'  number of decimals).
#' @param decimalMark Decimal separator mark.
#' @param bigMark Thousand and millions separator mark.
#'
#' @return A summarised_result object with the estimate_value column formatted.
#'
#' @description
#' Format the estimate_value column of summarised_result and compared_result
#' object by editing number of decimals, decimal and thousand/millions separator
#' marks.
#'
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
  decimals <- validateDecimals(result, decimals)
  checkmate::assertCharacter(decimalMark, len = 1, any.missing = FALSE)
  checkmate::assertCharacter(bigMark, len = 1, any.missing = FALSE)

  # format estimate
  result <- formatEstimateValueInternal(result, decimals, decimalMark, bigMark)

  return(result)
}

formatEstimateValueInternal <- function(result, decimals, decimalMark, bigMark) {
  formatted <- rep(FALSE, nrow(result))
  for (nm in names(decimals)) {
    n <- decimals[nm] |> unname()
    if (nm %in% unique(result[["estimate_name"]])) {
      id <- result[["estimate_name"]] == nm
    } else {
      id <- result[["estimate_type"]] == nm
    }
    result$estimate_value[id & !formatted] <- result$estimate_value[id & !formatted] |>
      as.numeric() |>
      round(digits = n) |>
      base::format(nsmall = n, big.mark = bigMark, decimal.mark = decimalMark, trim = TRUE)
    formatted[id] <- TRUE
  }
  return(result)
}
