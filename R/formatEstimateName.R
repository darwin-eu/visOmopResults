
#' Format estimate_value column of summarised_result and compared_result
#' object.
#'
#' @param result A summarised_result or compared_result.
#' @param format Named list of estimate name's to join.
#' @param keepNotFormatted Whether to keep not formatted.
#'
#' @export
#'
#' @examples
#' \donttest{
#' x <- 1
#' }
#'
formatEstimateName <- function(result,
                               format,
                               keepNotFormatted = TRUE) {
  # initial checks
  result <- validateResult(result)
  checkmate::assertList(format, "character", min.len = 1, any.missing = FALSE, unique = TRUE)
  checkmate::assertLogical(keepNotFormatted, len = 1, any.missing = FALSE)

  # format estimate
  result <- formatEstimateValueInternal(result, format, keepNotFormatted)

  return(result)
}

formatEstimateValueInternal <- function(result, format, keepNotFormatted) {
  # correct names


  #
  return(result)
}
