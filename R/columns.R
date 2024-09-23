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

#' Identify settings columns of a `<summarised_result>`
#'
#' @param result A `<summarised_result>`.
#'
#' @return Vector with names of the settings columns
#' @description Identifies and returns the columns of the settings table
#' obtained by using `settings()` in a `<summarised_result>` object.
#'
#' @export
#'
#' @examples
#' mockSummarisedResult() |>
#'   settingsColumns()
#'
settingsColumns <- function(result) {
  cols <- result |>
    validateSettingsAttribute() |>
    colnames()
  cols[cols != "result_id"]
}

#' Identify tidy columns of a `<summarised_result>`
#'
#' @param result A `<summarised_result>`.
#'
#' @return Table columns after applying `tidy()` function to a
#' `<summarised_result>`.
#'
#' @description Identifies and returns the columns that the tidy version of the
#' `<summarised_result>` will have.
#'
#' @export
#'
#' @examples
#' mockSummarisedResult() |>
#'   tidyColumns()
#'
tidyColumns <- function(result) {
  omopgenerics::validateResultArguemnt(result)
  colsSet <- colnames(settings(result))
  c("cdm_name", groupColumns(result), strataColumns(result), "variable_name",
    "variable_level", unique(result$estimate_name), additionalColumns(result),
    colsSet[colsSet != "result_id"])
}

getColumns <- function(result, col) {
  # initial checks
  omopgenerics::assertTable(result, columns = col)
  omopgenerics::assertCharacter(col, length = 1)

  # extract columns
  x <- result |>
    dplyr::select(dplyr::all_of(col)) |>
    dplyr::distinct() |>
    dplyr::pull() |>
    lapply(strsplit, split = " &&& ") |>
    unlist() |>
    unique()

  # eliminate overall
  x <- x[x != "overall"]

  return(x)
}
