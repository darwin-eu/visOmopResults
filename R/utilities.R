# Copyright 2025 DARWIN EU®
#
# This file is part of visOmopResults
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# Validate functions specific of `visOmopResults` package

validateDecimals <- function(result, decimals) {
  nm_type <- omopgenerics::estimateTypeChoices()
  nm_type <- nm_type[!nm_type %in% c("logical", "date")]
  nm_name <- result[["estimate_name"]] |> unique()
  nm_name <- nm_name[!nm_name %in% c("logical", "date")]
  errorMesssage <- "`decimals` must be named integerish vector. Names refere to estimate_type or estimate_name values."

  if (is.null(decimals)) {
  } else if (any(is.na(decimals))) { # NA
    cli::cli_abort(errorMesssage)
  } else if (!is.numeric(decimals)) { # not numeric
    cli::cli_abort(errorMesssage)
  } else if (!all(decimals == floor(decimals))) { # not integer
    cli::cli_abort(errorMesssage)
  } else if (!all(names(decimals) %in% c(nm_type, nm_name))) { # not correctly named
    conflict_nms <- names(decimals)[!names(decimals) %in% c(nm_type, nm_name)]
    if ("date" %in% conflict_nms) {
      cli::cli_warn("`date` will not be formatted.")
      conflict_nms <- conflict_nms[!conflict_nms %in% "date"]
      decimals <- decimals[!names(decimals) %in% "date"]
    }
    if ("logical" %in% conflict_nms) {
      cli::cli_warn("`logical` will not be formatted.")
      conflict_nms <- conflict_nms[!conflict_nms %in% "logical"]
      decimals <- decimals[!names(decimals) %in% "logical"]
    }
    if (length(conflict_nms) > 0) {
      cli::cli_abort(paste0(paste0(conflict_nms, collapse = ", "), " do not correspond to estimate_type or estimate_name values."))
    }
  } else if (length(decimals) == 1 & is.null(names(decimals))) { # same number to all
    decimals <- rep(decimals, length(nm_type))
    names(decimals) <- nm_type
  } else {
    decimals <- c(decimals[names(decimals) %in% nm_name],
                  decimals[names(decimals) %in% nm_type])
  }

  return(decimals)
}

validateEstimateName <- function(format, call = parent.frame()) {
  omopgenerics::assertCharacter(format, null = TRUE)
  if (!is.null(format)) {
    if (length(format) > 0){
      if (length(regmatches(format, gregexpr("(?<=\\<).+?(?=\\>)", format, perl = T)) |> unlist()) == 0) {
        cli::cli_abort("format input does not contain any estimate name indicated by <...>.")
      }
    } else {
      format <- NULL
    }
  }
  return(invisible(format))
}

validateStyle <- function(style, tableFormatType) {
  if (tableFormatType != "tibble") {
    if (is.list(style) | is.null(style)) {
      omopgenerics::assertList(style, null = TRUE, named = TRUE)
      if (is.list(style)) {
        notIn <- switch (tableFormatType,
          "datatable" = !names(style) %in% names(datatableStyleInternal("default")),
          "reactable" = !names(style) %in% names(reactableStyleInternal("default")),
          "gt" = !names(style) %in% names(gtStyleInternal("default")),
          "flextable" = !names(style) %in% names(flextableStyleInternal("default"))
        )
        if (sum(notIn) > 0 & tableFormatType == "datatable") {
          cli::cli_abort(c("`style` can only be defined for the following table parts in `datatable`: {datatableStyleInternal('default') |> names()}.",
                           "x" =  "{.strong {names(style)[notIn]}} {?is/are} not one of them."))
        }
        if (sum(notIn) > 0 & tableFormatType == "reactable") {
          cli::cli_abort(c("`style` can only be defined for the following table parts in `reactable`: {datatableStyleInternal('default') |> names()}.",
                           "x" =  "{.strong {names(style)[notIn]}} {?is/are} not one of them."))
        }
        if (sum(notIn) > 0 & !tableFormatType %in% c("datatable", "reactable")) {
          names <- c("header", "header_name", "header_level", "column_name", "group_label", "title", "subtitle", "body")
          cli::cli_abort(c("`style` can only be defined for the following table parts in `gt` and `flextable`: {names}.",
                           "x" =  "{.strong {names(style)[notIn]}} {?is/are} not one of them."))
        }
      }
    } else if (is.character(style)) {
      omopgenerics::assertCharacter(style, null = TRUE)
      eval(parse(text = paste0("style <- ", tableFormatType, "StyleInternal(styleName = style)")))
    } else {
      cli::cli_abort(paste0("Style must be one of 1) a named list of ", tableFormatType, " styling functions,
                   2) the string 'default' for visOmopResults default style, or 3) NULL to indicate no styling."))
    }
  }
  return(style)
}

