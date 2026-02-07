# Tables

## Introduction

The **visOmopResults** package provides user-friendly tools for creating
publication-ready tables and plots. This vignette documents the
package’s table functions:(1) the high-level table helpers and (2) the
lower-level `format*()` functions they rely on.

Supported table types: `<tibble>` (data.frame), `<gt>`, `<flextable>`,
`<tinytable>`, `<datatables>` (DT), and `<reactable>`. These table types
work in R Markdown, Quarto, Shiny, and other contexts.

To list supported table types by the package use the following function:

``` r
tableType()
#> [1] "gt"        "flextable" "tibble"    "datatable" "reactable" "tinytable"
```

Although the package primarily targets the `<summarised_result>` class
(see the `omopgenerics` package for details), most functions work with
any `data.frame`.

### Overview of table functions

Two main categories of table funcions:

- **Main table functions** — high-level table functions that return a
  completly formatted table object:
  [`visTable()`](https://darwin-eu.github.io/visOmopResults/reference/visTable.md)
  and
  [`visOmopTable()`](https://darwin-eu.github.io/visOmopResults/reference/visOmopTable.md).
- **Formatting functions** — lower-level functions (`format*()` family
  set) that formats a `data.frame` or `<summarised_result>` in a
  pipeline fashion, giving finer control.

This vignette first shows the main functions and then explains the
formatting building blocks so you understand how to compose more complex
table workflows, and understand advanced options of the main functions.

## Main table functions

The high-level helpers are convenient wrappers built on top of the
`format*()` functions. They accept a `result` (a `data.frame` or
`<summarised_result>`) and return a rendered table object.

### `visTable()` — format any data.frame

[`visTable()`](https://darwin-eu.github.io/visOmopResults/reference/visTable.md)
formats an arbitrary `data.frame`. Basic features include renaming
columns, hiding columns, grouping rows, and choosing the output table
type via `type`.

Tow show an example we’ll use the pengun dataset from `palmerpenguins`.

``` r
library(visOmopResults)
library(palmerpenguins)
library(dplyr)
library(tidyr)

x <- penguins |>
  filter(!is.na(sex) & year == 2008) |>
  select(!"body_mass_g") |>
  summarise(across(ends_with("mm"), ~mean(.x)), .by = c("species", "island", "sex"))
head(x)
#> # A tibble: 6 × 6
#>   species island    sex    bill_length_mm bill_depth_mm flipper_length_mm
#>   <fct>   <fct>     <fct>           <dbl>         <dbl>             <dbl>
#> 1 Adelie  Biscoe    female           36.6          17.2              187.
#> 2 Adelie  Biscoe    male             40.8          19.0              193.
#> 3 Adelie  Torgersen female           36.6          17.4              190 
#> 4 Adelie  Torgersen male             40.9          18.8              194.
#> 5 Adelie  Dream     female           36.3          17.8              189 
#> 6 Adelie  Dream     male             40.1          18.9              195
```

[`visTable()`](https://darwin-eu.github.io/visOmopResults/reference/visTable.md)
is used to quickly produce a `gt` table, where sex column is used for
groupping, column names are nicely renamed, and the year column hided:

``` r
visTable(
  result = x,
  groupColumn = c("sex"),
  rename = c(
    "Bill length (mm)" = "bill_length_mm",
    "Bill depth (mm)" = "bill_depth_mm",
    "Flipper length (mm)" = "flipper_length_mm"
  ),
  type = "gt",
  hide = "year"
)
```

| Species   | Island    | Bill length (mm) | Bill depth (mm)  | Flipper length (mm) |
|-----------|-----------|------------------|------------------|---------------------|
| female    |           |                  |                  |                     |
| Adelie    | Biscoe    | 36.6444444444444 | 17.2222222222222 | 186.555555555556    |
|           | Torgersen | 36.6125          | 17.4             | 190                 |
|           | Dream     | 36.275           | 17.7875          | 189                 |
| Gentoo    | Biscoe    | 45.2954545454545 | 14.1318181818182 | 213                 |
| Chinstrap | Dream     | 46               | 17.3             | 192.666666666667    |
| male      |           |                  |                  |                     |
| Adelie    | Biscoe    | 40.7555555555556 | 19.0333333333333 | 192.555555555556    |
|           | Torgersen | 40.925           | 18.8375          | 193.5               |
|           | Dream     | 40.1125          | 18.8875          | 195                 |
| Gentoo    | Biscoe    | 48.5391304347826 | 15.704347826087  | 222.086956521739    |
| Chinstrap | Dream     | 51.4             | 19.6             | 202.777777777778    |

If estimates of a `data.frame` are arranged into three three standard
columns (`estimate_name`, `estimate_type`, and `estimate_value`) these
can be formatted. This includes setting 2 decimals, allowing for
estimate combination with `estimateName`, and finally, allowing to
create headers with `header`:

``` r
# Transforming to estimate columns
x <- x |>
  pivot_longer(
    cols = ends_with("_mm"),
    names_to = "estimate_name",
    values_to = "estimate_value"
  ) |>
  mutate(estimate_type = "numeric")

# Use estimateName and header 
visTable(
  result = x,
  estimateName = c(
    "Bill length - Bill depth (mm)" = "<bill_length_mm> - <bill_depth_mm>",
    "Flipper length (mm)" = "<flipper_length_mm>"
  ),
  header = c("species", "island"),
  groupColumn = "sex",
  type = "gt",
  hide = c("year", "estimate_type")
)
```

[TABLE]

We can obtain the same table with `flextable` or `tinytable`, the former
seen below:

``` r
visTable(
  result = x,
  estimateName = c(
    "Bill length - Bill depth (mm)" = "<bill_length_mm> - <bill_depth_mm>",
    "Flipper length (mm)" = "<flipper_length_mm>"
  ),
  header = c("species", "island"),
  groupColumn = "sex",
  type = "flextable",
  hide = c("year", "estimate_type")
)
```

| Estimate name                 | Species       |               |               |               |               |
|-------------------------------|---------------|---------------|---------------|---------------|---------------|
|                               | Adelie        |               |               | Gentoo        | Chinstrap     |
|                               | Island        |               |               |               |               |
|                               | Biscoe        | Torgersen     | Dream         | Biscoe        | Dream         |
| female                        |               |               |               |               |               |
| Bill length - Bill depth (mm) | 36.64 - 17.22 | 36.61 - 17.40 | 36.27 - 17.79 | 45.30 - 14.13 | 46.00 - 17.30 |
| Flipper length (mm)           | 186.56        | 190.00        | 189.00        | 213.00        | 192.67        |
| male                          |               |               |               |               |               |
| Bill length - Bill depth (mm) | 40.76 - 19.03 | 40.92 - 18.84 | 40.11 - 18.89 | 48.54 - 15.70 | 51.40 - 19.60 |
| Flipper length (mm)           | 192.56        | 193.50        | 195.00        | 222.09        | 202.78        |

We can also have a similar interactive table using `datatable`:

``` r
visTable(
  result = x,
  estimateName = c(
    "Bill length - Bill depth (mm)" = "<bill_length_mm> - <bill_depth_mm>",
    "Flipper length (mm)" = "<flipper_length_mm>"
  ),
  header = c("species", "island"),
  groupColumn = "sex",
  type = "datatable",
  hide = c("year", "estimate_type")
)
```

Nevertheless, `reactable` currently only supports one level headers.
Thereby to use this type we have to reduce to one header. Instead of
having a two-level header, we can group by two columns:

``` r
visTable(
  result = x,
  estimateName = c(
    "Bill length - Bill depth (mm)" = "<bill_length_mm> - <bill_depth_mm>",
    "Flipper length (mm)" = "<flipper_length_mm>"
  ),
  header = c("island"),
  groupColumn = c("species", "sex"),
  type = "reactable",
  hide = c("year", "estimate_type")
)
```

### `visOmopTable()` — specialized for `<summarised_result>`

[`visOmopTable()`](https://darwin-eu.github.io/visOmopResults/reference/visOmopTable.md)
builds on
[`visTable()`](https://darwin-eu.github.io/visOmopResults/reference/visTable.md)
with behavior tuned to `<summarised_result>` objects:

- The result is processed with
  [`splitAll()`](https://darwin-eu.github.io/omopgenerics/reference/splitAll.html)
  (see `omopgenerics`) internally, so column names passed to arguments
  must match the split output.
- `settingsColumn` lets you use settings metadata as table columns and
  use them in `header`, `rename`, or `groupColumn`.
- `header` can accept special values (e.g. “strata” to show variables in
  `strata_name` and `strata_level`, or “settings” to show all
  `settingsColumn` values).
- `result_id` and `estimate_type` are hidden internally.
- If the input was processed with
  [`omopgenerics::suppress()`](https://darwin-eu.github.io/omopgenerics/reference/suppress.html),
  suppressed estimates can be shown as `NA` or as the placeholder
  `<{minCellCount}` via the `showMinCellCount` argument.

Example using a mock `<summarised_result>`:

``` r
result <- mockSummarisedResult() |>
  filter(strata_name == "age_group &&& sex")

# A flextable table with a few estimate formats
visOmopTable(
  result = result,
  estimateName = c(
    "N (%)" = "<count> (<percentage>%)",
    "N" = "<count>",
    "Mean (SD)" = "<mean> (<sd>)"
  ),
  header = c("package_name", "age_group"),
  groupColumn = c("cohort_name", "sex"),
  settingsColumn = "package_name",
  type = "flextable"
)
```

| CDM name        | Variable name   | Variable level | Estimate name | Package name    |                 |
|-----------------|-----------------|----------------|---------------|-----------------|-----------------|
|                 |                 |                |               | visOmopResults  |                 |
|                 |                 |                |               | Age group       |                 |
|                 |                 |                |               | \<40            | \>=40           |
| cohort1; Male   |                 |                |               |                 |                 |
| mock            | number subjects | –              | N             | 3,721,239       | 5,728,534       |
|                 | age             | –              | Mean (SD)     | 77.74 (1.08)    | 93.47 (7.24)    |
|                 | Medications     | Amoxiciline    | N (%)         | 9,947 (33.38%)  | 31,627 (47.64%) |
|                 |                 | Ibuprofen      | N (%)         | 5,893 (59.88%)  | 64,229 (97.62%) |
| cohort1; Female |                 |                |               |                 |                 |
| mock            | number subjects | –              | N             | 9,082,078       | 2,016,819       |
|                 | age             | –              | Mean (SD)     | 21.21 (4.11)    | 65.17 (8.21)    |
|                 | Medications     | Amoxiciline    | N (%)         | 51,863 (89.22%) | 66,201 (86.43%) |
|                 |                 | Ibuprofen      | N (%)         | 87,627 (73.18%) | 77,891 (35.67%) |
| cohort2; Male   |                 |                |               |                 |                 |
| mock            | number subjects | –              | N             | 2,059,746       | 1,765,568       |
|                 | age             | –              | Mean (SD)     | 86.97 (0.23)    | 34.03 (4.77)    |
|                 | Medications     | Amoxiciline    | N (%)         | 65,087 (40.00%) | 25,802 (32.54%) |
|                 |                 | Ibuprofen      | N (%)         | 65,472 (44.63%) | 35,320 (64.01%) |
| cohort2; Female |                 |                |               |                 |                 |
| mock            | number subjects | –              | N             | 6,870,228       | 3,841,037       |
|                 | age             | –              | Mean (SD)     | 48.21 (7.32)    | 59.96 (6.93)    |
|                 | Medications     | Amoxiciline    | N (%)         | 47,855 (75.71%) | 76,631 (20.27%) |
|                 |                 | Ibuprofen      | N (%)         | 27,026 (99.18%) | 99,268 (49.56%) |

Example showing suppressed values (treat input with
[`suppress()`](https://darwin-eu.github.io/omopgenerics/reference/suppress.html)
then display them with `showMinCellCount = TRUE`):

``` r
result |>
  suppress(minCellCount = 1000000) |>
  visOmopTable(
    estimateName = c(
      "N (%)" = "<count> (<percentage>%)",
      "N" = "<count>",
      "Mean (SD)" = "<mean> (<sd>)"
    ),
    header = c("group"),
    groupColumn = c("strata"),
    hide = c("cdm_name"),
    showMinCellCount = TRUE,
    type = "flextable"
  )
```

| Variable name   | Variable level | Estimate name | Cohort name  |              |
|-----------------|----------------|---------------|--------------|--------------|
|                 |                |               | cohort1      | cohort2      |
| \<40; Male      |                |               |              |              |
| number subjects | –              | N             | 3,721,239    | 2,059,746    |
| age             | –              | Mean (SD)     | 77.74 (1.08) | 86.97 (0.23) |
| Medications     | Amoxiciline    | N (%)         | \<1,000,000  | \<1,000,000  |
|                 | Ibuprofen      | N (%)         | \<1,000,000  | \<1,000,000  |
| \>=40; Male     |                |               |              |              |
| number subjects | –              | N             | 5,728,534    | 1,765,568    |
| age             | –              | Mean (SD)     | 93.47 (7.24) | 34.03 (4.77) |
| Medications     | Amoxiciline    | N (%)         | \<1,000,000  | \<1,000,000  |
|                 | Ibuprofen      | N (%)         | \<1,000,000  | \<1,000,000  |
| \<40; Female    |                |               |              |              |
| number subjects | –              | N             | 9,082,078    | 6,870,228    |
| age             | –              | Mean (SD)     | 21.21 (4.11) | 48.21 (7.32) |
| Medications     | Amoxiciline    | N (%)         | \<1,000,000  | \<1,000,000  |
|                 | Ibuprofen      | N (%)         | \<1,000,000  | \<1,000,000  |
| \>=40; Female   |                |               |              |              |
| number subjects | –              | N             | 2,016,819    | 3,841,037    |
| age             | –              | Mean (SD)     | 65.17 (8.21) | 59.96 (6.93) |
| Medications     | Amoxiciline    | N (%)         | \<1,000,000  | \<1,000,000  |
|                 | Ibuprofen      | N (%)         | \<1,000,000  | \<1,000,000  |

### Using `.options`

The main table functions (high-level) do not expose every granular
formatting argument directly. Instead, you can pass further
customisation through the `.options` list. To inspect available options
and defaults:

``` r
tableOptions()
#> $decimals
#>    integer percentage    numeric proportion 
#>          0          2          2          2 
#> 
#> $decimalMark
#> [1] "."
#> 
#> $bigMark
#> [1] ","
#> 
#> $keepNotFormatted
#> [1] TRUE
#> 
#> $useFormatOrder
#> [1] TRUE
#> 
#> $delim
#> [1] "\n"
#> 
#> $includeHeaderName
#> [1] TRUE
#> 
#> $includeHeaderKey
#> [1] TRUE
#> 
#> $na
#> [1] "–"
#> 
#> $title
#> NULL
#> 
#> $subtitle
#> NULL
#> 
#> $caption
#> NULL
#> 
#> $groupAsColumn
#> [1] FALSE
#> 
#> $groupOrder
#> NULL
#> 
#> $merge
#> [1] "all_columns"
```

These options originate from the lower-level formatting functions — see
the following section to better understand how to use `.options`.

Additionally, both
[`visTable()`](https://darwin-eu.github.io/visOmopResults/reference/visTable.md)
and
[`visOmopTable()`](https://darwin-eu.github.io/visOmopResults/reference/visOmopTable.md)
have the argument `style`. This allows to customise the visualisation of
the table, either by using built in styles or providing your own. To
know more about styles refer to the
[vignette](https://darwin-eu.github.io/visOmopResults/articles/a05_style.html)
on styles.

## Formatting functions (the `format*()` family)

Use these functions in a pipeline to prepare your data before rendering.
Typical pipeline order:

1.  (Optional for `<summarised_result>`): split the object
    ([`splitAll()`](https://darwin-eu.github.io/omopgenerics/reference/splitAll.html))
2.  Handle suppressed values
    ([`formatMinCellCount()`](https://darwin-eu.github.io/visOmopResults/reference/formatMinCellCount.md))
3.  Format estimate values
    ([`formatEstimateValue()`](https://darwin-eu.github.io/visOmopResults/reference/formatEstimateValue.md))
4.  Combine and rename estimates
    ([`formatEstimateName()`](https://darwin-eu.github.io/visOmopResults/reference/formatEstimateName.md))
5.  Prepare headers
    ([`formatHeader()`](https://darwin-eu.github.io/visOmopResults/reference/formatHeader.md))
6.  Render the table
    ([`formatTable()`](https://darwin-eu.github.io/visOmopResults/reference/formatTable.md))

Below we illustrate each of the steps 2 to 6.

### `formatMinCellCount()` — suppressed estimates

If estimates were suppressed with
[`omopgenerics::suppress()`](https://darwin-eu.github.io/omopgenerics/reference/suppress.html),
use
[`formatMinCellCount()`](https://darwin-eu.github.io/visOmopResults/reference/formatMinCellCount.md)
to mark which cells were suppressed (the function differentiates
suppressed cells from `NA`).

``` r
result <- result |> formatMinCellCount()
```

### `formatEstimateValue()` — numeric formatting

Control decimal places and separators per `estimate_type` (integer,
numeric, percentage and proportion) or per `estimate_name` (any estimate
name in your results).

In the example we distinguish by `estimate_type`:

``` r
result <- result |>
  formatEstimateValue(
    decimals = c(integer = 0, numeric = 4, percentage = 2),
    decimalMark = ".",
    bigMark = ","
  )
```

### `formatEstimateName()` — combine and order estimates

Create composite estimate displays (e.g. “N (%)”) and control
ordering/retention of unformatted rows:

``` r
result <- result |>
  formatEstimateName(
    estimateName = c(
      "N (%)" = "<count> (<percentage>%)",
      "N" = "<count>",
      "Mean (SD)" = "<mean> (<sd>)"
    ),
    keepNotFormatted = TRUE,
    useFormatOrder = FALSE
  )
```

If `keepNotFormatted = FALSE`, rows with an estimate name not included
between `<>` in `estimateName` will be dropped. The argument
`useFormatOrder` whether to use the order in which estimates are
mentioned in `estimateName` (TRUE) or use the order in the input table
(TRUE).

### `formatHeader()` — multi-level headers

Create multi-level column headers using up to three levels: custom
`header` labels, `header_name` (derived from column names), and
`header_level` (derived from column values). Use `delim` to set a
delimiter for multi-line headers.

``` r
result <- result |>
  mutate(across(c("strata_name", "strata_level"), ~ gsub("&&&", "and", .x))) |>
  formatHeader(
    header = c("Stratifications", "strata_name", "strata_level"),
    delim = "\n",
    includeHeaderName = FALSE,
    includeHeaderKey = TRUE
  )
```

It is important to set `includeHeaderKey = TRUE` for styling in the next
step, since style differentiates between header, header_name, and
header_level.

### `formatTable()` — render the final table

[`formatTable()`](https://darwin-eu.github.io/visOmopResults/reference/formatTable.md)
converts the prepared `data.frame` into a final `gt`, `flextable`,
`tinytable`, `datatable`, or `reactable` object. It accepts options such
as `na`, `title`, `subtitle`, `caption`, `groupColumn`, `groupAsColumn`,
`groupOrder`, and `merge`.

Example pipeline:

``` r
result <- result |>
  splitGroup() |>
  splitAdditional() |>
  select(!c("result_id", "estimate_type", "cdm_name"))

result |>
  formatTable(
    type = "gt",
    delim = "\n",
    na = "-",
    title = "My formatted table!",
    subtitle = "Created with the `visOmopResults` R package.",
    caption = NULL,
    groupColumn = "cohort_name",
    groupAsColumn = FALSE,
    groupOrder = c("cohort2", "cohort1"),
    merge = "variable_name"
  )
```

[TABLE]

## Notes & recommendations

- Use
  [`visTable()`](https://darwin-eu.github.io/visOmopResults/reference/visTable.md)
  for quick formatting of generic `data.frame` inputs. Use
  [`visOmopTable()`](https://darwin-eu.github.io/visOmopResults/reference/visOmopTable.md)
  when working with `<summarised_result>` objects to leverage the
  specialized behavior (automatic splitting, settings columns,
  suppressed-value handling).
- When you need fine-grained control over formatting build a pipeline
  using the `format*()` functions and finish with
  [`formatTable()`](https://darwin-eu.github.io/visOmopResults/reference/formatTable.md).
- Visit the
  [vignette](https://darwin-eu.github.io/visOmopResults/articles/a05_style.html)
  on `styles` to learn how to leverage build-in styles and create your
  own.
