#' @export
filterSettings <- function(.data, ...) {
  if ("result_id" %in% colnames(.data)) {
    cols <- colnames(settings(.data))
    cols <- cols[!cols %in% colnames(.data)]
    .data <- .data |> addSettings()
  } else {
    cols <- character()
  }
  cl <- class(.data)
  res <- keepClass(.data)
  res <- res |>
    dplyr::filter(...) |>
    dplyr::select(!dplyr::all_of(cols))
  res <- restoreClass(res, cl)
  res <- restoreAttributes(res, keepAttributes(.data, cl))
  return(res)
}
