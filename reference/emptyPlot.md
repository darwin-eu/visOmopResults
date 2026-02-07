# Returns an empty plot

Returns an empty plot

## Usage

``` r
emptyPlot(title = "No data to plot", subtitle = "", type = NULL, style = NULL)
```

## Arguments

- title:

  Title to use in the empty plot.

- subtitle:

  Subtitle to use in the empty plot.

- type:

  Character string indicating the output plot format. See
  [`plotType()`](https://darwin-eu.github.io/visOmopResults/reference/plotType.md)
  for the list of supported plot types. If `type = NULL`, the function
  will use the global setting defined via
  [`setGlobalPlotOptions()`](https://darwin-eu.github.io/visOmopResults/reference/setGlobalPlotOptions.md)
  (if available); otherwise, a standard `ggplot2` plot is produced by
  default.

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

## Value

An empty ggplot object

## Examples

``` r
emptyPlot()

```
