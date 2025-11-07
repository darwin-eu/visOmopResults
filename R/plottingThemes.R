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
#'   colour = "sex") +
#'  themeVisOmop()
themeVisOmop <- function(style = NULL, fontsizeRef = NULL) {
  omopgenerics::assertNumeric(fontsizeRef, length = 1, null = TRUE)
  validateStyle(style = style, obj = "plot", type = "ggplot", fontsizeRef = fontsizeRef)
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
