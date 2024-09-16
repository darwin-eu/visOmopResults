#' Add settings columns to a summaries_result object.
#'
#' @param result A summarised_result object.
#' @param settingsColumns Settings to be added as columns, by default all
#' settings will be added. If NULL or empty character vector, no settings will
#' be added.
#' @param columns `r lifecycle::badge("deprecated")`
#'
#' @export
#'
#' @return A summarised_result object with the added setting columns.
#'
#' @examples
#' library(visOmopResults)
#' mockSummarisedResult() |>
#'   addSettings(settingsColumns = c("result_type"))
#'
addSettings <- function(result,
                        settingsColumns = colnames(settings(result)),
                        columns = lifecycle::deprecated()) {

  if (lifecycle::is_present(columns)) {
    lifecycle::deprecate_warn("0.4.0", "addSettings(columns)", "addSettings(settingsColumns)")
  }

  # checks
  set <- attr(result, "settings")
  if (is.null(set)) {
    cli::cli_abort("`result` does not have 'settings' attribute")
  }
  settingsColumns <- settingsColumns[settingsColumns != "result_id"]
  if (is.null(settingsColumns)) {
    return(result)
  }
  notPresent <- settingsColumns[!settingsColumns %in% colnames(set)]
  if (length(notPresent)) {
    cli::cli_abort("The following columns are not present in settings: {notPresent}.")
  }
  # add settings
  toJoin <- settingsColumns[settingsColumns %in% colnames(result)]
  result <- result |>
    dplyr::left_join(
      set |> dplyr::select(dplyr::any_of(c("result_id", settingsColumns))),
      by = c("result_id", toJoin)
    )
  return(result)
}
