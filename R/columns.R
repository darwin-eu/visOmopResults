
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
  getColumns(result = result, col = "group_name", overall = overall)
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
  getColumns(result = result, col = "strata_name", overall = overall)
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
  getColumns(result = result, col = "additional_name", overall = overall)
}

getColumns <- function(result, col, overall) {
  # initial checks
  checkmate::assertTibble(result)
  checkmate::assertCharacter(col, any.missing = FALSE, len = 1)
  checkmate::assertTRUE(col %in% colnames(result))
  checkmate::assertLogical(overall, any.missing = FALSE, len = 1)

  # extract columns
  x <- result |>
      dplyr::pull(dplyr::all_of(col)) |>
      unique() |>
      lapply(strsplit, split = " and ") |>
      unlist() |>
      unique()

  # eliminate overall
  if (!overall) {
    x <- x[x != "overall"]
  }

  return(x)
}
