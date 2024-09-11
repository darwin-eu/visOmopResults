#' Filter a summarised_result
#'
#' @param result A summarised_result object.
#' @param ... Expressions that return a logical value (columns in settings are
#' used to evaluate the expression), and are defined in terms of the variables
#' in .data. If multiple expressions are included, they are combined with the &
#' operator. Only rows for which all conditions evaluate to TRUE are kept.
#'
#' @export
#'
#' @return A summarised_result object with only the result_id rows that fulfill
#' the required specified settings.
#'
#' @examples
#' library(dplyr)
#' library(omopgenerics)
#'
#' x <- tibble(
#'   "result_id" = as.integer(c(1, 2)),
#'   "cdm_name" = c("cprd", "eunomia"),
#'   "group_name" = "sex",
#'   "group_level" = "male",
#'   "strata_name" = "sex",
#'   "strata_level" = "male",
#'   "variable_name" = "Age group",
#'   "variable_level" = "10 to 50",
#'   "estimate_name" = "count",
#'   "estimate_type" = "numeric",
#'   "estimate_value" = "5",
#'   "additional_name" = "overall",
#'   "additional_level" = "overall"
#' ) |>
#'   newSummarisedResult(settings = tibble(
#'     "result_id" = c(1, 2), "custom" = c("A", "B")
#'   ))
#'
#' x
#'
#' x |> filterSettings(custom == "A")
#'
filterSettings <- function(result, ...) {
  # initial check
  assertClass(result, "summarised_result")

  # filter settings (try if error)
  result <- tryCatch(
    {
      attr(result, "settings") <- settings(result) |>
        dplyr::filter(...)

      # filter id from settings
      resId <- settings(result) |> dplyr::pull("result_id")
      result |> dplyr::filter(.data$result_id %in% .env$resId)
    },
    error = function(e) {
      warning("Variable filtering does not exist, returning empty result: ", e$message)
      omopgenerics::emptySummarisedResult()  # return empty result here
    }
  )

  return(result)
}
