# Creates a flextable or gt object from a dataframe

Creates a flextable object from a dataframe using a delimiter to span
the header, and allows to easily customise table style.

## Usage

``` r
formatTable(
  x,
  type = NULL,
  delim = "\n",
  style = NULL,
  na = "–",
  title = NULL,
  subtitle = NULL,
  caption = NULL,
  groupColumn = NULL,
  groupAsColumn = FALSE,
  groupOrder = NULL,
  merge = "all_columns"
)
```

## Arguments

- x:

  A dataframe.

- type:

  Character string specifying the desired output table format. See
  [`tableType()`](https://darwin-eu.github.io/visOmopResults/reference/tableType.md)
  for supported table types. If `type = NULL`, global options (set via
  [`setGlobalTableOptions()`](https://darwin-eu.github.io/visOmopResults/reference/setGlobalTableOptions.md))
  will be used if available; otherwise, a default `'gt'` table is
  created.

- delim:

  Delimiter to separate headers.

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

- na:

  How to display missing values. Not used for "datatable" and
  "reactable".

- title:

  Title of the table, or NULL for no title. Not used for "datatable".

- subtitle:

  Subtitle of the table, or NULL for no subtitle. Not used for
  "datatable" and "reactable".

- caption:

  Caption for the table, or NULL for no caption. Text in markdown
  formatting style (e.g. `*Your caption here*` for caption in italics).
  Not used for "reactable".

- groupColumn:

  Columns to use as group labels, to see options use
  `tableColumns(result)`. By default, the name of the new group will be
  the tidy\* column names separated by ";". To specify a custom group
  name, use a named list such as: list("newGroupName" =
  c("variable_name", "variable_level")).

  \*tidy: The tidy format applied to column names replaces "\_" with a
  space and converts to sentence case. Use `rename` to customise
  specific column names.

- groupAsColumn:

  Whether to display the group labels as a column (TRUE) or rows
  (FALSE). Not used for "datatable" and "reactable"

- groupOrder:

  Order in which to display group labels. Not used for "datatable" and
  "reactable".

- merge:

  Names of the columns to merge vertically when consecutive row cells
  have identical values. Alternatively, use "all_columns" to apply this
  merging to all columns, or use NULL to indicate no merging. Not used
  for "datatable" and "reactable".

## Value

A formatted table of the class selected in "type" argument.

## Examples

``` r
# Example 1
mockSummarisedResult() |>
  formatEstimateValue(decimals = c(integer = 0, numeric = 1)) |>
  formatHeader(
    header = c("Study strata", "strata_name", "strata_level"),
    includeHeaderName = FALSE
  ) |>
  formatTable(
    type = "flextable",
    style = "default",
    na = "--",
    title = "fxTable example",
    subtitle = NULL,
    caption = NULL,
    groupColumn = "group_level",
    groupAsColumn = TRUE,
    groupOrder = c("cohort1", "cohort2"),
    merge = "all_columns"
  )


.cl-e7344cf8{table-layout:auto;width:100%;}.cl-e72c9e36{font-family:'Arial';font-size:15pt;font-weight:bold;font-style:normal;text-decoration:none;color:rgba(0, 0, 0, 1.00);background-color:transparent;}.cl-e72c9e4a{font-family:'Arial';font-size:10pt;font-weight:bold;font-style:normal;text-decoration:none;color:rgba(0, 0, 0, 1.00);background-color:transparent;}.cl-e72c9e4b{font-family:'Arial';font-size:10pt;font-weight:normal;font-style:normal;text-decoration:none;color:rgba(0, 0, 0, 1.00);background-color:transparent;}.cl-e72f7d86{margin:0;text-align:left;border-bottom: 0 solid rgba(0, 0, 0, 1.00);border-top: 0 solid rgba(0, 0, 0, 1.00);border-left: 0 solid rgba(0, 0, 0, 1.00);border-right: 0 solid rgba(0, 0, 0, 1.00);padding-bottom:3pt;padding-top:3pt;padding-left:3pt;padding-right:3pt;line-height: 1;background-color:transparent;}.cl-e72f7d90{margin:0;text-align:center;border-bottom: 0 solid rgba(0, 0, 0, 1.00);border-top: 0 solid rgba(0, 0, 0, 1.00);border-left: 0 solid rgba(0, 0, 0, 1.00);border-right: 0 solid rgba(0, 0, 0, 1.00);padding-bottom:3pt;padding-top:3pt;padding-left:3pt;padding-right:3pt;line-height: 1;background-color:transparent;}.cl-e72fa176{background-color:transparent;vertical-align: middle;border-bottom: 1pt solid rgba(225, 225, 225, 1.00);border-top: 1pt solid rgba(200, 200, 200, 1.00);border-left: 1pt solid rgba(200, 200, 200, 1.00);border-right: 1pt solid rgba(200, 200, 200, 1.00);margin-bottom:0;margin-top:0;margin-left:0;margin-right:0;}.cl-e72fa18a{background-color:transparent;vertical-align: middle;border-bottom: 1pt solid rgba(225, 225, 225, 1.00);border-top: 1pt solid rgba(200, 200, 200, 1.00);border-left: 1pt solid rgba(225, 225, 225, 1.00);border-right: 1pt solid rgba(225, 225, 225, 1.00);margin-bottom:0;margin-top:0;margin-left:0;margin-right:0;}.cl-e72fa18b{background-color:transparent;vertical-align: middle;border-bottom: 1pt solid rgba(225, 225, 225, 1.00);border-top: 1pt solid rgba(200, 200, 200, 1.00);border-left: 1pt solid rgba(225, 225, 225, 1.00);border-right: 1pt solid rgba(225, 225, 225, 1.00);margin-bottom:0;margin-top:0;margin-left:0;margin-right:0;}.cl-e72fa194{background-color:transparent;vertical-align: middle;border-bottom: 1pt solid rgba(225, 225, 225, 1.00);border-top: 1pt solid rgba(200, 200, 200, 1.00);border-left: 1pt solid rgba(225, 225, 225, 1.00);border-right: 1pt solid rgba(200, 200, 200, 1.00);margin-bottom:0;margin-top:0;margin-left:0;margin-right:0;}.cl-e72fa19e{background-color:rgba(225, 225, 225, 1.00);vertical-align: middle;border-bottom: 1pt solid rgba(200, 200, 200, 1.00);border-top: 1pt solid rgba(200, 200, 200, 1.00);border-left: 1pt solid rgba(200, 200, 200, 1.00);border-right: 1pt solid rgba(200, 200, 200, 1.00);margin-bottom:0;margin-top:0;margin-left:0;margin-right:0;}.cl-e72fa19f{background-color:rgba(200, 200, 200, 1.00);vertical-align: middle;border-bottom: 1pt solid rgba(200, 200, 200, 1.00);border-top: 1pt solid rgba(200, 200, 200, 1.00);border-left: 1pt solid rgba(200, 200, 200, 1.00);border-right: 1pt solid rgba(200, 200, 200, 1.00);margin-bottom:0;margin-top:0;margin-left:0;margin-right:0;}.cl-e72fa1a8{background-color:rgba(200, 200, 200, 1.00);vertical-align: middle;border-bottom: 1pt solid rgba(200, 200, 200, 1.00);border-top: 1pt solid rgba(200, 200, 200, 1.00);border-left: 1pt solid rgba(200, 200, 200, 1.00);border-right: 1pt solid rgba(200, 200, 200, 1.00);margin-bottom:0;margin-top:0;margin-left:0;margin-right:0;}.cl-e72fa1a9{background-color:rgba(225, 225, 225, 1.00);vertical-align: middle;border-bottom: 1pt solid rgba(200, 200, 200, 1.00);border-top: 1pt solid rgba(200, 200, 200, 1.00);border-left: 1pt solid rgba(200, 200, 200, 1.00);border-right: 1pt solid rgba(200, 200, 200, 1.00);margin-bottom:0;margin-top:0;margin-left:0;margin-right:0;}.cl-e72fa1b2{background-color:rgba(233, 233, 233, 1.00);vertical-align: middle;border-bottom: 1pt solid rgba(200, 200, 200, 1.00);border-top: 1pt solid rgba(200, 200, 200, 1.00);border-left: 1pt solid rgba(200, 200, 200, 1.00);border-right: 1pt solid rgba(200, 200, 200, 1.00);margin-bottom:0;margin-top:0;margin-left:0;margin-right:0;}.cl-e72fa1b3{background-color:transparent;vertical-align: middle;border-bottom: 1pt solid rgba(200, 200, 200, 1.00);border-top: 1pt solid rgba(200, 200, 200, 1.00);border-left: 1pt solid rgba(200, 200, 200, 1.00);border-right: 1pt solid rgba(200, 200, 200, 1.00);margin-bottom:0;margin-top:0;margin-left:0;margin-right:0;}


fxTable example
```
