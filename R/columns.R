
#' Identify group columns in an omop result object.
#'
#' @param result An omop result object.
#' @param overall Whether to keep overall column if present.
#'
#' @export
#'
#' @examples
#' \donttest{
#' mockSummarisedResult() |>
#'   groupColumns()
#' }
#'
groupColumns <- function(result, overall = FALSE) {
  getColumns(result = result, prefix = "group", overall = overall)
}

#' Identify strata columns in an omop result object.
#'
#' @param result An omop result object.
#' @param overall Whether to keep overall column if present.
#'
#' @export
#'
#' @examples
#' \donttest{
#' mockSummarisedResult() |>
#'   strataColumns()
#' }
#'
strataColumns <- function(result, overall = FALSE) {
  getColumns(result = result, prefix = "strata", overall = overall)
}

#' Identify additional columns in an omop result object.
#'
#' @param result An omop result object.
#' @param overall Whether to keep overall column if present.
#'
#' @export
#'
#' @examples
#' \donttest{
#' mockSummarisedResult() |>
#'   additionalColumns()
#' }
#'
additionalColumns <- function(result, overall = FALSE) {
  getColumns(result = result, prefix = "additional", overall = overall)
}

getColumns <- function(result, prefix, overall) {
  # initial checks
  result <- validateResult(result)
  checkmate::assertLogical(overall, any.missing = FALSE, len = 1)

  # extract columns
  if (inherits(result, "summarised_result")) {
    x <- result |>
      dplyr::pull(paste0(prefix, "_name")) |>
      unique() |>
      lapply(strsplit, split = " and ") |>
      unique()
  } else {
    x <- result |>
      dplyr::pull(paste0(prefix, "additional_name_reference")) |>
      unique() |>
      lapply(strsplit, split = " and ") |>
      unique()
  }

  # eliminate overall
  if (!overall) {
    x <- x[x != "overall"]
  }

  return(x)
}
