#' Creates a tibble with specific rows pivotted into columns
#'
#' `r lifecycle::badge("deprecated")`
#'
#' @param result A summarised_result or compared_result.
#' @param header Names of the columns to make headers. Names not corresponding
#' to a column of the table result, will be used as headers at the defined
#' position.
#' @param delim Delimiter to use to separate headers.
#' @param includeHeaderName Whether to include the column name as header.
#' @param includeHeaderKey Whether to include the header key (header,
#' header_name, header_level) before each header type in the column names.
#'
#' @return A tibble with rows pivotted into columns with column names for future
#' spanner headers.
#'
#' @description
#' Pivots a summarised_result object based on the column names in header. The
#' names of the new columns refer to the information on the column based on
#' the header input, with labels are separated using a delimiter.
#'
#' @export
#'
#' @examples
#' \donttest{
#' result <- mockSummarisedResult()
#'
#' result |>
#'   formatTable(
#'     header = c(
#'       "Study cohorts", "group_level", "Study strata", "strata_name",
#'       "strata_level"
#'     ),
#'     includeHeaderName = FALSE
#'   )
#' }

formatTable <- function(result,
                        header,
                        delim = "\n",
                        includeHeaderName = TRUE,
                        includeHeaderKey = TRUE) {
  lifecycle::deprecate_warn(
    when = "0.0.2", what = "formatTable()", with = "formatHeader()"
  )
  formatHeader(
    result = result,
    header = header,
    delim = delim,
    includeHeaderName = includeHeaderName,
    includeHeaderKey = includeHeaderKey
  )
}
