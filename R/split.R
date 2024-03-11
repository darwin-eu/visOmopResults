#' Split group_name and group_level columns
#'
#' @param result A dataframe with at least the columns group_name and
#' group_level.
#' @param overall Whether to keep overall column if present.
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
                       overall = FALSE) {
  splitNameLevel(
    result = result,
    name = "group_name",
    level = "group_level",
    keep = FALSE,
    overall = overall
  )
}

#' Split strata_name and strata_level columns
#'
#' @param result A dataframe with at least the columns strata_name and
#' strata_level.
#' @param overall Whether to keep overall column if present.
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
                        overall = FALSE) {
  splitNameLevel(
    result = result,
    name = "strata_name",
    level = "strata_level",
    keep = FALSE,
    overall = overall
  )
}

#' Split additional_name and additional_level columns
#'
#' @param result  A dataframe with at least the columns additional_name and
#' additional_level.
#' @param overall Whether to keep overall column if present.
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
                            overall = FALSE) {
  splitNameLevel(
    result = result,
    name = "additional_name",
    level = "additional_level",
    keep = FALSE,
    overall = overall
  )
}

#' Split group, strata and additional at once.
#'
#' @param result A summarised_result object.
#'
#' @return A dataframe with group, strata and additional name as columns.
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
splitAll <- function(result) {
  result |>
    splitGroup(overall = FALSE) |>
    splitStrata(overall = FALSE) |>
    splitAdditional(overall = FALSE)
}

#' Split name and level columns into the columns
#'
#' @param result A summarised_result object.
#' @param name Column with the names.
#' @param level Column with the levels.
#' @param keep Whether to keep the original group_name and group_level columns.
#' @param overall Whether to keep overall column if present.
#' @param fill Optionally, a character that specifies what value should be
#' filled in with when missing.
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
                           overall = FALSE,
                           fill = NA_character_) {
  assertCharacter(name, length = 1)
  assertCharacter(level, length = 1)
  assertLogical(keep, length = 1)
  assertTibble(result, columns = c(name, level))
  assertCharacter(fill, length = 1, na = TRUE)

  newCols <- getColumns(result, name, TRUE)
  id <- which(name == colnames(result))

  nameValues <- result[[name]] |> strsplit(" and | &&& ")
  levelValues <- result[[level]] |> strsplit(" and | &&& ")
  if (!all(lengths(nameValues) == lengths(levelValues))) {
    cli::cli_abort("Column names and levels number does not match")
  }

  nameValue <- unique(unlist(nameValues))
  present <- nameValue[nameValue %in% colnames(result)]
  if (length(present) > 0) {
    cli::cli_warn(
      "The following columns will be overwritten:
      {paste0(present, collapse = ', ')}."
    )
  }
  for (k in seq_along(nameValue)) {
    col <- nameValue[k]
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

  if ("overall" %in% newCols & !overall) {
    newCols <- newCols[!newCols %in% "overall"]
    result <- result |>
      dplyr::select(-"overall")
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
