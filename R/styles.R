
# default Styles
defaultStyles <- function() {
  list.files(system.file("brand", package = "visOmopResults")) |>
    purrr::keep(\(x) stringr::str_ends(string = x, pattern = "\\.yml")) |>
    stringr::str_replace_all(pattern = "\\.yml$", replacement = "")
}

# check style and return link to yml
checkStyle <- function(style, call = parent.frame()) {
  sts <- defaultStyles()
  errorMessage <- c(x = "`style` must be a choice between default styles
  ({.var {sts}}) or point to an existing `.yml` file.")
  if (!is.character(style)) {
    cli::cli_abort(message = errorMessage, call = call)
  } else if (length(style) != 1) {
    cli::cli_abort(message = errorMessage, call = call)
  } else {
    if (style %in% sts) {
      file <- system.file("brand", paste0(style, ".yml"), package = "visOmopResults")
    } else if (stringr::str_ends(string = style, pattern = "\\.yml")) {
      if (file.exists(style)) {
        file <- style
      } else {
        cli::cli_abort(message = c("!" = "File {.path {style}} does not exist.", errorMessage), call = call)
      }
    } else {
      cli::cli_abort(message = errorMessage, call = call)
    }
  }

  return(file)
}

# transform the yaml to the internal list format
brandToList <- function(content) {
  # update colours from palette
  content <- updateColoursFromPalette(content = content)

  # collapse content
  content <- collapseContent(content)

  # get information from labels
  x <- labels() |>
    purrr::map(\(x) {
      lab <- x[x %in% names(content)][1]
      if (!is.na(lab)) {
        content[[lab]]
      } else {
        NULL
      }
    }) |>
    purrr::compact()

  return(x)
}
# substitute colours from palette
updateColoursFromPalette <- function(content) {
  colours <- content$color$palette
  if (length(colours) > 0) {
    content <- content |>
      rapply(
        f = \(x) {
          if (is.character(x)) {
            for (k in seq_along(x)) {
              if (x[k] %in% names(colours)) {
                x[k] <- colours[[x[k]]]
              }
            }
          }
          x
        },
        how = "replace"
      )
  }
  content
}
# collapse content into a list vector using : as separator for names
collapseContent <- function(x, prefix = "") {
  result <- list()

  for (nm in names(x)) {
    key <- ifelse(prefix == "", nm, paste0(prefix, ":", nm))
    val <- x[[nm]]

    if (is.list(val)) {
      result <- c(result, collapseContent(val, prefix = key))
    } else {
      result[[key]] <- val
    }
  }

  result
}
# labels hierarchy (do not use `.` in names as they will be converted to `:`)
labels <- function() {
  list(
    # plot parameters
    plot_background_color = c("defaults:visOmopResults:plot:background_color", "color:background"),
    plot_header_color = c("defaults:visOmopResults:plot:header_color", "color:foreground"),
    plot_header_text_color = c("defaults:visOmopResults:plot:header_text_color"),
    plot_header_text_bold = c("defaults:visOmopResults:plot:header_text_bold"),
    plot_font_size = c("defaults:visOmopResults:plot:font_size", "defaults:visOmopResults:plot:font_size", "typography:base:size"),
    plot_border_color = c("defaults:visOmopResults:plot:border_color", "color:foreground"),
    plot_grid_color = c("defaults:visOmopResults:plot:grid_major_color", "color:foreground"),
    plot_axis_color = c("defaults:visOmopResults:plot:axis_color"),
    plot_legend_position = c("defaults:visOmopResults:plot:legend_position"),
    plot_font_family = c("defaults:visOmopResults:plot:font_family", "typography:base:family"),

    # plot palettes
    plot_color_palette = c("defaults:visOmopResults:plot:color_palette"),
    plot_fill_palette = c("defaults:visOmopResults:plot:fill_palette", "defaults:visOmopResults:plot:color_palette"),

    # table parameters
    # header
    table_header_background_color = c("defaults:visOmopResults:table:header:background_color", "color:background"),
    table_header_text_bold = c("defaults:visOmopResults:table:header:text_bold"),
    table_header_text_color = c("defaults:visOmopResults:table:header:text_color"),
    table_header_font_size = c("defaults:visOmopResults:table:header:font_size", "defaults:visOmopResults:table:font_size", "typography:base:size"),
    table_header_font_family = c("defaults:visOmopResults:table:header:font_family", "defaults:visOmopResults:table:font_family", "typography:base:family"),
    table_header_align = c("defaults:visOmopResults:table:header:align", "defaults:visOmopResults:table:align"),
    table_header_border_color = c("defaults:visOmopResults:table:header:border_color", "defaults:visOmopResults:table:border_color"),
    table_header_border_width = c("defaults:visOmopResults:table:header:border_width", "defaults:visOmopResults:table:border_width"),
    table_header_text_line_space = c("defaults:visOmopResults:table:header:text_line_space", "defaults:visOmopResults:table:text_line_space"),
    table_header_text_space_before = c("defaults:visOmopResults:table:header:text_space_before", "defaults:visOmopResults:table:text_space_before"),
    table_header_text_space_after = c("defaults:visOmopResults:table:header:text_space_after", "defaults:visOmopResults:table:text_space_after"),
    # header name
    table_header_name_background_color = c("defaults:visOmopResults:table:header_name:background_color", "color:background"),
    table_header_name_text_bold = c("defaults:visOmopResults:table:header_name:text_bold"),
    table_header_name_text_color = c("defaults:visOmopResults:table:header_name:text_color"),
    table_header_name_font_size = c("defaults:visOmopResults:table:header_name:font_size", "defaults:visOmopResults:table:font_size", "typography:base:size"),
    table_header_name_font_family = c("defaults:visOmopResults:table:header_name:font_family", "defaults:visOmopResults:table:font_family", "typography:base:family"),
    table_header_name_align = c("defaults:visOmopResults:table:header_name:align", "defaults:visOmopResults:table:align"),
    table_header_name_border_color = c("defaults:visOmopResults:table:header_name:border_color", "defaults:visOmopResults:table:border_color"),
    table_header_name_border_width = c("defaults:visOmopResults:table:header_name:border_width", "defaults:visOmopResults:table:border_width"),
    table_header_name_text_line_space = c("defaults:visOmopResults:table:header_name:text_line_space", "defaults:visOmopResults:table:text_line_space"),
    table_header_name_text_space_before = c("defaults:visOmopResults:table:header_name:text_space_before", "defaults:visOmopResults:table:text_space_before"),
    table_header_name_text_space_after = c("defaults:visOmopResults:table:header_name:text_space_after", "defaults:visOmopResults:table:text_space_after"),
    # header_level
    table_header_level_background_color = c("defaults:visOmopResults:table:header_level:background_color", "color:background"),
    table_header_level_text_bold = c("defaults:visOmopResults:table:header_level:text_bold"),
    table_header_level_text_color = c("defaults:visOmopResults:table:header_level:text_color"),
    table_header_level_font_size = c("defaults:visOmopResults:table:header_level:font_size", "defaults:visOmopResults:table:font_size", "typography:base:size"),
    table_header_level_font_family = c("defaults:visOmopResults:table:header_level:font_family", "defaults:visOmopResults:table:font_family", "typography:base:family"),
    table_header_level_align = c("defaults:visOmopResults:table:header_level:align", "defaults:visOmopResults:table:align"),
    table_header_level_border_color = c("defaults:visOmopResults:table:header_level:border_color", "defaults:visOmopResults:table:border_color"),
    table_header_level_border_width = c("defaults:visOmopResults:table:header_level:border_width", "defaults:visOmopResults:table:border_width"),
    table_header_level_text_line_space = c("defaults:visOmopResults:table:header_level:text_line_space", "defaults:visOmopResults:table:text_line_space"),
    table_header_level_text_space_before = c("defaults:visOmopResults:table:header_level:text_space_before", "defaults:visOmopResults:table:text_space_before"),
    table_header_level_text_space_after = c("defaults:visOmopResults:table:header_level:text_space_after", "defaults:visOmopResults:table:text_space_after"),
    # column_name
    table_column_name_background_color = c("defaults:visOmopResults:table:column_name:background_color", "color:background"),
    table_column_name_text_bold = c("defaults:visOmopResults:table:column_name:text_bold"),
    table_column_name_text_color = c("defaults:visOmopResults:table:column_name:text_color"),
    table_column_name_font_size = c("defaults:visOmopResults:table:column_name:font_size", "defaults:visOmopResults:table:font_size", "typography:base:size"),
    table_column_name_font_family = c("defaults:visOmopResults:table:column_name:font_family", "defaults:visOmopResults:table:font_family", "typography:base:family"),
    table_column_name_align = c("defaults:visOmopResults:table:column_name:align", "defaults:visOmopResults:table:align"),
    table_column_name_border_color = c("defaults:visOmopResults:table:column_name:border_color", "defaults:visOmopResults:table:border_color"),
    table_column_name_border_width = c("defaults:visOmopResults:table:column_name:border_width", "defaults:visOmopResults:table:border_width"),
    table_column_name_text_line_space = c("defaults:visOmopResults:table:column_name:text_line_space", "defaults:visOmopResults:table:text_line_space"),
    table_column_name_text_space_before = c("defaults:visOmopResults:table:column_name:text_space_before", "defaults:visOmopResults:table:text_space_before"),
    table_column_name_text_space_after = c("defaults:visOmopResults:table:column_name:text_space_after", "defaults:visOmopResults:table:text_space_after"),
    # group_label
    table_group_label_background_color = c("defaults:visOmopResults:table:group_label:background_color", "color:background"),
    table_group_label_text_bold = c("defaults:visOmopResults:table:group_label:text_bold"),
    table_group_label_text_color = c("defaults:visOmopResults:table:group_label:text_color"),
    table_group_label_font_size = c("defaults:visOmopResults:table:group_label:font_size", "defaults:visOmopResults:table:font_size", "typography:base:size"),
    table_group_label_font_family = c("defaults:visOmopResults:table:group_label:font_family", "defaults:visOmopResults:table:font_family", "typography:base:family"),
    table_group_label_align = c("defaults:visOmopResults:table:group_label:align", "defaults:visOmopResults:table:align"),
    table_group_label_border_color = c("defaults:visOmopResults:table:group_label:border_color", "defaults:visOmopResults:table:border_color"),
    table_group_label_border_width = c("defaults:visOmopResults:table:group_label:border_width", "defaults:visOmopResults:table:border_width"),
    table_group_label_text_line_space = c("defaults:visOmopResults:table:group_label:text_line_space", "defaults:visOmopResults:table:text_line_space"),
    table_group_label_text_space_before = c("defaults:visOmopResults:table:group_label:text_space_before", "defaults:visOmopResults:table:text_space_before"),
    table_group_label_text_space_after = c("defaults:visOmopResults:table:group_label:text_space_after", "defaults:visOmopResults:table:text_space_after"),
    # title
    table_title_background_color = c("defaults:visOmopResults:table:title:background_color", "color:background"),
    table_title_text_bold = c("defaults:visOmopResults:table:title:text_bold"),
    table_title_text_color = c("defaults:visOmopResults:table:title:text_color"),
    table_title_font_size = c("defaults:visOmopResults:table:title:font_size", "defaults:visOmopResults:table:font_size", "typography:base:size"),
    table_title_font_family = c("defaults:visOmopResults:table:title:font_family", "defaults:visOmopResults:table:font_family", "typography:base:family"),
    table_title_align = c("defaults:visOmopResults:table:title:align", "defaults:visOmopResults:table:align"),
    table_title_border_color = c("defaults:visOmopResults:table:title:border_color", "defaults:visOmopResults:table:border_color"),
    table_title_border_width = c("defaults:visOmopResults:table:title:border_width", "defaults:visOmopResults:table:border_width"),
    # subtitle
    table_subtitle_background_color = c("defaults:visOmopResults:table:subtitle:background_color", "color:background"),
    table_subtitle_text_bold = c("defaults:visOmopResults:table:subtitle:text_bold"),
    table_subtitle_text_color = c("defaults:visOmopResults:table:subtitle:text_color"),
    table_subtitle_font_size = c("defaults:visOmopResults:table:subtitle:font_size", "defaults:visOmopResults:table:font_size", "typography:base:size"),
    table_subtitle_font_family = c("defaults:visOmopResults:table:subtitle:font_family", "defaults:visOmopResults:table:font_family", "typography:base:family"),
    table_subtitle_align = c("defaults:visOmopResults:table:subtitle:align", "defaults:visOmopResults:table:align"),
    table_subtitle_border_color = c("defaults:visOmopResults:table:subtitle:border_color", "defaults:visOmopResults:table:border_color"),
    table_subtitle_border_width = c("defaults:visOmopResults:table:subtitle:border_width", "defaults:visOmopResults:table:border_width"),
    # body
    table_body_background_color = c("defaults:visOmopResults:table:body:background_color", "color:background"),
    table_body_text_bold = c("defaults:visOmopResults:table:body:text_bold"),
    table_body_text_color = c("defaults:visOmopResults:table:body:text_color"),
    table_body_font_size = c("defaults:visOmopResults:table:body:font_size", "defaults:visOmopResults:table:font_size", "typography:base:size"),
    table_body_font_family = c("defaults:visOmopResults:table:body:font_family", "defaults:visOmopResults:table:font_family", "typography:base:family"),
    table_body_align = c("defaults:visOmopResults:table:body:align", "defaults:visOmopResults:table:align"),
    table_body_border_color = c("defaults:visOmopResults:table:body:border_color", "defaults:visOmopResults:table:border_color"),
    table_body_border_width = c("defaults:visOmopResults:table:body:border_width", "defaults:visOmopResults:table:border_width"),
    table_body_text_line_space = c("defaults:visOmopResults:table:body:text_line_space", "defaults:visOmopResults:table:text_line_space"),
    table_body_text_space_before = c("defaults:visOmopResults:table:body:text_space_before", "defaults:visOmopResults:table:text_space_before"),
    table_body_text_space_after = c("defaults:visOmopResults:table:body:text_space_after", "defaults:visOmopResults:table:text_space_after")
  )
}

# format table style in the specific type
formatTableStyle <- function(x, type) {
  if (type == "gt") {
    rlang::check_installed("gt")
    style <- styleGt(x = x)
  } else if (type == "flextable") {
    rlang::check_installed(c("flextable", "officer"))
    style <- styleFx(x = x)
  } else if (type == "tibble") {
    style <- list()
  } else if (type == "datatable") {
    rlang::check_installed(c("DT", "htmltools"))
    style <- styleDT(x = x)
  } else if (type == "reactable") {
    rlang::check_installed("reactable")
    style <- styleRT(x = x)
  } else if (type == "tinytable") {
    rlang::check_installed("tinytable")
    style <- styleTT(x = x)
  } else {
    cli::cli_abort(c(x = "Not supported type ('{type}')"))
  }
  return(style)
}
styleGt <- function(x) {

  fontFamily <- x[grepl("font_family", names(x)) & grepl("table", names(x))] |> unlist() |> unique()
  for (font in fontFamily) {
    x[x == font] <- safeFontFamily(family = font, ggDefaultFont = "system-ui")
  }

  correctGtColor <-
    labelsGt() |>
    rlang::set_names() |>
    purrr::map(\(lab) {
      nm1 <- paste0("table_", lab, "_background_color")
      nm2 <- paste0("table_", lab, "_text_bold")
      nm3 <- paste0("table_", lab, "_align")
      nm4 <- paste0("table_", lab, "_font_size")
      nm5 <- paste0("table_", lab, "_border_color")
      nm6 <- paste0("table_", lab, "_font_family")
      nm7 <- paste0("table_", lab, "_text_color")
      nm8 <- paste0("table_", lab, "_border_width")
      nm9 <- paste0("table_", lab, "_text_line_space")
      nm10 <- paste0("table_", lab, "_text_space_before")
      nm11 <- paste0("table_", lab, "_text_space_after")

      if (any(c(nm9, nm10, nm11) %in% names(x))) {
        cli::cli_inform("`text_line_space`, `text_space_before`, and `text_space_after` not supported for `gt`")
      }

      res <- list()

      # gt::cell_fill
      if (nm1 %in% names(x)) {
        res <- c(res, list(gt::cell_fill(color = x[[nm1]])))
      }

      # gt::cell_text
      args <- list()
      if (nm2 %in% names(x)) {
        args$weight <- ifelse(x[[nm2]] == "TRUE", "bold", "normal")
      }
      if (nm3 %in% names(x)) {
        args$align <- x[[nm3]]
      }
      if (nm4 %in% names(x)) {
        args$size <- as.numeric(gsub("pt", "", x[[nm4]]))
      }
      if (nm6 %in% names(x)) {
        args$font <- x[[nm6]]
      }
      if (nm7 %in% names(x)) {
        args$color <- x[[nm7]]
      }
      if (length(args) > 0) {
        res <- c(res, list(do.call(what = gt::cell_text, args = args)))
      }

      # gt::cell_borders
      args <- list()
      if (nm5 %in% names(x)) {
        args$color <- x[[nm5]]
      }
      if (nm8 %in% names(x)) {
        args$weight <- gt::px(as.numeric(x[[nm8]]))
      }
      if (length(args) > 0) {
        res <- c(res, list(do.call(what = gt::cell_borders, args = args)))
      }

      res
    })
}

styleFx <- function(x) {

  fontFamily <- x[grepl("font_family", names(x)) & grepl("table", names(x))] |> unlist() |> unique()
  for (font in fontFamily) {
    x[x == font] <- safeFontFamily(family = font, ggDefaultFont = "Helvetica")
  }

  labelsFlextable() |>
    rlang::set_names() |>
    purrr::map(\(lab) {
      nm1 <- paste0("table_", lab, "_background_color")
      nm2 <- paste0("table_", lab, "_text_bold")
      nm3 <- paste0("table_", lab, "_align")
      nm4 <- paste0("table_", lab, "_font_size")
      nm5 <- paste0("table_", lab, "_border_color")
      nm6 <- paste0("table_", lab, "_font_family")
      nm7 <- paste0("table_", lab, "_text_color")
      nm8 <- paste0("table_", lab, "_border_width")
      nm9 <- paste0("table_", lab, "_text_line_space")
      nm10 <- paste0("table_", lab, "_text_space_before")
      nm11 <- paste0("table_", lab, "_text_space_after")

      res <- list()

      # officer::fp_cell
      args <- list()
      if (nm1 %in% names(x)) {
        args$background.color <- x[[nm1]]
      }
      if (nm5 %in% names(x)) {
        if (nm8 %in% names(x)) {
          args$border <- officer::fp_border(color = x[[nm5]], width = as.numeric(x[[nm8]]))
        } else {
          args$border <- officer::fp_border(color = x[[nm5]])
        }
      } else if (nm8 %in% names(x)) {
        args$border <- officer::fp_border(width = as.numeric(x[[nm8]]))
      }
      if (nm10 %in% names(x)) {
        args$margin.top <- as.numeric(x[[nm10]])
      }
      if (nm11 %in% names(x)) {
        args$margin.bottom <- as.numeric(x[[nm11]])
      }
      if (length(args) > 0) {
        res <- c(res, list(cell = do.call(what = officer::fp_cell, args = args)))
      }

      # officer::fp_text
      args <- list()
      if (nm2 %in% names(x)) {
        args$bold <- as.logical(x[[nm2]])
      }
      if (nm4 %in% names(x)) {
        args$font.size <- as.numeric(gsub("pt", "", x[[nm4]]))
      }
      if (nm6 %in% names(x)) {
        args$font.family <- x[[nm6]]
      }
      if (nm7 %in% names(x)) {
        args$color <- x[[nm7]]
      }
      if (length(args) > 0) {
        res <- c(res, list(text = do.call(what = officer::fp_text, args = args)))
      }

      # officer::fp_par
      args <- list()
      if (nm3 %in% names(x)) {
        args$text.align <- x[[nm3]]
      }
      if (nm9 %in% names(x)) {
        args$line_spacing <- as.numeric(x[[nm9]])
      }
      if (length(args) > 0) {
        res <- c(res, list(text = do.call(what = officer::fp_par, args = args)))
      }

      res
    })
}
styleDT <- function(x) {
  defaultDatatable()
}
styleRT <- function(x) {
  defaultReactable()
}
styleTT <- function(x) {

  fontFamily <- x[grepl("font_family", names(x)) & grepl("table", names(x))] |> unlist() |> unique()
  if (length(fontFamily) > 0) {
    cli::cli_warn("Font family is not currently available for customisation in `tinytable`")
  }

  labelsTinytable() |>
    rlang::set_names() |>
    purrr::map(\(lab) {
      nm1 <- paste0("table_", lab, "_background_color")
      nm2 <- paste0("table_", lab, "_text_bold")
      nm3 <- paste0("table_", lab, "_align")
      nm4 <- paste0("table_", lab, "_font_size")
      nm5 <- paste0("table_", lab, "_border_color")
      nm6 <- paste0("table_", lab, "_font_family")
      nm7 <- paste0("table_", lab, "_text_color")
      nm8 <- paste0("table_", lab, "_border_width")
      nm9 <- paste0("table_", lab, "_text_line_space")
      nm10 <- paste0("table_", lab, "_text_space_before")
      nm11 <- paste0("table_", lab, "_text_space_after")

      if (any(c(nm9, nm10, nm11) %in% names(x))) {
        cli::cli_inform("`text_line_space`, `text_space_before`, and `text_space_after` not supported for `gt`")
      }

      res <- list(line = "lbtr")

      if (nm1 %in% names(x)) {
        res$background <- x[[nm1]]
      }
      if (nm2 %in% names(x)) {
        res$bold <- as.logical(x[[nm2]])
      }
      if (nm3 %in% names(x)) {
        res$align <- substr(x[[nm3]], 1, 1)
      }
      if (nm4 %in% names(x)) {
        res$fontsize <- as.numeric(gsub("pt", "", x[[nm4]]))
      }
      if (nm5 %in% names(x)) {
        res$line_color <- x[[nm5]]
      }

      if (nm7 %in% names(x)) {
        res$color <- x[[nm7]]
      }
      if (nm8 %in% names(x)) {
        res$line_width <- as.numeric(x[[nm8]])/16 # px to em
      }

      return(res)
    })
}
labelsTinytable <- function() {
  c("header", "header_name", "header_level", "column_name", "group_label",
    "title", "subtitle", "body")
}
labelsGt <- function() {
  c("header", "header_name", "header_level", "column_name", "group_label",
    "title", "subtitle", "body")
}
labelsFlextable <- function() {
  c("header", "header_name", "header_level", "column_name", "group_label",
    "title", "subtitle", "body")
}
defaultDatatable <- function() {
  list(
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
}
defaultReactable <- function() {
  list(
    "defaultColDef" = reactable::colDef(
      sortable = TRUE,
      resizable = TRUE,
      filterable = TRUE,
      headerStyle = list(textAlign = "center")
    ),
    "defaultColGroup" = reactable::colGroup(
      headerStyle = list(textAlign = "center")
    ),
    "defaultSortOrder" = "asc",
    "defaultSorted" = NULL,
    "defaultPageSize" = 10,
    "defaultExpanded" = TRUE,
    "highlight" = TRUE,
    "outlined" = FALSE,
    "bordered" = FALSE,
    "borderless" = FALSE,
    "striped" = TRUE,
    "theme" = NULL
  )
}

# helper function: check fontFamily is installed and loaded
safeFontFamily <- function(family, ggDefaultFont = "sans", registerFont = FALSE, call = parent.frame()) {

  rlang::check_installed("systemfonts")

  # Basic validation
  if (is.null(family)) return(family)
  if (!is.character(family) || length(family) != 1 || is.na(family) || nchar(family) == 0) {
    stop("`family` must be a non-empty single character string.", call. = FALSE)
  }
  if (identical(family, ggDefaultFont)) return(family)

  # Get authoritative OS-installed font families via systemfonts
  sysFonts <- systemfonts::system_fonts()
  osFamilies <- unique(as.character(sysFonts$family))

  if (.Platform$OS.type == "windows") {
    registeredFamilies <- names(grDevices::windowsFonts())
    # Check case-insensitive: is requested font already registered?
    if (!tolower(family) %in% tolower(registeredFamilies)) {
      # If font exists in OS fonts, attempt registration
      if (tolower(family) %in% tolower(osFamilies) & registerFont) {
        tryCatch({
          newEntry <- stats::setNames(list(grDevices::windowsFont(family)), family)
          do.call(grDevices::windowsFonts, newEntry)
        }, error = function(e) invisible(NULL))
      }
    }
  }

  availableFamilies <- character(0)

  if (.Platform$OS.type == "windows") {
    availableFamilies <- names(grDevices::windowsFonts())
  } else {
    sysName <- tolower(Sys.info()[["sysname"]])
    if (grepl("darwin|mac", sysName)) {
      availableFamilies <- names(grDevices::quartzFonts())
    } else {
      availableFamilies <- names(grDevices::X11Fonts())
    }
  }

  # Combine device-registered + system-installed families
  availableFamilies <- unique(c(availableFamilies, osFamilies))

  # Final availability check
  if (tolower(family) %in% tolower(availableFamilies)) {
    return(family)
  }

  # Not available: warn + fallback
  cli::cli_warn(c(
    "Requested font '{family}' is not available on this system or graphics device.",
    "i" = "Falling back to '{ggDefaultFont}'.",
    "v" = "See vingette on styles for more information."
  ),
  .call = call
  )

  return(ggDefaultFont)
}
