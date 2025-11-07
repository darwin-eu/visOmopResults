
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
    }
  }

  return(file)
}

# transform the yaml to the internal list format
brandToList <- function(content) {
  # update colours from palette
  content <- updateColoursFromPalette(content = content)

  # collapse content
  content <- collapseContent(content = content)

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
          if (is.character(x) && length(x) == 1) {
            if (x %in% names(colours)) {
              colours[[x]]
            } else {
              x
            }
          } else {
            x
          }
        },
        how = "replace"
      )
  }
  content
}
# collapse content into a list vector using : as separator for names
collapseContent <- function(content) {
  content <- unlist(content, recursive = TRUE, use.names = TRUE)
  names(content) <- gsub("\\.", "\\:", names(content), fixed = FALSE)
  as.list(content)
}
# labels hierarchy (do not use `.` in names as they will be converted to `:`)
labels <- function() {
  list(
    # plot parameters
    plot_background_color = c("plot:background-color", "color:background"),
    plot_header_color = c("plot:header-color", "color:foreground"),
    plot_header_text_color = c("plot:header-text-color"),
    plot_font_size = c("plot:font-size", "typography:plot-font-size", "typography:base-font-size"),
    plot_border_color = c("plot:border-color", "color:foreground"),
    plot_grid_color = c("plot:grid-major-color", "color:foreground"),
    plot_axis_color = c("plot:axis-color"),
    plot_legend_position = c("plot:legend-position"),
    plot_font_family = c("typography:plot", "typography:base"),

    # table parameters
    # header
    table_header_background_color = c("table:header:background-color", "color:background"),
    table_header_text_bold = c("table:header:text-bold"),
    table_header_text_color = c("table:header:text-color"),
    table_header_font_size = c("table:header:font-size", "typography:table-font-size", "typography:base-font-size"),
    table_header_font_family = c("table:header:font-family", "typography:table", "typography:base"),
    table_header_align = c("table:header:align"),
    table_header_border_color = c("table:header:border-color", "table:border-color"),
    table_header_border_width = c("table:header:border-width", "table:border-width"),
    # header name
    table_header_name_background_color = c("table:header-name:background-color", "color:background"),
    table_header_name_text_bold = c("table:header-name:text-bold"),
    table_header_name_text_color = c("table:header-name:text-color"),
    table_header_name_font_size = c("table:header-name:font-size", "typography:table-font-size", "typography:base-font-size"),
    table_header_name_font_family = c("table:header-name:font-family", "typography:table", "typography:base"),
    table_header_name_align = c("table:header-name:align"),
    table_header_name_border_color = c("table:header-name:border-color", "table:border-color"),
    table_header_name_border_width = c("table:header-name:border-width", "table:border-width"),
    # header_level
    table_header_level_background_color = c("table:header-level:background-color", "color:background"),
    table_header_level_text_bold = c("table:header-level:text-bold"),
    table_header_level_text_color = c("table:header-level:text-color"),
    table_header_level_font_size = c("table:header-level:font-size", "typography:table-font-size", "typography:base-font-size"),
    table_header_level_font_family = c("table:header-level:font-family", "typography:table", "typography:base"),
    table_header_level_align = c("table:header-level:align"),
    table_header_level_border_color = c("table:header-level:border-color", "table:border-color"),
    table_header_level_border_width = c("table:header-level:border-width", "table:border-width"),
    # column_name
    table_column_name_background_color = c("table:column-name:background-color", "color:background"),
    table_column_name_text_bold = c("table:column-name:text-bold"),
    table_column_name_text_color = c("table:column-name:text-color"),
    table_column_name_font_size = c("table:column-name:font-size", "typography:table-font-size", "typography:base-font-size"),
    table_column_name_font_family = c("table:column-name:font-family", "typography:table", "typography:base"),
    table_column_name_align = c("table:column-name:align"),
    table_column_name_border_color = c("table:column-name:border-color", "table:border-color"),
    table_column_name_border_width = c("table:column-name:border-width", "table:border-width"),
    # group_label
    table_group_label_background_color = c("table:group-label:background-color", "color:background"),
    table_group_label_text_bold = c("table:group-label:text-bold"),
    table_group_label_text_color = c("table:group-label:text-color"),
    table_group_label_font_size = c("table:group-label:font-size", "typography:table-font-size", "typography:base-font-size"),
    table_group_label_font_family = c("table:group-label:font-family", "typography:table", "typography:base"),
    table_group_label_align = c("table:group-label:align"),
    table_group_label_border_color = c("table:group-label:border-color", "table:border-color"),
    table_group_label_border_width = c("table:group-label:border-width", "table:border-width"),
    # title
    table_title_background_color = c("table:title:background-color", "color:background"),
    table_title_text_bold = c("table:title:text-bold"),
    table_title_text_color = c("table:title:text-color"),
    table_title_font_size = c("table:title:font-size", "typography:table-font-size", "typography:base-font-size"),
    table_title_font_family = c("table:title:font-family", "typography:table", "typography:base"),
    table_title_align = c("table:title:align"),
    table_title_border_color = c("table:title:border-color", "table:border-color"),
    table_title_border_width = c("table:title:border-width", "table:border-width"),
    # subtitle
    table_subtitle_background_color = c("table:subtitle:background-color", "color:background"),
    table_subtitle_text_bold = c("table:subtitle:text-bold"),
    table_subtitle_text_color = c("table:subtitle:text-color"),
    table_subtitle_font_size = c("table:subtitle:font-size", "typography:table-font-size", "typography:base-font-size"),
    table_subtitle_font_family = c("table:subtitle:font-family", "typography:table", "typography:base"),
    table_subtitle_align = c("table:subtitle:align"),
    table_subtitle_border_color = c("table:subtitle:border-color", "table:border-color"),
    table_subtitle_border_width = c("table:subtitle:border-width", "table:border-width"),
    # body
    table_body_background_color = c("table:body:background-color", "color:background"),
    table_body_text_bold = c("table:body:text-bold"),
    table_body_text_color = c("table:body:text-color"),
    table_body_font_size = c("table:body:font-size", "typography:table-font-size", "typography:base-font-size"),
    table_body_font_family = c("table:body:font-family", "typography:table", "typography:base"),
    table_body_align = c("table:body:align"),
    table_body_border_color = c("table:body:border-color", "table:border-color"),
    table_body_border_width = c("table:body:border-width", "table:border-width")
  )
}