validatePivotEstimatesBy <- function(pivotEstimatesBy, call = parent.frame()) {
  omopgenerics::assertCharacter(x = pivotEstimatesBy, null = TRUE, call = call)
  notValid <- any(c(
    !pivotEstimatesBy %in% omopgenerics::resultColumns(),
    c("estimate_type", "estimate_value") %in% pivotEstimatesBy
  ))
  if (isTRUE(notValid)) {
    cli::cli_abort(
      c("x" = "`pivotEstimatesBy` must refer to <summarised_result> columns.
        It cannot include `estimate_value` and `estimate_type`."),
      call = call)
  }
  return(invisible(pivotEstimatesBy))
}

validateSettingsColumn <- function(settingsColumn, result, call = parent.frame()) {
  set <- settings(result)
  omopgenerics::assertCharacter(x = settingsColumn, null = TRUE, call = call)
  if (!is.null(settingsColumn)) {
    omopgenerics::assertTable(set, columns = settingsColumn)
    settingsColumn <- settingsColumn[settingsColumn != "result_id"]
    notPresent <- settingsColumn[!settingsColumn %in% colnames(set)]
    if (length(notPresent) > 0) {
      cli::cli_abort("The following `settingsColumn` are not present in settings: {notPresent}.")
    }
  } else {
    settingsColumn <- character()
  }
  return(invisible(settingsColumn))
}

validateRename <- function(rename, result, call = parent.frame()) {
  omopgenerics::assertCharacter(rename, null = TRUE, named = TRUE, call = call)
  if (!is.null(rename)) {
    notCols <- !rename %in% colnames(result)
    if (sum(notCols) > 0) {
      cli::cli_warn(
        "The following values of `rename` do not refer to column names
        and will be ignored: {rename[notCols]}", call = call
      )
      rename <- rename[!notCols]
    }
  } else {
    rename <- character()
  }
  return(invisible(rename))
}

validateGroupColumn <- function(groupColumn, cols, sr = NULL, rename = NULL, call = parent.frame()) {
  if (!is.null(groupColumn)) {
    if (!is.list(groupColumn)) {
      groupColumn <- list(groupColumn)
    }
    if (length(groupColumn) > 1) {
      cli::cli_abort("`groupColumn` must be a character vector, or a list with just one element (a character vector).", call = call)
    }
    omopgenerics::assertCharacter(groupColumn[[1]], null = TRUE, call = call)
    if (!is.null(sr) & length(groupColumn[[1]]) > 0) {
      settingsColumn <- settingsColumns(sr)
      settingsColumn <- settingsColumn[settingsColumn %in% cols]
      groupColumn[[1]] <- purrr::map(groupColumn[[1]], function(x) {
        if (x %in% c("group", "strata", "additional", "estimate", "settings")) {
          switch(x,
                 group = groupColumns(sr),
                 strata = strataColumns(sr),
                 additional = additionalColumns(sr),
                 estimate = "estimate_name",
                 settings = settingsColumn)
        } else {
          x
        }
      }) |> unlist()
    }
    if (any(!groupColumn[[1]] %in% cols)) {
      set <- character()
      if (!is.null(sr)) set <- "or in the settings stated in `settingsColumn`"
      cli::cli_abort("`groupColumn` must refer to columns in the result table {set}", call = call)
    }
    if (is.null(names(groupColumn)) & length(groupColumn[[1]]) > 0) {
      if (!is.null(rename)) {
        names(groupColumn) <- paste0(renameInternal(groupColumn[[1]], rename), collapse = "; ")
      } else {
        names(groupColumn) <- paste0(groupColumn[[1]], collapse = "_")
      }
    }
  }
  return(invisible(groupColumn))
}

validateMerge <- function(x, merge, groupColumn, call = parent.frame()) {
  if (!is.null(merge)) {
    if (any(merge %in% groupColumn)) {
      cli::cli_abort("groupColumn and merge must have different column names.", call = call)
    }
    ind <- ! merge %in% c(colnames(x), "all_columns")
    if (sum(ind) == 1) {
      cli::cli_inform(c("!" = "{merge[ind]} is not a column in the dataframe.", call = call))
    } else if (sum(ind) > 1) {
      cli::cli_inform(c("!" = "{merge[ind]} are not columns in the dataframe.", call = call))
    }
    omopgenerics::assertCharacter(merge)
  }
  return(invisible(merge))
}

validateDelim <- function(delim, call = parent.frame()) {
  omopgenerics::assertCharacter(delim, length = 1)
  if (nchar(delim) != 1) {
    cli::cli_abort("The value supplied for `delim` must be a single character.", call = call)
  }
  return(invisible(delim))
}

validateShowMinCellCount <- function(showMinCellCount, set) {
  omopgenerics::assertLogical(showMinCellCount, length = 1)
  if ((!"min_cell_count" %in% colnames(set) | all(set$min_cell_count == "0")) & isTRUE(showMinCellCount)) {
    showMinCellCount <- FALSE
  }
  return(invisible(showMinCellCount))
}

validateSettingsAttribute <- function(result, call = parent.frame()) {
  set <- attr(result, "settings")
  if (is.null(set)) {
    cli::cli_abort("`result` does not have attribute settings", call = call)
  }
  if (!"result_id" %in% colnames(set) | !"result_id" %in% colnames(result)) {
    cli::cli_abort("'result_id' must be part of both `result` and its settings attribute.", call = call)
  }
  return(invisible(set))
}

checkVisTableInputs <- function(header, groupColumn, hide, call = parent.frame()) {
  int1 <- dplyr::intersect(header, groupColumn[[1]])
  int2 <- dplyr::intersect(header, hide)
  int3 <- dplyr::intersect(hide, groupColumn[[1]])
  if (length(c(int1, int2, int3)) > 0) {
    cli::cli_abort("Columns passed to {.strong `header`}, {.strong `groupColumn`}, and {.strong `hide`} must be different.", call = call)
  }
}

validateFactor <- function(factor, resultTidy) {
  if (length(factor) > 0) {
    omopgenerics::assertList(factor, named = TRUE, class = "character")
    for (nm in names(factor)) {
      content <- resultTidy |> dplyr::pull(.data[[nm]]) |> unique()
      notIn <- ! content %in% factor[[nm]]
      if (any(notIn)) {
        cli::cli_abort("{.strong {content[notIn]}} variable{?s} in {.strong {nm}} column are not in `factor`")
      }
    }
  }
  return(invisible(factor))
}

validateHeader <- function(x, header, hide, settingsColumn = NULL, summarisedResult = FALSE) {
  # Check current header
  if (summarisedResult) {
    xTest <- tidySummarisedResult(x, settingsColumn = settingsColumn, pivotEstimatesBy = NULL)
  } else {
    xTest <- x
  }
  xTest <- xTest |> dplyr::select(!dplyr::any_of(c(hide, "result_id", "estimate_type")))
  xCols <- colnames(xTest)
  combinations <- xTest |>
    dplyr::group_by(dplyr::across(dplyr::any_of(xCols[xCols != "estimate_value"]))) |>
    dplyr::tally() |>
    dplyr::filter(.data$n > 1)

  # Solve if needed
  if (nrow(combinations) > 0) {
    if (summarisedResult) {
      setCols <- omopgenerics::settingsColumns(x)
      x <- x |>
        addSettings() |>
        splitAll()
      hideSettings <- setCols[!setCols %in% settingsColumn]
    }
    x <- x |>
      dplyr::select(!dplyr::any_of(c(header, "result_id", "estimate_type", "estimate_value")))
    colCounts <- sapply(x, dplyr::n_distinct)
    mustCols <- names(colCounts)[colCounts > 1]
    hideNeeded <- mustCols %in% hide
    if (any(hideNeeded)) {
      cli::cli_warn("{.strong {mustCols[hideNeeded]}} column{?s} will be added to the table to create a header with unique values")
      hide <- hide[!hide %in% mustCols[hideNeeded]]
    }
    if (summarisedResult) {
      settingsNeeded <- mustCols %in% hideSettings
      if (any(settingsNeeded)) {
        cli::cli_warn("{.strong {mustCols[settingsNeeded]}} column{?s} from settings will be added to the table to create a header with unique values")
        settingsColumn <- c(settingsColumn, mustCols[settingsNeeded])
      }
    }
  }

  return(list(hide = hide, settingsColumn = settingsColumn))
}
