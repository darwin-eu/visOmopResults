
<!-- README.md is generated from README.Rmd. Please edit that file -->

# visOmopResults

<!-- badges: start -->

[![R-CMD-check](https://github.com/catalamarti/gtSummarisedResult/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/catalamarti/gtSummarisedResult/actions/workflows/R-CMD-check.yaml)
[![CRAN
status](https://www.r-pkg.org/badges/version/visOmopResults)](https://CRAN.R-project.org/package=visOmopResults)
[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
<!-- badges: end -->

## Package overview

visOmopResults contains functions for formatting objects of the class
*summarised_result* and *compared_result* (see R package
[omopgenerics](https://cran.r-project.org/web/packages/omopgenerics/index.html)).
This package simplifies the handling of these objects to obtain nice
output tables in the format of *gt* or *flextable*’ to report results
via Shiny apps, RMarkdown, Quarto, and more.

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
library(dplyr)
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
result
#> # A tibble: 126 × 15
#>    cdm_name result_type package_name   package_version group_name  group_level
#>    <chr>    <chr>       <chr>          <chr>           <chr>       <chr>      
#>  1 mock     <NA>        visOmopResults 0.0.1           cohort_name cohort1    
#>  2 mock     <NA>        visOmopResults 0.0.1           cohort_name cohort1    
#>  3 mock     <NA>        visOmopResults 0.0.1           cohort_name cohort1    
#>  4 mock     <NA>        visOmopResults 0.0.1           cohort_name cohort1    
#>  5 mock     <NA>        visOmopResults 0.0.1           cohort_name cohort1    
#>  6 mock     <NA>        visOmopResults 0.0.1           cohort_name cohort1    
#>  7 mock     <NA>        visOmopResults 0.0.1           cohort_name cohort1    
#>  8 mock     <NA>        visOmopResults 0.0.1           cohort_name cohort1    
#>  9 mock     <NA>        visOmopResults 0.0.1           cohort_name cohort1    
#> 10 mock     <NA>        visOmopResults 0.0.1           cohort_name cohort2    
#> # ℹ 116 more rows
#> # ℹ 9 more variables: strata_name <chr>, strata_level <chr>,
#> #   variable_name <chr>, variable_level <chr>, estimate_name <chr>,
#> #   estimate_type <chr>, estimate_value <chr>, additional_name <chr>,
#> #   additional_level <chr>
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
result
#> # A tibble: 72 × 15
#>    cdm_name result_type package_name   package_version group_name  group_level
#>    <chr>    <chr>       <chr>          <chr>           <chr>       <chr>      
#>  1 mock     <NA>        visOmopResults 0.0.1           cohort_name cohort1    
#>  2 mock     <NA>        visOmopResults 0.0.1           cohort_name cohort1    
#>  3 mock     <NA>        visOmopResults 0.0.1           cohort_name cohort1    
#>  4 mock     <NA>        visOmopResults 0.0.1           cohort_name cohort1    
#>  5 mock     <NA>        visOmopResults 0.0.1           cohort_name cohort1    
#>  6 mock     <NA>        visOmopResults 0.0.1           cohort_name cohort1    
#>  7 mock     <NA>        visOmopResults 0.0.1           cohort_name cohort1    
#>  8 mock     <NA>        visOmopResults 0.0.1           cohort_name cohort1    
#>  9 mock     <NA>        visOmopResults 0.0.1           cohort_name cohort1    
#> 10 mock     <NA>        visOmopResults 0.0.1           cohort_name cohort2    
#> # ℹ 62 more rows
#> # ℹ 9 more variables: strata_name <chr>, strata_level <chr>,
#> #   variable_name <chr>, variable_level <chr>, estimate_name <chr>,
#> #   estimate_type <chr>, estimate_value <chr>, additional_name <chr>,
#> #   additional_level <chr>
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
result
#> # A tibble: 8 × 21
#>   cdm_name result_type package_name   package_version group_name  group_level
#>   <chr>    <chr>       <chr>          <chr>           <chr>       <chr>      
#> 1 mock     <NA>        visOmopResults 0.0.1           cohort_name cohort1    
#> 2 mock     <NA>        visOmopResults 0.0.1           cohort_name cohort2    
#> 3 mock     <NA>        visOmopResults 0.0.1           cohort_name cohort1    
#> 4 mock     <NA>        visOmopResults 0.0.1           cohort_name cohort2    
#> 5 mock     <NA>        visOmopResults 0.0.1           cohort_name cohort1    
#> 6 mock     <NA>        visOmopResults 0.0.1           cohort_name cohort2    
#> 7 mock     <NA>        visOmopResults 0.0.1           cohort_name cohort1    
#> 8 mock     <NA>        visOmopResults 0.0.1           cohort_name cohort2    
#> # ℹ 15 more variables: variable_name <chr>, variable_level <chr>,
#> #   estimate_name <chr>, estimate_type <chr>, additional_name <chr>,
#> #   additional_level <chr>,
#> #   `[header]Study strata\n[header_level]overall\n[header_level]overall` <chr>,
#> #   `[header]Study strata\n[header_level]age_group and sex\n[header_level]<40 and Male` <chr>,
#> #   `[header]Study strata\n[header_level]age_group and sex\n[header_level]>=40 and Male` <chr>,
#> #   `[header]Study strata\n[header_level]age_group and sex\n[header_level]<40 and Female` <chr>, …
```

### 4. gtTable

Finally, we convert the transformed *summarised_result* object in steps
1, 2, and 3, into a nice gt object. We use the default visOmopResults
style. Additonally, we separet data into groups specified by
*group_level* column to differentiate between cohort1 and cohort2.

``` r
gtResult <- result |>
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

<div id="dhrxytqjwg" style="padding-left:0px;padding-right:0px;padding-top:10px;padding-bottom:10px;overflow-x:auto;overflow-y:auto;width:auto;height:auto;">
<style>#dhrxytqjwg table {
  font-family: system-ui, 'Segoe UI', Roboto, Helvetica, Arial, sans-serif, 'Apple Color Emoji', 'Segoe UI Emoji', 'Segoe UI Symbol', 'Noto Color Emoji';
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
}
&#10;#dhrxytqjwg thead, #dhrxytqjwg tbody, #dhrxytqjwg tfoot, #dhrxytqjwg tr, #dhrxytqjwg td, #dhrxytqjwg th {
  border-style: none;
}
&#10;#dhrxytqjwg p {
  margin: 0;
  padding: 0;
}
&#10;#dhrxytqjwg .gt_table {
  display: table;
  border-collapse: collapse;
  line-height: normal;
  margin-left: auto;
  margin-right: auto;
  color: #333333;
  font-size: 16px;
  font-weight: normal;
  font-style: normal;
  background-color: #FFFFFF;
  width: auto;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #A8A8A8;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #A8A8A8;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
}
&#10;#dhrxytqjwg .gt_caption {
  padding-top: 4px;
  padding-bottom: 4px;
}
&#10;#dhrxytqjwg .gt_title {
  color: #333333;
  font-size: 125%;
  font-weight: initial;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-color: #FFFFFF;
  border-bottom-width: 0;
}
&#10;#dhrxytqjwg .gt_subtitle {
  color: #333333;
  font-size: 85%;
  font-weight: initial;
  padding-top: 3px;
  padding-bottom: 5px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-color: #FFFFFF;
  border-top-width: 0;
}
&#10;#dhrxytqjwg .gt_heading {
  background-color: #FFFFFF;
  text-align: center;
  border-bottom-color: #FFFFFF;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
}
&#10;#dhrxytqjwg .gt_bottom_border {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}
&#10;#dhrxytqjwg .gt_col_headings {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
}
&#10;#dhrxytqjwg .gt_col_heading {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: normal;
  text-transform: inherit;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: bottom;
  padding-top: 5px;
  padding-bottom: 6px;
  padding-left: 5px;
  padding-right: 5px;
  overflow-x: hidden;
}
&#10;#dhrxytqjwg .gt_column_spanner_outer {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: normal;
  text-transform: inherit;
  padding-top: 0;
  padding-bottom: 0;
  padding-left: 4px;
  padding-right: 4px;
}
&#10;#dhrxytqjwg .gt_column_spanner_outer:first-child {
  padding-left: 0;
}
&#10;#dhrxytqjwg .gt_column_spanner_outer:last-child {
  padding-right: 0;
}
&#10;#dhrxytqjwg .gt_column_spanner {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  vertical-align: bottom;
  padding-top: 5px;
  padding-bottom: 5px;
  overflow-x: hidden;
  display: inline-block;
  width: 100%;
}
&#10;#dhrxytqjwg .gt_spanner_row {
  border-bottom-style: hidden;
}
&#10;#dhrxytqjwg .gt_group_heading {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: middle;
  text-align: left;
}
&#10;#dhrxytqjwg .gt_empty_group_heading {
  padding: 0.5px;
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  vertical-align: middle;
}
&#10;#dhrxytqjwg .gt_from_md > :first-child {
  margin-top: 0;
}
&#10;#dhrxytqjwg .gt_from_md > :last-child {
  margin-bottom: 0;
}
&#10;#dhrxytqjwg .gt_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  margin: 10px;
  border-top-style: solid;
  border-top-width: 1px;
  border-top-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: middle;
  overflow-x: hidden;
}
&#10;#dhrxytqjwg .gt_stub {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-right-style: solid;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  padding-left: 5px;
  padding-right: 5px;
}
&#10;#dhrxytqjwg .gt_stub_row_group {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-right-style: solid;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  padding-left: 5px;
  padding-right: 5px;
  vertical-align: top;
}
&#10;#dhrxytqjwg .gt_row_group_first td {
  border-top-width: 2px;
}
&#10;#dhrxytqjwg .gt_row_group_first th {
  border-top-width: 2px;
}
&#10;#dhrxytqjwg .gt_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}
&#10;#dhrxytqjwg .gt_first_summary_row {
  border-top-style: solid;
  border-top-color: #D3D3D3;
}
&#10;#dhrxytqjwg .gt_first_summary_row.thick {
  border-top-width: 2px;
}
&#10;#dhrxytqjwg .gt_last_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}
&#10;#dhrxytqjwg .gt_grand_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}
&#10;#dhrxytqjwg .gt_first_grand_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-style: double;
  border-top-width: 6px;
  border-top-color: #D3D3D3;
}
&#10;#dhrxytqjwg .gt_last_grand_summary_row_top {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-style: double;
  border-bottom-width: 6px;
  border-bottom-color: #D3D3D3;
}
&#10;#dhrxytqjwg .gt_striped {
  background-color: rgba(128, 128, 128, 0.05);
}
&#10;#dhrxytqjwg .gt_table_body {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}
&#10;#dhrxytqjwg .gt_footnotes {
  color: #333333;
  background-color: #FFFFFF;
  border-bottom-style: none;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
}
&#10;#dhrxytqjwg .gt_footnote {
  margin: 0px;
  font-size: 90%;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
}
&#10;#dhrxytqjwg .gt_sourcenotes {
  color: #333333;
  background-color: #FFFFFF;
  border-bottom-style: none;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
}
&#10;#dhrxytqjwg .gt_sourcenote {
  font-size: 90%;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
}
&#10;#dhrxytqjwg .gt_left {
  text-align: left;
}
&#10;#dhrxytqjwg .gt_center {
  text-align: center;
}
&#10;#dhrxytqjwg .gt_right {
  text-align: right;
  font-variant-numeric: tabular-nums;
}
&#10;#dhrxytqjwg .gt_font_normal {
  font-weight: normal;
}
&#10;#dhrxytqjwg .gt_font_bold {
  font-weight: bold;
}
&#10;#dhrxytqjwg .gt_font_italic {
  font-style: italic;
}
&#10;#dhrxytqjwg .gt_super {
  font-size: 65%;
}
&#10;#dhrxytqjwg .gt_footnote_marks {
  font-size: 75%;
  vertical-align: 0.4em;
  position: initial;
}
&#10;#dhrxytqjwg .gt_asterisk {
  font-size: 100%;
  vertical-align: 0;
}
&#10;#dhrxytqjwg .gt_indent_1 {
  text-indent: 5px;
}
&#10;#dhrxytqjwg .gt_indent_2 {
  text-indent: 10px;
}
&#10;#dhrxytqjwg .gt_indent_3 {
  text-indent: 15px;
}
&#10;#dhrxytqjwg .gt_indent_4 {
  text-indent: 20px;
}
&#10;#dhrxytqjwg .gt_indent_5 {
  text-indent: 25px;
}
</style>
<table class="gt_table" data-quarto-disable-processing="false" data-quarto-bootstrap="false">
  <thead>
    <tr class="gt_heading">
      <td colspan="20" class="gt_heading gt_title gt_font_normal gt_bottom_border" style="font-size: 15; text-align: center; font-weight: bold;">My first gt table with visOmopResults!</td>
    </tr>
    &#10;    <tr class="gt_col_headings gt_spanner_row">
      <th class="gt_center gt_columns_top_border gt_column_spanner_outer" rowspan="1" colspan="11" style="background-color: #C8C8C8; text-align: center; font-weight: bold;" scope="colgroup" id></th>
      <th class="gt_center gt_columns_top_border gt_column_spanner_outer" rowspan="1" colspan="9" style="background-color: #C8C8C8; text-align: center; font-weight: bold;" scope="colgroup" id="Study strata">
        <span class="gt_column_spanner">Study strata</span>
      </th>
    </tr>
    <tr class="gt_col_headings gt_spanner_row">
      <th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="2" colspan="1" style="text-align: center; font-weight: bold;" scope="col" id="cdm_name">cdm_name</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="2" colspan="1" style="text-align: center; font-weight: bold;" scope="col" id="result_type">result_type</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="2" colspan="1" style="text-align: center; font-weight: bold;" scope="col" id="package_name">package_name</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="2" colspan="1" style="text-align: center; font-weight: bold;" scope="col" id="package_version">package_version</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="2" colspan="1" style="text-align: center; font-weight: bold;" scope="col" id="group_name">group_name</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="2" colspan="1" style="text-align: center; font-weight: bold;" scope="col" id="variable_name">variable_name</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="2" colspan="1" style="text-align: center; font-weight: bold;" scope="col" id="variable_level">variable_level</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="2" colspan="1" style="text-align: center; font-weight: bold;" scope="col" id="estimate_name">estimate_name</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="2" colspan="1" style="text-align: center; font-weight: bold;" scope="col" id="estimate_type">estimate_type</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="2" colspan="1" style="text-align: center; font-weight: bold;" scope="col" id="additional_name">additional_name</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="2" colspan="1" style="text-align: center; font-weight: bold;" scope="col" id="additional_level">additional_level</th>
      <th class="gt_center gt_columns_top_border gt_column_spanner_outer" rowspan="1" colspan="1" style="background-color: #E1E1E1; text-align: center; font-weight: bold;" scope="col" id="overall">
        <span class="gt_column_spanner">overall</span>
      </th>
      <th class="gt_center gt_columns_top_border gt_column_spanner_outer" rowspan="1" colspan="4" style="background-color: #E1E1E1; text-align: center; font-weight: bold;" scope="colgroup" id="age_group and sex">
        <span class="gt_column_spanner">age_group and sex</span>
      </th>
      <th class="gt_center gt_columns_top_border gt_column_spanner_outer" rowspan="1" colspan="2" style="background-color: #E1E1E1; text-align: center; font-weight: bold;" scope="colgroup" id="sex">
        <span class="gt_column_spanner">sex</span>
      </th>
      <th class="gt_center gt_columns_top_border gt_column_spanner_outer" rowspan="1" colspan="2" style="background-color: #E1E1E1; text-align: center; font-weight: bold;" scope="colgroup" id="age_group">
        <span class="gt_column_spanner">age_group</span>
      </th>
    </tr>
    <tr class="gt_col_headings">
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" style="background-color: #E1E1E1; text-align: center; font-weight: bold;" scope="col" id="overall">overall</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" style="background-color: #E1E1E1; text-align: center; font-weight: bold;" scope="col" id="&amp;lt;40 and Male">&lt;40 and Male</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" style="background-color: #E1E1E1; text-align: center; font-weight: bold;" scope="col" id="&amp;gt;=40 and Male">&gt;=40 and Male</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" style="background-color: #E1E1E1; text-align: center; font-weight: bold;" scope="col" id="&amp;lt;40 and Female">&lt;40 and Female</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" style="background-color: #E1E1E1; text-align: center; font-weight: bold;" scope="col" id="&amp;gt;=40 and Female">&gt;=40 and Female</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" style="background-color: #E1E1E1; text-align: center; font-weight: bold;" scope="col" id="Male">Male</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" style="background-color: #E1E1E1; text-align: center; font-weight: bold;" scope="col" id="Female">Female</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" style="background-color: #E1E1E1; text-align: center; font-weight: bold;" scope="col" id="&amp;lt;40">&lt;40</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" style="background-color: #E1E1E1; text-align: center; font-weight: bold;" scope="col" id="&amp;gt;=40">&gt;=40</th>
    </tr>
  </thead>
  <tbody class="gt_table_body">
    <tr class="gt_group_heading_row">
      <th colspan="20" class="gt_group_heading" style="background-color: #E9E9E9; font-weight: bold;" scope="colgroup" id="cohort1">cohort1</th>
    </tr>
    <tr class="gt_row_group_first"><td headers="cohort1  cdm_name" class="gt_row gt_left" style="text-align: left;"><div class='gt_from_md'><p>mock</p>
