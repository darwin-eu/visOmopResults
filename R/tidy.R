#' Get a tidy visualization of a summarised_result object
#'
#' @param x A summarised_result.
#' @param splitGroup If TRUE it will split the group name-level column pair.
#' @param splitStrata If TRUE it will split the group name-level column pair.
#' @param splitAdditional If TRUE it will split the group name-level column pair.
#' @param pivotEstimatesBy Names from which pivot wider the estimate values. If
#' NULL the table will not be pivotted.
#' @param nameStyle Name style (glue package specifications) to customize names
#' when pivotting estimates. If NULL standard tidyr::pivot_wider formatting will
#' be used.
#' @param ... For compatibility (not used).
#'
#' @return A tibble.
#'
#' @description
#' `r lifecycle::badge("experimental")`
#' Provides tools for obtaining a tidy version of a summarised_result object. If
#' the summarised results object contains settings, these will be transformed
#' into columns.
#'
#' @export
#'
#' @examples
#' result <- mockSummarisedResult()
#'
#' result |> tidy()
#'
tidy.summarised_result <- function(x,
                                   splitGroup = TRUE,
                                   splitStrata = TRUE,
                                   splitAdditional = TRUE,
                                   pivotEstimatesBy = "estimate_name",
                                   nameStyle = NULL,
                                   ...) {
  # initial checks
  assertTibble(x, columns = pivotEstimatesBy)
  assertLogical(splitGroup, length = 1)
  assertLogical(splitStrata, length = 1)
  assertLogical(splitAdditional, length = 1)
  assertCharacter(pivotEstimatesBy, null = TRUE)
  assertCharacter(nameStyle, null = TRUE)

  # code
  result_out <- x |>
    dplyr::filter(.data$variable_name != "settings")

  if (splitGroup) {
    result_out <- result_out |> splitGroup()
  }
  if (splitStrata) {
    result_out <- result_out |> splitStrata()
  }
  if (splitAdditional) {
    result_out <- result_out |> splitAdditional()
  }

  if (length(pivotEstimatesBy) > 0) {
    if (is.null(nameStyle)) {
      nameStyle <- paste0("{", paste0(pivotEstimatesBy, collapse = "}_{"), "}")
    }
    typeNameConvert <- result_out |>
      dplyr::distinct(dplyr::across(dplyr::all_of(c("estimate_type", pivotEstimatesBy)))) |>
      dplyr::mutate(estimate_type = dplyr::case_when(
        grepl("percentage|proportion", .data$estimate_name) ~ "numeric",
        !grepl("numeric|percentage|proportion|integer|date|double|logical|character", .data$estimate_type) ~ "character",
        .default = .data$estimate_type
      ),
      new_name = glue::glue(nameStyle)
      )
    result_out <- result_out |>
      dplyr::select(-"estimate_type") |>
      tidyr::pivot_wider(
        names_from = dplyr::all_of(pivotEstimatesBy),
        values_from = "estimate_value",
        names_glue = nameStyle
      ) |>
      dplyr::mutate(
        dplyr::across(dplyr::all_of(typeNameConvert$new_name),
                      ~ asEstimateType(.x, name = deparse(substitute(.)), dict = typeNameConvert)
        )
      )
  }

  settings <- x |> omopgenerics::settings()
  if (nrow(settings) > 0) {
    result_out <- result_out |>
      dplyr::left_join(settings,
                       by = c("result_id", "cdm_name", "result_type"))
  }

  return(result_out)
}

asEstimateType <- function(x, name, dict) {
  type <- dict$estimate_type[dict$new_name == name]
  return(eval(parse(text = paste0("as.", type, "(x)"))))
}

