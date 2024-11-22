#' Apply visOmopResults default styling to a ggplot
#'
#' @param fontsizeRef An integer to use as reference when adjusting label
#' fontsize.
#' @param legendPosition If there is a legend, where should it go? Options are
#' the same as for ggplot. By default it is in the right side.
#'
#' @export
#'
#' @examples
#' \donttest{
#' result <- mockSummarisedResult() |> dplyr::filter(variable_name == "age")
#'
#' barPlot(
#'   result = result,
#'   x = "cohort_name",
#'   y = "mean",
#'   facet = c("age_group", "sex"),
#'   colour = "sex") +
#'   themeVisOmop()
#'}

themeVisOmop <- function(fontsizeRef = 13, legendPosition = "right") {
  omopgenerics::assertNumeric(fontsizeRef)
  color.background <- "#ffffff"
  color.grid.major <- "#d9d9d9"
  color.axis.text <- "#252525"
  color.axis.title <- "#252525"
  color.border <- "#595959"
    ggplot2::theme_bw() +
    ggplot2::theme(
      # facet
      strip.text = ggplot2::element_text(face = "bold", size = fontsizeRef-1),
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
      legend.position = legendPosition,
      # background
      panel.background = ggplot2::element_rect(fill = color.background, colour = color.background),
      plot.background = ggplot2::element_rect(fill = color.background, colour = color.background),
      panel.border = ggplot2::element_rect(colour = color.border),
      # grid
      panel.grid.major = ggplot2::element_line(color = color.grid.major, size = .25),
      # margin
      plot.margin = grid::unit(c(0.35, 0.2, 0.3, 0.35), "cm")
    )
}
