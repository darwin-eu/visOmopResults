
#' Add headers to a omop result_object.
#'
#' @param result A result object.
#' @param header Names of the headers. If they point to a column, that column is
#' used as header.
#' @param style Set style for the different headers. Use the labels header (a
#' header name), header_name () and header_level (). If name is not provided
#' `header` is assumed.
#' @param na Substitute for NA.
#'
gtHeader <- function(result,
                     header = character(),
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
  result <- validateResult(result)
  checkmate::checkCharacter(header, any.missing = FALSE)
  # check style
  checkmate::checkCharacter(na, any.missing = FALSE, len = 1)

  # reverse oder
  header <- rev(header)

  # pivot wider
  cols <- header[header %in% colnames(result)]
  if (length(cols) > 0) {
    result <- result |>
      dplyr::mutate(dplyr::across(
        dplyr::all_of(cols), ~ dplyr::if_else(is.na(.x), .env$na, .x)
      ))
    colDetails <- result |>
      dplyr::select(dplyr::all_of(cols)) |>
      dplyr::distinct() |>
      dplyr::mutate("name" = sprintf("column%03i", dplyr::row_number()))
    result <- result |>
      dplyr::inner_join(colDetails, by = cols) |>
      dplyr::select(-dplyr::all_of(cols)) |>
      tidyr::pivot_wider(names_from = "name", values_from = "estimate_value")
    columns <- colDetails$name
  } else {
    columns <- "estimate_value"
  }

  # add spanners
  headerCols <- character()
  headerNameCols <- character()
  headerLevel <- character()
  gtResult <- gt::gt(result)
  for (k in seq_along(header)) {
    if (header[k] %in% cols) {
      spanners <- colDetails[[header[k]]] |> unique()
      for (span in spanners) {
        colsSpanner <- colDetails$name[colDetails[[header[k]]] == span]
        gtResult <- gtResult |>
          gt::tab_spanner(
            label = span |> styleName(),
            columns = colsSpanner,
            id = paste0(header[k], " ", span)
          )
        headerLevel <- c(headerLevel, paste0(header[k], " ", span))
      }
      headerNameCols <- c(headerNameCols, header[k])
    } else {
      headerCols <- c(headerCols, header[k])
    }
    gtResult <- gtResult |>
      gt::tab_spanner(
        label = header[k] |> styleName(),
        columns = columns,
        id = header[k]
      )
  }

  # style
  gtResult <- gtResult |>
    gt::tab_style(
      style = style$header,
      locations = gt::cells_column_spanners(spanners = headerCols)
    ) |>
    gt::tab_style(
      style = style$header_name,
      locations = gt::cells_column_spanners(spanners = headerNameCols)
    ) |>
    gt::tab_style(
      style = style$header_level,
      locations = gt::cells_column_spanners(spanners = headerLevel)
    )

  # columns
  if (length(cols) > 0) {
    for (col in colDetails$name) {
      gtResult <- gtResult |> gt::cols_label(!!!"" |> rlang::set_names(col))
    }
  }

  return(gtResult)
}

styleName <- function(x) {
  x <- snakecase::to_sentence_case(x)
  if (x == "") {
    x <- "-"
  }
  return(x)
}
