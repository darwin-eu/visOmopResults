
#' Unite one or more columns in name-level format.
#'
#' @param x Tibble or data.frame.
#' @param cols Columns to aggregate.
#' @param name Column name of the `name` column.
#' @param level Column name of the `level` column.
#' @param keep Whether to keep the original columns.
#'
#' @return A Tibble with the new columns.
#'
#' @examples
#' \donttest{
#' x <- dplyr::tibble(
#'   variable = "number subjects",
#'   value = c(10, 15, 40, 78),
#'   sex = c("Male", "Female", "Male", "Female"),
#'   age_group = c("<40", ">40", ">40", "<40")
#' )
#'
#' x
#'
#' x |>
#'   uniteNameLevel(
#'     cols = c("sex", "age_group"),
#'     name = "new_column_name",
#'     level = "new_column_level"
#'   )
#' }
#'
#' @export
#'
uniteNameLevel <- function(x,
                           cols,
                           name = "group_name",
                           level = "group_level",
                           keep = FALSE) {
  # initial checks
  checkmate::assertCharacter(cols)
  checkmate::assertCharacter(name, len = 1, any.missing = FALSE)
  checkmate::assertCharacter(level, len = 1, any.missing = FALSE)
  checkmate::assertLogical(keep, len = 1, any.missing = FALSE)
  checkmate::assertTibble(x)
  checkmate::assertTRUE(all(cols %in% colnames(x)))

  id <- min(which(colnames(x) %in% cols))

  present <- c(name, level)[c(name, level) %in% colnames(x)]
  if (length(present) > 0) {
    cli::cli_warn(
      "The following columns will be overwritten:
      {paste0(present, collapse = ', ')}."
    )
  }

  containAnd <- cols[grepl(" and ", cols)]
  if (length(containAnd) > 0) {
    cli::cli_abort("Column names must not contain ' and ' : `{paste0(containAnd, collapse = '`, `')}`")
  }
  containAnd <- cols[
    lapply(cols, function(col){any(grepl(" and ", x[[col]]))}) |> unlist()
  ]
  if (length(containAnd) > 0) {
    cli::cli_abort("Column values must not contain ' and '. Present in: `{paste0(containAnd, collapse = '`, `')}`.")
  }

  x <- x |>
    dplyr::mutate(!!name := paste0(cols, collapse = " and ")) |>
    tidyr::unite(
      col = !!level, dplyr::all_of(cols), sep = " and ", remove = !keep
    )

  if (keep) {
    colskeep <- cols
  } else {
    colskeep <- character()
  }

  # move cols
  if (id == 1) {
    x <- x |> dplyr::relocate(dplyr::all_of(c(colskeep, name, level)))
  } else {
    id <- colnames(x)[id - 1]
    x <- x |>
      dplyr::relocate(
        dplyr::all_of(c(colskeep, name, level)), .after = dplyr::all_of(id)
      )
  }

  return(x)
}

#' Unite one or more columns in group_name-group_level format.
#'
#' @param x Tibble or data.frame.
#' @param cols Columns to aggregate.
#'
#' @return A Tibble with the new columns.
#'
#' @examples
#' \donttest{
#' x <- dplyr::tibble(
#'   variable = "number subjects",
#'   value = c(10, 15, 40, 78),
#'   sex = c("Male", "Female", "Male", "Female"),
#'   age_group = c("<40", ">40", ">40", "<40")
#' )
#'
#' x
#'
#' x |>
#'   uniteGroup(c("sex", "age_group"))
#' }
#'
#' @export
#'
uniteGroup <- function(x, cols) {
  uniteNameLevel(
    x = x, cols = cols, name = "group_name", level = "group_level", keep = FALSE
  )
}

#' Unite one or more columns in strata_name-strata_level format.
#'
#' @param x Tibble or data.frame.
#' @param cols Columns to aggregate.
#'
#' @return A Tibble with the new columns.
#'
#' @examples
#' \donttest{
#' x <- dplyr::tibble(
#'   variable = "number subjects",
#'   value = c(10, 15, 40, 78),
#'   sex = c("Male", "Female", "Male", "Female"),
#'   age_group = c("<40", ">40", ">40", "<40")
#' )
#'
#' x
#'
#' x |>
#'   uniteStrata(c("sex", "age_group"))
#' }
#'
#' @export
#'
uniteStrata <- function(x, cols) {
  uniteNameLevel(
    x = x, cols = cols, name = "strata_name", level = "strata_level",
    keep = FALSE
  )
}

#' Unite one or more columns in additional_name-additional_level format.
#'
#' @param x Tibble or data.frame.
#' @param cols Columns to aggregate.
#'
#' @return A Tibble with the new columns.
#'
#' @examples
#' \donttest{
#' x <- dplyr::tibble(
#'   variable = "number subjects",
#'   value = c(10, 15, 40, 78),
#'   sex = c("Male", "Female", "Male", "Female"),
#'   age_group = c("<40", ">40", ">40", "<40")
#' )
#'
#' x
#'
#' x |>
#'   uniteAdditional(c("sex", "age_group"))
#' }
#'
#' @export
#'
uniteAdditional <- function(x, cols) {
  uniteNameLevel(
    x = x, cols = cols, name = "additional_name", level = "additional_level",
    keep = FALSE
  )
}
