# Apply a pre-defined visOmopResults theme to a ggplot

Apply a pre-defined visOmopResults theme to a ggplot

## Usage

``` r
themeVisOmop(style = NULL, fontsizeRef = NULL)
```

## Arguments

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

- fontsizeRef:

  An integer to use as reference when adjusting label fontsize.

## Examples

``` r
result <- mockSummarisedResult() |> dplyr::filter(variable_name == "age")

barPlot(
  result = result,
  x = "cohort_name",
  y = "mean",
  facet = c("age_group", "sex"),
  colour = "sex") +
 themeVisOmop()
```
