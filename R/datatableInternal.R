datatableInternal <- function(x,
                              delim = "\n",
                              style = "default",
                              caption = NULL,
                              groupColumn = NULL) {

  # Package checks
  rlang::check_installed("DT")
  rlang::check_installed("htmltools")

  style <- validateStyle(style, "datatable")
  options <- style[c(
    "scrollX", "scrollY", "scrollCollapse", "pageLength", "lengthMenu",
    "searchHighlight", "scroller", "deferRender", "fixedColumns",
    "fixedHeader"
  )]
  options <- options[!sapply(options, is.null)]

  # Eliminate prefixes
  colnames(x) <- gsub("\\[header\\]|\\[header_level\\]|\\[header_name\\]|\\[column_name\\]", "", colnames(x))

  # groupColumn
  if (length(groupColumn) > 0) {
    nameGroup <- names(groupColumn)
    x <- x |>
      tidyr::unite(
        !!nameGroup, groupColumn[[1]], sep = "; ", remove = TRUE, na.rm = TRUE
      ) |>
      dplyr::relocate(!!nameGroup)
    options$rowGroup = list(dataSrc = 1)
  }

  # header
  header <- colnames(x)
  container <- paste0("<table class='display'><thead><tr>", paste0("<th>", header, "</th>", collapse = " "), "</tr></thead></table>")
  if (any(grepl(delim, header))) {
    header_split <- stringr::str_split(header, paste0("\\", delim))

    levels <- sapply(header_split, length)
    max_depth <- max(levels)
    if (length(unique(levels)) > max_depth) {
      cli::cli_abort("In this package version, all headers must have the same number of levels.")
    }

    inHtml <- NULL
    for (ii in 1:max_depth) {
      levelHeaders <- sapply(header_split, function(x){x[ii]})
      levelHeaders <- levelHeaders[!is.na(levelHeaders)]
      levelHeadersTable <- table(levelHeaders)

      if (ii != max_depth) {
        html.ii <- lapply(unique(levelHeaders), function(item) {
          if (levelHeadersTable[item] == 1) {
            paste0("<th rowspan='", max_depth, "'>", item, "</th>")
          } else {
            paste0("<th colspan ='", levelHeadersTable[item], "'>", item, "</th>")
          }
        }) |> unlist() |> paste0(collapse = "\n")
        html.ii <- paste0("<tr>", html.ii, "</tr>")

      } else {
        html.ii <- paste0("<th>", levelHeaders, "</th>", collapse = "\n")
      }

      inHtml <- c(inHtml, paste0("<tr>", html.ii, "</tr>"))
    }

    container <- paste0("<table class='display'>",paste0("<thead>", inHtml |> paste0(collapse = "\n"), "</thead>"), "</table>")
  }

  # datatable
  if (is.null(style$filter)) {
    DT::datatable(
      x,
      options = options,
      caption =  htmltools::tags$caption(
        style = style$caption, caption
      ),
      rownames = style$rownames,
      extensions = list("FixedColumns", "FixedHeader", "Responsive", "RowGroup", "Scroller"),
      container = container
    )
  } else {
    DT::datatable(
      x,
      options = options,
      caption =  htmltools::tags$caption(
        style = style$caption, caption
      ),
      filter = style$filter,
      rownames = style$rownames,
      extensions = list("FixedColumns", "FixedHeader", "Responsive", "RowGroup", "Scroller"),
      container = container
    )
  }
}

datatableStyleInternal <- function(styleName) {
  styles <- list(
    "default" = list(
      # "header" = list(),
      # "header_name" = list(),
      # "header_level" = list(),
      # "column_name" = list(),
      # "group_label" = list(),
      # "title" = list(),
      # "subtitle" = list(),
      # "body" = list()
      "caption" = 'caption-side: bottom; text-align: center;',
      "scrollX" = TRUE,
      "scrollY" = 400,
      "scroller" = TRUE,
      "deferRender" = TRUE,
      "scrollCollapse" = TRUE,
      "fixedColumns" = list(leftColumns = 0, rightColumns = 0),
      "fixedHeader" = TRUE,
      "pageLength" = 10,
      "lengthMenu" = c(5, 10, 20, 50, 100),
      "filter" = "bottom",
      "searchHighlight" = TRUE,
      "rownames" = FALSE
    )
  )
  if (!styleName %in% names(styles)) {
    cli::cli_inform(c("i" = "{styleName} does not correspon to any of our defined styles. Returning default style."))
    styleName <- "default"
  }
  return(styles[[styleName]])
}
