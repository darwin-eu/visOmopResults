#' Helper for consistent documentation of `plots`.
#'
#' @param result A `<summarised_result>` object.
#' @param x Column or estimate name that is used as x variable.
#' @param y Column or estimate name that is used as y variable.
#' @param width Bar width, as in `geom_col()` of the `ggplot2` package.
#' @param just Adjustment for column placement, as in `geom_col()` of the
#' `ggplot2` package.
#' @param facet Variables to facet by, a formula can be provided to specify
#' which variables should be used as rows and which ones as columns.
#' @param colour Columns to use to determine the colours.
#' @param group Columns to use to determine the group.
#' @param label Character vector with the columns to display interactively in
#' `plotly`.
#' @param style Visual theme to apply. Character, or `NULL`.
#' If a character, this may be either the name of a built-in style
#' (see `plotStyle()`), or a path to a `.yml` file that
#' defines a custom style. If `NULL`, the function will use the
#' explicit default style, unless a global style option is
#' set (see `setGlobalPlotOptions()`), or a `_brand.yml` file is present
#' (in that order).
#' Refer to the package vignette on styles to learn more.
#' @param type Character string indicating the output plot format.
#' See `plotType()` for the list of supported plot types. If `type = NULL`,
#' the function will use the global setting defined via `setGlobalPlotOptions()`
#' (if available); otherwise, a standard `ggplot2` plot is produced by default.
#' @param lower Estimate name for the lower quantile of the box.
#' @param middle Estimate name for the middle line of the box.
#' @param upper Estimate name for the upper quantile of the box.
#' @param ymin Estimate name for the lower limit of the bars.
#' @param ymax Estimate name for the upper limit of the bars.
#' @param line Whether to plot a line using `geom_line`.
#' @param point Whether to plot points using `geom_point`.
#' @param ribbon Whether to plot a ribbon using `geom_ribbon`.
#' @param ymin Lower limit of error bars, if provided is plot using
#' `geom_errorbar`.
#' @param ymax Upper limit of error bars, if provided is plot using
#' `geom_errorbar`.
#' @param position Position of bars, can be either `dodge` or `stack`
#'
#' @name plotDoc
#' @keywords internal
NULL


#' Helper for consistent documentation of `tables`.
#'
#' @param estimateName A named list of estimate names to join, sorted by
#' computation order. Use `<...>` to indicate estimate names.
#' @param groupColumn Columns to use as group labels, to see options use
#' `tableColumns(result)`. By default, the name of the new group will be the
#' tidy* column names separated by ";". To specify a custom group name, use a
#' named list such as:
#' list("newGroupName" = c("variable_name", "variable_level")).
#'
#' *tidy: The tidy format applied to column names replaces "_" with a space and
#' converts to sentence case. Use `rename` to customise specific column names.
#'
#' @param rename A named vector to customise column names, e.g.,
#' c("Database name" = "cdm_name"). The function renames all column names
#' not specified here into a tidy* format.
#' @param type Character string specifying the desired output table format.
#' See `tableType()` for supported table types. If `type = NULL`, global
#' options (set via `setGlobalTableOptions()`) will be used if available;
#' otherwise, a default `'gt'` table is created.
#' @param columnOrder Character vector establishing the position of the columns
#' in the formatted table. Columns in either header, groupColumn, or hide will
#' be ignored.
#' @param factor A named list where names refer to columns (see available columns
#' in `tableColumns()`) and list elements are the level order of that column
#' to arrange the results. The column order in the list will be used for
#' arranging the result.
#' @param style Defines the visual formatting of the table.
#' This argument can be provided in one of the following ways:
#' 1. **Pre-defined style:** Use the name of a built-in style (e.g., `"darwin"`).
#' See `tableStyle()` for available options.
#' 2. **YAML file path:** Provide the path to an existing `.yml` file defining
#' a new style.
#' 3. **List of custome R code:** Supply a block of custom R code or a named list
#' describing styles for each table section. This code must be specific to
#' the selected table type.
#' If `style = NULL`, the function will use global options
#' (see `setGlobalTableOptions()`) or an existing `_brand.yml` file (if found);
#' otherwise, the default style is applied.
#' For more details, see the *Styles* vignette on the package website.
#' @param showMinCellCount If `TRUE`, suppressed estimates will be indicated with
#' "<\{min_cell_count\}", otherwise, the default `na` defined in `.options` will be
#' used.
#' @param .options A named list with additional formatting options.
#' `visOmopResults::tableOptions()` shows allowed arguments and their default values.
#'
#' @name tableDoc
#' @keywords internal
NULL
