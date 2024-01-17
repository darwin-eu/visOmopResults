
#' Create a gt table from a summarised_result object.
#'
#' @param result A summarised_result object.
#' @param format #To inherit from formatEstimateName
#' @param splitGroup Whether to split group_name and group_level in several
#' columns.
#' @param splitStrata Whether to split strata_name and strata_level in several
#' columns.
#' @param splitAdditional Whether to split additional_name and additional_level
#' in several columns.
#' @param columns Columns to keep. You can rename them with this command.
#' @param header Columns to use as spanners in the gt table.
#' @param keepNotFormatted #To inherit formatEstimateName
#' @param decimals #To inherit formatEstimateValue
#' @param decimalMark #To inherit formatEstimateValue
#' @param bigMark #To inherit formatEstimateValue
#' @param style #To inherit gtHeader
#' @param na Substitute for NA values.
#'
#' @order 2
#'
#' @return A formatted gt table.
#'
formatSummarisedResult <- function(result,
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
  opts <- c(colnames(result), "group", "strata", "additional")
  checkmate::checkTRUE(all(header %in% c("cdm_name", "group", "strata", "additional")))
  checkmate::checkTRUE(length(header) == length(unique(header)))
  checkmate::checkCharacter(columns, any.missing = FALSE)
  checkmate::checkTRUE(columns %in% colnames(result))

  # prepare columns
  if ("group" %in% c(columns, header)) {
    header <- groupLabels(result, "group", splitGroup, header)
    result <- prepareGroup(result, "group", splitGroup)
  }
  if ("strata" %in% c(columns, header)) {
    header <- groupLabels(result, "strata", splitStrata, header)
    result <- prepareGroup(result, "strata", splitStrata)
  }
  if ("additional" %in% c(columns, header)) {
    header <- groupLabels(result, "additional", splitAdditional, header)
    result <- prepareGroup(result, "additional", splitAdditional)
  }

  # format estimate_name
  result <- formatEstimateNameInternal(
    result = result, format = format, keepNotFormatted = keepNotFormatted
  )

  # format estimate_value
  result <- formatEstimateValueInternal(
    result = result, decimals = decimals, decimalMark = decimalMark,
    bigMark = bigMark
  )

  # select columns
  result <- result |>
    dplyr::select(dplyr::any_of(c(columns, "estimate_value", header))) |>
    dplyr::mutate(dplyr::across(
      dplyr::everything(), ~ dplyr::if_else(is.na(.x), .env$na, .x)
    ))

  # crete gt table
  gtResult <- gtHeader(result = result, header = header, style = style)

  return(gtResult)
}

groupLabels <- function(result, name, split, header) {
  if (split) {
    x <- result[[paste0(name, "_name")]] |>
      unique() |>
      strsplit(split = " and ") |>
      unlist() |>
      unique()
    if (length(x) > 1) {
      x <- x[x != "overall"]
    }
    id <- which(header == name)
    is <- 1:id
    if (id >= length(header)) {
      iu <- NULL
    } else {
      iu <- (id+1):length(header)
    }
    header <- c(header[is], x, header[iu])
  }
  return(header)
}
prepareGroup <- function(result, name, split) {
  nm <- paste0(name, "_name")
  lv <- paste0(name, "_level")
  if (split) {
    result <- result |>
      omopgenerics::splitGroup(name = nm, level = lv, keep = FALSE)
  } else {
    result <- result |>
      dplyr::mutate(!!name := paste0(.data[[nm]], ": ", .data[[lv]])) |>
      dplyr::select(-dplyr::all_of(c(nm, lv)))
  }
  return(result)
}
