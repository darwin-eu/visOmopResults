#' Format a summarised_result object into a gt, flextable or tibble object
#'
#' @param result A summarised_result.
#' @param formatEstimateName Named list of estimate name's to join, sorted by
#' computation order. Indicate estimate_name's between <...>.
#' @param header A vector containing which elements should go into the header
#' in order (`cdm_name`, `group`, `strata`, `additional`,
#' `variable`, `estimate`, and `settings`).
#' @param groupColumn Column to use as group labels.
#' @param split A vector containing the name-level groups to split ("group",
#' "strata", "additional"), or an empty character vector to not split.
#' @param type Type of desired formatted table, possibilities: "gt",
#' "flextable", "tibble".
#' @param renameColumns Named vector to customisa column names, for instance:
#' c("Database name" = "cdm_name")). By default column names are transformed to
#' sentence case.
#' @param minCellCount Counts below which results will be clouded.
#' @param excludeColumns Columns to drop from the output table.
#' @param .options Named list with additional formatting options.
#' visOmopResults::optionsvisOmopTable() shows allowed arguments and
#' their default values.
#'
#' @return A tibble, gt, or flextable object.
#'
#'
#' @export
#'
#' @examples
#' mockSummarisedResult() |> visOmopTable(
#'   formatEstimateName = c("N%" = "<count> (<percentage>)",
#'                          "N" = "<count>",
#'                          "Mean (SD)" = "<mean> (<sd>)"),
#'   header = c("group"),
#'   split = c("group","strata",  "additional")
#' )
#'
visOmopTable <- function(result,
                        formatEstimateName,
                        header,
                        split,
                        groupColumn = NULL,
                        type = "gt",
                        renameColumns = NULL,
                        minCellCount = 5,
                        excludeColumns = c("result_id", "estimate_type"),
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
  assertCharacter(renameColumns, null = TRUE, named = TRUE)
  if (length(split) > 0) {
    if (!all(split %in% c("group", "strata", "additional"))) {
      cli::cli_abort("Accepted values for split are: `group`, `strata`, and/or `additional`. It also supports an empty character vector (`character()`).")
    }
  }
  if ("cdm_name" %in% header & "cdm_name" %in% excludeColumns) {
    cli::cli_abort("`cdm_name` cannot be part of the header and also an excluded column.")
  }
  if (!is.null(renameColumns)) {
    notCols <- !renameColumns %in% colnames(result)
    if (sum(notCols) > 0) {
      cli::cli_warn("The following values of `renameColumns` do not refer to column names and will be ignored: {renameColumns[notCols]}")
      renameColumns <- renameColumns[!notCols]
    }
  }
  if ("cdm_name" %in% header & "cdm_name" %in% renameColumns) {
    cdmName <- names(renameColumns)[renameColumns == "cdm_name"]
    renameColumns <- renameColumns[renameColumns != "cdm_name"]
  } else {
    cdmName <- "CDM name"
  }

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
  # Settings:
  settings <- omopgenerics::settings(result)
  colsSettings <- character()
  if ("settings" %in% header) {
    colsSettings <- colnames(settings)
    x <- x |> addSettings()
  } else {
    x <- x
  }
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

  # Nice cases ----
  # Get relevant columns with nice cases (body and header)
  notFormat <- c("estimate_value", "cdm_name", colsGroup, colsStrata, colsAdditional, colsVariable, colsEstimate, colsSettings)
  if (!is.null(renameColumns)) {
    ids = renameColumns %in% notFormat & renameColumns != "cdm_name"
    if (sum(ids) > 0) {
      renameColumns = renameColumns[!ids]
    }
    notFormat <- c(notFormat, renameColumns)
  }
  notFormat <- notFormat[(notFormat %in% colnames(x)) & (!notFormat %in% excludeColumns)]
  x <- x |>
    dplyr::mutate(dplyr::across(
      .cols = !dplyr::all_of(c("cdm_name", "estimate_name")), .fn = ~ formatString(.x)
    )) |>
    dplyr::select(!dplyr::all_of(excludeColumns)) |>
    dplyr::rename_with(
      .fn =  ~ formatString(.x),
      .cols = !dplyr::all_of(notFormat)
    )
  if (!"cdm_name" %in% header & !"cdm_name" %in% excludeColumns) {
    if ((!is.null(renameColumns) & !"cdm_name" %in% renameColumns) | length(renameColumns) == 0) {
      x <- x |> dplyr::rename(!!cdmName := "cdm_name")
    }
  }
  if (!is.null(renameColumns)) {
    colsSorted <- colnames(x)[colnames(x) %in% renameColumns]
    newNames <- names(renameColumns)
    names(newNames) <- renameColumns
    colnames(x)[colnames(x) %in% renameColumns] <- newNames[colsSorted]
  }


  # Header ----
  # Format header
  formatHeader <- character()
  for (k in seq(header)) {
    if (header[k] %in% c("cdm_name", "group", "strata", "additional", "estimate", "variable", "settings")) {
      formatHeader <- c(formatHeader,
                        switch(
                          header[k],
                          "cdm_name" = c(cdmName, "cdm_name"),
                          "group" = colsGroup,
                          "strata" = colsStrata,
                          "additional" = colsAdditional,
                          "estimate" = colsEstimate,
                          "variable" = colsVariable,
                          "settings" = colsSettings,
                        )
      )
    } else {
      formatHeader <- c(formatHeader, header[k])
    }
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

#' Additional arguments for the function visOmopTable
#'
#' `r lifecycle::badge("deprecated")`
#'
#' @description
#' It provides a list of allowed inputs for .option argument in
#' visOmopTable and their given default value.
#'
#'
#' @return The default .options named list.
#'
#' @export
#'
#' @examples
#' {
#' optionsVisOmopTable()
#' }
#'
#'
optionsVisOmopTable <- function() {
  return(defaultTableOptions(NULL))
}



#' Format a summarised_result object into a gt, flextable or tibble object
#'
#' @param result A summarised_result.
#' @param formatEstimateName Named list of estimate name's to join, sorted by
#' computation order. Indicate estimate_name's between <...>.
#' @param header A vector containing which elements should go into the header
#' in order (`cdm_name`, `group`, `strata`, `additional`,
#' `variable`, `estimate`, and `settings`).
#' @param groupColumn Column to use as group labels.
#' @param split A vector containing the name-level groups to split ("group",
#' "strata", "additional"), or an empty character vector to not split.
#' @param type Type of desired formatted table, possibilities: "gt",
#' "flextable", "tibble".
#' @param renameColumns Named vector to customisa column names, for instance:
#' c("Database name" = "cdm_name")). By default column names are transformed to
#' sentence case.
#' @param minCellCount Counts below which results will be clouded.
#' @param excludeColumns Columns to drop from the output table.
#' @param .options Named list with additional formatting options.
#' visOmopResults::optionsvisOmopTable() shows allowed arguments and
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
                         renameColumns = NULL,
                         minCellCount = 5,
                         excludeColumns = c("result_id", "estimate_type"),
                         .options = list()) {

  lifecycle::deprecate_soft(
    when = "0.3.0",
    what = "formatTable()",
    with = "visOmopTable()"
  )

  visOmopTable(result = result,
              formatEstimateName = formatEstimateName,
              header = header,
              split = split,
              groupColumn = groupColumn,
              type = type,
              renameColumns = renameColumns,
              minCellCount = minCellCount,
              excludeColumns = excludeColumns,
              .options = .options)
}
