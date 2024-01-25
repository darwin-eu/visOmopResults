
validateResult <- function(x, call = parent.frame()) {
  xn <- tryCatch(
    validateSummarisedResult(x = x, call = call),
    error = function(e){NULL}
  )
  if (inherits(xn, "summarised_result")) {
    return(xn)
  }
  xn <- tryCatch(
    validateComparedResult(x = x, call = call),
    error = function(e){NULL}
  )
  if (inherits(xn, "compared_result")) {
    return(xn)
  }
  cli::cli_abort("Please provide a valid result object.", call = call)
}

validateSummarisedResult <- function(x, call = parent.frame()) {
  if (inherits(x, "summarised_result")) {
    return(x)
  }
  omopgenerics::summarisedResult(x)
}

validateComparedResult <- function(x, call = parent.frame()) {
  if (inherits(x, "compared_result")) {
    return(x)
  }
  omopgenerics::comparedResult(x)
}

validateDecimals <- function(result, decimals, call = parent.frame()) {
  nm_type <- c("numeric", "integer", "proportion", "percentage")
  nm_name <- result[["estimate_name"]] |> unique()
  errorMesssage <- "`decimals` must be named integerish vector. Names refere to estimate_type or estimate_name columns."
  if (!is.numeric(decimals) | length(decimals) == 0) {
    cli::cli_abort(errorMesssage)
  }
  if (!all(decimals == floor(decimals))) {
    cli::cli_abort(errorMesssage)
  }
  if (length(decimals) == 1 & is.null(names(decimals))) {
    decimals <- rep(decimals, length(nm_type))
    names(decimals) <- nm_type
  }
  if (!all(names(decimals) %in% c(nm_type, nm_name))) {
    cli::cli_abort(errorMesssage)
  } else {
    decimals <- c(decimals[names(decimals) %in% nm_name],
                  decimals[names(decimals) %in% nm_type])
  }
  return(decimals)
}

validateEstimateNameFormat <- function(format, call = parent.frame()) {
  if (length(stringr::str_match_all(format, "(?<=\\<).+?(?=\\>)") |> unlist()) == 0) {
    cli::cli_abort("format input does not contain any estimate name indicated by <...>.")
  }
}
