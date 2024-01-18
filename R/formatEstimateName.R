
#' Format estimate_value column of summarised_result and compared_result
#' object.
#'
#' @param result A summarised_result or compared_result.
#' @param format Named list of estimate name's to join, sorted by computation
#' order.
#' @param keepNotFormatted Whether to keep rows not formatted.
#'
#' @export
#'
#' @examples
#' \donttest{
#' x <- 1
#' }
#'
formatEstimateName <- function(result,
                               format = NULL,
                               keepNotFormatted = TRUE) {
  # initial checks
  result <- validateResult(result)
  checkmate::assertCharacter(format, any.missing = FALSE, unique = TRUE, min.chars = 1, null.ok = TRUE)
  checkmate::assertLogical(keepNotFormatted, len = 1, any.missing = FALSE)

  # format estimate
  resultFormatted <- formatEstimateNameInternal(
    result = result, format = format, keepNotFormatted = keepNotFormatted
  )

  # class
  if (inherits(result, "summarised_result")) {
    resultFormatted <- resultFormatted |> omopgenerics::summarisedResult()
  } else {
    resultFormatted <- resultFormatted |> omopgenerics::comparedResult()
  }

  return(resultFormatted)
}

formatEstimateNameInternal <- function(result, format, keepNotFormatted) {
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
  nms[nms == ""] <- format[nms == ""]

  # keys
  keys <- result[["estimate_name"]] |> unique()
  keys <- keys[order(nchar(keys), decreasing = TRUE)]

  # format
  ocols <- colnames(result)
  cols <- ocols[
    !ocols %in% c("estimate_name", "estimate_type", "estimate_value")
  ]
  result <- result |>
    dplyr::mutate("formatted" = FALSE, "id" = dplyr::row_number())

  for (k in seq_along(format)) {
    nameK <- nms[k]
    formatK <- format[k] |> unname()
    x <- getKeys(formatK, keys)
    formatK <- x$format
    keysK <- x$keys
    len <- length(keysK)
    if (len > 0) {
      res <- result |>
        dplyr::filter(!.data$formatted) |>
        dplyr::filter(.data$estimate_name %in% .env$keysK) |>
        dplyr::group_by(dplyr::across(dplyr::all_of(cols))) |>
        dplyr::filter(dplyr::n() == .env$len) |>
        dplyr::mutate("id" = min(.data$id)) |>
        dplyr::ungroup()
      resF <- res |>
        dplyr::select(-"estimate_type") |>
        tidyr::pivot_wider(
          names_from = "estimate_name", values_from = "estimate_value"
        ) |>
        evalName(formatK, keysK) |>
        dplyr::mutate(
          "estimate_name" = nameK,
          "formatted" = TRUE,
          "estimate_type" = "character"
        ) |>
        dplyr::select(dplyr::all_of(c(ocols, "id", "formatted")))
      result <- result |>
        dplyr::anti_join(
          res |> dplyr::select(dplyr::all_of(c(cols, "estimate_name"))),
          by = c(cols, "estimate_name")
        ) |>
        dplyr::union_all(resF)
    }
  }
  result <- result |>
    dplyr::arrange(.data$id) |>
    dplyr::select(dplyr::all_of(c(ocols, "formatted")))

  # keepNotFormated
  if (!keepNotFormatted) {
    result <- result |> dplyr::filter(.data$formatted)
  }

  result <- result |> dplyr::select(-"formatted")

  return(result)
}
getKeys <- function(format, keys) {
  keysK <- character()
  ik <- 1
  for (k in seq_along(keys)) {
    counts <- stringr::str_count(string = format, pattern = keys[k])
    if (counts > 0) {
      format <- gsub(
        pattern = keys[k], replacement = paste0("#", ik, "#"), x = format
      )
      keysK <- c(keysK, keys[k])
      ik <- ik + 1
    }
  }
  return(list(format = format, keys = keysK))
}
evalName <- function(result, format, keys) {
  for (k in seq_along(keys)) {
    format <- gsub(
      pattern = paste0("#", k, "#"),
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
