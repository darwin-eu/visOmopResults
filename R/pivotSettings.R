#' Add settings as columns
#'
#' @param x A summarised_result.
#'
#' @return A tibble.
#'
#' @description
#' `r lifecycle::badge("experimental")`
#' Pivot settings rows into columns.
#'
#' @export
#'
#' @examples
#' result <- mockSummarisedResult()
#'
#' result |> tidy()
#'
pivotSettings <- function(x) {
  assertTibble(x)

  settings <- x |> omopgenerics::settings()
  if (nrow(settings) > 0) {
    result_out <- x |>
      dplyr::filter(.data$variable_name != "settings") |>
      dplyr::left_join(settings,
                       by = c("result_id", "cdm_name", "result_type"))
  }

  return(result_out)
}


