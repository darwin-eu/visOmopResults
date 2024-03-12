#' Split group_name and group_level columns
#'
#' @param result A dataframe with at least the columns group_name and
#' group_level.
#' @param keep Whether to keep the original group_name and group_level columns.
#' @param fill Optionally, a character that specifies what value should be
#' filled in with when missing.
#' @param overall deprecated.
#'
#' @return A dataframe.
#' @description
#' Pivots the input dataframe so the values of the column group_name are
#' transformed into columns that contain values from the group_level column.
#'
#'
#' @export
#'
#' @examples
#' mockSummarisedResult() |>
#'   splitGroup()
#'
splitGroup <- function(result,
                       keep = FALSE,
                       fill = "overall",
                       overall = lifecycle::deprecated()) {
  if (lifecycle::is_present(overall)) {
    lifecycle::deprecate_warn("0.1.0", "splitGroup(overall)")
  }
  splitNameLevel(
    result = result,
    name = "group_name",
    level = "group_level",
    keep = keep,
    fill = fill
  )
}

#' Split strata_name and strata_level columns
#'
#' @param result A dataframe with at least the columns strata_name and
#' strata_level.
#' @param keep Whether to keep the original group_name and group_level columns.
#' @param fill Optionally, a character that specifies what value should be
#' filled in with when missing.
#' @param overall deprecated.
#'
#' @return A dataframe.
#' @description
#' Pivots the input dataframe so the values of the column strata_name are
#' transformed into columns that contain values from the strata_level column.
#'
#' @export
#'
#' @examples
#' mockSummarisedResult() |>
#'   splitStrata()
#'
splitStrata <- function(result,
                        keep = FALSE,
                        fill = "overall",
                        overall = lifecycle::deprecated()) {
  if (lifecycle::is_present(overall)) {
    lifecycle::deprecate_warn("0.1.0", "splitStrata(overall)")
  }
  splitNameLevel(
    result = result,
    name = "strata_name",
    level = "strata_level",
    keep = keep,
    fill = fill
  )
}

#' Split additional_name and additional_level columns
#'
#' @param result  A dataframe with at least the columns additional_name and
#' additional_level.
#' @param keep Whether to keep the original group_name and group_level columns.
#' @param fill Optionally, a character that specifies what value should be
#' filled in with when missing.
#' @param overall deprecated.
#'
#' @return A dataframe.
#' @description
#' Pivots the input dataframe so the values of the column additional_name are
#' transformed into columns that contain values from the additional_level column.
#'
#' @export
#'
#' @examples
#' mockSummarisedResult() |>
#'   splitAdditional()
#'
splitAdditional <- function(result,
                            keep = FALSE,
                            fill = "overall",
                            overall = lifecycle::deprecated()) {
  if (lifecycle::is_present(overall)) {
    lifecycle::deprecate_warn("0.1.0", "splitAdditional(overall)")
  }
  splitNameLevel(
    result = result,
    name = "additional_name",
    level = "additional_level",
    keep = keep,
    fill = fill
  )
}

#' Split group, strata and additional at once.
#'
#' @param result A summarised_result object.
#' @param keep Whether to keep the original group_name and group_level columns.
#' @param fill Optionally, a character that specifies what value should be
#' filled in with when missing.
#' @param overall deprecated.
#'
#' @return A dataframe with group, strata and additional name as columns.
#'
#' @description
#' Pivots the input dataframe so group, strata and additional name columns are
#' transformed into columns that contain values from the corresponding level
#'  columns (group, strata, and additional).
#'
#' @export
#'
#' @examples
#' mockSummarisedResult() |>
#'   splitAll()
#'
splitAll <- function(result,
                     keep = FALSE,
                     fill = "overall",
                     overall = lifecycle::deprecated()) {
  if (lifecycle::is_present(overall)) {
    lifecycle::deprecate_warn("0.1.0", "splitAll(overall)")
  }
  result |>
    splitGroup(keep = keep, fill = fill) |>
    splitStrata(keep = keep, fill = fill) |>
    splitAdditional(keep = keep, fill = fill)
}

#' Split name and level columns into the columns
#'
#' @param result A summarised_result object.
#' @param name Column with the names.
#' @param level Column with the levels.
#' @param keep Whether to keep the original group_name and group_level columns.
#' @param fill Optionally, a character that specifies what value should be
#' filled in with when missing.
#' @param overall deprecated.
#'
#' @return A dataframe with the specified name column values as columns.
#' @description
#' Pivots the input dataframe so the values of the name columns are transformed
#' into columns, which values come from the specified level column.
#'
#' @export
#'
#' @examples
#' mockSummarisedResult() |>
#'   splitNameLevel(name = "group_name",
#'                  level = "group_level",
#'                  keep = FALSE)
#'
splitNameLevel <- function(result,
                           name = "group_name",
                           level = "group_level",
                           keep = FALSE,
                           fill = "overall",
                           overall = lifecycle::deprecated()) {
  if (lifecycle::is_present(overall)) {
    lifecycle::deprecate_warn("0.1.0", "splitNameLevel(overall)")
  }
  assertCharacter(name, length = 1)
  assertCharacter(level, length = 1)
  assertLogical(keep, length = 1)
  assertTibble(result, columns = c(name, level))
  assertCharacter(fill, length = 1, na = TRUE)

  newCols <- getColumns(result = result, col = name)
  id <- which(name == colnames(result))

  nameValues <- result[[name]] |> strsplit(" and | &&& ")
  levelValues <- result[[level]] |> strsplit(" and | &&& ")
  if (!all(lengths(nameValues) == lengths(levelValues))) {
    cli::cli_abort("Column names and levels number does not match")
  }

  present <- newCols[newCols %in% colnames(result)]
  if (length(present) > 0) {
    cli::cli_warn(
      "The following columns will be overwritten:
      {paste0(present, collapse = ', ')}."
    )
  }
  for (k in seq_along(newCols)) {
    col <- newCols[k]
    dat <- lapply(seq_along(nameValues), function(y) {
      res <- levelValues[[y]][nameValues[[y]] == col]
      if (length(res) == 0) {
        return(as.character(NA))
      } else {
        return(res)
      }
    }) |>
      unlist()
    result[[col]] <- dat
  }

  if (!keep) {
    result <- result |> dplyr::select(-dplyr::all_of(c(name, level)))
    colskeep <- character()
  } else {
    colskeep <- c(name, level)
  }

  # move cols
  if (id == 1) {
    result <- result |> dplyr::relocate(dplyr::any_of(newCols))
  } else {
    id <- colnames(result)[id - 1]
    result <- result |>
      dplyr::relocate(
        dplyr::any_of(c(colskeep, newCols)), .after = dplyr::all_of(id)
      )
  }

  # use fill
  if (!is.na(fill)) {
    result <- result |>
      dplyr::mutate(dplyr::across(
        dplyr::any_of(newCols),
        ~ dplyr::if_else(is.na(.x), .env$fill, .x)
      ))
  }

  return(result)
}
