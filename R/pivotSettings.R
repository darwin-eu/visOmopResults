#' Add settings as columns
#'
#' @param result A summarised_result.
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
#' result <- mockSummarisedResult(settings = TRUE)
#' result |> pivotSettings()
#'
pivotSettings <- function(result) {
  assertTibble(result)
  assertClass(result, "summarised_result")

  settings <- result |> omopgenerics::settings()
  result_out <- result |>
    dplyr::filter(.data$variable_name != "settings") |>
    dplyr::left_join(settings,
                     by = c("result_id", "cdm_name", "result_type"))

  return(result_out)
}


