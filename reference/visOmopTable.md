# Generate a formatted table from a `<summarised_result>`

This function combines the functionalities of
[`formatEstimateValue()`](https://darwin-eu.github.io/visOmopResults/reference/formatEstimateValue.md),
`estimateName()`,
[`formatHeader()`](https://darwin-eu.github.io/visOmopResults/reference/formatHeader.md),
and
[`formatTable()`](https://darwin-eu.github.io/visOmopResults/reference/formatTable.md)
into a single function specifically for `<summarised_result>` objects.

## Usage

``` r
visOmopTable(
  result,
  estimateName = character(),
  header = character(),
  settingsColumn = character(),
  groupColumn = character(),
  rename = character(),
  type = NULL,
  hide = character(),
  columnOrder = character(),
  factor = list(),
  style = NULL,
  showMinCellCount = TRUE,
  .options = list()
)
```

## Arguments

- result:

  A `<summarised_result>` object.

- estimateName:

  A named list of estimate names to join, sorted by computation order.
  Use `<...>` to indicate estimate names.

- header:

  A vector specifying the elements to include in the header. The order
  of elements matters, with the first being the topmost header. Elements
  in header can be:

  - Any of the columns returned by `tableColumns(result)` to create a
    header for these columns.

  - Any other input to create an overall header.

- settingsColumn:

  A character vector with the names of settings to include in the table.
  To see options use `settingsColumns(result)`.

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

- hide:

  Columns to drop from the output table. By default, `result_id` and
  `estimate_type` are always dropped.

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

## Value

A formatted table of the class selected in "type" argument.

## Examples

``` r
result <- mockSummarisedResult()
result |>
  visOmopTable(
    estimateName = c("N%" = "<count> (<percentage>)",
                     "N" = "<count>",
                     "Mean (SD)" = "<mean> (<sd>)"),
    header = c("cohort_name"),
    rename = c("Database name" = "cdm_name"),
    groupColumn = strataColumns(result)
  )


  


Database name
```