</div></td>
<td headers="cohort1  result_type" class="gt_row gt_left" style="text-align: left; border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; border-top-width: 1px; border-top-style: solid; border-top-color: #D3D3D3; border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: #D3D3D3;">-</td>
<td headers="cohort1  package_name" class="gt_row gt_left" style="text-align: left; border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; border-top-width: 1px; border-top-style: solid; border-top-color: #D3D3D3; border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: #D3D3D3;"><div class='gt_from_md'><p>visOmopResults</p>
</div></td>
<td headers="cohort1  package_version" class="gt_row gt_right" style="text-align: left; border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; border-top-width: 1px; border-top-style: solid; border-top-color: #D3D3D3; border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: #D3D3D3;"><div class='gt_from_md'><p>0.0.1</p>
</div></td>
<td headers="cohort1  group_name" class="gt_row gt_left" style="text-align: left; border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; border-top-width: 1px; border-top-style: solid; border-top-color: #D3D3D3; border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: #D3D3D3;"><div class='gt_from_md'><p>cohort_name</p>
</div></td>
<td headers="cohort1  variable_name" class="gt_row gt_left" style="text-align: left; border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; border-top-width: 1px; border-top-style: solid; border-top-color: #D3D3D3; border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: #D3D3D3;"><div class='gt_from_md'><p>number subjects</p>
</div></td>
<td headers="cohort1  variable_level" class="gt_row gt_left" style="text-align: left; border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; border-top-width: 1px; border-top-style: solid; border-top-color: #D3D3D3; border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: #D3D3D3;">-</td>
<td headers="cohort1  estimate_name" class="gt_row gt_left" style="text-align: left; border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; border-top-width: 1px; border-top-style: solid; border-top-color: #D3D3D3; border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: #D3D3D3;"><div class='gt_from_md'><p>N</p>
</div></td>
<td headers="cohort1  estimate_type" class="gt_row gt_left" style="text-align: left; border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; border-top-width: 1px; border-top-style: solid; border-top-color: #D3D3D3; border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: #D3D3D3;"><div class='gt_from_md'><p>character</p>
</div></td>
<td headers="cohort1  additional_name" class="gt_row gt_left" style="text-align: left; border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; border-top-width: 1px; border-top-style: solid; border-top-color: #D3D3D3; border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: #D3D3D3;"><div class='gt_from_md'><p>overall</p>
</div></td>
<td headers="cohort1  additional_level" class="gt_row gt_left" style="text-align: left; border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; border-top-width: 1px; border-top-style: solid; border-top-color: #D3D3D3; border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: #D3D3D3;"><div class='gt_from_md'><p>overall</p>
</div></td>
<td headers="cohort1  [header]Study strata
[header_level]overall
[header_level]overall" class="gt_row gt_right" style="text-align: right; border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; border-top-width: 1px; border-top-style: solid; border-top-color: #D3D3D3; border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: #D3D3D3;"><div class='gt_from_md'><p>617,400</p>
</div></td>
<td headers="cohort1  [header]Study strata
[header_level]age_group and sex
[header_level]<40 and Male" class="gt_row gt_right" style="text-align: right; border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; border-top-width: 1px; border-top-style: solid; border-top-color: #D3D3D3; border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: #D3D3D3;"><div class='gt_from_md'><p>70,173</p>
</div></td>
<td headers="cohort1  [header]Study strata
[header_level]age_group and sex
[header_level]>=40 and Male" class="gt_row gt_right" style="text-align: right; border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; border-top-width: 1px; border-top-style: solid; border-top-color: #D3D3D3; border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: #D3D3D3;"><div class='gt_from_md'><p>3,241,583</p>
</div></td>
<td headers="cohort1  [header]Study strata
[header_level]age_group and sex
[header_level]<40 and Female" class="gt_row gt_right" style="text-align: right; border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; border-top-width: 1px; border-top-style: solid; border-top-color: #D3D3D3; border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: #D3D3D3;"><div class='gt_from_md'><p>6,118,453</p>
</div></td>
<td headers="cohort1  [header]Study strata
[header_level]age_group and sex
[header_level]>=40 and Female" class="gt_row gt_right" style="text-align: right; border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; border-top-width: 1px; border-top-style: solid; border-top-color: #D3D3D3; border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: #D3D3D3;"><div class='gt_from_md'><p>8,439,690</p>
</div></td>
<td headers="cohort1  [header]Study strata
[header_level]sex
[header_level]Male" class="gt_row gt_right" style="text-align: right; border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; border-top-width: 1px; border-top-style: solid; border-top-color: #D3D3D3; border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: #D3D3D3;"><div class='gt_from_md'><p>380,543</p>
</div></td>
<td headers="cohort1  [header]Study strata
[header_level]sex
[header_level]Female" class="gt_row gt_right" style="text-align: right; border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; border-top-width: 1px; border-top-style: solid; border-top-color: #D3D3D3; border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: #D3D3D3;"><div class='gt_from_md'><p>5,343,740</p>
</div></td>
<td headers="cohort1  [header]Study strata
[header_level]age_group
[header_level]<40" class="gt_row gt_right" style="text-align: right; border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; border-top-width: 1px; border-top-style: solid; border-top-color: #D3D3D3; border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: #D3D3D3;"><div class='gt_from_md'><p>9,570,279</p>
</div></td>
<td headers="cohort1  [header]Study strata
[header_level]age_group
[header_level]>=40" class="gt_row gt_right" style="text-align: right;"><div class='gt_from_md'><p>792,434</p>
</div></td></tr>
    <tr><td headers="cohort1  cdm_name" class="gt_row gt_left" style="text-align: left; border-top-width: 1px; border-top-style: hidden; border-top-color: #000000;"><div class='gt_from_md'></div></td>
