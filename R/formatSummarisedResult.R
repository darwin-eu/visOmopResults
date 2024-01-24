#' Create a nice table from a summarised_result object.
#'
#' @param result A summarised_result object.
#' @param tableType Type of table to format into (currently accepting "gt").
#' @param header Names of the columns to make headers. Names not corresponding
#' to a column of the table result, will be used as headers at the defined
#' position.
#' @param estimateNameFormat Named list of estimate name's to join, sorted by
#'  computation order.
#' @param style Named list that specifies how to style the different parts of
#' the table. Accepted entries are: title, subtitle, header, header_name,
#' header_level, column_name, group_label, and body. If NULL, the table will
#' not be styled (default of the chosed tableType), and if "deafult" it will
#' be styled as OMOP's default
#' @param decimals Number of decimals per estimate_type (integer, numeric,
#' percentage, proportion).
#' @param title Title of the table, or NULL for no title.
#' @param subtitle Subtitle of the table, or NULL for no subtitle.
#' @param caption Caption for the table, or NULL for no caption. Text in
#' markdown formatting style (e.g. `*Your caption here*` for caption in
#' italics).
#' @param .options list of default options (includeHeaderName = TRUE,
#' keepNotFormatted = TRUE, decimalMark = ".", bigMark = ",", na = "-",
#' groupNameCol = NULL, groupNameAsColumn = FALSE, groupOrder = NULL).
#'
#' @noRd
#'
#' @examples
#' \donttest{
#' mockSummarisedResult() |>
#'   formatSummarisedResult(tableType = "gt",
#'                          header = c("Study strata","strata_name",
#'                                     "strata_level"),
#'                          estimateNameFormat = c("N(%)" =
#'                                                   "<count> (<percentage>%)"),
#'                          style = "default",
#'                          decimals = c(
#'                            integer = 0, numeric = 2, percentage = 1,
#'                            proportion = 3
#'                          ),
#'                          .options = list("groupNameCol" = "group_level",
#'                                          "groupNameAsColumn" = FALSE,
#'                                          "groupOrder" = c("cohort1",
#'                                                           "cohort2"),
#'                                          "includeHeaderName" = FALSE))
#' }
#'
#'
#' @return A formatted table from a summarisedResult dataframe.
#'
formatSummarisedResult <- function(result,
                                   tableType = "gt",
                                   header = NULL,
                                   estimateNameFormat = NULL,
                                   style = "default",
                                   decimals = c(
                                     integer = 0, numeric = 2, percentage = 2,
                                     proportion = 3
                                   ),
                                   title = NULL,
                                   subtitle = NULL,
                                   caption = NULL,
                                   .options = list()
                                   ) {

  # .options
  options <- addDefaultOptions(.options)

  # initial checks
  result <- validateResult(result)
  decimals <- validateDecimals(decimals)
  checkmate::assertCharacter(options$na, len = 1, null.ok = TRUE)
  checkmate::assertCharacter(title, len = 1, null.ok = TRUE, any.missing = FALSE)
  checkmate::assertCharacter(subtitle, len = 1, null.ok = TRUE, any.missing = FALSE)
  checkmate::assertCharacter(caption, len = 1, null.ok = TRUE, any.missing = FALSE)
  checkmate::assertCharacter(options$groupNameCol, null.ok = TRUE, any.missing = FALSE)
  checkmate::assertLogical(options$groupNameAsColumn, len = 1, any.missing = FALSE)
  checkmate::assertCharacter(options$groupOrder, null.ok = TRUE, any.missing = FALSE)
  checkmate::assertCharacter(header, any.missing = FALSE, null.ok = TRUE)
  checkmate::assertLogical(options$includeHeaderName, any.missing = FALSE, len = 1)
  checkmate::assertCharacter(options$decimalMark, len = 1, any.missing = FALSE)
  checkmate::assertCharacter(options$bigMark, len = 1, any.missing = FALSE)
  checkmate::assertCharacter(estimateNameFormat, any.missing = FALSE, unique = TRUE, min.chars = 1, null.ok = TRUE)
  checkmate::assertLogical(options$keepNotFormatted, len = 1, any.missing = FALSE)

  # format estimate_value
  result <- formatEstimateValue(
    result = result, decimals = decimals, decimalMark = options$decimalMark,
    bigMark = options$bigMark
  )

  # format estimate_name
  if (! is.null(estimateNameFormat)) {
    result <- formatEstimateName(
      result = result, estimateNameFormat = estimateNameFormat,
      keepNotFormatted = options$keepNotFormatted
    )
  }

  # select columns
  if (! is.null(header)) {
    result <- formatTable(result = result,
                 header = header,
                 delim = "\n",
                 includeHeaderName = options$includeHeaderName)
  }

  # format table
  if (tableType == "gt") {
    if (is.character(style)) {
      if(style == "default") {
        result <- gtTable(
          x = result,
          delim = "\n",
          na = options$na,
          title = title,
          subtitle = subtitle,
          caption = caption,
          groupNameCol = options$groupNameCol,
          groupNameAsColumn = options$groupNameAsColumn,
          groupOrder = options$groupOrder
        )
      } else {
        cli::cli_abort("Style must be a list names of styles, NULL, or set to 'default'")
      }
    } else{
      result <- gtTable(
        x = result,
        delim = "\n",
        style = style,
        na = options$na,
        title = title,
        subtitle = subtitle,
        caption = caption,
        groupNameCol = options$groupNameCol,
        groupNameAsColumn = options$groupNameAsColumn,
        groupOrder = options$groupOrder
      )
    }
  } else if (tableType == "fx") {
    if (is.character(style)) {
      if(style == "default") {
        result <- fxTable(
          x = result,
          delim = "\n",
          na = options$na,
          title = title,
          subtitle = subtitle,
          caption = caption,
          groupNameCol = options$groupNameCol,
          groupNameAsColumn = options$groupNameAsColumn,
          groupOrder = options$groupOrder
        )
      } else {
        cli::cli_abort("Style must be a list names of styles, NULL, or set to 'default'")
      }
    } else {
      result <- fxTable(
        x = result,
        delim = "\n",
        style = style,
        na = options$na,
        title = title,
        subtitle = subtitle,
        caption = caption,
        groupNameCol = options$groupNameCol,
        groupNameAsColumn = options$groupNameAsColumn,
        groupOrder = options$groupOrder
      )
    }
  }

return(result)
}

addDefaultOptions <- function(input_options) {

  default <- list(
    includeHeaderName = TRUE,
    keepNotFormatted = TRUE,
    decimalMark = ".",
    bigMark = ",",
    na = "-",
    groupNameCol = NULL,
    groupNameAsColumn = FALSE,
    groupOrder = NULL
  )

  for (opt in names(default)) {
    if (!opt %in% names(input_options)) {
      input_options[[opt]] <- default[[opt]]
    }
  }

  return(input_options)
}


