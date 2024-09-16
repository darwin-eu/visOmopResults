#' Identify variables in group_name column
#'
#' @param result A tibble.
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
groupColumns <- function(result) {
  getColumns(result = result, col = "group_name")
}

#' Identify variables in strata_name column
#'
#' @param result A tibble.
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
strataColumns <- function(result) {
  getColumns(result = result, col = "strata_name")
}

#' Identify variables in additional_name column
#'
#' @param result A tibble.
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
additionalColumns <- function(result) {
  getColumns(result = result, col = "additional_name")
}

getColumns <- function(result, col) {
  # initial checks
  omopgenerics::assertTable(result, columns = col)
  omopgenerics::assertCharacter(col, length = 1)

  # extract columns
  x <- result |>
    dplyr::pull(dplyr::all_of(col)) |>
    unique() |>
    lapply(strsplit, split = " &&& ") |>
    unlist() |>
    unique()

  # eliminate overall
  x <- x[x != "overall"]

  return(x)
}