# format table style in the specific type
formatTableStyle <- function(x, type) {
  if (type == "gt") {
    style <- styleGt(x = x)
  } else if (type == "flextable") {
    style <- styleFx(x = x)
  } else if (type == "tibble") {
    style <- list()
  } else if (type == "datatable") {
    style <- styleDT(x = x)
  } else if (type == "reactable") {
    style <- styleRT(x = x)
  } else if (type == "tinytable") {
    style <- styleTT(x = x)
  } else {
    cli::cli_abort(c(x = "Not supported type ('{type}')"))
  }
  return(style)
}
styleGt <- function(x) {
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
        args$size <- as.numeric(x[[nm4]])
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
      if (length(args) > 0) {
        res <- c(res, list(cell = do.call(what = officer::fp_cell, args = args)))
      }

      # officer::fp_text
      args <- list()
      if (nm2 %in% names(x)) {
        args$bold <- as.logical(x[[nm2]])
      }
      if (nm4 %in% names(x)) {
        args$font.size <- as.numeric(x[[nm4]])
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
      if (nm3 %in% names(x)) {
        res <- c(res, list(paragraph = officer::fp_par(text.align = x[[nm3]])))
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
  labelsTinytable() |>
    rlang::set_names() |>
    purrr::map(\(lab) {
      nm1 <- paste0("table_", lab, "_background_color")
      nm2 <- paste0("table_", lab, "_text_bold")
      nm3 <- paste0("table_", lab, "_align")
      nm4 <- paste0("table_", lab, "_font_size")
      nm5 <- paste0("table_", lab, "_border_color")
      nm6 <- paste0("table_", lab, "_font_family") # dont know how to edit font family in tinytable
      nm7 <- paste0("table_", lab, "_text_color")
      nm8 <- paste0("table_", lab, "_border_width")

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
        res$fontsize <- as.numeric(x[[nm4]])
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

# format plot style in ggplot2
formatPlotStyle <- function(x, fontsizeRef = NULL) {
  if (is.null(fontsizeRef)) {
    fontSize <- as.numeric(x$plot_font_size)
  } else {
    fontSize <- fontsizeRef
  }
  colorBackrgound <- x$plot_background_color
  colorHeader <- x$plot_header_color
  colorGrid <- x$plot_grid_color
  colorAxis <- x$plot_axis_color
  colorBorder <- x$plot_border_color
  legendPosition <- x$plot_legend_position
  fontFamily <- x$plot_font_family
  headerTextColour <- x$plot_header_text_color

  # check font
  fontFamily <- safeFontFamily(fontFamily)

  ggplot2::theme_bw() +
    ggplot2::theme(
      # facet
      strip.text = ggplot2::element_text(face = "bold", size = fontSize, colour = headerTextColour, family = fontFamily),
      strip.background = ggplot2::element_rect(fill = colorHeader, colour = colorBorder),
      strip.text.y.left = ggplot2::element_text(angle = 0, family = fontFamily),
      strip.text.y.right = ggplot2::element_text(angle = 0, family = fontFamily),
      # title
      plot.title = ggplot2::element_text(face = "bold", size = fontSize+2),
      # axis
      axis.text.y = ggplot2::element_text(size = fontSize-1, color = colorAxis, family = fontFamily),
      axis.text.x = ggplot2::element_text(size = fontSize-1, color = colorAxis, family = fontFamily),
      axis.title.x = ggplot2::element_text(size = fontSize, vjust = 0, color = colorAxis, family = fontFamily),
      axis.title.y = ggplot2::element_text(size = fontSize, vjust = 1.25, color = colorAxis, family = fontFamily),
      # legend
      legend.text = ggplot2::element_text(size = fontSize-1, family = fontFamily),
      legend.title = ggplot2::element_text(size = fontSize, family = fontFamily),
      legend.position = legendPosition,
      # background
      panel.background = ggplot2::element_rect(fill = colorBackrgound, colour = colorBackrgound),
      plot.background = ggplot2::element_rect(fill = colorBackrgound, colour = colorBackrgound),
      panel.border = ggplot2::element_rect(colour = colorBorder),
      # grid
      panel.grid.major = ggplot2::element_line(color = colorGrid, linewidth = .25),
      # margin
      plot.margin = grid::unit(c(0.35, 0.2, 0.3, 0.35), "cm")
    )
}

# helper function: check fontFamily is installed and loaded
safeFontFamily <- function(family, ggDefaultFont = "sans", call = parent.frame()) {
  # checks
  omopgenerics::assertCharacter(family, length = 1, na = FALSE, null = TRUE)
  if (is.null(family)) return(family)
  if (family == ggDefaultFont) return(family)
  rlang::check_installed("extrafont")

  # Register extrafont fonts for this session/device
  device <- if (.Platform$OS.type == "windows") "win" else "pdf"
  extrafont::loadfonts(device = device, quiet = TRUE)

  available <- tolower(family) %in% tolower(extrafont::fonts())

  if (!available) {
    cli::cli_warn(
      c(
        "Requested font '{family}' is not available on this system or not imported for use with R (if it's the latter, run `extrafont::font_import()` once).",
        "i" = "Falling back to '{ggDefaultFont}'.",
        "v" = "See the package vignette for guidance on installing/importing fonts for plotting."
      ),
      .call = call
    )
    return(ggDefaultFont)
  }
  return(family)
}
