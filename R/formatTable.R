#' Format a summarised_result object into a gt, flextable or tibble object
#'
#' @param result A summarised_result.
#' @param formatEstimateName Named list of estimate name's to join, sorted by
#' computation order. Indicate estimate_name's between <...>.
#' @param header A vector containing which elements should go into the header
#' in order. Allowed are: `cdm_name`, `group`, `strata`, `additional`,
#' `variable`, `estimate`, `settings`.
#' @param groupColumn Column to use as group labels.
#' @param split A vector containing the name-level groups to split ("group",
#' "strata", "additional"), or an empty character vector to not split.
#' @param type Type of desired formatted table, possibilities: "gt",
#' "flextable", "tibble".
#' @param minCellCount Counts below which results will be clouded.
#' @param excludeColumns Columns to drop from the output table.
#' @param .options Named list with additional formatting options.
#' visOmopResults::optionsFormatTable() shows allowed arguments and
#' their default values.
#'
#' @return A tibble, gt, or flextable object.
#'
#'
#' @export
#'
#' @examples
#' mockSummarisedResult() |> formatTable(
#'   formatEstimateName = c("N%" = "<count> (<percentage>)",
#'                          "N" = "<count>",
#'                          "Mean (SD)" = "<mean> (<sd>)"),
#'   header = c("group"),
#'   split = c("group","strata",  "additional")
#' )
#'
formatTable <- function(result,
                        formatEstimateName,
                        header,
                        split,
                        groupColumn = NULL,
                        type = "gt",
                        minCellCount = 5,
                        excludeColumns = c("result_id", "result_type", "package_name", "package_version", "estimate_type"),
                        .options = list()) {
  # initial checks
  result <- omopgenerics::newSummarisedResult(result)
  assertChoice(type, c("gt", "flextable", "tibble"))
  assertCharacter(formatEstimateName)
  assertCharacter(header)
  assertCharacter(groupColumn, null = TRUE, length = 1)
  assertCharacter(split)
  assertCharacter(excludeColumns, null = TRUE)
  assertNumeric(minCellCount, length = 1, null = FALSE, integerish = TRUE)
  assertList(.options)
  if (length(split) > 0) {
    if (!all(split %in% c("group", "strata", "additional"))) {
      cli::cli_abort("Accepted values for split are: `group`, `strata`, and/or `additional`. It also supports an empty character vector (`character()`).")
    }
  }
  if ("cdm_name" %in% header & "cdm_name" %in% excludeColumns) {
    cli::cli_abort("`cdm_name` cannot be part of the header and also an excluded column.")
  }
  if(!all(header %in% c("cdm_name", "group", "strata", "additional", "estimate", "variable", "settings"))) {
    cli::cli_abort("Allowed values in header vector are: `cdm_name`, `group`, `strata`, `additional`, `estimate`, `variable`, and `settings`.")
  }

  # settings
  settings <- omopgenerics::settings(result)
  result <- result |> dplyr::filter(.data$variable_name != "settings")

  # .options
  .options <- defaultTableOptions(.options)

  # Supress counts & format estimates ----
  x <- result |>
    # think how to better handle min cell count in this process (formatEstimateName --> nothing if any is NA)
    omopgenerics::suppress(minCellCount = minCellCount) |>
    dplyr::mutate(estimate_value = dplyr::if_else(
      is.na(.data$estimate_value), paste0("<", .env$minCellCount), .data$estimate_value
    )) |>
    visOmopResults::formatEstimateValue(
      decimals = .options$decimals,
      decimalMark = .options$decimalMark,
      bigMark = .options$bigMark
    ) |>
    visOmopResults::formatEstimateName(
      estimateNameFormat = formatEstimateName,
      keepNotFormatted = .options$keepNotFormatted,
      useFormatOrder = .options$useFormatOrder
    )

  # Split & prepare header ----
  # Group:
  splitGroup <- "group" %in% split
  headerGroup <- "group" %in% header
  colsGroup <- character()
  if (headerGroup & splitGroup) {
    colsGroup <- visOmopResults::groupColumns(result)
    colsGroup <- lapply(as.list(colsGroup), function(element) {c(formatString(element), element)}) |> unlist()
    x <- x |> visOmopResults::splitGroup()
  } else if (headerGroup & !splitGroup) {
    if (length(visOmopResults::groupColumns(result)) > 0) {
      colsGroup <- c("group_name", "group_level")
    } else {
      x <- x |> visOmopResults::splitGroup()
    }
  } else if (!headerGroup & splitGroup) {
    x <- x |> visOmopResults::splitGroup()
  }

  # Strata:
  splitStrata <- "strata" %in% split
  headerStrata <- "strata" %in% header
  colsStrata <- character()
  if (headerStrata & splitStrata) {
    colsStrata <- visOmopResults::strataColumns(result)
    colsStrata <- lapply(as.list(colsStrata), function(element) {c(formatString(element), element)}) |> unlist()
    x <- x |> visOmopResults::splitStrata()
  } else if (headerStrata & !splitStrata) {
    if (length(visOmopResults::strataColumns(result)) > 0) {
      colsStrata <- c("strata_name", "strata_level")
    } else {
      x <- x |> visOmopResults::splitStrata()
    }
  } else if (!headerStrata & splitStrata) {
    x <- x |> visOmopResults::splitStrata()
  }

  # Additional:
  splitAdditional <- "additional" %in% split
  headerAdditional <- "additional" %in% header
  colsAdditional <- character()
  if (headerAdditional & splitAdditional) {
    colsAdditional <- visOmopResults::additionalColumns(result)
    colsAdditional <- lapply(as.list(colsAdditional), function(element) {c(formatString(element), element)}) |> unlist()
    x <- x |> visOmopResults::splitAdditional()
  } else if (headerAdditional & !splitAdditional) {
    if (length(visOmopResults::additionalColumns(result)) > 0) {
      colsAdditional <- c("additional_name", "additional_level")
    } else {
      x <- x |> visOmopResults::splitAdditional()
    }
  } else if (!headerAdditional & splitAdditional) {
    x <- x |> visOmopResults::splitAdditional()
  }

  # Others:
  colsVariable <- character()
  if ("variable" %in% header) {
    colsVariable = c("variable_name", "variable_level")
    x <- x |>
      dplyr::mutate(dplyr::across(dplyr::starts_with("variable"), ~ dplyr::if_else(is.na(.x), .options$na, .x)))
  }
  colsEstimate <- character()
  if ("estimate" %in% header) {
    colsEstimate = c("estimate_name")
  }
  colsSettings <- character()
  if ("settings" %in% header) {
    colsSettings <- colnames(settings)
    colsSettings <- colsSettings[!colsSettings %in% c("result_id", "cdm_name", "result_type")]
    if (length(colsSettings) > 0) {
      x <- x |>
        dplyr::left_join(
          settings |>
            tidyr::pivot_longer(cols = dplyr::all_of(colsSettings), names_to = "settings_name", values_to = "settings_level"),
          by = c("result_id", "cdm_name", "result_type"))
      colsSettings <- c("settings_name", "settings_level")
    } else {
      colsSettings <- character()
      cli::cli_warn("There are no settings to add in the header.")
    }
  }

  # Nice cases ----
  # Get relevant columns with nice cases (body and header)
  notFormat <- c("estimate_value", "cdm_name", colsGroup, colsStrata, colsAdditional, colsVariable, colsEstimate, colsSettings)
  notFormat <- notFormat[(notFormat %in% colnames(x)) & (!notFormat %in% excludeColumns)]
  x <- x |>
    dplyr::mutate(dplyr::across(.cols = !dplyr::all_of(c("cdm_name", "estimate_name")), .fn = ~ formatString(.x))) |>
    dplyr::select(!dplyr::all_of(excludeColumns)) |>
    dplyr::rename_with(
      .fn =  ~ formatString(.x),
      .cols = !dplyr::all_of(notFormat)
    )
  if (!"cdm_name" %in% header & !"cdm_name" %in% excludeColumns) {
    x <- x |> dplyr::rename("CDM name" = "cdm_name")
  }

  # Header ----
  # Format header
  formatHeader <- character()
  for (k in seq(header)) {
    formatHeader <- c(formatHeader,
                      switch(
                        header[k],
                        "cdm_name" = c("CDM name", "cdm_name"),
                        "group" = colsGroup,
                        "strata" = colsStrata,
                        "additional" = colsAdditional,
                        "estimate" = colsEstimate,
                        "variable" = colsVariable,
                        "settings" = colsSettings,
                      )
    )
  }

  if (length(formatHeader) > 0) {
    x <- x |>
      visOmopResults::formatHeader(
        header = formatHeader,
        delim = .options$delim,
        includeHeaderName = FALSE,
        includeHeaderKey = .options$includeHeaderKey
      )
  } else {
    x <- x |> dplyr::rename("Estimate value" = "estimate_value")
  }


  # Format table ----
  if (all(.options$colsToMergeRows %in% colnames(x))) {
    .options$colsToMergeRows <- formatString(.options$colsToMergeRows)
  }
  if (!is.null(groupColumn)) {
    if (groupColumn == "cdm_name") {
      groupColumn <- "CDM name"
    } else {
      groupColumn <- formatString(groupColumn)
    }
    if (!groupColumn %in% colnames(x)) {
      possibleGroups <- colnames(x)
      possibleGroups <- gsub(" ", "_", tolower(possibleGroups[!grepl("\\[header", possibleGroups)]))
      cli::cli_abort(c(paste0(
        "'", groupColumn, "' is not a column in the formatted table created."),
        "i" = paste0("Possible group columns are: '",
        paste0(possibleGroups, collapse = "', '"), "'"
      )))
    }
  }

  if (type == "gt") {
    x <- x |>
      visOmopResults::gtTable(
        delim = .options$delim,
        style = .options$style,
        na = .options$na,
        title = .options$title,
        subtitle = .options$subtitle,
        caption = .options$caption,
        groupNameCol = groupColumn,
        groupNameAsColumn = .options$groupNameAsColumn,
        groupOrder = .options$groupOrder,
        colsToMergeRows = .options$colsToMergeRows
      )
  } else if (type == "flextable") {
    x <- x |>
      visOmopResults::fxTable(
        delim = .options$delim,
        style = .options$style,
        na = .options$na,
        title = .options$title,
        subtitle = .options$subtitle,
        caption = .options$caption,
        groupNameCol = groupColumn,
        groupNameAsColumn = .options$groupNameAsColumn,
        groupOrder = .options$groupOrder,
        colsToMergeRows = .options$colsToMergeRows
      )
  } else if (type == "tibble") {
    class(x) <- class(x)[!class(x) %in% c("summarised_result", "omop_result")]
  }

  return(x)
}

formatString <- function(x) {
  stringr::str_to_sentence(gsub("_", " ", gsub("&&&", "and", x)))
}

defaultTableOptions <- function(userOptions) {
  defaultOpts <- list(
    decimals = c(integer = 0, percentage = 2, numeric = 2, proportion = 2),
    decimalMark = ".",
    bigMark = ",",
    keepNotFormatted = TRUE,
    useFormatOrder = TRUE,
    delim = "\n",
    includeHeaderKey = TRUE,
    style = "default",
    na = "-",
    title = NULL,
    subtitle = NULL,
    caption = NULL,
    groupNameAsColumn = FALSE,
    groupOrder = NULL,
    colsToMergeRows = "all_columns"
  )

  for (opt in names(userOptions)) {
    defaultOpts[[opt]] <- userOptions[[opt]]
  }

  return(defaultOpts)
}

#' Additional arguments for the function formatTable
#'
#' @description
#' It provides a list of allowed inputs for .option argument in
#' formatTable and their given default value.
#'
#'
#' @return The default .options named list.
#'
#' @export
#'
#' @examples
#' {
#' optionsFormatTable()
#' }
#'
#'
optionsFormatTable <- function() {
  return(defaultTableOptions(NULL))
}
