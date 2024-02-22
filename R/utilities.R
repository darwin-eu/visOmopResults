
validateResult <- function(x, call = parent.frame()) {
  xn <- tryCatch(
    omopgenerics::newSummarisedResult(x),
    error = function(e){NULL}
  )
  if (!is.null(xn)) {
    return(xn)
  }
  xn <- tryCatch(
    omopgenerics::newComparedResult(x),
    error = function(e){NULL}
  )
  if (!is.null(xn)) {
    return(xn)
  }
  cli::cli_abort("Please provide a valid result object.", call = call)
}

validateDecimals <- function(result, decimals) {
  nm_type <- omopgenerics::estimateTypeChoices()
  nm_name <- result[["estimate_name"]] |> unique()
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
    cli::cli_abort(glue::glue("{paste0(conflict_nms, collapse = ", ")} do not correspont to estimate_type or estimate_name values."))
  } else if (length(decimals) == 1 & is.null(names(decimals))) { # same number to all
    decimals <- rep(decimals, length(nm_type))
    names(decimals) <- nm_type
  } else {
    decimals <- c(decimals[names(decimals) %in% nm_name],
                  decimals[names(decimals) %in% nm_type])
  }

  return(decimals)
}

validateEstimateNameFormat <- function(format, call = parent.frame()) {
  if (!is.null(format)) {
    if (length(format) > 0){
      if (length(stringr::str_match_all(format, "(?<=\\<).+?(?=\\>)") |> unlist()) == 0) {
        cli::cli_abort("format input does not contain any estimate name indicated by <...>.")
      }
    } else {
      format <- NULL
    }
  }
  return(format)
}

validateStyle <- function(style, tableFormatType) {
  if (is.list(style) | is.null(style)) {
    checkmate::assertList(style, null.ok = TRUE, any.missing = FALSE)
  } else if (is.character(style)) {
    checkmate::assertCharacter(style, min.chars = 1, any.missing = FALSE, max.len = 1)
    eval(parse(text = paste0("style <- ", tableFormatType, "Styles(styleName = style)")))
  } else {
    cli::cli_abort("Style must be one of 1) a named list of flextable styling function,
                   2) the string 'default' for our default style, or 3) NULL to indicate no styling.")
  }
  return(style)
}

validateColsToMergeRows <- function(x, colsToMergeRows, groupNameCol) {
  if (!is.null(colsToMergeRows)) {
    if (any(colsToMergeRows %in% groupNameCol)) {
      cli::cli_abort("groupNameCol and colsToMergeRows must have different column names.")
    }
    ind <- ! colsToMergeRows %in% c(colnames(x), "all_columns")
    if (sum(ind) == 1) {
      warning(glue::glue("{colsToMergeRows[ind]} is not a column in the dataframe."))
    } else if (sum(ind) > 1) {
      warning(glue::glue("{colsToMergeRows[ind]} are not columns in the dataframe."))
    }
  }
}

validateDelim <- function(delim) {
  if (!rlang::is_character(delim)) {
    cli::cli_abort("The value supplied for `delim` must be of type `character`.")
  }
  if (length(delim) != 1) {
    cli::cli_abort("`delim` must be a single value.")
  }
  if (nchar(delim) != 1) {
    cli::cli_abort("The value supplied for `delim` must be a single character.")
  }
}
