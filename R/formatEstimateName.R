
#' Format estimate_value column of summarised_result and compared_result
#' object.
#'
#' @param result A summarised_result or compared_result.
#' @param format Named list of estimate name's to join.
#' @param keepNotFormatted Whether to keep not formatted.
#'
#' @export
#'
#' @examples
#' \donttest{
#' x <- 1
#' }
#'
formatEstimateName <- function(result,
                               format,
                               keepNotFormatted = TRUE) {
  # initial checks
  result <- validateResult(result)
  checkmate::assertCharacter(format, any.missing = FALSE, unique = TRUE, min.chars = 1)
  checkmate::assertLogical(keepNotFormatted, len = 1, any.missing = FALSE)

  # format estimate
  result <- formatEstimateValueInternal(result, format, keepNotFormatted)

  return(result)
}

formatEstimateValueInternal <- function(result, format, keepNotFormatted) {
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
    formatK <- format[k]
    keysK <- getKeys(formatK, keys)
    if (length(keysK) > 0) {
      res <- result |>
        dplyr::filter(!.data$formatted) |>
        dplyr::filter(.data$estimate_name %in% .env$keysK) |>
        dplyr::group_by(dplyr::across(dplyr::all_of(cols))) |>
        dplyr::filter(dplyr::n() == length(keyksK)) |>
        dplyr::mutate("id" = min(.data$id)) |>
        dplyr::ungroup() |>
        tidyr::pivot_wider(
          names_from = "estimate_name", values_from = "estimate_value"
        ) |>
        evalName(formatK) |>
        dplyr::mutate(
          "estimate_name" = nameK,
          "formatted" = TRUE,
          estimate_type = "character"
        ) |>
        dplyr::select(dplyr::all_of(c(ocols, "id", "formatted")))
      result <- result |>
        dplyr::anti_join(res, by = cols) |>
        dplyr::union_all(res)
    }
  }
  result <- result |>
    dplyr::arrange(.data$id) |>
    dplyr::select(dplyr::all_of(ocol, "formatted"))

  # keepNotFormated
  if (!keepNotFormatted) {
    result <- result |> dplyr::filter(.data$formated)
  }

  return(result)
}

getKeys <- function(format, keys) {
  for (k in seq_along(keys)) {
    format <- gsub(
      pattern = keys[k], replacement = paste0("#", k, "#"), x = format
    )
  }
  return(format)
}
evalName <- function(result, format, keys) {
  ik <- 0
  if (substr(format, 1 ,1) == "#") ik <- 1
  format <- strsplit(x = format, split = "#") |> unlist()
  for (k in seq_along(format)) {
    if ((k + ik) %% 2) {

    }
  }
}
