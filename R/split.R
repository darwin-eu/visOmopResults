#' Split group_name and group_level columns
#'
#' @param result A dataframe with at least the columns group_name and
#' group_level.
#' @param keep Whether to keep the original group_name and group_level columns.
#' @param fill Optionally, a character that specifies what value should be
#' filled in with when missing.
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
                       fill = "overall") {
  splitNameLevelInternal(
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
                        fill = "overall") {
  splitNameLevelInternal(
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
                            fill = "overall") {
  splitNameLevelInternal(
    result = result,
    name = "additional_name",
    level = "additional_level",
    keep = keep,
    fill = fill
  )
}

#' Split all pairs name-level into columns.
#'
#' @param result A data.frame.
#' @param keep Whether to keep the original name-level columns.
#' @param fill A character that specifies what value should be filled in when
#' missing.
#' @param exclude Name of a column pair to exclude.
#'
#' @return A dataframe with group, strata and additional as columns.
#'
#' @description
#' Pivots the input dataframe so any pair name-level columns are transformed
#' into columns (name) that contain values from the corresponding level.
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
                     exclude = "variable") {
  omopgenerics::assertTable(result, class = "data.frame")
  omopgenerics::assertLogical(keep, length = 1)
  omopgenerics::assertCharacter(fill, length = 1)
  omopgenerics::assertCharacter(exclude, null = TRUE)

  cols <- colnames(result)
  cols <- intersect(
    cols[stringr::str_ends(cols, "_name")] |>
      stringr::str_replace("_name$", ""),
    cols[stringr::str_ends(cols, "_level")] |>
      stringr::str_replace("_level$", "")
  )
  cols <- cols[!cols %in% exclude]

  for (col in cols) {
    result <- tryCatch(
      expr = {
        result |>
          splitNameLevelInternal(
            name = paste0(col, "_name"),
            level = paste0(col, "_level"),
            keep = keep,
            fill = fill
          )
      },
      error = function(e) {
        cli::cli_warn(c(
          "!" = "Couldn't split pair: {.var {col}_name}-{.var {col}_level}: {e$message}"
        ))
        return(result)
      }
    )
  }

  return(result)
}

#' Split name and level columns into the columns
#'
#' @param result A `<summarised_result>` object.
#' @param name Column with the names.
#' @param level Column with the levels.
#' @param keep Whether to keep the original group_name and group_level columns.
#' @param fill Optionally, a character that specifies what value should be
#' filled in with when missing.
#'
#' @return A dataframe with the specified name column values as columns.
#' @description
#' `r lifecycle::badge("deprecated")`
#' Pivots the input dataframe so the values of the name columns are transformed
#' into columns, which values come from the specified level column.
#'
#' @export
#'
splitNameLevel <- function(result,
                           name = "group_name",
                           level = "group_level",
                           keep = FALSE,
                           fill = "overall") {
  lifecycle::deprecate_soft(when = "0.4.0", what = "splitNameLevel()")
  splitNameLevelInternal(
    result = result,
    name = name,
    level = level,
    keep = keep,
    fill = fill
  )
}

splitNameLevelInternal <- function(result,
                                   name = "group_name",
                                   level = "group_level",
                                   keep = FALSE,
                                   fill = "overall") {
  omopgenerics::assertCharacter(name, length = 1)
  omopgenerics::assertCharacter(level, length = 1)
  omopgenerics::assertLogical(keep, length = 1)
  omopgenerics::assertTable(result, columns = c(name, level))
  omopgenerics:: assertCharacter(fill, length = 1, na = TRUE)

  newCols <- getColumns(result = result, col = name)
  id <- which(name == colnames(result))

  nameValues <- result[[name]] |> strsplit(" &&& ")
  levelValues <- result[[level]] |> strsplit(" &&& ")
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
