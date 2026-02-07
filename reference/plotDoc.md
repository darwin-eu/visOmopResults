# Helper for consistent documentation of `plots`.

Helper for consistent documentation of `plots`.

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

- facet:

  Variables to facet by, a formula can be provided to specify which
  variables should be used as rows and which ones as columns.

- colour:

  Columns to use to determine the colours.

- group:

  Columns to use to determine the group.

- label:

  Character vector with the columns to display interactively in
  `plotly`.

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

- lower:

  Estimate name for the lower quantile of the box.

- middle:

  Estimate name for the middle line of the box.

- upper:

  Estimate name for the upper quantile of the box.

- line:

  Whether to plot a line using `geom_line`.

- point:

  Whether to plot points using `geom_point`.

- ribbon:

  Whether to plot a ribbon using `geom_ribbon`.

- ymin:

  Lower limit of error bars, if provided is plot using `geom_errorbar`.

- ymax:

  Upper limit of error bars, if provided is plot using `geom_errorbar`.

- position:

  Position of bars, can be either `dodge` or `stack`
