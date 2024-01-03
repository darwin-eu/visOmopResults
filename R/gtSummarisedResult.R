
#' Create a gt table from a summarised_result object.
#'
#' @param result A summarised_result object.
#' @param format String to group and format estimate_name column.
#' @param splitGroup Whether to split group_name and group_level in several
#' columns.
#' @param splitStrata Whether to split strata_name and strata_level in several
#' columns.
#' @param splitAdditional Whether to split additional_name and additional_level
#' in several columns.
#' @param columns Columns to keep. You can rename them with this command.
#' @param header Columns to use as spanners in the gt table.
#'
#' @return A formatted gt table.
#'
gtSummarisedResult <- function(result,
                               format = NULL,
                               splitGroup = TRUE,
                               splitStrata = TRUE,
                               splitAdditional = FALSE,
                               columns = c("variable_name", "variable_level", "format" = "estimate_name"),
                               header = c("cdm_name", "group", "strata"),
                               keepNotFormatted = TRUE,
                               decimals = c(
                                 integer = 0, numeric = 2, percentage = 1,
                                 proportion = 3
                               ),
                               decimalMark = ".",
                               bigMark = ",",
                               style = list(
                                 "header" = list(
                                   gt::cell_fill(color = "#c8c8c8"),
                                   gt::cell_text(weight = "bold")
                                 ),
                                 "header_name" = list(gt::cell_fill(color = "#e1e1e1")),
                                 "header_level" = list(gt::cell_fill(color = "#ffffff"))
                               ),
                               na = "-") {
  # initial checks
  result <- validateSummarisedResult(result)
  checkmate::checkTRUE(all(header %in% c("cdm_name", "group", "strata", "additional")))
  checkmate::checkTRUE(length(header) == length(unique(header)))
  checkmate::checkCharacter(columns, any.missing = FALSE)
  checkmate::checkTRUE(columns %in% colnames(result))

  if (expandGroup) {}

}
