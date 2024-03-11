#' Get a tidy visualization of a summarised_result object
#'
#' @param result A summarised_result.
#' @param split Whether to split all name/level column pairs or not.
#' @param pivotSettings TRUE to pivot settings into columns, and FALSE to remove
#' them form the results.
#' @param pivotEstimatesBy Names from which pivot wider the estimate values. If
#' NULL the table will not be pivotted.
#' @param glueName Name style (glue package specifications) to customize names
#' when pivotting estimates.
#'
#' @return A tibble.
#'
#' @description
#' \\ifelse{html}{\\href{https://lifecycle.r-lib.org/articles/stages.html#experimental}{\\figure{lifecycle-experimental.svg}{options: alt='[Experimental]'}}}{\\strong{[Experimental]}}
#' Provides tools for obtaining for tidying a summarised_result object.
#'
#'
#' @export
#'
#' @examples
#' result <- mockSummarisedResult()
#'
#' result |> tidySummarisedResult()

tidySummarisedResult <- function(result,
                                 split = TRUE,
                                 pivotSettings = TRUE,
                                 pivotEstimatesBy = NULL,
                                 estimateLabels = NULL) {
  # initial checks
  assertTibble(result, columns = pivotEstimatesBy)
  assertLogical(split, length = 1)
  assertLogical(pivotSettings, length = 1)
  assertCharacter(pivotEstimatesBy, null = TRUE)
  assertCharacter(estimateLabels, null = TRUE)

  # code
  result_out <- result |>
    dplyr::filter(variable_name != "settings")

  if (split) {
    result_out <- result_out |> splitAll()
  }

  if (length(pivotEstimatesBy) > 0) {
    typeNameConvert <- result_out |>
      dplyr::distinct(dplyr::across(dplyr::all_of(c("estimate_type", pivotEstimatesBy)))) |>
      dplyr::mutate(estimate_type = dplyr::case_when(
        grepl("percentage|proportion", .data$estimate_name) ~ "numeric",
        !grepl("numeric|percentage|proportion|integer|date|double|logical|character", .data$estimate_type) ~ "character",
        .default = .data$estimate_type
      ),
      new_name = glue::glue(estimateLabels)
      )

    result_out <- result_out |>
      dplyr::select(-"estimate_type") |>
      tidyr::pivot_wider(
        names_from = pivotEstimatesBy,
        values_from = "estimate_value",
        names_glue = estimateLabels
      ) |>
      dplyr::mutate(
        dplyr::across(dplyr::all_of(typeNameConvert$new_name),
                      ~ asEstimateType(.x,
                                       name = deparse(substitute(.)),
                                       dict = typeNameConvert))
      )
  }

  if (pivotSettings) {
    result_out <- result_out |>
      dplyr::left_join(result |> omopgenerics::settings(),
                       by = c("result_id", "cdm_name", "result_type"))
  }

  return(result_out)
}

asEstimateType <- function(x, name, dict) {
  type <- dict$estimate_type[dict$new_name == name]
  return(eval(parse(text = paste0("as.", type, "(x)"))))
}
