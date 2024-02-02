#' Creats a flextable object from a dataframe
#'
#' @param x A dataframe.
#' @param delim Delimiter.
#' @param style Named list that specifies how to style the different parts of
#' the gt table. Accepted entries are: title, subtitle, header, header_name,
#' header_level, column_name, group_label, and body. Alternatively, use
#' "default" to get visOmopResult style, or NULL for gt style
#' @param na How to display missing values.
#' @param title Title of the table, or NULL for no title.
#' @param subtitle Subtitle of the table, or NULL for no subtitle.
#' @param caption Caption for the table, or NULL for no caption. Text in
#' markdown formatting style (e.g. `*Your caption here*` for caption in
#' italics).
#' @param groupNameCol Column to use as group labels.
#' @param groupNameAsColumn Whether to display the group labels as a column
#' (TRUE) or rows (FALSE).
#' @param groupOrder Order in which to display group labels.
#' @param colsToMergeRows specify the names of the columns to vertically merge
#' when consecutive cells have identical values. Alternatively, use
#' "all_columns" to apply this merging to all columns, or use NULL to indicate
#' no merging should be applied.
#'
#' @return flextable object
#'
#' @description
#' Creats a flextable object from a dataframe using as delimiter (`delim`) to span
#' the header, and the specified styles for different parts of the table.
#'
#' @examples
#' \donttest{
#' mockSummarisedResult() |>
#'   formatEstimateValue(decimals = c(integer = 0, numeric = 1)) |>
#'   formatTable(header = c("Study strata", "strata_name", "strata_level"),
#'               includeHeaderName = FALSE) |>
#'   fxTable(
#'     style = "default",
#'     na = "--",
#'     title = "fxTable example",
#'     subtitle = NULL,
#'     caption = NULL,
#'     groupNameCol = "group_level",
#'     groupNameAsColumn = TRUE,
#'     groupOrder = c("cohort1", "cohort2"),
#'     colsToMergeRows = "all_columns"
#'  )
#' }
#'
#' @return A flextable.
#'
#' @export
#'
fxTable <- function(
    x,
    delim = "\n",
    style = "default",
    na = "-",
    title = NULL,
    subtitle = NULL,
    caption = NULL,
    groupNameCol = NULL,
    groupNameAsColumn = FALSE,
    groupOrder = NULL,
    colsToMergeRows = NULL
) {

  # Checks
  checkmate::assertDataFrame(x)
  checkmate::assertCharacter(delim, min.chars = 1, len = 1, any.missing = FALSE)
  checkmate::assertCharacter(na, len = 1, null.ok = TRUE)
  checkmate::assertCharacter(title, len = 1, null.ok = TRUE, any.missing = FALSE)
  checkmate::assertCharacter(subtitle, len = 1, null.ok = TRUE, any.missing = FALSE)
  checkmate::assertCharacter(caption, len = 1, null.ok = TRUE, any.missing = FALSE)
  checkmate::assertCharacter(groupNameCol, null.ok = TRUE, any.missing = FALSE)
  checkmate::assertLogical(groupNameAsColumn, len = 1, any.missing = FALSE)
  checkmate::assertCharacter(groupOrder, null.ok = TRUE, any.missing = FALSE)
  checkmate::assertCharacter(colsToMergeRows, null.ok = TRUE, any.missing = FALSE)
  checkColsToMergeRows(x, colsToMergeRows, groupNameCol)
  style <- checkStyle(style, "fx")
  if (is.null(title) & !is.null(subtitle)) {
    cli::cli_abort("There must be a title for a subtitle.")
  }


  # Header id's
  spanCols_ids <- which(grepl("\\[header\\]|\\[header_level\\]|\\[header_name\\]|\\[column_name\\]", colnames(x)))
  spanners <-  strsplit(colnames(x)[spanCols_ids[1]], delim) |> unlist()
  header_rows <- which(grepl("\\[header\\]", spanners))
  header_name_rows <- which(grepl("\\[header_name\\]", spanners))
  header_level_rows <- which(grepl("\\[header_level\\]", spanners))

  # Eliminate prefixes
  colnames(x) <- gsub("\\[header\\]|\\[header_level\\]|\\[header_name\\]|\\[column_name\\]", "", colnames(x))

  # na
  if (!is.null(na)){
    x[is.na(x)] <- na
  }

  # Flextable
  if (is.null(groupNameCol)) {
    flex_x <- x |> flextable::flextable() |> flextable::separate_header(split = delim)
  } else {
    if (!is.null(groupOrder)) {
      x <-x |> dplyr::mutate(!!groupNameCol := factor(.data[[groupNameCol]], levels = groupOrder)) |>
        dplyr::relocate(!!groupNameCol) |>
        dplyr::arrange(.data[[groupNameCol]])
    } else {
      x <- x |>  dplyr::mutate(!!groupNameCol := factor(.data[[groupNameCol]])) |>
        dplyr::relocate(!!groupNameCol) |>
        dplyr::arrange(.data[[groupNameCol]])
    }
    if (groupNameAsColumn) {
      flex_x <- x |> flextable::flextable() |> flextable::merge_v(j = groupNameCol) |> flextable::separate_header(split = delim)
    } else {
      flex_x <- x |> flextable::as_grouped_data(groups = groupNameCol) |> flextable::flextable() |>
        flextable::separate_header(split = delim)
      flex_x <- flex_x |>
        flextable::merge_h(i = which(!is.na(flex_x$body$dataset[[groupNameCol]])), part = "body")
    }
  }

  # Headers
  if (length(header_rows)>0 & "header" %in% names(style)) {
    flex_x <- flex_x |>
      flextable::style(part = "header", i = header_rows, j = spanCols_ids, pr_t = style$header$text,
                       pr_c = style$header$cell, pr_p = style$header$paragraph)
  }
  if (length(header_name_rows)>0 & "header_name" %in% names(style)) {
    flex_x <- flex_x |>
      flextable::style(part = "header", i = header_name_rows, j = spanCols_ids, pr_t = style$header_name$text,
                       pr_c = style$header_name$cell, pr_p = style$header_name$paragraph)
  }
  if (length(header_level_rows)>0 & "header_level" %in% names(style)) {
    flex_x <- flex_x |>
      flextable::style(part = "header", i = header_level_rows, j = spanCols_ids, pr_t = style$header_level$text,
                       pr_c = style$header_level$cell, pr_p = style$header_level$paragraph)
  }
  if ("column_name" %in% names(style)) {
    flex_x <- flex_x |>
      flextable::style(part = "header", j = which(! 1:ncol(x) %in% spanCols_ids),
                       pr_t = style$column_name$text, pr_c = style$column_name$cell, pr_p = style$column_name$paragraph)
  }

  # Basic default + merge columns
  if (!is.null(colsToMergeRows)) { # style while merging rows
    flex_x <- fxMergeRows(flex_x, colsToMergeRows, groupNameCol)
  } else {
    if (!is.null(groupNameCol)) { # style group different
      indRowGroup <- which(!is.na(flex_x$body$dataset[[groupNameCol]]))
      flex_x <- flex_x |>
        flextable::border(
          j = 1,
          i = indRowGroup,
          border = officer::fp_border(color = "gray"),
          part = "body") |>
        flextable::border(border = officer::fp_border(color = "gray"),
                          j = 2:ncol(x),
                          part = "body") |>
        flextable::border(
          j = 1,
          border.left = officer::fp_border(color = "gray"),
          part = "body") |>
        flextable::border( # correct group level bottom
          i = nrow(flex_x$body$dataset),
          border.bottom = officer::fp_border(color = "gray"),
          part = "body") |>
        flextable::border( # correct group level right border
          i = which(!is.na(flex_x$body$dataset[[groupNameCol]])),
          j = 1,
          border.right = officer::fp_border(color = "transparent"),
          part = "body")
    } else { # style body equally
      flex_x <- flex_x |>
        flextable::border(border = officer::fp_border(color = "gray"),
                          part = "body")
    }
  }
  flex_x <- flex_x |>
    flextable::border(border = officer::fp_border(color = "gray", width = 1.2),
                      part = "header",
                      i = 1:nrow(flex_x$header$dataset)) |>
    flextable::align(part = "header", align = "center") |>
    flextable::valign(part = "header", valign = "center") |>
    flextable::align(j = spanCols_ids, part = "body", align = "right") |>
    flextable::align(j = which(!1:ncol(x) %in% spanCols_ids), part = "body", align = "left")

  # Other options:
  # caption
  if(!is.null(caption)){
    flex_x <- flex_x |>
      flextable::set_caption(caption = caption)
  }
  # title + subtitle
  if(!is.null(title) & !is.null(subtitle)){
    if (! "title" %in% names(style)) {
      style$title <- list("text" = officer::fp_text(bold = TRUE, font.size = 13),
                          "paragraph" = officer::fp_par(text.align = "center"))
    }
    if (! "subtitle" %in% names(style)) {
      style$subtitle <- list("text" = officer::fp_text(bold = TRUE, font.size = 11),
                             "paragraph" = officer::fp_par(text.align = "center"))
    }
    flex_x <- flex_x |>
      flextable::add_header_lines(values = subtitle) |>
      flextable::add_header_lines(values = title) |>
      flextable::style(part = "header", i = 1, pr_t = style$title$text,
                       pr_p = style$title$paragraph, pr_c = style$title$cell) |>
      flextable::style(part = "header", i = 2, pr_t = style$subtitle$text,
                       pr_p = style$subtitle$paragraph, pr_c = style$subtitle$cell)
  }
  # title
  if(!is.null(title)  & is.null(subtitle)){
    if (! "title" %in% names(style)) {
      style$title <- list("text" = officer::fp_text(bold = TRUE, font.size = 13),
                          "paragraph" = officer::fp_par(text.align = "center"))
    }
    flex_x <- flex_x |>
      flextable::add_header_lines(values = title) |>
      flextable::style(part = "header", i = 1, pr_t = style$title$text,
                       pr_p = style$title$paragraph, pr_c = style$title$cell)
  }
  # body
  flex_x <- flex_x |>
    flextable::style(part = "body", pr_t = style$body$text,
                     pr_p = style$body$paragraph, pr_c = style$body$cell)
  # group label
  if (!is.null(groupNameCol)) {
    if (!groupNameAsColumn) {
      flex_x <- flex_x |>
        flextable::style(part = "body", i = which(!is.na(flex_x$body$dataset[[groupNameCol]])),
                         pr_t = style$group_label$text, pr_p = style$group_label$paragraph, pr_c = style$group_label$cell)
    } else {
      flex_x <- flex_x |>
        flextable::style(part = "body", j = which(flex_x$body$dataset |> colnames() == groupNameCol),
                         pr_t = style$group_label$text, pr_p = style$group_label$paragraph, pr_c = style$group_label$cell)
    }

  }
  return(flex_x)
}