<td headers="cohort1  result_type" class="gt_row gt_left" style="text-align: left; border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; border-top-width: 1px; border-top-style: hidden; border-top-color: #000000; border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: #D3D3D3;"><div class='gt_from_md'></div></td>
<td headers="cohort1  package_name" class="gt_row gt_left" style="text-align: left; border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; border-top-width: 1px; border-top-style: hidden; border-top-color: #000000; border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: #D3D3D3;"><div class='gt_from_md'></div></td>
<td headers="cohort1  package_version" class="gt_row gt_right" style="text-align: left; border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; border-top-width: 1px; border-top-style: hidden; border-top-color: #000000; border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: #D3D3D3;"><div class='gt_from_md'></div></td>
<td headers="cohort1  group_name" class="gt_row gt_left" style="text-align: left; border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; border-top-width: 1px; border-top-style: hidden; border-top-color: #000000; border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: #D3D3D3;"><div class='gt_from_md'></div></td>
<td headers="cohort1  variable_name" class="gt_row gt_left" style="text-align: left; border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; border-top-width: 1px; border-top-style: solid; border-top-color: #D3D3D3; border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: #D3D3D3;"><div class='gt_from_md'><p>age</p>
</div></td>
<td headers="cohort1  variable_level" class="gt_row gt_left" style="text-align: left; border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; border-top-width: 1px; border-top-style: solid; border-top-color: #D3D3D3; border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: #D3D3D3;">-</td>
<td headers="cohort1  estimate_name" class="gt_row gt_left" style="text-align: left; border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; border-top-width: 1px; border-top-style: solid; border-top-color: #D3D3D3; border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: #D3D3D3;"><div class='gt_from_md'><p>Mean (SD)</p>
</div></td>
<td headers="cohort1  estimate_type" class="gt_row gt_left" style="text-align: left; border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; border-top-width: 1px; border-top-style: solid; border-top-color: #D3D3D3; border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: #D3D3D3;"><div class='gt_from_md'><p>character</p>
</div></td>
<td headers="cohort1  additional_name" class="gt_row gt_left" style="text-align: left; border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; border-top-width: 1px; border-top-style: solid; border-top-color: #D3D3D3; border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: #D3D3D3;"><div class='gt_from_md'><p>overall</p>
</div></td>
<td headers="cohort1  additional_level" class="gt_row gt_left" style="text-align: left; border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; border-top-width: 1px; border-top-style: solid; border-top-color: #D3D3D3; border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: #D3D3D3;"><div class='gt_from_md'><p>overall</p>
</div></td>
<td headers="cohort1  [header]Study strata
[header_level]overall
[header_level]overall" class="gt_row gt_right" style="text-align: right; border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; border-top-width: 1px; border-top-style: solid; border-top-color: #D3D3D3; border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: #D3D3D3;"><div class='gt_from_md'><p>0.18 (7.87)</p>
</div></td>
<td headers="cohort1  [header]Study strata
[header_level]age_group and sex
[header_level]<40 and Male" class="gt_row gt_right" style="text-align: right; border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; border-top-width: 1px; border-top-style: solid; border-top-color: #D3D3D3; border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: #D3D3D3;"><div class='gt_from_md'><p>89.99 (8.86)</p>
</div></td>
<td headers="cohort1  [header]Study strata
[header_level]age_group and sex
[header_level]>=40 and Male" class="gt_row gt_right" style="text-align: right; border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; border-top-width: 1px; border-top-style: solid; border-top-color: #D3D3D3; border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: #D3D3D3;"><div class='gt_from_md'><p>28.21 (5.11)</p>
</div></td>
<td headers="cohort1  [header]Study strata
[header_level]age_group and sex
[header_level]<40 and Female" class="gt_row gt_right" style="text-align: right; border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; border-top-width: 1px; border-top-style: solid; border-top-color: #D3D3D3; border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: #D3D3D3;"><div class='gt_from_md'><p>85.56 (8.06)</p>
</div></td>
<td headers="cohort1  [header]Study strata
[header_level]age_group and sex
[header_level]>=40 and Female" class="gt_row gt_right" style="text-align: right; border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; border-top-width: 1px; border-top-style: solid; border-top-color: #D3D3D3; border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: #D3D3D3;"><div class='gt_from_md'><p>81.69 (2.78)</p>
</div></td>
<td headers="cohort1  [header]Study strata
[header_level]sex
[header_level]Male" class="gt_row gt_right" style="text-align: right; border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; border-top-width: 1px; border-top-style: solid; border-top-color: #D3D3D3; border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: #D3D3D3;"><div class='gt_from_md'><p>1.80 (0.77)</p>
</div></td>
<td headers="cohort1  [header]Study strata
[header_level]sex
[header_level]Female" class="gt_row gt_right" style="text-align: right; border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; border-top-width: 1px; border-top-style: solid; border-top-color: #D3D3D3; border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: #D3D3D3;"><div class='gt_from_md'><p>30.13 (2.01)</p>
</div></td>
<td headers="cohort1  [header]Study strata
[header_level]age_group
[header_level]<40" class="gt_row gt_right" style="text-align: right; border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; border-top-width: 1px; border-top-style: solid; border-top-color: #D3D3D3; border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: #D3D3D3;"><div class='gt_from_md'><p>4.44 (7.92)</p>
</div></td>
<td headers="cohort1  [header]Study strata
[header_level]age_group
[header_level]>=40" class="gt_row gt_right" style="text-align: right;"><div class='gt_from_md'><p>45.91 (9.67)</p>
</div></td></tr>
    <tr><td headers="cohort1  cdm_name" class="gt_row gt_left" style="text-align: left; border-top-width: 1px; border-top-style: hidden; border-top-color: #000000;"><div class='gt_from_md'></div></td>
