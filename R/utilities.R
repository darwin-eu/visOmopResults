
validateResult <- function(x, call = parent.frame()) {
  xn <- tryCatch(
    validateSummarisedResult(x = x, call = call),
    error = function(e){NULL}
  )
  if (inherits(xn, "summarised_result")) {
    return(xn)
  }
  xn <- tryCatch(
    validateSummarisedResult(x = x, call = call),
    error = function(e){NULL}
  )
  if (inherits(xn, "summarised_result")) {
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

validateDecimals <- function(decimals, call = parent.frame()) {
  nms <- c("numeric", "integer", "proportion", "percentage")
  errorMesssage <- c(
    "`decimals` must be named integerish vector. Names refere to estimate_type.
    Possible names: ", paste0(nms, collapse = ", "), "."
  ) |>
    paste0(collapse = "")
  if (!is.numeric(decimals) | length(decimals) == 0) {
    cli::cli_abort(errorMesssage)
  }
  if (!all(decimals == floor(decimals))) {
    cli::cli_abort(errorMesssage)
  }
  if (length(decimals) == 1 & is.null(names(decimals))) {
    decimals <- rep(decimals, length(nms))
    names(decimals) <- nms
  }
  if (!all(names(decimals) %in% nms)) {
    cli::cli_abort(errorMesssage)
  }
  return(decimals)
}
