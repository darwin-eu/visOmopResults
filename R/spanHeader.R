#'
#' Format estimate_value column of summarised_result and compared_result
#' object.
#'
#' @param result A summarised_result or compared_result.
#' @param header Names of the columns to make headers. Names not corresponding
#' to a column of the table result, will be used as headers at the defined
#' position.
#' @param delim Delimiter to use to separate headers.
#' @param includeHeaderName Wheather to include the column name as header.
#'
#' @export
#'
#' @examples
#' \donttest{
#' result <- mockSummarisedResult()
#'
#' result |>
#'   spanHeader(header = c("Study cohorts", "group_level", "Study strata",
#'                         "strata_name", "strata_level"),
#'              includeHeaderName = FALSE)
#' }

spanHeader<- function(result,
                      header,
                      delim = "\n",
                      includeHeaderName = TRUE) {
  # initial checks
  result <- validateResult(result)
  checkmate::assertCharacter(x = header, any.missing = FALSE)
  checkmate::assertCharacter(delim, min.chars = 1, len = 1, any.missing = FALSE, max.len = 1)
  checkmate::assertLogical(includeHeaderName, any.missing = FALSE, len = 1)
  if (!rlang::is_character(delim)) {
    cli::cli_abort("The value supplied for `delim` must be of type `character`.")
  }
  if (length(delim) != 1) {
    cli::cli_abort("`delim` must be a single value.")
  }
  if (nchar(delim) != 1) {
    cli::cli_abort("The value supplied for `delim` must be a single character.")
  }

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
          if (k < length(header)) {
            if (includeHeaderName) {
              colDetails$new_name[colDetails[[header[k]]] == span] <- paste0(colDetails$new_name[colDetails[[header[k]]] == span], "[header_name]", header[k], delim, "[header_level]", span, delim)
            } else {
              colDetails$new_name[colDetails[[header[k]]] == span] <- paste0(colDetails$new_name[colDetails[[header[k]]] == span], "[header_level]", span, delim)
            }
          } else {
            if (includeHeaderName) {
              colDetails$new_name[colDetails[[header[k]]] == span] <- paste0(colDetails$new_name[colDetails[[header[k]]] == span], "[header_name]", header[k], delim, "[column_name]", span, delim)
            } else {
              colDetails$new_name[colDetails[[header[k]]] == span] <- paste0(colDetails$new_name[colDetails[[header[k]]] == span], "[column_name]", span, delim)
            }
          }
        }
      } else {
        if (k < length(header)) {
          colDetails$new_name <- paste0(colDetails$new_name, "[header]", header[k], delim)
        } else {
          colDetails$new_name <- paste0(colDetails$new_name, "[column_name]", header[k], delim)
        }
      }
    }
    colDetails <- colDetails |> dplyr::mutate(new_name = base::substring(.data$new_name, 0, nchar(.data$new_name)-1))

    # add column names
    names(result)[names(result) %in% colDetails$name] <- colDetails$new_name

  } else {
    new_name <- paste0("[header]", paste(header[1:(length(header)-1)], collapse = delim), delim, "[column_name]", header[-1])
    result <- result |> dplyr::rename(!!new_name := "estimate_value")
    class(result) <- c("tbl_df", "tbl", "data.frame")
  }

  return(result)
}
