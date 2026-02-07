# Create a bar plot visualisation from a `<summarised_result>` object

Create a bar plot visualisation from a `<summarised_result>` object

## Usage

``` r
barPlot(
  result,
  x,
  y,
  width = NULL,
  just = 0.5,
  position = "dodge",
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

- y:

  Column or estimate name that is used as y variable.

- width:

  Bar width, as in `geom_col()` of the `ggplot2` package.

- just:

  Adjustment for column placement, as in `geom_col()` of the `ggplot2`
  package.

- position:

  Position of bars, can be either `dodge` or `stack`

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

A plot object.

## Examples

``` r
result <- mockSummarisedResult() |> dplyr::filter(variable_name == "age")

barPlot(
  result = result,
  x = "cohort_name",
  y = "mean",
  facet = c("age_group", "sex"),
  colour = "sex")

```