<td headers="cohort1  result_type" class="gt_row gt_left" style="text-align: left; border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; border-top-width: 1px; border-top-style: hidden; border-top-color: #000000; border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: #D3D3D3;"><div class='gt_from_md'></div></td>
<td headers="cohort1  package_name" class="gt_row gt_left" style="text-align: left; border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; border-top-width: 1px; border-top-style: hidden; border-top-color: #000000; border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: #D3D3D3;"><div class='gt_from_md'></div></td>
<td headers="cohort1  package_version" class="gt_row gt_right" style="text-align: left; border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; border-top-width: 1px; border-top-style: hidden; border-top-color: #000000; border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: #D3D3D3;"><div class='gt_from_md'></div></td>
<td headers="cohort1  group_name" class="gt_row gt_left" style="text-align: left; border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; border-top-width: 1px; border-top-style: hidden; border-top-color: #000000; border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: #D3D3D3;"><div class='gt_from_md'></div></td>
<td headers="cohort1  variable_name" class="gt_row gt_left" style="text-align: left; border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; border-top-width: 1px; border-top-style: solid; border-top-color: #D3D3D3; border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: #D3D3D3;"><div class='gt_from_md'><p>Medications</p>
</div></td>
<td headers="cohort1  variable_level" class="gt_row gt_left" style="text-align: left; border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; border-top-width: 1px; border-top-style: solid; border-top-color: #D3D3D3; border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: #D3D3D3;"><div class='gt_from_md'><p>Amoxiciline</p>
</div></td>
<td headers="cohort1  estimate_name" class="gt_row gt_left" style="text-align: left; border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; border-top-width: 1px; border-top-style: solid; border-top-color: #D3D3D3; border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: #D3D3D3;"><div class='gt_from_md'><p>N (%)</p>
</div></td>
<td headers="cohort1  estimate_type" class="gt_row gt_left" style="text-align: left; border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; border-top-width: 1px; border-top-style: solid; border-top-color: #D3D3D3; border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: #D3D3D3;"><div class='gt_from_md'><p>character</p>
</div></td>
<td headers="cohort1  additional_name" class="gt_row gt_left" style="text-align: left; border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; border-top-width: 1px; border-top-style: solid; border-top-color: #D3D3D3; border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: #D3D3D3;"><div class='gt_from_md'><p>overall</p>
</div></td>
<td headers="cohort1  additional_level" class="gt_row gt_left" style="text-align: left; border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; border-top-width: 1px; border-top-style: solid; border-top-color: #D3D3D3; border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: #D3D3D3;"><div class='gt_from_md'><p>overall</p>
</div></td>
<td headers="cohort1  [header]Study strata
[header_level]overall
[header_level]overall" class="gt_row gt_right" style="text-align: right; border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; border-top-width: 1px; border-top-style: solid; border-top-color: #D3D3D3; border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: #D3D3D3;"><div class='gt_from_md'><p>71,561 (19.6%)</p>
</div></td>
<td headers="cohort1  [header]Study strata
[header_level]age_group and sex
[header_level]<40 and Male" class="gt_row gt_right" style="text-align: right; border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; border-top-width: 1px; border-top-style: solid; border-top-color: #D3D3D3; border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: #D3D3D3;"><div class='gt_from_md'><p>3,130 (38.8%)</p>
</div></td>
<td headers="cohort1  [header]Study strata
[header_level]age_group and sex
[header_level]>=40 and Male" class="gt_row gt_right" style="text-align: right; border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; border-top-width: 1px; border-top-style: solid; border-top-color: #D3D3D3; border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: #D3D3D3;"><div class='gt_from_md'><p>58,244 (70.6%)</p>
</div></td>
<td headers="cohort1  [header]Study strata
[header_level]age_group and sex
[header_level]<40 and Female" class="gt_row gt_right" style="text-align: right; border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; border-top-width: 1px; border-top-style: solid; border-top-color: #D3D3D3; border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: #D3D3D3;"><div class='gt_from_md'><p>35,186 (35.8%)</p>
</div></td>
<td headers="cohort1  [header]Study strata
[header_level]age_group and sex
[header_level]>=40 and Female" class="gt_row gt_right" style="text-align: right; border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; border-top-width: 1px; border-top-style: solid; border-top-color: #D3D3D3; border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: #D3D3D3;"><div class='gt_from_md'><p>32,863 (22.8%)</p>
</div></td>
<td headers="cohort1  [header]Study strata
[header_level]sex
[header_level]Male" class="gt_row gt_right" style="text-align: right; border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; border-top-width: 1px; border-top-style: solid; border-top-color: #D3D3D3; border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: #D3D3D3;"><div class='gt_from_md'><p>97,052 (73.7%)</p>
</div></td>
<td headers="cohort1  [header]Study strata
[header_level]sex
[header_level]Female" class="gt_row gt_right" style="text-align: right; border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; border-top-width: 1px; border-top-style: solid; border-top-color: #D3D3D3; border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: #D3D3D3;"><div class='gt_from_md'><p>75,470 (53.4%)</p>
</div></td>
<td headers="cohort1  [header]Study strata
[header_level]age_group
[header_level]<40" class="gt_row gt_right" style="text-align: right; border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; border-top-width: 1px; border-top-style: solid; border-top-color: #D3D3D3; border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: #D3D3D3;"><div class='gt_from_md'><p>81,915 (62.6%)</p>
</div></td>
<td headers="cohort1  [header]Study strata
[header_level]age_group
[header_level]>=40" class="gt_row gt_right" style="text-align: right;"><div class='gt_from_md'><p>28,296 (66.0%)</p>
</div></td></tr>
    <tr><td headers="cohort1  cdm_name" class="gt_row gt_left" style="text-align: left; border-top-width: 1px; border-top-style: hidden; border-top-color: #000000;"><div class='gt_from_md'></div></td>
