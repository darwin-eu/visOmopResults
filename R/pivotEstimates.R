#' Set estimates as columns
#'
#' @param result A summarised_result.
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

#' Pivot longer multiple columns using the type column, so they can be pivoted
#' back. All values will be converted to characters.
#'
#' @param result A data.frame.
#' @param cols Columns of this data.frame that you want to pivot.
#' @param prefix Prefix for the new columns.
#'
#' @return The data.frame with the new 3 columns
#' @export
#'
#' @examples
#' library(dplyr, warn.conflicts = FALSE)
#'
#' tibble(
#'   cdm_name = c("mock 1", "mock 1", "mock 2", "mock 2"),
#'   cohort_name = c("cohort1", "cohort2", "cohort1", "cohort2"),
#'   age_mean = c(40L, 32L, 44L, 67L),
#'   blood_mode = c("A", "B", "0", "B")
#' ) |>
#'   pivotLongerType(cols = c("age_mean", "blood_mode"))
#'
pivotLongerType <- function(result,
                            cols,
                            prefix = "estimate") {
  # initial checks
  omopgenerics::assertCharacter(cols)
  if (length(cols) == 0) {
    cli::cli_abort("{.var cols} must select at least one column.")
  }
  omopgenerics::assertTable(result, class = "data.frame", columns = cols)
  omopgenerics::assertCharacter(prefix, length = 1)

  # new cols
  nms <- paste0(prefix, "_name")
  typ <- paste0(prefix, "_type")
  vls <- paste0(prefix, "_value")
  pos <- which(colnames(result) %in% cols)[1]

  # pivot estimates
  types <- purrr::map(result, \(x) dplyr::type_sum(x) |> getTypes())
  result |>
    dplyr::mutate(dplyr::across(dplyr::all_of(cols), as.character)) |>
    tidyr::pivot_longer(
      cols = dplyr::all_of(cols), names_to = nms, values_to = vls
    ) |>
    dplyr::mutate(!!!typeColumn(prefix, types)) |>
    dplyr::relocate(
      dplyr::all_of(c(paste0(prefix, c("_name", "_type", "_value")))),
      .before = !!pos
    )
}
getTypes <- function(x) {
  x
}
typeColumn <- function(prefix, types) {
  paste0(
    "dplyr::case_when(",
    paste0(
      '.data[["', prefix, '_name"]] == "', names(types), '" ~ "', unlist(types),
      '"', collapse = ", "
    ),
    ")"
  ) |>
    rlang::parse_exprs() |>
    rlang::set_names(paste0(prefix, "_type"))
}
