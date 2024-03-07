#' Identify group columns in an omop result object
#'
#' @param result A summarised_result.
#' @param overall Whether to keep overall column if present.
#'
#' @return Unique values of the group name column.
#' @description Identifies and returns the unique values in group_name column.
#'
#' @export
#'
#' @examples
#' mockSummarisedResult() |>
#'   groupColumns()
#'
groupColumns <- function(result, overall = FALSE) {
  getColumns(result = result, col = "group_name", overall = overall)
}

#' Identify strata columns in an omop result object
#'
#' @param result A summarised_result.
#' @param overall Whether to keep overall column if present.
#'
#' @return Unique values of the strata name column.
#' @description Identifies and returns the unique values in strata_name column.
#'
#' @export
#'
#' @examples
#' mockSummarisedResult() |>
#'   strataColumns()
#'
strataColumns <- function(result, overall = FALSE) {
  getColumns(result = result, col = "strata_name", overall = overall)
}

#' Identify additional columns in an omop result object
#'
#' @param result A summarised_result.
#' @param overall Whether to keep overall column if present.
#'
#' @return Unique values of the additional name column.
#' @description Identifies and returns the unique values in additional_name
#' column.
#'
#' @export
#'
#' @examples
#' mockSummarisedResult() |>
#'   additionalColumns()
#'
additionalColumns <- function(result, overall = FALSE) {
  getColumns(result = result, col = "additional_name", overall = overall)
}

getColumns <- function(result, col, overall) {
  # initial checks
  assertTibble(result, columns = col)
  assertCharacter(col, length = 1)
  assertLogical(overall, length = 1)

  # extract columns
  x <- result |>
      dplyr::pull(dplyr::all_of(col)) |>
      unique() |>
      lapply(strsplit, split = " and | &&& ") |>
      unlist() |>
      unique()

  # eliminate overall
  if (!overall) {
    x <- x[x != "overall"]
  }

  return(x)
}
