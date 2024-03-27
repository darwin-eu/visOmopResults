appendSettings <- function(result, colsSettings) {
  # initial checks
  assertTibble(result, columns = colsSettings)
  assertCharacter(colsSettings, null = TRUE)

  # check if there is already a result id
  if("result_id" %in% colnames(result)) {
    ids <- result |>
      dplyr::select(dplyr::all_of(c("result_id", colsSettings))) |>
      dplyr::distinct()
    result <- result |>
      dplyr::select(!dplyr::all_of(colsSettings))
    # check result_id linked to one set of settings:
    if (nrow(ids) != length(unique(ids$result_id))) {
      cli::cli_abort("Settings do not match result ids.")
    }
  } else {
    ids <- result |>
      dplyr::select(dplyr::all_of(colsSettings)) |>
      dplyr::distinct() |>
      dplyr::mutate("result_id" = as.integer(dplyr::row_number()))
    result <- result |>
      dplyr::left_join(ids, by = colsSettings) |>
      dplyr::select(!dplyr::all_of(colsSettings))
  }
  # format settings to summarised
  settingsIds <- ids |>
    tidyr::pivot_longer(
      cols = dplyr::all_of(colsSettings),
      names_to = "estimate_name",
      values_to = "estimate_value"
    ) |>
    dplyr::inner_join(
      # change to PatientProfiles once released
      variableTypes(ids) |>
        dplyr::select(
          "estimate_name" = "variable_name", "estimate_type" = "variable_type"
        ) |>
        dplyr::mutate("estimate_type" = dplyr::if_else(
          .data$estimate_type == "categorical", "character", .data$estimate_type
        )),
      by = "estimate_name"
    ) |>
    dplyr::mutate(
      "estimate_value" = as.character(.data$estimate_value),
      "variable_name" = "settings",
      "variable_level" = NA_character_,
      "group_name" = "overall",
      "group_level" = "overall",
      "strata_name" = "overall",
      "strata_level" = "overall",
      "additional_name" = "overall",
      "additional_level" = "overall",
      "package_name" = result$package_name[1],
      "package_version" = result$package_version[1],
      "result_type" = result$result_type[1],
      "cdm_name" = result$cdm_name[1]
    )
  # append settings
  result <- settingsIds |>
    dplyr::union_all(result) |>
    dplyr::arrange(.data$result_id) |>
    dplyr::select(dplyr::all_of(omopgenerics::resultColumns()))
  return(result)
}


variableTypes <- function(table) {
  if (ncol(table) > 0) {
    x <- dplyr::tibble(
      "variable_name" = colnames(table),
      "variable_type" = lapply(colnames(table), function(x) {
        table %>%
          dplyr::select(dplyr::all_of(x)) %>%
          utils::head(1) %>%
          dplyr::pull() %>%
          dplyr::type_sum() |>
          assertClassification()
      }) %>% unlist()
    )
  } else {
    x <- dplyr::tibble(
      "variable_name" = character(),
      "variable_type" = character()
    )
  }
  return(x)
}

#' @noRd
assertClassification <- function(x) {
  switch (
    x,
    "chr" = "categorical",
    "fct" = "categorical",
    "ord" = "categorical",
    "date" = "date",
    "dttm" = "date",
    "lgl" = "logical",
    "drtn" = "numeric",
    "dbl" = "numeric",
    "int" = "integer",
    "int64" = "integer",
    NA_character_
  )
}