fxStyles <- function(styleName) {
  styles <- list (
    "default" = list(
      "header" = list(
        "cell" = officer::fp_cell(background.color = "#c8c8c8"),
        "text" = officer::fp_text(bold = TRUE)),
      "header_name" = list(
        "cell" = officer::fp_cell(background.color = "#d9d9d9"),
        "text" = officer::fp_text(bold = TRUE)),
      "header_level" = list(
        "cell" = officer::fp_cell(background.color = "#e1e1e1"),
        "text" = officer::fp_text(bold = TRUE)),
      "column_name" = list(
        "text" = officer::fp_text(bold = TRUE)),
      "group_label" = list(
        "cell" = officer::fp_cell(background.color = "#e9e9e9",
                                  border = officer::fp_border(color = "gray")),
        "text" = officer::fp_text(bold = TRUE)),
      "title" = list(
        "text" = officer::fp_text(bold = TRUE, font.size = 15)),
      "subtitle" = list(
        "text" = officer::fp_text(bold = TRUE, font.size = 12)),
      "body" = list()
    )
  )
  if (! styleName %in% names(styles)) {
    warning(glue::glue("{styleName} does not correspon to any of our defined styles. Returning default."),
            call. = FALSE)
    styleName <- "default"
  }
  return(styles[[styleName]])
}