<td headers="cohort1  result_type" class="gt_row gt_left" style="text-align: left; border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; border-top-width: 1px; border-top-style: hidden; border-top-color: #000000; border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: #D3D3D3;"><div class='gt_from_md'></div></td>
<td headers="cohort1  package_name" class="gt_row gt_left" style="text-align: left; border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; border-top-width: 1px; border-top-style: hidden; border-top-color: #000000; border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: #D3D3D3;"><div class='gt_from_md'></div></td>
<td headers="cohort1  package_version" class="gt_row gt_right" style="text-align: left; border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; border-top-width: 1px; border-top-style: hidden; border-top-color: #000000; border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: #D3D3D3;"><div class='gt_from_md'></div></td>
<td headers="cohort1  group_name" class="gt_row gt_left" style="text-align: left; border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; border-top-width: 1px; border-top-style: hidden; border-top-color: #000000; border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: #D3D3D3;"><div class='gt_from_md'></div></td>
<td headers="cohort1  variable_name" class="gt_row gt_left" style="text-align: left; border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; border-top-width: 1px; border-top-style: hidden; border-top-color: #000000; border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: #D3D3D3;"><div class='gt_from_md'></div></td>
<td headers="cohort1  variable_level" class="gt_row gt_left" style="text-align: left; border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; border-top-width: 1px; border-top-style: solid; border-top-color: #D3D3D3; border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: #D3D3D3;"><div class='gt_from_md'><p>Ibuprofen</p>
</div></td>
<td headers="cohort1  estimate_name" class="gt_row gt_left" style="text-align: left; border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; border-top-width: 1px; border-top-style: solid; border-top-color: #D3D3D3; border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: #D3D3D3;"><div class='gt_from_md'><p>N (%)</p>
</div></td>
<td headers="cohort1  estimate_type" class="gt_row gt_left" style="text-align: left; border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; border-top-width: 1px; border-top-style: solid; border-top-color: #D3D3D3; border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: #D3D3D3;"><div class='gt_from_md'><p>character</p>
</div></td>
<td headers="cohort1  additional_name" class="gt_row gt_left" style="text-align: left; border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; border-top-width: 1px; border-top-style: solid; border-top-color: #D3D3D3; border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: #D3D3D3;"><div class='gt_from_md'><p>overall</p>
</div></td>
<td headers="cohort1  additional_level" class="gt_row gt_left" style="text-align: left; border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; border-top-width: 1px; border-top-style: solid; border-top-color: #D3D3D3; border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: #D3D3D3;"><div class='gt_from_md'><p>overall</p>
</div></td>
<td headers="cohort1  [header]Study strata
[header_level]overall
[header_level]overall" class="gt_row gt_right" style="text-align: right; border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; border-top-width: 1px; border-top-style: solid; border-top-color: #D3D3D3; border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: #D3D3D3;"><div class='gt_from_md'><p>29,297 (48.8%)</p>
</div></td>
<td headers="cohort1  [header]Study strata
[header_level]age_group and sex
[header_level]<40 and Male" class="gt_row gt_right" style="text-align: right; border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; border-top-width: 1px; border-top-style: solid; border-top-color: #D3D3D3; border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: #D3D3D3;"><div class='gt_from_md'><p>71,154 (97.6%)</p>
</div></td>
<td headers="cohort1  [header]Study strata
[header_level]age_group and sex
[header_level]>=40 and Male" class="gt_row gt_right" style="text-align: right; border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; border-top-width: 1px; border-top-style: solid; border-top-color: #D3D3D3; border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: #D3D3D3;"><div class='gt_from_md'><p>99,888 (39.1%)</p>
</div></td>
<td headers="cohort1  [header]Study strata
[header_level]age_group and sex
[header_level]<40 and Female" class="gt_row gt_right" style="text-align: right; border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; border-top-width: 1px; border-top-style: solid; border-top-color: #D3D3D3; border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: #D3D3D3;"><div class='gt_from_md'><p>60,605 (69.2%)</p>
</div></td>
<td headers="cohort1  [header]Study strata
[header_level]age_group and sex
[header_level]>=40 and Female" class="gt_row gt_right" style="text-align: right; border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; border-top-width: 1px; border-top-style: solid; border-top-color: #D3D3D3; border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: #D3D3D3;"><div class='gt_from_md'><p>60,177 (37.2%)</p>
</div></td>
<td headers="cohort1  [header]Study strata
[header_level]sex
[header_level]Male" class="gt_row gt_right" style="text-align: right; border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; border-top-width: 1px; border-top-style: solid; border-top-color: #D3D3D3; border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: #D3D3D3;"><div class='gt_from_md'><p>53,792 (75.6%)</p>
</div></td>
<td headers="cohort1  [header]Study strata
[header_level]sex
[header_level]Female" class="gt_row gt_right" style="text-align: right; border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; border-top-width: 1px; border-top-style: solid; border-top-color: #D3D3D3; border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: #D3D3D3;"><div class='gt_from_md'><p>20,111 (31.4%)</p>
</div></td>
<td headers="cohort1  [header]Study strata
[header_level]age_group
[header_level]<40" class="gt_row gt_right" style="text-align: right; border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; border-top-width: 1px; border-top-style: solid; border-top-color: #D3D3D3; border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: #D3D3D3;"><div class='gt_from_md'><p>37,089 (45.3%)</p>
</div></td>
<td headers="cohort1  [header]Study strata
[header_level]age_group
[header_level]>=40" class="gt_row gt_right" style="text-align: right;"><div class='gt_from_md'><p>60,320 (8.1%)</p>
</div></td></tr>
    <tr class="gt_group_heading_row">
      <th colspan="20" class="gt_group_heading" style="background-color: #E9E9E9; font-weight: bold;" scope="colgroup" id="cohort2">cohort2</th>
    </tr>
    <tr class="gt_row_group_first"><td headers="cohort2  cdm_name" class="gt_row gt_left" style="text-align: left;"><div class='gt_from_md'><p>mock</p>
