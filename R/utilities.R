
validateSummarisedResult <- function(x, call = parent.frame()) {
  if (!inherits(x, "data.frame")) {
    cli::cli_abort(
      message = "{parse(text = substitute(x))} must be a local data.frame,
      tibble or summarised_result object.",
      call = call
    )
  }

}

