#' Apply styling to text or column names
#'
#' @param x A character vector to style text.
#' @param fun A styling function to apply to text in `x`. The default function
#' converts snake_case to sentence case.
#' @param custom A named character vector indicating custom names for specific
#' values in `x`. If NULL, the styling function in `fun` is applied to all
#' values.
#' @param keep Either a character vector of names to keep unchanged. If NULL,
#' all names will be styled.
#'
#' @description
#' This function styles character vectors or column names in a data frame.
#' The styling function can be customised, or you can provide specific
#' replacements for certain values.
#'
#' @return A character vector of styled text or a data frame with styled column
#'  names.
#' @export
#'
#' @examples
#' # Styling a character vector
#' customiseText(c("some_column_name", "another_column"))
#'
#' # Custom styling for specific values
#' customiseText(x = c("some_column", "another_column"),
#'           custom = c("Custom Name" = "another_column"))
#'
#' # Keeping specific values unchanged
#' customiseText(x = c("some_column", "another_column"), keep = "another_column")
#'
#' # Styling column names and variables in a data frame
#' dplyr::tibble(
#'   some_column = c("hi_there", "rename_me", "example", "to_keep"),
#'   another_column = 1:4,
#'   to_keep = "as_is"
#' ) |>
#'   dplyr::mutate(
#'     "some_column" = customiseText(some_column, custom = c("EXAMPLE" = "example"), keep = "to_keep")
#'   ) |>
#'   dplyr::rename_with(.fn = ~ customiseText(.x, keep = "to_keep"))

customiseText <- function(x,
                          fun = \(x)stringr::str_to_sentence(gsub("_", " ", x)),
                          custom = NULL,
                          keep = NULL) {
  # Checks
  omopgenerics::assertCharacter(x, null = TRUE, na = TRUE)
  omopgenerics::assertCharacter(custom, named = TRUE, null = TRUE)
  omopgenerics::assertCharacter(keep, null = TRUE)
  if (!is.function(fun)) {
    cli::cli_abort(c(
      "x" = "`fun` must be a function.",
      ">" = "To ensure the input is a function check `is.function(fun)`"
    ))
  }

  cols <- x[!x %in% keep]
  return(purrr::map(x, renameInternal, fun = fun, rename = custom, cols = cols) |> unlist())
}

renameInternal <- function(x, rename = NULL, cols = NULL, fun = formatToSentence) {
  newNames <- character()
  for (xx in x) {
    if (!is.null(rename) & (xx %in% rename)) {
      newNames <- c(newNames, names(rename)[rename == xx])
    } else if (xx %in% cols | is.null(cols)) {
      newNames <- c(newNames, fun(xx))
    } else {
      newNames <- c(newNames, xx)
    }
  }
  return(newNames)
}

