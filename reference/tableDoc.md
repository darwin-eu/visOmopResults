# Helper for consistent documentation of `tables`.

Helper for consistent documentation of `tables`.

## Arguments

- estimateName:

  A named list of estimate names to join, sorted by computation order.
  Use `<...>` to indicate estimate names.

- groupColumn:

  Columns to use as group labels, to see options use
  `tableColumns(result)`. By default, the name of the new group will be
  the tidy\* column names separated by ";". To specify a custom group
  name, use a named list such as: list("newGroupName" =
  c("variable_name", "variable_level")).

  \*tidy: The tidy format applied to column names replaces "\_" with a
  space and converts to sentence case. Use `rename` to customise
  specific column names.

- rename:

  A named vector to customise column names, e.g., c("Database name" =
  "cdm_name"). The function renames all column names not specified here
  into a tidy\* format.

- type:

  Character string specifying the desired output table format. See
  [`tableType()`](https://darwin-eu.github.io/visOmopResults/reference/tableType.md)
  for supported table types. If `type = NULL`, global options (set via
  [`setGlobalTableOptions()`](https://darwin-eu.github.io/visOmopResults/reference/setGlobalTableOptions.md))
  will be used if available; otherwise, a default `'gt'` table is
  created.

- columnOrder:

  Character vector establishing the position of the columns in the
  formatted table. Columns in either header, groupColumn, or hide will
  be ignored.

- factor:

  A named list where names refer to columns (see available columns in
  [`tableColumns()`](https://darwin-eu.github.io/visOmopResults/reference/tableColumns.md))
  and list elements are the level order of that column to arrange the
  results. The column order in the list will be used for arranging the
  result.

- style:

  Defines the visual formatting of the table. This argument can be
  provided in one of the following ways:

  1.  **Pre-defined style:** Use the name of a built-in style (e.g.,
      `"darwin"`). See
      [`tableStyle()`](https://darwin-eu.github.io/visOmopResults/reference/tableStyle.md)
      for available options.

  2.  **YAML file path:** Provide the path to an existing `.yml` file
      defining a new style.

  3.  **List of custome R code:** Supply a block of custom R code or a
      named list describing styles for each table section. This code
      must be specific to the selected table type. If `style = NULL`,
      the function will use global options (see
      [`setGlobalTableOptions()`](https://darwin-eu.github.io/visOmopResults/reference/setGlobalTableOptions.md))
      or an existing `_brand.yml` file (if found); otherwise, the
      default style is applied. For more details, see the *Styles*
      vignette on the package website.

- showMinCellCount:

  If `TRUE`, suppressed estimates will be indicated with
  "\<{min_cell_count}", otherwise, the default `na` defined in
  `.options` will be used.

- .options:

  A named list with additional formatting options.
  [`visOmopResults::tableOptions()`](https://darwin-eu.github.io/visOmopResults/reference/tableOptions.md)
  shows allowed arguments and their default values.
