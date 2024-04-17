#' Create a header for gt and flextable objects.
#'
#' @param result A summarised_result.
#' @param header Names of the columns to make headers. Names that doesn't
#' correspond to a column of the table result, will be used as headers at the
#' defined position.
#' @param delim Delimiter to use to separate headers.
#' @param includeHeaderName Whether to include the column name as header.
#' @param includeHeaderKey Whether to include the header key (header,
#' header_name, header_level) before each header type in the column names.
#'
#' @return A tibble with rows pivotted into columns with key names for
#' subsequent header formatting.
#'
#' @description
#' Pivots a summarised_result object based on the column names in header,
#' generating specific column names for subsequent header formatting in
#' gtTable and fxTable functions.
#'
#' @export
#'
#' @examples
#' result <- mockSummarisedResult()
#'
#' result |>
#'   formatHeader(
#'     header = c(
#'       "Study cohorts", "group_level", "Study strata", "strata_name",
#'       "strata_level"
#'     ),
#'     includeHeaderName = FALSE
#'   )

formatHeader <- function(result,
                         header,
                         delim = "\n",
                         includeHeaderName = TRUE,
                         includeHeaderKey = TRUE) {
  # initial checks
  assertTibble(result)
  assertCharacter(header, null = TRUE)
  assertCharacter(delim, length = 1)
  assertLogical(includeHeaderName, length = 1)
  validateDelim(delim)

  if (!is.null(header)) {
    if (length(header) > 0) {
      # correct names
      nms <- names(header)
      if (is.null(nms)) {
        nms <- rep("", length(header))
      }
      nms[nms  == ""] <- header[nms  == ""]

      # pivot wider
      cols <- header[header %in% colnames(result)] |> unname()
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
          if (header[k] %in% cols) { # Header in dataframe
            spanners <- colDetails[[header[k]]] |> unique()
            for (span in spanners) { # loop through column values
              if (!is.na(span)) {
                colsSpanner <- colDetails[[header[k]]] == span
                if (includeHeaderKey) {
                  if (includeHeaderName) {
                    colDetails$new_name[colsSpanner] <- paste0(colDetails$new_name[colsSpanner], "[header_name]", nms[k], delim, "[header_level]", span, delim)
                  } else {
                    colDetails$new_name[colsSpanner] <- paste0(colDetails$new_name[colsSpanner], "[header_level]", span, delim)
                  }
                } else {
                  if (includeHeaderName) {
                    colDetails$new_name[colsSpanner] <- paste0(colDetails$new_name[colsSpanner], nms[k], delim, span, delim)
                  } else {
                    colDetails$new_name[colsSpanner] <- paste0(colDetails$new_name[colsSpanner], span, delim)
                  }
                }
              } else {
                cli::cli_abort(paste0("There are missing levels in '", header[k], "'."))
              }
            }
          } else {
            if (includeHeaderKey) {
              colDetails$new_name <- paste0(colDetails$new_name, "[header]", nms[k], delim)
            } else {
              colDetails$new_name <- paste0(colDetails$new_name, nms[k], delim)
            }
          }
        }
        colDetails <- colDetails |> dplyr::mutate(new_name = base::substring(.data$new_name, 0, nchar(.data$new_name)-1))
        # add column names
        names(result)[names(result) %in% colDetails$name] <- colDetails$new_name

      } else {
        if (includeHeaderKey) {
          new_name <- paste0("[header]", paste(header, collapse = paste0(delim, "[header]")))
        } else {
          new_name <- paste(header, collapse = delim)
        }
        result <- result |> dplyr::rename(!!new_name := "estimate_value")
        class(result) <- c("tbl_df", "tbl", "data.frame")
      }
    }
  }
  return(result)
}
