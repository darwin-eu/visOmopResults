
gtSummarisedResult <- function(result,
                               format,
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
                               na = "-",
                               cdmName = TRUE,
                               expandGroup = TRUE,
                               expandStrata = TRUE,
                               expandAdditional = FALSE,
                               columns = c("variable_name", "variable_level", "format" = "estimate_name")) {

}
