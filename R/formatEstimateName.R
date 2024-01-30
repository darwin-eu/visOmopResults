#' Format estimate_name and estimate_value column
#'
#' @param result A summarised_result or compared_result.
#' @param estimateNameFormat Named list of estimate name's to join, sorted by
#' computation order. Indicate estimate_name's between <...>.
#' @param keepNotFormatted Whether to keep rows not formatted.
#' @param useNewFormatOrder Whether to use the order in which estimate names
#' appear in the estimateNameFormat argument and send not formatted rows to the
#' end, or to use the order in the input dataframe.
#'
#' @description
#' Format estimate_name and estimate_value column of summarised_result and
#' compared_result object, by changing the name of the estimate name and/or joining
#' diferent estimate names together in a row.
#'
#' @return A summarised_result object withspecified changes in estimate_name and
#' estimate_value.
#'
#' @export
#'
#' @examples
#' \donttest{
#' result <- mockSummarisedResult()
#' result |> formatEstimateName(
#'     estimateNameFormat = c("N (%)" = "<count> (<percentage>%)",
#'                            "N" = "<count>"),
#'     keepNotFormatted = FALSE)
#' }
#'
formatEstimateName <- function(result,
                               estimateNameFormat = NULL,
                               keepNotFormatted = TRUE,
                               useNewFormatOrder = TRUE) {
  # initial checks
  result <- validateResult(result)
  validateEstimateNameFormat(estimateNameFormat)
  checkmate::assertCharacter(estimateNameFormat, any.missing = FALSE, unique = TRUE, min.chars = 1, null.ok = TRUE)
  checkmate::assertLogical(keepNotFormatted, len = 1, any.missing = FALSE)
  checkmate::assertLogical(useNewFormatOrder, len = 1, any.missing = FALSE)

  # format estimate
  resultFormatted <- formatEstimateNameInternal(
    result = result, format = estimateNameFormat,
    keepNotFormatted = keepNotFormatted, useNewFormatOrder = useNewFormatOrder
  )

  # class
  if (inherits(result, "summarised_result")) {
    resultFormatted <- resultFormatted |> omopgenerics::summarisedResult()
  } else {
    resultFormatted <- resultFormatted |> omopgenerics::comparedResult()
  }

  return(resultFormatted)
}

formatEstimateNameInternal <- function(result, format, keepNotFormatted, useNewFormatOrder) {
  # if no format no action is performed
  if (length(format) == 0) {
    return(result)
  }
  # correct names
  if (is.null(names(format))) {
    nms <- rep("", length(format))
  } else {
    nms <- names(format)
  }
  nms[nms == ""] <- gsub("<|>", "", format[nms == ""])
  # format
  ocols <- colnames(result)
  cols <- ocols[
    !ocols %in% c("estimate_name", "estimate_type", "estimate_value")
  ]

  # start formatting
  result <- result |>
    dplyr::mutate("formatted" = FALSE, "id" = dplyr::row_number()) |>
    dplyr::group_by(dplyr::across(dplyr::all_of(cols))) |>
    dplyr::mutate(group_id = min(.data$id)) |>
    dplyr::ungroup()

  resultF <- NULL
  for (k in seq_along(format)) {
    nameK <- nms[k]
    formatK <- format[k] |> unname()
    keys <- result[["estimate_name"]] |> unique()
    keysK <- stringr::str_match_all(formatK, "(?<=\\<).+?(?=\\>)") |> unlist()
    format_boolean <- all(keysK %in% keys)
    len <- length(keysK)
    if (len > 0 & format_boolean) {
      formatKNum <- getFormatNum(formatK, keysK)
      res <- result |>
        dplyr::filter(!.data$formatted) |>
        dplyr::filter(.data$estimate_name %in% .env$keysK) |>
        dplyr::group_by(dplyr::across(dplyr::all_of(cols))) |>
        dplyr::filter(dplyr::n() == .env$len) |>
          dplyr::mutate("id" = min(.data$id))
      resF <- res |>
        dplyr::ungroup() |>
        dplyr::select(-"estimate_type") |>
        tidyr::pivot_wider(
          names_from = "estimate_name", values_from = "estimate_value"
        ) |>
        evalName(formatKNum, keysK) |>
        dplyr::mutate(
          "estimate_name" = nameK,
          "formatted" = TRUE,
          "estimate_type" = "character"
        ) |>
        dplyr::select(dplyr::all_of(c(ocols, "id", "group_id", "formatted")))
      result <- result |>
        dplyr::anti_join(
          res |> dplyr::select(dplyr::all_of(c(cols, "estimate_name"))),
          by = c(cols, "estimate_name")
        ) |>
        dplyr::union_all(resF)
    } else {
      if (len > 0) {warning(glue::glue("{formatK} has not been formatted."), call. = FALSE)
       } else {warning(glue::glue("{formatK} does not contain an estimate name indicated by <...>"), call. = FALSE)}
    }
  }
  #useNewFormatOrder
  if (useNewFormatOrder) {
    new_order <- dplyr::tibble(estimate_name = nms, format_id = 1:length(nms)) |>
      dplyr::union_all(result |>
                         dplyr::select("estimate_name") |>
                         dplyr::distinct() |>
                         dplyr::filter(!.data$estimate_name %in% nms) |>
                         dplyr::mutate(format_id = length(format) + dplyr::row_number()))
    result <- result |>
      dplyr::left_join(new_order)
    result <- result[order(result$group_id, result$format_id, decreasing = FALSE),] |>
      dplyr::select(-c("id", "group_id", "format_id"))
  } else {
    result <- result |>
      dplyr::arrange(.data$id) |>
      dplyr::select(-"id", -"group_id")
  }
  # keepNotFormated
  if (!keepNotFormatted) {
    result <- result |> dplyr::filter(.data$formatted)
  }
  # result
  result <- result |> dplyr::select(-"formatted")
  return(result)
}
getFormatNum <- function(format, keys) {
  ik <- 1
  for (k in seq_along(keys)) {
    format <- gsub(
      pattern = keys[k], replacement = paste0("#", ik, "#"), x = format
    )
    ik <- ik + 1
  }
  return(format)
}
evalName <- function(result, format, keys) {
  for (k in seq_along(keys)) {
    format <- gsub(
      pattern = paste0("<#", k, "#>"),
      replacement = paste0("#x#.data[[\"", keys[k], "\"]]#x#"),
      x = format
    )
  }
  format <- strsplit(x = format, split = "#x#") |> unlist()
  format <- format[format != ""]
  id <- !startsWith(format, ".data")
  format[id] <- paste0("\"", format[id], "\"")
  format <- paste0(format, collapse = ", ")
  format <- paste0("paste0(", format, ")")
  result <- result |>
    dplyr::mutate("estimate_value" = eval(parse(text = format)))
  return(result)
}
