# Create a box plot visualisation from a `<summarised_result>` object

Create a box plot visualisation from a `<summarised_result>` object

## Usage

``` r
boxPlot(
  result,
  x,
  lower = "q25",
  middle = "median",
  upper = "q75",
  ymin = "min",
  ymax = "max",
  facet = NULL,
  colour = NULL,
  style = NULL,
  type = NULL,
  label = character()
)
```

## Arguments

- result:

  A `<summarised_result>` object.

- x:

  Column or estimate name that is used as x variable.

- lower:

  Estimate name for the lower quantile of the box.

- middle:

  Estimate name for the middle line of the box.

- upper:

  Estimate name for the upper quantile of the box.

- ymin:

  Lower limit of error bars, if provided is plot using `geom_errorbar`.

- ymax:

  Upper limit of error bars, if provided is plot using `geom_errorbar`.

- facet:

  Variables to facet by, a formula can be provided to specify which
  variables should be used as rows and which ones as columns.

- colour:

  Columns to use to determine the colours.

- style:

  Visual theme to apply. Character, or `NULL`. If a character, this may
  be either the name of a built-in style (see
  [`plotStyle()`](https://darwin-eu.github.io/visOmopResults/reference/plotStyle.md)),
  or a path to a `.yml` file that defines a custom style. If `NULL`, the
  function will use the explicit default style, unless a global style
  option is set (see
  [`setGlobalPlotOptions()`](https://darwin-eu.github.io/visOmopResults/reference/setGlobalPlotOptions.md)),
  or a `_brand.yml` file is present (in that order). Refer to the
  package vignette on styles to learn more.

- type:

  Character string indicating the output plot format. See
  [`plotType()`](https://darwin-eu.github.io/visOmopResults/reference/plotType.md)
  for the list of supported plot types. If `type = NULL`, the function
  will use the global setting defined via
  [`setGlobalPlotOptions()`](https://darwin-eu.github.io/visOmopResults/reference/setGlobalPlotOptions.md)
  (if available); otherwise, a standard `ggplot2` plot is produced by
  default.

- label:

  Character vector with the columns to display interactively in
  `plotly`.

## Value

A ggplot2 object.

## Examples

``` r
dplyr::tibble(year = "2000", q25 = 25, median = 50, q75 = 75, min = 0, max = 100) |>
  boxPlot(x = "year")

```