</div></td>
<td headers="cohort2  result_type" class="gt_row gt_left" style="text-align: left; border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; border-top-width: 1px; border-top-style: solid; border-top-color: #D3D3D3; border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: #D3D3D3;">-</td>
<td headers="cohort2  package_name" class="gt_row gt_left" style="text-align: left; border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; border-top-width: 1px; border-top-style: solid; border-top-color: #D3D3D3; border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: #D3D3D3;"><div class='gt_from_md'><p>visOmopResults</p>
</div></td>
<td headers="cohort2  package_version" class="gt_row gt_right" style="text-align: left; border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; border-top-width: 1px; border-top-style: solid; border-top-color: #D3D3D3; border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: #D3D3D3;"><div class='gt_from_md'><p>0.0.1</p>
</div></td>
<td headers="cohort2  group_name" class="gt_row gt_left" style="text-align: left; border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; border-top-width: 1px; border-top-style: solid; border-top-color: #D3D3D3; border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: #D3D3D3;"><div class='gt_from_md'><p>cohort_name</p>
</div></td>
<td headers="cohort2  variable_name" class="gt_row gt_left" style="text-align: left; border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; border-top-width: 1px; border-top-style: solid; border-top-color: #D3D3D3; border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: #D3D3D3;"><div class='gt_from_md'><p>number subjects</p>
</div></td>
<td headers="cohort2  variable_level" class="gt_row gt_left" style="text-align: left; border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; border-top-width: 1px; border-top-style: solid; border-top-color: #D3D3D3; border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: #D3D3D3;">-</td>
<td headers="cohort2  estimate_name" class="gt_row gt_left" style="text-align: left; border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; border-top-width: 1px; border-top-style: solid; border-top-color: #D3D3D3; border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: #D3D3D3;"><div class='gt_from_md'><p>N</p>
</div></td>
<td headers="cohort2  estimate_type" class="gt_row gt_left" style="text-align: left; border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; border-top-width: 1px; border-top-style: solid; border-top-color: #D3D3D3; border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: #D3D3D3;"><div class='gt_from_md'><p>character</p>
</div></td>
<td headers="cohort2  additional_name" class="gt_row gt_left" style="text-align: left; border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; border-top-width: 1px; border-top-style: solid; border-top-color: #D3D3D3; border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: #D3D3D3;"><div class='gt_from_md'><p>overall</p>
</div></td>
<td headers="cohort2  additional_level" class="gt_row gt_left" style="text-align: left; border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; border-top-width: 1px; border-top-style: solid; border-top-color: #D3D3D3; border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: #D3D3D3;"><div class='gt_from_md'><p>overall</p>
</div></td>
<td headers="cohort2  [header]Study strata
[header_level]overall
[header_level]overall" class="gt_row gt_right" style="text-align: right; border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; border-top-width: 1px; border-top-style: solid; border-top-color: #D3D3D3; border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: #D3D3D3;"><div class='gt_from_md'><p>5,273,457</p>
</div></td>
<td headers="cohort2  [header]Study strata
[header_level]age_group and sex
[header_level]<40 and Male" class="gt_row gt_right" style="text-align: right; border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; border-top-width: 1px; border-top-style: solid; border-top-color: #D3D3D3; border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: #D3D3D3;"><div class='gt_from_md'><p>3,071,341</p>
</div></td>
<td headers="cohort2  [header]Study strata
[header_level]age_group and sex
[header_level]>=40 and Male" class="gt_row gt_right" style="text-align: right; border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; border-top-width: 1px; border-top-style: solid; border-top-color: #D3D3D3; border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: #D3D3D3;"><div class='gt_from_md'><p>2,971,065</p>
</div></td>
<td headers="cohort2  [header]Study strata
[header_level]age_group and sex
[header_level]<40 and Female" class="gt_row gt_right" style="text-align: right; border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; border-top-width: 1px; border-top-style: solid; border-top-color: #D3D3D3; border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: #D3D3D3;"><div class='gt_from_md'><p>2,344,573</p>
</div></td>
<td headers="cohort2  [header]Study strata
[header_level]age_group and sex
[header_level]>=40 and Female" class="gt_row gt_right" style="text-align: right; border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; border-top-width: 1px; border-top-style: solid; border-top-color: #D3D3D3; border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: #D3D3D3;"><div class='gt_from_md'><p>616,372</p>
</div></td>
<td headers="cohort2  [header]Study strata
[header_level]sex
[header_level]Male" class="gt_row gt_right" style="text-align: right; border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; border-top-width: 1px; border-top-style: solid; border-top-color: #D3D3D3; border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: #D3D3D3;"><div class='gt_from_md'><p>8,250,081</p>
</div></td>
<td headers="cohort2  [header]Study strata
[header_level]sex
[header_level]Female" class="gt_row gt_right" style="text-align: right; border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; border-top-width: 1px; border-top-style: solid; border-top-color: #D3D3D3; border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: #D3D3D3;"><div class='gt_from_md'><p>9,825,862</p>
</div></td>
<td headers="cohort2  [header]Study strata
[header_level]age_group
[header_level]<40" class="gt_row gt_right" style="text-align: right; border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; border-top-width: 1px; border-top-style: solid; border-top-color: #D3D3D3; border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: #D3D3D3;"><div class='gt_from_md'><p>8,403,587</p>
</div></td>
<td headers="cohort2  [header]Study strata
[header_level]age_group
[header_level]>=40" class="gt_row gt_right" style="text-align: right;"><div class='gt_from_md'><p>6,569,903</p>
</div></td></tr>
    <tr><td headers="cohort2  cdm_name" class="gt_row gt_left" style="text-align: left; border-top-width: 1px; border-top-style: hidden; border-top-color: #000000;"><div class='gt_from_md'></div></td>
