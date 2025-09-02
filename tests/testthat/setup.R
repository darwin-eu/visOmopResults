getTinytableStyle <- function(tinytable, ii, jj) {
  style <- dplyr::as_tibble(dplyr::filter(tinytable@style, i == ii & j == jj))
  attr(style, "out.attrs") <- NULL
  attr(style, "row.names") <- 1L
  return(style)
}
