#' Creats a gt object from a dataframe
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
#'
#' @return gt object
#'
#' @description
#' Creats a gt object from a dataframe using as delimiter (`delim`) to span
#' the header, and the specified styles for different parts of the table.
#'
#' @examples
#' \donttest{
#' mockSummarisedResult() |>
#'   formatEstimateValue(decimals = c(integer = 0, numeric = 1)) |>
#'   formatTable(header = c("Study strata", "strata_level"),
#'               includeHeaderName = FALSE) |>
#'   gtTable(
#'     style = list("header" = list(
#'       gt::cell_fill(color = "#d9d9d9"),
#'       gt::cell_text(weight = "bold")),
#'       "header_level" = list(gt::cell_fill(color = "#e1e1e1"),
#'                             gt::cell_text(weight = "bold")),
#'       "column_name" = list(gt::cell_text(weight = "bold")),
#'       "title" = list(gt::cell_text(weight = "bold"),
#'                      gt::cell_fill(color = "#c8c8c8")),
#'       "group_label" = gt::cell_fill(color = "#e1e1e1")),
#'     na = "--",
#'     title = "gtTable example",
#'     subtitle = NULL,
#'     caption = NULL,
#'     groupNameCol = "group_level",
#'     groupNameAsColumn = FALSE,
#'     groupOrder = c("cohort1", "cohort2")
#'   )
#' }
#'
#' @return A gt table.
#'
#' @export
#'
gtTable <- function(
    x,
    delim = "\n",
    style = "style",
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
  if (is.list(style) | is.null(style)) {
    checkmate::assertList(style, null.ok = TRUE, any.missing = FALSE)
  } else if (is.character(style)) {
    checkmate::assertCharacter(style, min.chars = 1, any.missing = FALSE, max.len = 1)
    style <- gtStyles(styleName = style)
  } else {
    cli::cli_abort("Style must be a named list of gt styling function,
                   the string 'default' for our default style, or NULL for gt default style.")
  }

  # Spanners
  if (!is.null(groupNameCol)) {
    gtResult <- x |>
      gt::gt(groupname_col = groupNameCol, row_group_as_column = groupNameAsColumn) |>
      gt::tab_spanner_delim(delim = delim)
    if (!is.null(groupOrder)) {
      gtResult <- gtResult |>
        gt::row_group_order(groups = groupOrder)
    }
  } else {
    gtResult <- x |> gt::gt() |> gt::tab_spanner_delim(delim = delim)
  }
  # Header style
  spanner_ids <- gtResult$`_spanners`$spanner_id
  style_ids <- lapply(strsplit(spanner_ids, delim), function(vect){vect[[1]]}) |> unlist()

  header_id <- grepl("\\[header\\]", style_ids)
  header_name_id <- grepl("\\[header_name\\]", style_ids)
  header_level_id <- grepl("\\[header_level\\]", style_ids)

  # column names in spanner: header_level or header?
  header_level <- all(grepl("header_level", lapply(strsplit(colnames(x)[grepl(delim, colnames(x))], delim), function(x) {x[length(x)]}) |> unlist()))

  if (sum(header_id) > 0 & "header" %in% names(style)) {
    gtResult <- gtResult |>
      gt::tab_style(
        style = style$header,
        locations = gt::cells_column_spanners(spanners = spanner_ids[header_id])
      )
    if (!header_level) {
      gtResult <- gtResult |>
        gt::tab_style(
          style = style$header,
          locations = gt::cells_column_labels(columns = which(grepl("\\[header\\]", colnames(x))))
        )
    }
  }
  if (sum(header_name_id) > 0 & "header_name" %in% names(style)) {
    gtResult <- gtResult |>
      gt::tab_style(
        style = style$header_name,
        locations = gt::cells_column_spanners(spanners = spanner_ids[header_name_id])
      )
  }
  if (sum(header_level_id) > 0 & "header_level" %in% names(style)) {
    gtResult <- gtResult |>
      gt::tab_style(
        style = style$header_level,
        locations = gt::cells_column_spanners(spanners = spanner_ids[header_level_id])
      )
    if (header_level) {
      gtResult <- gtResult |>
        gt::tab_style(
          style = style$header_level,
          locations = gt::cells_column_labels(columns = which(grepl("\\[header_level\\]", colnames(x))))
        )
    }
  }
  if ("column_name" %in% names(style)) {
    col_name_ids <- which(!grepl("\\[header\\]|\\[header_level\\]|\\[header_name\\]", colnames(x)))
    gtResult <- gtResult |>
      gt::tab_style(
        style = style$column_name,
        locations = gt::cells_column_labels(columns = col_name_ids)
      )
  }

 # Eliminate prefixes
  gtResult$`_spanners`$spanner_label <- lapply(gtResult$`_spanners`$spanner_label,
                                               function(label){
                                                 gsub("\\[header\\]|\\[header_level\\]|\\[header_name\\]|\\[column_name\\]", "", label)
                                                 })
  gtResult <- gtResult |> gt::cols_label_with(columns = tidyr::contains("header"),
                                  fn = ~ gsub("\\[header\\]|\\[header_level\\]", "", .))
  # Other options:
  ## na
  if (!is.null(na)){
    gtResult <- gtResult |> gt::sub_missing(missing_text = na)
  }
  ## caption
  if(!is.null(caption)){
    gtResult <- gtResult |>
      gt::tab_caption(
        caption = gt::md(caption)
      )
  }
  ## title + subtitle
  if(!is.null(title) & !is.null(subtitle)){
    gtResult <- gtResult |>
      gt::tab_header(
        title = title,
        subtitle = subtitle
      )
    if ("title" %in% names(style)) {
      gtResult <- gtResult |>
        gt::tab_style(
          style = style$title,
          locations = gt::cells_title(groups = "title")
        )
    }
    if ("subtitle" %in% names(style)) {
      gtResult <- gtResult |>
        gt::tab_style(
          style = style$subtitle,
          locations = gt::cells_title(groups = "subtitle")
        )
    }
  }
  ## title
  if(!is.null(title)  & is.null(subtitle)){
    gtResult <- gtResult |>
      gt::tab_header(
        title = title
      )
    if ("title" %in% names(style)) {
      gtResult <- gtResult |>
        gt::tab_style(
          style = style$title,
          locations = gt::cells_title(groups = "title")
        )
    }
  }
  ## body
  if ("body" %in% names(style)) {
    gtResult <- gtResult |>
      gt::tab_style(
        style = style$body,
        locations = gt::cells_body()
      )
  }
  ## group_label
  if ("group_label" %in% names(style)) {
    gtResult <- gtResult |>
      gt::tab_style(
        style = style$group_label,
        locations = gt::cells_row_groups()
      )
  }
  return(gtResult)
}

gtStyles <- function(styleName) {
  styles <- list (
    "default" = list(
      "header" = list(gt::cell_fill(color = "#c8c8c8"),
                      gt::cell_text(weight = "bold", align = "center")),
      "header_name" = list(gt::cell_fill(color = "#d9d9d9"),
                           gt::cell_text(weight = "bold", align = "center")),
      "header_level" = list(gt::cell_fill(color = "#e1e1e1"),
                            gt::cell_text(weight = "bold", align = "center")),
      "column_name" = list(gt::cell_text(weight = "bold", align = "center")),
      "group_label" = list(gt::cell_fill(color = "#e9e9e9"),
                           gt::cell_text(weight = "bold")),
      "title" = list(gt::cell_text(weight = "bold", size = 15, align = "center")),
      "subtitle" = list(gt::cell_text(weight = "bold", size = 12, align = "center")),
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
