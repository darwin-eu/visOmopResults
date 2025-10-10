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
#' @param style Character indicating which pre-defined style to apply. Refer to
#' the function `plotStyle()` to see the available styles.
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
#'   colour = "sex") +
#'  themeVisOmop()

themeVisOmop <- function(style = "default", fontsizeRef = 11) {
  omopgenerics::assertChoice(x = style, choices = plotStyle(), null = TRUE)
  if (length(style) != 0) {
    if (style == "default") {
      themeDefault(fontsizeRef = fontsizeRef)
    }
    else if (style == "darwin") {
      themeDarwin(fontsizeRef = fontsizeRef)
    }
  }
}

#' Apply visOmopResults default styling to a ggplot
#' @noRd
themeDefault <- function(fontsizeRef) {
  omopgenerics::assertNumeric(fontsizeRef)
  color.background <- "#ffffff"
  color.grid.major <- "#d9d9d9"
  color.axis.text <- "#252525"
  color.axis.title <- "#252525"
  color.border <- "#595959"
  ggplot2::theme_bw() +
    ggplot2::theme(
      # facet
      strip.text = ggplot2::element_text(face = "bold", size = fontsizeRef),
      strip.background = ggplot2::element_rect(fill = "#e5e6e4", colour = color.border),
      strip.text.y.left = ggplot2::element_text(angle = 0),
      strip.text.y.right = ggplot2::element_text(angle = 0),
      # title
      plot.title = ggplot2::element_text(face = "bold", size = fontsizeRef+2),
      # axis
      axis.text.y = ggplot2::element_text(size = fontsizeRef-1, color = color.axis.text),
      axis.text.x = ggplot2::element_text(size = fontsizeRef-1, color = color.axis.text),
      axis.title.x = ggplot2::element_text(size = fontsizeRef, vjust = 0, color = color.axis.title),
      axis.title.y = ggplot2::element_text(size = fontsizeRef, vjust = 1.25, color = color.axis.title),
      # legend
      legend.text = ggplot2::element_text(size = fontsizeRef-1),
      legend.title = ggplot2::element_text(size = fontsizeRef),
      legend.position = "right",
      # background
      panel.background = ggplot2::element_rect(fill = color.background, colour = color.background),
      plot.background = ggplot2::element_rect(fill = color.background, colour = color.background),
      panel.border = ggplot2::element_rect(colour = color.border),
      # grid
      panel.grid.major = ggplot2::element_line(color = color.grid.major, linewidth = .25),
      # margin
      plot.margin = grid::unit(c(0.35, 0.2, 0.3, 0.35), "cm")
    )
}

#' Apply Darwin styling to a ggplot
#' @noRd
themeDarwin <- function(fontsizeRef) {
  omopgenerics::assertNumeric(fontsizeRef)
  color.background <- "#ffffff"
  color.grid.major <- "#d9d9d9"
  color.axis.text <- "#252525"
  color.axis.title <- "#252525"
  color.border <- "#d2d2d2"
  ggplot2::theme_bw() +
    ggplot2::theme(
      # facet
      strip.text = ggplot2::element_text(face = "bold", size = fontsizeRef, colour = "#FFFFFF", family = "Calibri"),
      strip.background = ggplot2::element_rect(fill = "#003399", colour = color.border),
      strip.text.y.left = ggplot2::element_text(angle = 0, family = "Calibri"),
      strip.text.y.right = ggplot2::element_text(angle = 0, family = "Calibri"),
      strip.background.x = ggplot2::element_rect(colour = "#ffffff"),
      strip.background.y = ggplot2::element_rect(colour = "#003399"),
      # title
      plot.title = ggplot2::element_text(face = "bold", size = fontsizeRef+2),
      # axis
      axis.text.y = ggplot2::element_text(size = fontsizeRef-1, color = color.axis.text, family = "Calibri"),
      axis.text.x = ggplot2::element_text(size = fontsizeRef-1, color = color.axis.text, family = "Calibri"),
      axis.title.x = ggplot2::element_text(size = fontsizeRef, vjust = 0, color = color.axis.title, family = "Calibri"),
      axis.title.y = ggplot2::element_text(size = fontsizeRef, vjust = 1.25, color = color.axis.title, family = "Calibri"),
      # legend
      legend.text = ggplot2::element_text(size = fontsizeRef-1, family = "Calibri"),
      legend.title = ggplot2::element_text(size = fontsizeRef, family = "Calibri"),
      legend.position = "right",
      # background
      panel.background = ggplot2::element_rect(fill = color.background, colour = color.background),
      plot.background = ggplot2::element_rect(fill = color.background, colour = color.background),
      panel.border = ggplot2::element_rect(colour = color.border),
      # grid
      panel.grid.major = ggplot2::element_line(color = color.grid.major, linewidth = .25),
      # margin
      plot.margin = grid::unit(c(0.35, 0.2, 0.3, 0.35), "cm")
    )
}

#' Get Calibri font for "darwin" plot style
#' @description Imports and registers the Calibri font for use in ggplot2 plots
#'   when using the themeDarwin.
#' @details This function is required only once per R installation or after
#'   installing a new font. It uses the extrafont package to map system fonts
#'   to R's graphics devices.
#' @param device Character string indicating the graphics device to load the
#'   fonts into (e.g., "win", "pdf", "postscript"). Defaults to "win" (Windows).
#' @return Invisibly returns TRUE on successful registration.
#' @export
requireExtrafont <- function(device = "win") {
  rlang::check_installed("extrafont")

  # font_import() only if it hasn't been done before
  if (!("Calibri" %in% extrafont::fonts())) {
    cli::cli_inform("Importing system fonts (required once). This may take several minutes.")
    extrafont::font_import(prompt = FALSE)
  }

  cli::cli_inform("Loading Calibri font for the '{device}' graphics device.")
  extrafont::loadfonts(device = device, quiet = TRUE)

  return(invisible(TRUE))
}
