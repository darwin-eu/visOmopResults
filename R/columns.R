#' Identify group columns in an omop result object
#'
#' @param result A summarised_result.
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

#' Identify strata columns in an omop result object
#'
#' @param result A summarised_result.
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

#' Identify tidy columns of a summarised_result
#'
#' @param result A summarised_result.
#'
#' @return Table columns after applying `tidy()` function to a summarisd result.
#' @description Identifies and returns the columns that the tidy version of the
#' summarised_result will have.
#'
#' @export
#'
#' @examples
#' mockSummarisedResult() |>
#'   tidyColumns()
#'
tidyColumns <- function(result) {
  omopgenerics::validateResultArguemnt(result)
  colnames(tidy(result))
}

#' Identify additional columns in an omop result object
#'
#' @param result A summarised_result.
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
  assertTibble(result, columns = col)
  assertCharacter(col, length = 1)

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
