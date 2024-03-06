
validateResult <- function(x, call = parent.frame()) {
  xn <- tryCatch(
    omopgenerics::newSummarisedResult(x),
    error = function(e){NULL}
  )
  if (!is.null(xn)) {
    return(xn)
  }
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
    cli::cli_abort(paste0(paste0(conflict_nms, collapse = ", "), " do not correspont to estimate_type or estimate_name values."))
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
      if (length(regmatches(format, gregexpr("(?<=\\<).+?(?=\\>)", format, perl = T)) |> unlist()) == 0) {
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
    assertList(style, null = TRUE, named = TRUE)
  } else if (is.character(style)) {
    assertCharacter(style, null = TRUE)
    eval(parse(text = paste0("style <- ", tableFormatType, "Styles(styleName = style)")))
  } else {
    if (tableFormatType == "fx") {
      tableFormatType <- "flextable"
    }
    cli::cli_abort(paste0("Style must be one of 1) a named list of ", tableFormatType, " styling functions,
                   2) the string 'default' for visOmopResults default style, or 3) NULL to indicate no styling."))
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
      warning(paste0(colsToMergeRows[ind], " is not a column in the dataframe."))
    } else if (sum(ind) > 1) {
      warning(paste0(colsToMergeRows[ind], " are not columns in the dataframe."))
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