fxMergeRows <- function(fx_x, colsToMergeRows, groupNameCol) {
  colNms <- colnames(fx_x$body$dataset)
  if (colsToMergeRows[1] == "all_columns") {
    if (is.null(groupNameCol)) {
      colsToMergeRows <- colNms
    } else {
      colsToMergeRows <- colNms[!colNms %in% groupNameCol]
    }
  }

  # sort
  ind <- match(colsToMergeRows, colNms)
  names(ind) <- colsToMergeRows
  colsToMergeRows <- names(sort(ind))

  # fill groupCol
  indColGroup <- NULL
  if ( !is.null(groupNameCol)) {
    groupCol <- as.character(fx_x$body$dataset[[groupNameCol]])
    for (k in 2:length(groupCol)){
      if (is.na(groupCol[k])) {
        groupCol[k] <- groupCol[k-1]
      }
    }
    indColGroup <- which(groupNameCol %in% colNms)
    indRowGroup <- which(!is.na(fx_x$body$dataset[[groupNameCol]]))
  }


  for (k in seq_along(colsToMergeRows)) {

    if (k > 1) {
      prevMerged <- mergeCol
      prevId <- prevMerged == dplyr::lag(prevMerged) & prevId
    } else {
      prevId <- rep(TRUE, nrow(fx_x$body$dataset))
    }

    col <- colsToMergeRows[k]
    mergeCol <- fx_x$body$dataset[[col]]
    mergeCol[is.na(mergeCol)] <- "this is NA"

    if (is.null(groupNameCol)) {
      id <- which(mergeCol == dplyr::lag(mergeCol) & prevId)
    } else {
      id <- which(groupCol == dplyr::lag(groupCol) & mergeCol == dplyr::lag(mergeCol) & prevId)
    }

    fx_x <- fx_x |> flextable::compose(i = id, j = ind[k], flextable::as_paragraph(flextable::as_chunk("")))
    fx_x <- fx_x |>
      flextable::border(
        i = which(!1:nrow(fx_x$body$dataset) %in% id),
        j = ind[k],
        border.top = officer::fp_border(color = "gray"),
        part = "body")
  }

  # style the rest
  fx_x <- fx_x |>
    flextable::border(
      j = which(! 1:ncol(fx_x$body$dataset) %in% c(ind, indColGroup)),
      border.top = officer::fp_border(color = "gray"),
      part = "body") |>
    flextable::border(
      j = 1:ncol(fx_x$body$dataset),
      border.right = officer::fp_border(color = "gray"),
      part = "body") |>
    flextable::border(
      j = 1,
      border.left = officer::fp_border(color = "gray"),
      part = "body") |>
    flextable::border( # correct bottom
      i = nrow(fx_x$body$dataset),
      border.bottom = officer::fp_border(color = "gray"),
      part = "body")
  if (!is.null(groupNameCol)) {
    fx_x <- fx_x |>
      flextable::border(
        j = indColGroup,
        i = indRowGroup,
        border = officer::fp_border(color = "gray"),
        part = "body") |>
      flextable::border(
        i = which(!is.na(fx_x$body$dataset[[groupNameCol]])),
        j = 1,
        border.right = officer::fp_border(color = "transparent"),
        part = "body")
  }


  return(fx_x)
}