<td headers="cohort2  result_type" class="gt_row gt_left" style="text-align: left; border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; border-top-width: 1px; border-top-style: hidden; border-top-color: #000000; border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: #D3D3D3;"><div class='gt_from_md'></div></td>
<td headers="cohort2  package_name" class="gt_row gt_left" style="text-align: left; border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; border-top-width: 1px; border-top-style: hidden; border-top-color: #000000; border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: #D3D3D3;"><div class='gt_from_md'></div></td>
<td headers="cohort2  package_version" class="gt_row gt_right" style="text-align: left; border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; border-top-width: 1px; border-top-style: hidden; border-top-color: #000000; border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: #D3D3D3;"><div class='gt_from_md'></div></td>
<td headers="cohort2  group_name" class="gt_row gt_left" style="text-align: left; border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; border-top-width: 1px; border-top-style: hidden; border-top-color: #000000; border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: #D3D3D3;"><div class='gt_from_md'></div></td>
<td headers="cohort2  variable_name" class="gt_row gt_left" style="text-align: left; border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; border-top-width: 1px; border-top-style: solid; border-top-color: #D3D3D3; border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: #D3D3D3;"><div class='gt_from_md'><p>age</p>
</div></td>
<td headers="cohort2  variable_level" class="gt_row gt_left" style="text-align: left; border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; border-top-width: 1px; border-top-style: solid; border-top-color: #D3D3D3; border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: #D3D3D3;">-</td>
<td headers="cohort2  estimate_name" class="gt_row gt_left" style="text-align: left; border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; border-top-width: 1px; border-top-style: solid; border-top-color: #D3D3D3; border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: #D3D3D3;"><div class='gt_from_md'><p>Mean (SD)</p>
</div></td>
<td headers="cohort2  estimate_type" class="gt_row gt_left" style="text-align: left; border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; border-top-width: 1px; border-top-style: solid; border-top-color: #D3D3D3; border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: #D3D3D3;"><div class='gt_from_md'><p>character</p>
</div></td>
<td headers="cohort2  additional_name" class="gt_row gt_left" style="text-align: left; border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; border-top-width: 1px; border-top-style: solid; border-top-color: #D3D3D3; border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: #D3D3D3;"><div class='gt_from_md'><p>overall</p>
</div></td>
<td headers="cohort2  additional_level" class="gt_row gt_left" style="text-align: left; border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; border-top-width: 1px; border-top-style: solid; border-top-color: #D3D3D3; border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: #D3D3D3;"><div class='gt_from_md'><p>overall</p>
</div></td>
<td headers="cohort2  [header]Study strata
[header_level]overall
[header_level]overall" class="gt_row gt_right" style="text-align: right; border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; border-top-width: 1px; border-top-style: solid; border-top-color: #D3D3D3; border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: #D3D3D3;"><div class='gt_from_md'><p>77.36 (2.99)</p>
</div></td>
<td headers="cohort2  [header]Study strata
[header_level]age_group and sex
[header_level]<40 and Male" class="gt_row gt_right" style="text-align: right; border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; border-top-width: 1px; border-top-style: solid; border-top-color: #D3D3D3; border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: #D3D3D3;"><div class='gt_from_md'><p>42.88 (7.23)</p>
</div></td>
<td headers="cohort2  [header]Study strata
[header_level]age_group and sex
[header_level]>=40 and Male" class="gt_row gt_right" style="text-align: right; border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; border-top-width: 1px; border-top-style: solid; border-top-color: #D3D3D3; border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: #D3D3D3;"><div class='gt_from_md'><p>16.00 (0.24)</p>
</div></td>
<td headers="cohort2  [header]Study strata
[header_level]age_group and sex
[header_level]<40 and Female" class="gt_row gt_right" style="text-align: right; border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; border-top-width: 1px; border-top-style: solid; border-top-color: #D3D3D3; border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: #D3D3D3;"><div class='gt_from_md'><p>36.36 (6.80)</p>
</div></td>
<td headers="cohort2  [header]Study strata
[header_level]age_group and sex
[header_level]>=40 and Female" class="gt_row gt_right" style="text-align: right; border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; border-top-width: 1px; border-top-style: solid; border-top-color: #D3D3D3; border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: #D3D3D3;"><div class='gt_from_md'><p>4.22 (2.97)</p>
</div></td>
<td headers="cohort2  [header]Study strata
[header_level]sex
[header_level]Male" class="gt_row gt_right" style="text-align: right; border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; border-top-width: 1px; border-top-style: solid; border-top-color: #D3D3D3; border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: #D3D3D3;"><div class='gt_from_md'><p>24.40 (6.29)</p>
</div></td>
<td headers="cohort2  [header]Study strata
[header_level]sex
[header_level]Female" class="gt_row gt_right" style="text-align: right; border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; border-top-width: 1px; border-top-style: solid; border-top-color: #D3D3D3; border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: #D3D3D3;"><div class='gt_from_md'><p>47.57 (1.60)</p>
</div></td>
<td headers="cohort2  [header]Study strata
[header_level]age_group
[header_level]<40" class="gt_row gt_right" style="text-align: right; border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; border-top-width: 1px; border-top-style: solid; border-top-color: #D3D3D3; border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: #D3D3D3;"><div class='gt_from_md'><p>74.52 (1.40)</p>
</div></td>
<td headers="cohort2  [header]Study strata
[header_level]age_group
[header_level]>=40" class="gt_row gt_right" style="text-align: right;"><div class='gt_from_md'><p>23.33 (1.30)</p>
</div></td></tr>
    <tr><td headers="cohort2  cdm_name" class="gt_row gt_left" style="text-align: left; border-top-width: 1px; border-top-style: hidden; border-top-color: #000000;"><div class='gt_from_md'></div></td>
<td headers="cohort2  result_type" class="gt_row gt_left" style="text-align: left; border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; border-top-width: 1px; border-top-style: hidden; border-top-color: #000000; border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: #D3D3D3;"><div class='gt_from_md'></div></td>
<td headers="cohort2  package_name" class="gt_row gt_left" style="text-align: left; border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; border-top-width: 1px; border-top-style: hidden; border-top-color: #000000; border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: #D3D3D3;"><div class='gt_from_md'></div></td>
<td headers="cohort2  package_version" class="gt_row gt_right" style="text-align: left; border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; border-top-width: 1px; border-top-style: hidden; border-top-color: #000000; border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: #D3D3D3;"><div class='gt_from_md'></div></td>
<td headers="cohort2  group_name" class="gt_row gt_left" style="text-align: left; border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; border-top-width: 1px; border-top-style: hidden; border-top-color: #000000; border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: #D3D3D3;"><div class='gt_from_md'></div></td>
<td headers="cohort2  variable_name" class="gt_row gt_left" style="text-align: left; border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; border-top-width: 1px; border-top-style: solid; border-top-color: #D3D3D3; border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: #D3D3D3;"><div class='gt_from_md'><p>Medications</p>
</div></td>
<td headers="cohort2  variable_level" class="gt_row gt_left" style="text-align: left; border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; border-top-width: 1px; border-top-style: solid; border-top-color: #D3D3D3; border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: #D3D3D3;"><div class='gt_from_md'><p>Amoxiciline</p>
</div></td>
<td headers="cohort2  estimate_name" class="gt_row gt_left" style="text-align: left; border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; border-top-width: 1px; border-top-style: solid; border-top-color: #D3D3D3; border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: #D3D3D3;"><div class='gt_from_md'><p>N (%)</p>
</div></td>
<td headers="cohort2  estimate_type" class="gt_row gt_left" style="text-align: left; border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; border-top-width: 1px; border-top-style: solid; border-top-color: #D3D3D3; border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: #D3D3D3;"><div class='gt_from_md'><p>character</p>
</div></td>
<td headers="cohort2  additional_name" class="gt_row gt_left" style="text-align: left; border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; border-top-width: 1px; border-top-style: solid; border-top-color: #D3D3D3; border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: #D3D3D3;"><div class='gt_from_md'><p>overall</p>
</div></td>
<td headers="cohort2  additional_level" class="gt_row gt_left" style="text-align: left; border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; border-top-width: 1px; border-top-style: solid; border-top-color: #D3D3D3; border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: #D3D3D3;"><div class='gt_from_md'><p>overall</p>
</div></td>
<td headers="cohort2  [header]Study strata
[header_level]overall
[header_level]overall" class="gt_row gt_right" style="text-align: right; border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; border-top-width: 1px; border-top-style: solid; border-top-color: #D3D3D3; border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: #D3D3D3;"><div class='gt_from_md'><p>64,840 (61.3%)</p>
</div></td>
<td headers="cohort2  [header]Study strata
[header_level]age_group and sex
[header_level]<40 and Male" class="gt_row gt_right" style="text-align: right; border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; border-top-width: 1px; border-top-style: solid; border-top-color: #D3D3D3; border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: #D3D3D3;"><div class='gt_from_md'><p>36,431 (45.0%)</p>
</div></td>
<td headers="cohort2  [header]Study strata
[header_level]age_group and sex
[header_level]>=40 and Male" class="gt_row gt_right" style="text-align: right; border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; border-top-width: 1px; border-top-style: solid; border-top-color: #D3D3D3; border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: #D3D3D3;"><div class='gt_from_md'><p>99,110 (13.2%)</p>
</div></td>
<td headers="cohort2  [header]Study strata
[header_level]age_group and sex
[header_level]<40 and Female" class="gt_row gt_right" style="text-align: right; border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; border-top-width: 1px; border-top-style: solid; border-top-color: #D3D3D3; border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: #D3D3D3;"><div class='gt_from_md'><p>47,105 (45.3%)</p>
</div></td>
<td headers="cohort2  [header]Study strata
[header_level]age_group and sex
[header_level]>=40 and Female" class="gt_row gt_right" style="text-align: right; border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; border-top-width: 1px; border-top-style: solid; border-top-color: #D3D3D3; border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: #D3D3D3;"><div class='gt_from_md'><p>44,761 (8.9%)</p>
</div></td>
<td headers="cohort2  [header]Study strata
[header_level]sex
[header_level]Male" class="gt_row gt_right" style="text-align: right; border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; border-top-width: 1px; border-top-style: solid; border-top-color: #D3D3D3; border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: #D3D3D3;"><div class='gt_from_md'><p>39,217 (3.5%)</p>
</div></td>
<td headers="cohort2  [header]Study strata
[header_level]sex
[header_level]Female" class="gt_row gt_right" style="text-align: right; border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; border-top-width: 1px; border-top-style: solid; border-top-color: #D3D3D3; border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: #D3D3D3;"><div class='gt_from_md'><p>41,988 (4.9%)</p>
</div></td>
<td headers="cohort2  [header]Study strata
[header_level]age_group
[header_level]<40" class="gt_row gt_right" style="text-align: right; border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; border-top-width: 1px; border-top-style: solid; border-top-color: #D3D3D3; border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: #D3D3D3;"><div class='gt_from_md'><p>17,295 (93.2%)</p>
</div></td>
<td headers="cohort2  [header]Study strata
[header_level]age_group
[header_level]>=40" class="gt_row gt_right" style="text-align: right;"><div class='gt_from_md'><p>68,197 (69.3%)</p>
</div></td></tr>
    <tr><td headers="cohort2  cdm_name" class="gt_row gt_left" style="text-align: left; border-top-width: 1px; border-top-style: hidden; border-top-color: #000000;"><div class='gt_from_md'></div></td>
