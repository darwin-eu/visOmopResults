
#' Creats a gt table from a tibble using as deliminter (`delim`) for spanners.
#'
#' @param x A dataframe.
#' @param delim Delimiter.
#' @param style Named list that specifies how to style the different parts of
#' the table. Accepted entries are: title, subtitle, header, header_name,
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
#' @examples
#' \donttest{
#' mockSummarisedResult() |>
#'   formatEstimateValue(decimals = c(integer = 0, numeric = 1)) |>
#'   spanHeader(header = c("Study strata", "strata_level"),
#'              includeHeader = FALSE) |>
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
    style = list(
      "header" = list(
        gt::cell_fill(color = "#c8c8c8"),
        gt::cell_text(weight = "bold")
      ),
      "header_name" = list(gt::cell_fill(color = "#e1e1e1"),
                           gt::cell_text(weight = "bold")),
      "header_level" = list(gt::cell_fill(color = "#ffffff"),
                            gt::cell_text(weight = "bold")),
      "column_name" = list(gt::cell_text(weight = "bold"))
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

  if (sum(header_id) > 0 & "header" %in% names(style)) {
    gtResult <- gtResult |>
      gt::tab_style(
        style = style$header,
        locations = gt::cells_column_spanners(spanners = spanner_ids[header_id])
      )
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
  }
  if ("column_name" %in% names(style)) {
    gtResult <- gtResult |>
      gt::tab_style(
        style = style$column_name,
        locations = gt::cells_column_labels()
      )
  }

 # Eliminate prefixes
  gtResult$`_spanners`$spanner_label <- lapply(gtResult$`_spanners`$spanner_label,
                                               function(label){
                                                 gsub("\\[header\\]|\\[header_level\\]|\\[header_name\\]|\\[column_name\\]", "", label)
                                                 })
  gtResult <- gtResult |> gt::cols_label_with(columns = tidyr::contains("[column_name]"),
                                  fn = ~ gsub("\\[column_name\\]", "", .))
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
