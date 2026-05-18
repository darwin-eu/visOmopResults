# Generate a formatted table from a `<data.table>`

This function combines the functionalities of
[`formatEstimateValue()`](https://darwin-eu.github.io/visOmopResults/reference/formatEstimateValue.md),
[`formatEstimateName()`](https://darwin-eu.github.io/visOmopResults/reference/formatEstimateName.md),
[`formatHeader()`](https://darwin-eu.github.io/visOmopResults/reference/formatHeader.md),
and
[`formatTable()`](https://darwin-eu.github.io/visOmopResults/reference/formatTable.md)
into a single function. While it does not require the input table to be
a `<summarised_result>`, it does expect specific fields to apply some
formatting functionalities.

## Usage

``` r
visTable(
  result,
  estimateName = character(),
  header = character(),
  groupColumn = character(),
  rename = character(),
  type = NULL,
  hide = character(),
  style = NULL,
  .options = list()
)
```

## Arguments

- result:

  A table to format.

- estimateName:

  A named list of estimate names to join, sorted by computation order.
  Use `<...>` to indicate estimate names.

- header:

  A vector specifying the elements to include in the header. The order
  of elements matters, with the first being the topmost header. The
  vector elements can be column names or labels for overall headers. The
  table must contain an `estimate_value` column to pivot the headers.

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

  Columns to drop from the output table.

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
  visTable(
    estimateName = c("N%" = "<count> (<percentage>)",
                     "N" = "<count>",
                     "Mean (SD)" = "<mean> (<sd>)"),
    header = c("Estimate"),
    rename = c("Database name" = "cdm_name"),
    groupColumn = c("strata_name", "strata_level"),
    hide = c("additional_name", "additional_level", "estimate_type", "result_type")
  )


  

Result id
```
