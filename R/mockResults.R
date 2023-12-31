
#' A summarised_result mock object.
#'
#' @export
#'
#' @examples
#' \donttest{
#' mockSummarisedResult()
#' }
#'
mockSummarisedResult <- function() {
  # TO modify when PatientProfiles works with omopgenerics
  dplyr::tibble(
    "cdm_name" = "mock",
    "result_type" = NA_character_,
    "package_name" = "gtSummarisedResult",
    "package_version" = utils::packageVersion("gtSummarisedResult") |>
      as.character(),
    "group_name" = "cohort_name",
    "group_level" = c(rep("cohort1", 9), rep("cohort2", 9)),
    "strata_name" = rep(c(
      "overall", rep("age_group and sex", 4), rep("sex", 2), rep("age_group", 2)
    ), 2),
    "strata_level" = rep(c(
      "overall", "<40 and Male", ">=40 and Male", "<40 and Female",
      ">=40 and Female", "Male", "Female", "<40", ">=40"
    ), 2),
    "variable_name" = "number subjects",
    "variable_level" = NA_character_,
    "estimate_name" = "count",
    "estimate_type" = "integer",
    "estimate_value" = round(100*stats::runif(18)) |> as.character(),
    "additional_name" = "overall",
    "additional_level" = "overall"
  ) |>
    omopgenerics::summarisedResult()
}
