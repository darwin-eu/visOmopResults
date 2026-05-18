# Create an alluvial plot visualisation from a data frame or a `<summarised_result>` object.

Create an alluvial plot visualisation from a data frame or a
`<summarised_result>` object.

## Usage

``` r
alluvialPlot(result, x, y, colour = x, facet = NULL, style = NULL, type = NULL)
```

## Arguments

- result:

  A `<summarised_result>` object.

- x:

  A character vector of column names to use as alluvial axes, in order
  from left to right. Must contain at least 2 elements.

- y:

  Column or estimate name that is used as y variable.

- colour:

  Columns to use to determine the colours.

- facet:

  Variables to facet by, a formula can be provided to specify which
  variables should be used as rows and which ones as columns.

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

## Value

A plot object.

## Examples

``` r
result <- dplyr::tibble(
  treatment_1 = c("A", "A", "A", "B", "B", "B", "C", "C"),
  treatment_2 = c("A", "A", "B", "A", "B", "B", "B", "C"),
  treatment_3 = c("A", "B", "B", "A", "A", "B", "B", "C"),
  count       = c(22, 3, 5, 7, 3, 17, 4, 12)
)

# basic alluvial plot with 3 axes
alluvialPlot(
  result = result,
  x = c("treatment_1", "treatment_2", "treatment_3"),
  y = "count"
)
#> Warning: Some strata appear at multiple axes.
#> Warning: Some strata appear at multiple axes.
#> Warning: Ignoring empty aesthetic: `family`.


# colour by first axis
alluvialPlot(
  result = result,
  x = c("treatment_1", "treatment_2", "treatment_3"),
  y = "count",
  colour = "treatment_1"
)
#> Warning: Some strata appear at multiple axes.
#> Warning: Some strata appear at multiple axes.
#> Warning: Ignoring empty aesthetic: `family`.


# colour by multiple variables
alluvialPlot(
  result = result,
  x = c("treatment_1", "treatment_2", "treatment_3"),
  y = "count",
  colour = c("treatment_1", "treatment_2")
)
#> Warning: Some strata appear at multiple axes.
#> Warning: Some strata appear at multiple axes.
#> Warning: Ignoring empty aesthetic: `family`.
```
