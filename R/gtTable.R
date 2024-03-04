#' Creates a gt object from a dataframe
#'
#' @param x A dataframe.
#' @param delim Delimiter.
#' @param style Named list that specifies how to style the different parts of
#' the gt table. Accepted entries are: title, subtitle, header, header_name,
#' header_level, column_name, group_label, and body. Alternatively, use
#' "default" to get visOmopResults style, or NULL for gt style
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
#' @param colsToMergeRows Names of the columns to merge vertically
#' when consecutive row cells have identical values. Alternatively, use
#' "all_columns" to apply this merging to all columns, or use NULL to indicate
#' no merging.
#'
#' @return gt object.
#'
#' @description
#' Creates a flextable object from a dataframe using a delimiter to span
#' the header, and allows to easily customise table style.
#'
#' @examples
#' mockSummarisedResult() |>
#'   formatEstimateValue(decimals = c(integer = 0, numeric = 1)) |>
#'   formatHeader(header = c("Study strata", "strata_name", "strata_level"),
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
#'     groupOrder = c("cohort1", "cohort2"),
#'     colsToMergeRows = "all_columns"
#'   )
#'
#' @return A gt table.
#'
#' @export
#'
gtTable <- function(
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

  # Package checks
  rlang::check_installed("gt")

  # Input checks
  assertTibble(x)
  assertCharacter(delim, length = 1)
  assertCharacter(na, length = 1, null = TRUE)
  assertCharacter(title, length = 1, null = TRUE)
  assertCharacter(subtitle, length = 1, null = TRUE)
  assertCharacter(caption, length = 1, null= TRUE)
  assertCharacter(groupNameCol, null = TRUE)
  assertLogical(groupNameAsColumn, length = 1)
  assertCharacter(groupOrder, null = TRUE)
  assertCharacter(colsToMergeRows, null = TRUE)
  validateColsToMergeRows(x, colsToMergeRows, groupNameCol)
  style <- validateStyle(style, "gt")
  if (is.null(title) & !is.null(subtitle)) {
    cli::cli_abort("There must be a title for a subtitle.")
  }

  # na
  if (!is.null(na)){
    x <- x |>
      dplyr::mutate(
        dplyr::across(dplyr::where(~is.numeric(.x)), ~as.character(.x)),
        dplyr::across(colnames(x), ~ dplyr::if_else(is.na(.x), na, .x))
      )
  }

  # Spanners
  if (!is.null(groupNameCol)) {
    if (is.null(groupOrder)) {
      x <- x |>
        dplyr::mutate(!!groupNameCol := factor(.data[[groupNameCol]])) |>
        dplyr::arrange_at(groupNameCol, .by_group = TRUE)
    } else {
      x <- x |>
        dplyr::mutate(!!groupNameCol := factor(.data[[groupNameCol]], levels = groupOrder)) |>
        dplyr::arrange_at(groupNameCol, .by_group = TRUE)
    }
    gtResult <- x |>
      gt::gt(groupname_col = groupNameCol, row_group_as_column = groupNameAsColumn) |>
      gt::tab_spanner_delim(delim = delim) |>
        gt::row_group_order(groups = x[[groupNameCol]] |> levels())
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

  # Our default:
  gtResult <- gtResult |>
    gt::tab_style(
      style = gt::cell_text(align = "right"),
      locations = gt::cells_body(columns = which(grepl("\\[header\\]|\\[header_level\\]|\\[header_name\\]|\\[column_name\\]", colnames(x))))
    ) |>
    gt::tab_style(
      style = gt::cell_text(align = "left"),
      locations = gt::cells_body(columns = which(!grepl("\\[header\\]|\\[header_level\\]|\\[header_name\\]|\\[column_name\\]", colnames(x))))
    ) |>
    gt::tab_style(
      style = list(gt::cell_borders(color = "#D3D3D3")),
      locations = list(gt::cells_body(columns = 2:(ncol(x)-1)))
    )

  # Merge rows
  if (!is.null(colsToMergeRows)) {
    gtResult <- gtMergeRows(gtResult, colsToMergeRows, groupNameCol, groupOrder)
  }

   # Other options:
  ## na
  # if (!is.null(na)){
  #   # gtResult <- gtResult |> gt::sub_missing(missing_text = na)
  # }
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
    warning(paste0(styleName, "does not correspon to any of our defined styles. Returning default."),
            call. = FALSE)
    styleName <- "default"
  }
  return(styles[[styleName]])
}

gtMergeRows <- function(gt_x, colsToMergeRows, groupNameCol, groupOrder) {

  colNms <- colnames(gt_x$`_data`)
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

  for (k in seq_along(colsToMergeRows)) {

    if (k > 1) {
      prevMerged <- mergeCol
      prevId <- prevMerged == dplyr::lag(prevMerged) & prevId
    } else {
      prevId <- rep(TRUE, nrow(gt_x$`_data`))
    }

    col <- colsToMergeRows[k]
    mergeCol <- gt_x$`_data`[[col]]
    mergeCol[is.na(mergeCol)] <- "-"

    if (is.null(groupNameCol)) {
      id <- which(mergeCol == dplyr::lag(mergeCol) & prevId)
    } else {
      groupCol <- gt_x$`_data`[[groupNameCol]]
      id <- which(groupCol == dplyr::lag(groupCol) & mergeCol == dplyr::lag(mergeCol) & prevId)
    }

    gt_x$`_data`[[col]][id] <- ""
    gt_x <- gt_x |>
      gt::tab_style(
        style = list(gt::cell_borders(style = "hidden", sides = "top")),
        locations = list(gt::cells_body(columns = col, rows = id))
      )
  }
  return(gt_x)
}
