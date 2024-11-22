#' Formats the estimate_value column
#'
#' @param result A `<summarised_result>`.
#' @param decimals Number of decimals per estimate type (integer, numeric,
#' percentage, proportion), estimate name, or all estimate values (introduce the
#'  number of decimals).
#' @param decimalMark Decimal separator mark.
#' @param bigMark Thousand and millions separator mark.
#'
#' @return A `<summarised_result>`.
#'
#' @description
#' Formats the estimate_value column of `<summarised_result>` object by editing
#' number of decimals, decimal and thousand/millions separator marks.
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

formatEstimateValue <- function(result,
                                decimals = c(
                                  integer = 0, numeric = 2, percentage = 1,
                                  proportion = 3
                                ),
                                decimalMark = ".",
                                bigMark = ",") {
  # initial checks
  omopgenerics::assertTable(result, columns = c("estimate_name", "estimate_type", "estimate_value"))
  decimals <- validateDecimals(result, decimals)
  omopgenerics::assertCharacter(decimalMark, length = 1)
  omopgenerics::assertCharacter(bigMark, length = 1, null = TRUE)

  if (is.null(bigMark)) {bigMark <- ""}

  result <- formatEstimateValueInternal(result, decimals, decimalMark, bigMark)


  return(result)
}

formatEstimateValueInternal <- function(result, decimals, decimalMark, bigMark) {
  nms_name <- unique(result[["estimate_name"]])
  if (is.null(decimals)) { # default decimal formatting
    for (nm in nms_name) {
      result$estimate_value[result[["estimate_name"]] == nm] <- result$estimate_value[result[["estimate_name"]] == nm] |>
        as.numeric() |>
        base::format(big.mark = bigMark, decimal.mark = decimalMark,
                     trim = TRUE, justify = "none", scientific = FALSE)
    }
  } else {
    formatted <- rep(FALSE, nrow(result))
    for (nm in names(decimals)) {
      if (nm %in% nms_name) {
        id <- result[["estimate_name"]] == nm & !formatted &
          result$estimate_value != "-" &
          !grepl("<", result$estimate_value) &
          !is.na(result$estimate_value)
      } else {
        id <- result[["estimate_type"]] == nm & !formatted &
          result$estimate_value != "-" &
          !grepl("<", result$estimate_value) &
          !is.na(result$estimate_value)
      }
      n <- decimals[nm] |> unname()
      result$estimate_value[id] <- result$estimate_value[id] |>
        as.numeric() |>
        round(digits = n) |>
        base::format(nsmall = n, big.mark = bigMark, decimal.mark = decimalMark,
                     trim = TRUE, justify = "none", scientific = FALSE)
      formatted[id] <- TRUE
    }
  }
  return(result)
}
