#' Add settings columns to a summaries_result object.
#'
#' @param result A summarised_result object.
#' @param columns Settings to be added as columns, by default all settings will
#' be added.
#'
#' @export
#'
#' @return A summarised_result object with the added setting columns.
#'
addSettings <- function(result, columns = NULL) {
  assertClass(result, "summarised_result")
  set <- omopgenerics::settings(result)
  if (is.null(columns)) {
    columns <- colnames(set)
    columns <- columns[columns != "result_id"]
  }
  notPresent <- columns[!columns %in% colnames(set)]
  if (length(notPresent)) {
    cli::cli_abort("The following columns are not present in settings: {paste0(notPresent, collapse = ', ')}.")
  }
  toJoin <- columns[columns %in% colnames(result)]
  resultOut <- result |>
    dplyr::left_join(
      set |> dplyr::select(dplyr::all_of(c("result_id", columns))),
      by = c("result_id", toJoin)
    )
  return(resultOut)
}