<td headers="cohort2  result_type" class="gt_row gt_left" style="text-align: left; border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; border-top-width: 1px; border-top-style: hidden; border-top-color: #000000; border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: #D3D3D3;"><div class='gt_from_md'></div></td>
<td headers="cohort2  package_name" class="gt_row gt_left" style="text-align: left; border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; border-top-width: 1px; border-top-style: hidden; border-top-color: #000000; border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: #D3D3D3;"><div class='gt_from_md'></div></td>
<td headers="cohort2  package_version" class="gt_row gt_right" style="text-align: left; border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; border-top-width: 1px; border-top-style: hidden; border-top-color: #000000; border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: #D3D3D3;"><div class='gt_from_md'></div></td>
<td headers="cohort2  group_name" class="gt_row gt_left" style="text-align: left; border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; border-top-width: 1px; border-top-style: hidden; border-top-color: #000000; border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: #D3D3D3;"><div class='gt_from_md'></div></td>
<td headers="cohort2  variable_name" class="gt_row gt_left" style="text-align: left; border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; border-top-width: 1px; border-top-style: hidden; border-top-color: #000000; border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: #D3D3D3;"><div class='gt_from_md'></div></td>
<td headers="cohort2  variable_level" class="gt_row gt_left" style="text-align: left; border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; border-top-width: 1px; border-top-style: solid; border-top-color: #D3D3D3; border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: #D3D3D3;"><div class='gt_from_md'><p>Ibuprofen</p>
</div></td>
<td headers="cohort2  estimate_name" class="gt_row gt_left" style="text-align: left; border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; border-top-width: 1px; border-top-style: solid; border-top-color: #D3D3D3; border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: #D3D3D3;"><div class='gt_from_md'><p>N (%)</p>
</div></td>
<td headers="cohort2  estimate_type" class="gt_row gt_left" style="text-align: left; border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; border-top-width: 1px; border-top-style: solid; border-top-color: #D3D3D3; border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: #D3D3D3;"><div class='gt_from_md'><p>character</p>
</div></td>
<td headers="cohort2  additional_name" class="gt_row gt_left" style="text-align: left; border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; border-top-width: 1px; border-top-style: solid; border-top-color: #D3D3D3; border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: #D3D3D3;"><div class='gt_from_md'><p>overall</p>
</div></td>
<td headers="cohort2  additional_level" class="gt_row gt_left" style="text-align: left; border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; border-top-width: 1px; border-top-style: solid; border-top-color: #D3D3D3; border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: #D3D3D3;"><div class='gt_from_md'><p>overall</p>
</div></td>
<td headers="cohort2  [header]Study strata
[header_level]overall
[header_level]overall" class="gt_row gt_right" style="text-align: right; border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; border-top-width: 1px; border-top-style: solid; border-top-color: #D3D3D3; border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: #D3D3D3;"><div class='gt_from_md'><p>88,736 (2.2%)</p>
</div></td>
<td headers="cohort2  [header]Study strata
[header_level]age_group and sex
[header_level]<40 and Male" class="gt_row gt_right" style="text-align: right; border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; border-top-width: 1px; border-top-style: solid; border-top-color: #D3D3D3; border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: #D3D3D3;"><div class='gt_from_md'><p>92,307 (22.9%)</p>
</div></td>
<td headers="cohort2  [header]Study strata
[header_level]age_group and sex
[header_level]>=40 and Male" class="gt_row gt_right" style="text-align: right; border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; border-top-width: 1px; border-top-style: solid; border-top-color: #D3D3D3; border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: #D3D3D3;"><div class='gt_from_md'><p>67,427 (75.1%)</p>
</div></td>
<td headers="cohort2  [header]Study strata
[header_level]age_group and sex
[header_level]<40 and Female" class="gt_row gt_right" style="text-align: right; border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; border-top-width: 1px; border-top-style: solid; border-top-color: #D3D3D3; border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: #D3D3D3;"><div class='gt_from_md'><p>17,714 (67.5%)</p>
</div></td>
<td headers="cohort2  [header]Study strata
[header_level]age_group and sex
[header_level]>=40 and Female" class="gt_row gt_right" style="text-align: right; border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; border-top-width: 1px; border-top-style: solid; border-top-color: #D3D3D3; border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: #D3D3D3;"><div class='gt_from_md'><p>41,648 (67.4%)</p>
</div></td>
<td headers="cohort2  [header]Study strata
[header_level]sex
[header_level]Male" class="gt_row gt_right" style="text-align: right; border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; border-top-width: 1px; border-top-style: solid; border-top-color: #D3D3D3; border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: #D3D3D3;"><div class='gt_from_md'><p>58,969 (11.8%)</p>
</div></td>
<td headers="cohort2  [header]Study strata
[header_level]sex
[header_level]Female" class="gt_row gt_right" style="text-align: right; border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; border-top-width: 1px; border-top-style: solid; border-top-color: #D3D3D3; border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: #D3D3D3;"><div class='gt_from_md'><p>79,365 (59.4%)</p>
</div></td>
<td headers="cohort2  [header]Study strata
[header_level]age_group
[header_level]<40" class="gt_row gt_right" style="text-align: right; border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; border-top-width: 1px; border-top-style: solid; border-top-color: #D3D3D3; border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: #D3D3D3;"><div class='gt_from_md'><p>10,225 (87.6%)</p>
</div></td>
<td headers="cohort2  [header]Study strata
[header_level]age_group
[header_level]>=40" class="gt_row gt_right" style="text-align: right;"><div class='gt_from_md'><p>49,073 (97.2%)</p>
</div></td></tr>
  </tbody>
  &#10;  
</table>
</div>
