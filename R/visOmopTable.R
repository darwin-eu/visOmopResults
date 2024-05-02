#' Format a summarised_result object into a gt, flextable or tibble object
#'
#' @param result A summarised_result.
#' @param formatEstimateName Named list of estimate name's to join, sorted by
#' computation order. Indicate estimate_name's between <...>.
#' @param header A vector containing which elements should go into the header
#' in order (`cdm_name`, `group`, `strata`, `additional`,
#' `variable`, `estimate`, and `settings`).
#' @param groupColumn Columns to use as group labels. By default the name of the
#' new group will be the column names separated by "_". To specify a new
#' grouping name enter a named list such as:
#' list(`newGroupName` = c("variable_name", "variable_level"))
#' @param split A vector containing the name-level groups to split ("group",
#' "strata", "additional"), or an empty character vector to not split.
#' @param type Type of desired formatted table, possibilities: "gt",
#' "flextable", "tibble".
#' @param renameColumns Named vector to customise column names, for instance:
#' c("Database name" = "cdm_name")). By default column names are transformed to
#' sentence case.
#' @param showMinCellCount If TRUE, suppressed estimates will be indicated with
#' "<\{minCellCount\}", otherwise the default na defined in `.options` will
#' be used.
#' @param minCellCount `r lifecycle::badge("deprecated")` Suppression of
#' estimates when counts < minCellCount should be done before with
#' `ompogenerics::suppress()`.
#' @param excludeColumns Columns to drop from the output table.
#' @param .options Named list with additional formatting options.
#' visOmopResults::optionsVisOmopTable() shows allowed arguments and
#' their default values.
#'
#' @return A tibble, gt, or flextable object.
#'
#'
#' @export
#'
#' @examples
#' mockSummarisedResult() |>
#' visOmopTable(
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
                         showMinCellCount = TRUE,
                         minCellCount = lifecycle::deprecated(),
                         excludeColumns = c("result_id", "estimate_type"),
                         .options = list()) {

  if (lifecycle::is_present(minCellCount)) {
    lifecycle::deprecate_warn("0.3.0", "visOmopTable(minCellCount)")
  }

  # initial checks
  result <- omopgenerics::newSummarisedResult(result)
  assertChoice(type, c("gt", "flextable", "tibble"))
  assertCharacter(formatEstimateName)
  assertCharacter(header)
  assertCharacter(split)
  assertCharacter(excludeColumns, null = TRUE)
  assertList(.options)
  assertLogical(showMinCellCount, length = 1)
  assertCharacter(renameColumns, null = TRUE, named = TRUE)
  checkGroupColumn(groupColumn)
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
  if ("group" %in% split & any(grepl("group", excludeColumns))) {
    cli::cli_abort("`group` columns cannot be splitted and excluded at the same time. ")
  }
  if ("strata" %in% split & any(grepl("strata", excludeColumns))) {
    cli::cli_abort("`strata` columns cannot be splitted and excluded at the same time. ")
  }
  if ("additional" %in% split & any(grepl("additional", excludeColumns))) {
    cli::cli_abort("`additional` columns cannot be splitted and excluded at the same time. ")
  }
  if (inherits(groupColumn, "list")) {
    nameGroup <- names(groupColumn)
    groupColumn <- groupColumn[[1]]
  } else if (length(groupColumn) > 1) {
    nameGroup <- paste0(groupColumn, collapse = "_")
  }

  # .options
  .options <- defaultTableOptions(.options)

  # Format estimates ----
  settings <- omopgenerics::settings(result)
  if (!"min_cell_count" %in% colnames(settings)) {
    cli::cli_inform(c("!" = "Results have not been suppressed."))
    showMinCellCount <- FALSE
  }
  if (showMinCellCount) {
    result <- result |>
      dplyr::left_join(
        settings |> dplyr::select("result_id", "min_cell_count"),
        by = "result_id"
      ) |>
      dplyr::mutate(estimate_value = dplyr::if_else(
        is.na(.data$estimate_value), paste0("<", base::format(.data$min_cell_count, big.mark = ",")), .data$estimate_value
      )) |>
      dplyr::select(!"min_cell_count")
  }

  x <- result |>
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
    if (all(is.na(x$variable_level))) {
      colsVariable <- c("variable_name")
      excludeColumns <- c(excludeColumns, "variable_level")
    }
    x <- x |>
      dplyr::mutate(dplyr::across(dplyr::starts_with("variable"), ~ dplyr::if_else(is.na(.x), .options$na, .x)))
  }
  colsEstimate <- character()
  if ("estimate" %in% header) {
    colsEstimate = c("estimate_name")
  }

  # Nice cases ----
  # renames
  if (! "cdm_name" %in% renameColumns) {
    renameColumns <- c(renameColumns, "CDM name" = "cdm_name")
  }
  cdmName <- names(renameColumns)[renameColumns == "cdm_name"]
  # columns not to format
  notFormat <- c("estimate_value", colsGroup, colsStrata, colsAdditional,
                 colsVariable, colsEstimate, colsSettings) |> unique()

  # dont rename columns in notFormat
  ids = renameColumns %in% notFormat
  if (sum(ids) > 0) {
    renameColumns = renameColumns[!ids]
  }
  notFormat <- c(notFormat, renameColumns)
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

  # rename columns manually
  if ("cdm_name" %in% header) {
    renameColumns <- renameColumns[!renameColumns %in% "cdm_name"]
  }
  if (length(renameColumns) > 0) {
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
    ids <- .options$colsToMergeRows %in% renameColumns
    if (any(ids)) {
      colsSorted <- .options$colsToMergeRows[.options$colsToMergeRows %in% renameColumns]
      newNames <- names(renameColumns)
      names(newNames) <- renameColumns
      .options$colsToMergeRows[ids] <- newNames[colsSorted]
    }
    .options$colsToMergeRows[!ids] <- formatString(.options$colsToMergeRows[!ids])
  }

  if (!is.null(groupColumn)) {
    # rename
    ids <- groupColumn %in% renameColumns
    newGroupcolumn <- groupColumn
    if (any(ids)) {
      colsSorted <- newGroupcolumn[newGroupcolumn %in% renameColumns]
      newNames <- names(renameColumns)
      names(newNames) <- renameColumns
      newGroupcolumn[ids] <- newNames[colsSorted]
    }
    newGroupcolumn[!ids] <- formatString(newGroupcolumn[!ids])
    # check compatibility
    idsGroup <- !newGroupcolumn %in% colnames(x)
    if (any(idsGroup)) {
      possibleGroups <- colnames(x)[!grepl("\\[header", colnames(x))]
      for (k in 1:length(possibleGroups)) {
        if (possibleGroups[k] %in% names(renameColumns)) {
          possibleGroups[k] <- renameColumns[possibleGroups[k]]
        } else {
          possibleGroups[k] <- gsub(" ", "_", tolower(possibleGroups[k]))
        }
      }
      cli::cli_abort(c(paste0(
        "{groupColumn[idsGroup]} is not a column in the formatted table created."),
        "i" = paste0("Possible group columns are: '", paste0(possibleGroups, collapse = "', '"), "'"
        )))
    }
    # > 1 group
    if (length(newGroupcolumn) > 1) {
      x <- x |>
        tidyr::unite(!!nameGroup, dplyr::all_of(newGroupcolumn), sep = "; ")
      newGroupcolumn <- nameGroup
    }
  } else {
    newGroupcolumn <- NULL
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
        groupColumn = newGroupcolumn,
        groupAsColumn = .options$groupAsColumn,
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
        groupColumn = newGroupcolumn,
        groupAsColumn = .options$groupAsColumn,
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
    groupAsColumn = FALSE,
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
#' `r lifecycle::badge("deprecated")`
#'
#' @param result A summarised_result.
#' @param formatEstimateName Named list of estimate name's to join, sorted by
#' computation order. Indicate estimate_name's between <...>.
#' @param header A vector containing which elements should go into the header
#' in order (`cdm_name`, `group`, `strata`, `additional`,
#' `variable`, `estimate`, and `settings`).
#' @param groupColumn Columns to use as group labels. By default the name of the
#' new group will be the column names separated by "_". To specify a new
#' grouping name enter a named list such as:
#' list(`newGroupName` = c("variable_name", "variable_level"))
#' @param split A vector containing the name-level groups to split ("group",
#' "strata", "additional"), or an empty character vector to not split.
#' @param type Type of desired formatted table, possibilities: "gt",
#' "flextable", "tibble".
#' @param renameColumns Named vector to customise column names, for instance:
#' c("Database name" = "cdm_name")). By default column names are transformed to
#' sentence case.
#' @param minCellCount `r lifecycle::badge("deprecated")` Suppression of
#' estimates when counts < minCellCount should be done before with
#' `ompogenerics::suppress()`.
#' @param excludeColumns Columns to drop from the output table.
#' @param .options Named list with additional formatting options.
#' visOmopResults::optionsVisOmopTable() shows allowed arguments and
#' their default values.
#'
#' @return A tibble, gt, or flextable object.
#'
#' @description
#' `formatTable()` was renamed to `visOmopTable()`
#'
#' @keywords internal
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
                        minCellCount = lifecycle::deprecated(),
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
               excludeColumns = excludeColumns,
               .options = .options
  )
}
