
<!-- README.md is generated from README.Rmd. Please edit that file -->

# visOmopResults

<!-- badges: start -->

[![R-CMD-check](https://github.com/oxford-pharmacoepi/visOmopResults/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/oxford-pharmacoepi/visOmopResults/actions/workflows/R-CMD-check.yaml)
[![CRAN
status](https://www.r-pkg.org/badges/version/visOmopResults)](https://CRAN.R-project.org/package=visOmopResults)
[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
<!-- badges: end -->

## Package overview

visOmopResults contains functions for formatting objects of the class
*summarised_result* and *compared_result* (see R package
[omopgenerics](https://CRAN.R-project.org/package=omopgenerics)). This
package simplifies the handling of these objects to obtain nice output
tables in the format of *gt* or *flextable*’ to report results via Shiny
apps, RMarkdown, Quarto, and more.

## Installation

You can install the development version of visOmopResults from
[GitHub](https://github.com/oxford-pharmacoepi/visOmopResults) with:

``` r
# install.packages("devtools")
devtools::install_github("oxford-pharmacoepi/visOmopResults")
```

## Example

In this example we show how to use the package to format a mock
*summarised_result* object into a nice gt object.

First we load the package and create the mock *summarised_result*
object.

``` r
library(visOmopResults)
result <- mockSummarisedResult()
```

### 1. formatEstimateValue

We utilize this function to modify the *estimate_value* column. In this
case, we will apply the default settings of the function, which include
using 0 decimals for integer values, 2 decimals for numeric values, 1
decimal for percentages, and 3 decimals for proportions. Additionally,
the function sets the decimal mark to ‘.’, and the thousand/millions
separator to ‘,’ by default.”

``` r
result <- result |> 
  formatEstimateValue(
    decimals = c(integer = 0, numeric = 2, percentage = 1, proportion = 3),
    decimalMark = ".",
    bigMark = ",")
```

``` r
result |> dplyr::glimpse()
#> Rows: 126
#> Columns: 15
#> $ cdm_name         <chr> "mock", "mock", "mock", "mock", "mock", "mock", "mock…
#> $ result_type      <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N…
#> $ package_name     <chr> "visOmopResults", "visOmopResults", "visOmopResults",…
#> $ package_version  <chr> "0.0.1", "0.0.1", "0.0.1", "0.0.1", "0.0.1", "0.0.1",…
#> $ group_name       <chr> "cohort_name", "cohort_name", "cohort_name", "cohort_…
#> $ group_level      <chr> "cohort1", "cohort1", "cohort1", "cohort1", "cohort1"…
#> $ strata_name      <chr> "overall", "age_group and sex", "age_group and sex", …
#> $ strata_level     <chr> "overall", "<40 and Male", ">=40 and Male", "<40 and …
#> $ variable_name    <chr> "number subjects", "number subjects", "number subject…
#> $ variable_level   <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N…
#> $ estimate_name    <chr> "count", "count", "count", "count", "count", "count",…
#> $ estimate_type    <chr> "integer", "integer", "integer", "integer", "integer"…
#> $ estimate_value   <chr> "4,530,457", "7,827,494", "4,349,346", "1,962,506", "…
#> $ additional_name  <chr> "overall", "overall", "overall", "overall", "overall"…
#> $ additional_level <chr> "overall", "overall", "overall", "overall", "overall"…
```

### 2. formatEstimateName

With this function we can transform the *estimate_name* and
*estimate_value* columns. For example, it allows to consolidate into one
row counts and percentages related to the same variable within the same
group and strata. It’s worth noting that the estimate_name is enclosed
within \<…\> in the *estimateNameFormat* argument.”

``` r
result <- result |> formatEstimateName(
  estimateNameFormat = c("N (%)" = "<count> (<percentage>%)",
                         "N" = "<count>",
                         "Mean (SD)" = "<mean> (<sd>)"),
  keepNotFormatted = FALSE)
#> Joining with `by = join_by(estimate_name)`
```

``` r
result |> dplyr::glimpse()
#> Rows: 72
#> Columns: 15
#> $ cdm_name         <chr> "mock", "mock", "mock", "mock", "mock", "mock", "mock…
#> $ result_type      <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N…
#> $ package_name     <chr> "visOmopResults", "visOmopResults", "visOmopResults",…
#> $ package_version  <chr> "0.0.1", "0.0.1", "0.0.1", "0.0.1", "0.0.1", "0.0.1",…
#> $ group_name       <chr> "cohort_name", "cohort_name", "cohort_name", "cohort_…
#> $ group_level      <chr> "cohort1", "cohort1", "cohort1", "cohort1", "cohort1"…
#> $ strata_name      <chr> "overall", "age_group and sex", "age_group and sex", …
#> $ strata_level     <chr> "overall", "<40 and Male", ">=40 and Male", "<40 and …
#> $ variable_name    <chr> "number subjects", "number subjects", "number subject…
#> $ variable_level   <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N…
#> $ estimate_name    <chr> "N", "N", "N", "N", "N", "N", "N", "N", "N", "N", "N"…
#> $ estimate_type    <chr> "character", "character", "character", "character", "…
#> $ estimate_value   <chr> "4,530,457", "7,827,494", "4,349,346", "1,962,506", "…
#> $ additional_name  <chr> "overall", "overall", "overall", "overall", "overall"…
#> $ additional_level <chr> "overall", "overall", "overall", "overall", "overall"…
```

### 3. formatTable

Next step is to format our table before tranforming to gt object. We
will pivot *strata_name* and *strata_level* columns to have the strata
groups as columns under the header “Study strata”.

``` r
result <- result |>
  formatTable(header = c("Study strata", "strata_name", "strata_level"),
              delim = "\n", 
              includeHeaderName = FALSE,
              includeHeaderKey = TRUE)
```

``` r
result |> dplyr::glimpse()
#> Rows: 8
#> Columns: 21
#> $ cdm_name                                                                               <chr> …
#> $ result_type                                                                            <chr> …
#> $ package_name                                                                           <chr> …
#> $ package_version                                                                        <chr> …
#> $ group_name                                                                             <chr> …
#> $ group_level                                                                            <chr> …
#> $ variable_name                                                                          <chr> …
#> $ variable_level                                                                         <chr> …
#> $ estimate_name                                                                          <chr> …
#> $ estimate_type                                                                          <chr> …
#> $ additional_name                                                                        <chr> …
#> $ additional_level                                                                       <chr> …
#> $ `[header]Study strata\n[header_level]overall\n[header_level]overall`                   <chr> …
#> $ `[header]Study strata\n[header_level]age_group and sex\n[header_level]<40 and Male`    <chr> …
#> $ `[header]Study strata\n[header_level]age_group and sex\n[header_level]>=40 and Male`   <chr> …
#> $ `[header]Study strata\n[header_level]age_group and sex\n[header_level]<40 and Female`  <chr> …
#> $ `[header]Study strata\n[header_level]age_group and sex\n[header_level]>=40 and Female` <chr> …
#> $ `[header]Study strata\n[header_level]sex\n[header_level]Male`                          <chr> …
#> $ `[header]Study strata\n[header_level]sex\n[header_level]Female`                        <chr> …
#> $ `[header]Study strata\n[header_level]age_group\n[header_level]<40`                     <chr> …
#> $ `[header]Study strata\n[header_level]age_group\n[header_level]>=40`                    <chr> …
```

### 4. gtTable

Finally, we convert the transformed *summarised_result* object in steps
1, 2, and 3, into a nice gt object. We use the default visOmopResults
style. Additonally, we separet data into groups specified by
*group_level* column to differentiate between cohort1 and cohort2.

``` r
gtResult <- result |>
  dplyr::select(-c("result_type", "package_name", "package_version", 
                   "group_name", "additional_name", "additional_level",
                   "estimate_type")) |>
  gtTable(
    delim = "\n",
    style = "default",
    na = "-",
    title = "My first gt table with visOmopResults!",
    groupNameCol = "group_level",
    groupNameAsColumn = FALSE,
    groupOrder = c("cohort1", "cohort2"),
    colsToMergeRows = "all_columns"
    )
```

``` r
gtResult 
```

![](./man/figures/gt_table.png)
