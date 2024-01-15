#' Format estimate_value column of summarised_result and compared_result
#' object.
#'
#' @param result A summarised_result or compared_result.
#' @param header Names of the columns to make headers. Names not corresponding to a column of the table result, will be used as headers at the defined position.
#' @param includeHeader Wheather to include the column name as header.
#'
#' @export
#'
#' @examples
#' \donttest{
#' result <- mockSummarisedResult()
#'
#' result |> formatEstimateValue(decimals = 1)
#'
#' result |> formatEstimateValue(decimals = c(integer = 0, numeric = 1))
#' }

spanHeader<- function(result,
                      header,
                      includeHeader = TRUE) {
  # initial checks
  result <- validateResult(result)
  checkmate::assertCharacter(x = header, any.missing = FALSE)
  checkmate::assertLogical(includeHeader, any.missing = FALSE, len = 1)

  # pivot wider
  cols <- header[header %in% colnames(result)]
  if (length(cols) > 0) {
    colDetails <- result |>
      dplyr::select(dplyr::all_of(cols)) |>
      dplyr::distinct() |>
      dplyr::mutate("name" = sprintf("column%03i", dplyr::row_number()))
    result <- result |>
      dplyr::inner_join(colDetails, by = cols) |>
      dplyr::select(-dplyr::all_of(cols)) |>
      tidyr::pivot_wider(names_from = "name", values_from = "estimate_value")
    columns <- colDetails$name

    # create column names
    colDetails <- colDetails |> dplyr::mutate(new_name = "")
    for (k in seq_along(header)) {
      if (header[k] %in% cols) {
        spanners <- colDetails[[header[k]]] |> unique()
        for (span in spanners) {
          colsSpanner <- colDetails$name[colDetails[[header[k]]] == span]
          if (includeHeader) {
            colDetails$new_name[colDetails[[header[k]]] == span] <- paste0(colDetails$new_name[colDetails[[header[k]]] == span], header[k], "\n", span, "\n")
          } else {
            colDetails$new_name[colDetails[[header[k]]] == span] <- paste0(colDetails$new_name[colDetails[[header[k]]] == span], span, "\n")
          }
        }
      } else {
        colDetails$new_name <- paste0(colDetails$new_name, header[k], "\n")
      }
    }
    colDetails <- colDetails |> dplyr::mutate(new_name = base::substring(.data$new_name, 0, nchar(.data$new_name)-1))

    # add column names
    names(result)[names(result) %in% colDetails$name] <- colDetails$new_name

  } else {
    result <- result |> dplyr::rename(!!paste(header, collapse = "\n") := "estimate_value")
    class(result) <- c("tbl_df", "tbl", "data.frame")
  }

  return(result)
}
