#' Append settings as rows in a summarised result
#'
#' @param x A tibble with columns from summarised result and columns
#' corresponding to settings.
#' @param colsSettings Columns of x to append as settings rows.
#'
#' @return A tibble.
#'
#' @description
#' `r lifecycle::badge("experimental")`
#'
#'
#' @export
#'
#' @examples
#' result <- mockSummarisedResult()[1,] |>
#' dplyr::mutate(
#'   mock_default = TRUE,
#'   example_setting = 1
#' )
#' appendSettings(result, colsSettings = c("mock_default", "example_setting"))
#'

appendSettings <- function(x, colsSettings) {
  # initial checks
  assertCharacter(colsSettings, null = TRUE)
  assertTibble(x, columns = colsSettings)

  # check if there is already a x id
  if("result_id" %in% colnames(x)) {
    ids <- x |>
      dplyr::select(dplyr::all_of(c("result_id", colsSettings))) |> # !!! canviar depnent result_id uniqueness
      dplyr::distinct()
    x <- x |>
      dplyr::select(!dplyr::all_of(colsSettings))
    # check result_id linked to one set of settings:
    if (nrow(ids) != length(unique(ids$result_id))) {
      cli::cli_abort("Settings do not match result ids.")
    }
  } else {
    ids <- x |>
      dplyr::select(dplyr::all_of(columnsToDistinct)) |> # !!! canviar depnent result_id uniqueness
      dplyr::distinct() |>
      dplyr::mutate("result_id" = as.integer(dplyr::row_number()))
    x <- x |>
      dplyr::left_join(ids, by = colsSettings) |>
      dplyr::select(!dplyr::all_of(colsSettings)) |>
      dplyr::relocate("result_id")
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
      "additional_level" = "overall"
    ) |>
    dplyr::left_join(
      x |>
        dplyr::distinct(dplyr::all_of(c("result_id", "cdm_name", "result_type", "package_name", "package_version"))),
      by = "result_id"
    )
  # check if there are non-summarised result columns
  nonS <- !colnames(x) %in% c(omopgenerics::resultColumns(), colsSettings)
  if(sum(nonS) > 0) {
    toFillNa <- colnames(x)[nonS]
    settingsIds[toFillNa] = NA_character_
  }
  settingsIds <- settingsIds |>
    dplyr::select(dplyr::all_of(colnames(x)))
  # append settings
  x <- settingsIds |>
    dplyr::union_all(x) |>
    dplyr::arrange(.data$result_id)
  return(x)
}


variableTypes <- function(table) {
  assertTable(table)
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
    "chr" = "character",
    "fct" = "character",
    "ord" = "character",
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
