# Copyright 2025 DARWIN EU®
#
# This file is part of visOmopResults
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

#' Apply a pre-defined visOmopResults theme to a ggplot
#'
#' @inheritParams plotDoc
#' @param fontsizeRef An integer to use as reference when adjusting label
#' fontsize.
#'
#' @export
#'
#' @examples
#' result <- mockSummarisedResult() |> dplyr::filter(variable_name == "age")
#'
#' barPlot(
#'   result = result,
#'   x = "cohort_name",
#'   y = "mean",
#'   facet = c("age_group", "sex"),
#'   colour = "sex"
#' ) +
#'   themeVisOmop()
#'
themeVisOmop <- function(style = NULL, fontsizeRef = NULL) {
  omopgenerics::assertNumeric(fontsizeRef, length = 1, null = TRUE)
  x <- validateStyle(style = style, obj = "plot", type = "ggplot")

  themeStyle(x = x, fontsizeRef = fontsizeRef)
}

# format plot style in ggplot2
themeStyle <- function(x, fontsizeRef = NULL) {
  if (is.null(fontsizeRef)) {
    fontSize <- as.numeric(gsub("pt", "", x$plot_font_size))
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
  headerTextBold <- NULL
  if (!is.null(x$plot_header_text_bold)) {
    if (x$plot_header_text_bold) {
      headerTextBold <- "bold"
    }
  }

  # check font
  fontFamily <- safeFontFamily(fontFamily, registerFont = TRUE)

  ggplot2::theme_bw() +
    ggplot2::theme(
      # facet
      strip.text = ggplot2::element_text(face = headerTextBold, size = fontSize, colour = headerTextColour, family = fontFamily),
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
      plot.margin = grid::unit(c(0.35, 0.2, 0.3, 0.35), "cm"),
      # palettes
      palette.colour.discrete = paletteSet(x$discrete_colour),
      palette.colour.continuous = paletteSet(x$continuous_colour),
      palette.fill.discrete = paletteSet(x$discrete_fill),
      palette.fill.continuous = paletteSet(x$continuous_fill)
    )
}

paletteSet <- function(...) {
  sets <- list(...)
  sets <- purrr::keep(sets, \(x) !is.null(x) && length(x) > 0)

  if (length(sets) == 0) return(NULL)

  palette <- sets[[1]]

  if (is.character(palette) &&
      length(palette) > 1 &&
      all(grepl("^#[0-9A-Fa-f]{6}$", palette))) {
    return(newPlotPalette(colors = palette))
  }

  palette
}

newPlotPalette <- function(colors) {
  force(colors)
  function(n) getPalette(colors = colors, n = n)
}

hex2hue <- function(h) {
  r <- strtoi(substr(h, 2, 3), 16) / 255
  g <- strtoi(substr(h, 4, 5), 16) / 255
  b <- strtoi(substr(h, 6, 7), 16) / 255
  max_c <- max(r, g, b)
  min_c <- min(r, g, b)
  if (max_c == min_c) {
    return(0)
  }
  d <- max_c - min_c
  hue <- switch(which.max(c(r, g, b)),
                `1` = (g - b) / d + ifelse(g < b, 6, 0),
                `2` = (b - r) / d + 2,
                `3` = (r - g) / d + 4)
  (hue / 6) * 360
}
sortHue <- function(hex, ref) {
  l <- length(hex)
  if (l > 2) {
    hue <- purrr::map_dbl(hex, hex2hue)
    hex <- hex[order(hue)]
  }
  id <- which(hex == ref)
  hex[c(id:l, seq_len(id-1))]
}
getPalette <- function(colors, n) {
  if (n <= length(colors)) {
    colors <- sortHue(colors[1:n], colors[1])
  } else {
    ramp <- grDevices::colorRampPalette(c(sortHue(colors, colors[1]), colors[1]))
    colors <- ramp(n = n + 1)[1:n]
  }
  return(colors)
}
