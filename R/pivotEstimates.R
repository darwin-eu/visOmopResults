#' Set estimates as columns
#'
#' @param result A `<summarised_result>`.
#' @param pivotEstimatesBy Names from which pivot wider the estimate values. If
#' NULL the table will not be pivotted.
#' @param nameStyle Name style (glue package specifications) to customise names
#' when pivotting estimates. If NULL standard tidyr::pivot_wider formatting will
#' be used.
#'
#' @return A tibble.
#'
#' @description
#' Pivot the estimates as new columns in result table.
#'
#' @export
#'
#' @examples
#' result <- mockSummarisedResult()
#' result |> pivotEstimates()
#'
pivotEstimates <- function(result,
                           pivotEstimatesBy = "estimate_name",
                           nameStyle = NULL) {
  # initial checks
  pivotEstimatesBy <- validatePivotEstimatesBy(pivotEstimatesBy = pivotEstimatesBy)
  omopgenerics::assertCharacter(nameStyle, null = TRUE, length = 1)
  omopgenerics::assertTable(result, columns = pivotEstimatesBy)

  # pivot estimates
  result_out <- result
  if (length(pivotEstimatesBy) > 0) {
    if (is.null(nameStyle)) {
      nameStyle <- paste0("{", paste0(pivotEstimatesBy, collapse = "}_{"), "}")
    }
    if(grepl("__", nameStyle)){
      cli::cli_warn(c("!" = "Double underscores found in 'nameStyle'. Converting to a single underscore."))
    }
    typeNameConvert <- result |>
      dplyr::distinct(dplyr::across(dplyr::all_of(c("estimate_type", pivotEstimatesBy)))) |>
      dplyr::mutate(
        estimate_type = dplyr::case_when(
          grepl("percentage|proportion", .data$estimate_type) ~ "numeric",
          "date" == .data$estimate_type ~ "Date",
          .default = .data$estimate_type
        ),
        new_name = glue::glue(nameStyle, .na = "") |>
          stringr::str_replace_all("_+", "_") |> #remove multiple _
          stringr::str_replace_all("^_|_$", "") #remove leading/trailing _
      )

    result_out <- result |>
      dplyr::select(-"estimate_type") |>
      tidyr::pivot_wider(
        names_from = dplyr::all_of(pivotEstimatesBy),
        values_from = "estimate_value",
        names_glue = nameStyle
      ) |>
      dplyr::rename_with(~ stringr::str_remove_all(., "_NA|NA_")) |>
      dplyr::mutate(
        dplyr::across(dplyr::all_of(typeNameConvert$new_name),
                      ~ asEstimateType(.x, name = deparse(substitute(.)), dict = typeNameConvert)
        )
      )
  }
  return(result_out)
}

asEstimateType <- function(x, name, dict) {
  type <- dict$estimate_type[dict$new_name == name]
  return(eval(parse(text = paste0("as.", type, "(x)"))))
}
