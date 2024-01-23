#' Creats a flextable object from a dataframe
#'
#' @param x A dataframe.
#' @param delim Delimiter.
#' @param style Named list that specifies how to style the different parts of
#' the flextable. Accepted entries are: title, subtitle, header, header_name,
#' header_level, column_name, group_label, and body.
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
#'   formatTable(header = c("Study strata", "strata_level"),
#'               includeHeader = FALSE) |>
#'   fxTable(
#'     style = list(
#'       "header" = list(
#'         "cell" = officer::fp_cell(background.color = "#c8c8c8"),
#'         "text" = officer::fp_text(bold = TRUE)),
#'       "header_level" = list(
#'         "cell" = officer::fp_cell(background.color = "#e1e1e1"),
#'         "text" = officer::fp_text(bold = TRUE)),
#'       "group_label" = list(
#'         "cell" = officer::fp_cell(
#'           background.color = "#e9ecef",
#'           border = officer::fp_border(width = 1, color = "gray")),
#'         "text" = officer::fp_text(bold = TRUE))
#'     ),
#'     na = "--",
#'     title = "fxTable example",
#'     subtitle = NULL,
#'     caption = NULL,
#'     groupNameCol = "group_level",
#'     groupNameAsColumn = TRUE,
#'     groupOrder = c("cohort1", "cohort2")
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
    style = list(
      "header" = list("cell" = officer::fp_cell(background.color = "#c8c8c8"),
                      "text" = officer::fp_text(bold = TRUE)),
      "header_name" = list("cell" = officer::fp_cell(background.color = "#d9d9d9"),
                           "text" = officer::fp_text(bold = TRUE)),
      "header_level" = list("cell" = officer::fp_cell(background.color = "#e1e1e1"),
                            "text" = officer::fp_text(bold = TRUE)),
      "column_name" = list("text" = officer::fp_text(bold = TRUE))
    ),
    na = "-",
    title = NULL,
    subtitle = NULL,
    caption = NULL,
    groupNameCol = NULL,
    groupNameAsColumn = FALSE,
    groupOrder = NULL
) {

  # Checks
  checkmate::assertDataFrame(x)
  checkmate::assertCharacter(delim, min.chars = 1, len = 1, any.missing = FALSE)
  checkmate::assertList(style, null.ok = TRUE, any.missing = FALSE)
  checkmate::assertCharacter(na, len = 1, null.ok = TRUE)
  checkmate::assertCharacter(title, len = 1, null.ok = TRUE, any.missing = FALSE)
  checkmate::assertCharacter(subtitle, len = 1, null.ok = TRUE, any.missing = FALSE)
  checkmate::assertCharacter(caption, len = 1, null.ok = TRUE, any.missing = FALSE)
  checkmate::assertCharacter(groupNameCol, null.ok = TRUE, any.missing = FALSE)
  checkmate::assertLogical(groupNameAsColumn, len = 1, any.missing = FALSE)
  checkmate::assertCharacter(groupOrder, null.ok = TRUE, any.missing = FALSE)
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
      flextable::style(part = "header", j = which(! 1:ncol(x) %in% spanCols_ids), pr_t = style$column_name$text,
                       pr_c = style$column_name$cell, pr_p = style$column_name$paragraph)
  }

  # Our default
  flex_x <- flex_x |>
    flextable::border(border = officer::fp_border(color = "gray"), part = "all") |>
    flextable::border(border = officer::fp_border(color = "gray", width = 2), part = "header", i = 1:nrow(flex_x$header$dataset)) |>
    flextable::align(part = "header", align = "center") |>
    flextable::valign(part = "header", valign = "center")

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
