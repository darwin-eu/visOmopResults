
<!-- README.md is generated from README.Rmd. Please edit that file -->

# visOmopResults <img src="man/figures/logo.png" align="right" height="200"/>

<!-- badges: start -->

[![R-CMD-check](https://github.com/oxford-pharmacoepi/visOmopResults/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/oxford-pharmacoepi/visOmopResults/actions/workflows/R-CMD-check.yaml)
[![CRAN
status](https://www.r-pkg.org/badges/version/visOmopResults)](https://CRAN.R-project.org/package=visOmopResults)
[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
[![Codecov test
coverage](https://codecov.io/gh/oxford-pharmacoepi/visOmopResults/branch/main/graph/badge.svg)](https://app.codecov.io/gh/oxford-pharmacoepi/visOmopResults?branch=main)
<!-- badges: end -->

## Package overview

visOmopResults contains functions for formatting objects of the class
*summarised_result* (see R package
[omopgenerics](https://cran.r-project.org/package=omopgenerics)). This
package simplifies the handling of these objects to obtain nice output
tables in the format of *gt* or *flextable*’ to report results via Shiny
apps, RMarkdown, Quarto, and more.

## Installation

You can install the latest version of visOmopResults from CRAN:

``` r
install.packages("visOmopResults")
```

Or you can install the development version from
[GitHub](https://github.com/oxford-pharmacoepi/visOmopResults) with:

``` r
# install.packages("devtools")
devtools::install_github("oxford-pharmacoepi/visOmopResults")
```

## Example usage

First, we load the package and create a summarised result object with
mock results

``` r
library(visOmopResults)
result <- mockSummarisedResult()
```

We can use the function `formatTable()` to get a nice *gt* table:

``` r
formatTable(
  result,
  formatEstimateName = c("N%" = "<count> (<percentage>)",
                         "N" = "<count>",
                         "Mean (SD)" = "<mean> (<sd>)"),
  header = c("Stratifications", "strata"),
  split = c("group","additional")
)
```

<div id="jipyxdnolg" style="padding-left:0px;padding-right:0px;padding-top:10px;padding-bottom:10px;overflow-x:auto;overflow-y:auto;width:auto;height:auto;">
<style>#jipyxdnolg table {
  font-family: system-ui, 'Segoe UI', Roboto, Helvetica, Arial, sans-serif, 'Apple Color Emoji', 'Segoe UI Emoji', 'Segoe UI Symbol', 'Noto Color Emoji';
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
}
&#10;#jipyxdnolg thead, #jipyxdnolg tbody, #jipyxdnolg tfoot, #jipyxdnolg tr, #jipyxdnolg td, #jipyxdnolg th {
  border-style: none;
}
&#10;#jipyxdnolg p {
  margin: 0;
  padding: 0;
}
&#10;#jipyxdnolg .gt_table {
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
&#10;#jipyxdnolg .gt_caption {
  padding-top: 4px;
  padding-bottom: 4px;
}
&#10;#jipyxdnolg .gt_title {
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
&#10;#jipyxdnolg .gt_subtitle {
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
&#10;#jipyxdnolg .gt_heading {
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
&#10;#jipyxdnolg .gt_bottom_border {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}
&#10;#jipyxdnolg .gt_col_headings {
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
&#10;#jipyxdnolg .gt_col_heading {
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
&#10;#jipyxdnolg .gt_column_spanner_outer {
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
&#10;#jipyxdnolg .gt_column_spanner_outer:first-child {
  padding-left: 0;
}
&#10;#jipyxdnolg .gt_column_spanner_outer:last-child {
  padding-right: 0;
}
&#10;#jipyxdnolg .gt_column_spanner {
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
&#10;#jipyxdnolg .gt_spanner_row {
  border-bottom-style: hidden;
}
&#10;#jipyxdnolg .gt_group_heading {
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
&#10;#jipyxdnolg .gt_empty_group_heading {
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
&#10;#jipyxdnolg .gt_from_md > :first-child {
  margin-top: 0;
}
&#10;#jipyxdnolg .gt_from_md > :last-child {
  margin-bottom: 0;
}
&#10;#jipyxdnolg .gt_row {
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
&#10;#jipyxdnolg .gt_stub {
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
&#10;#jipyxdnolg .gt_stub_row_group {
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
&#10;#jipyxdnolg .gt_row_group_first td {
  border-top-width: 2px;
}
&#10;#jipyxdnolg .gt_row_group_first th {
  border-top-width: 2px;
}
&#10;#jipyxdnolg .gt_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}
&#10;#jipyxdnolg .gt_first_summary_row {
  border-top-style: solid;
  border-top-color: #D3D3D3;
}
&#10;#jipyxdnolg .gt_first_summary_row.thick {
  border-top-width: 2px;
}
&#10;#jipyxdnolg .gt_last_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}
&#10;#jipyxdnolg .gt_grand_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}
&#10;#jipyxdnolg .gt_first_grand_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-style: double;
  border-top-width: 6px;
  border-top-color: #D3D3D3;
}
&#10;#jipyxdnolg .gt_last_grand_summary_row_top {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-style: double;
  border-bottom-width: 6px;
  border-bottom-color: #D3D3D3;
}
&#10;#jipyxdnolg .gt_striped {
  background-color: rgba(128, 128, 128, 0.05);
}
&#10;#jipyxdnolg .gt_table_body {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}
&#10;#jipyxdnolg .gt_footnotes {
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
&#10;#jipyxdnolg .gt_footnote {
  margin: 0px;
  font-size: 90%;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
}
&#10;#jipyxdnolg .gt_sourcenotes {
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
&#10;#jipyxdnolg .gt_sourcenote {
  font-size: 90%;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
}
&#10;#jipyxdnolg .gt_left {
  text-align: left;
}
&#10;#jipyxdnolg .gt_center {
  text-align: center;
}
&#10;#jipyxdnolg .gt_right {
  text-align: right;
  font-variant-numeric: tabular-nums;
}
&#10;#jipyxdnolg .gt_font_normal {
  font-weight: normal;
}
&#10;#jipyxdnolg .gt_font_bold {
  font-weight: bold;
}
&#10;#jipyxdnolg .gt_font_italic {
  font-style: italic;
}
&#10;#jipyxdnolg .gt_super {
  font-size: 65%;
}
&#10;#jipyxdnolg .gt_footnote_marks {
  font-size: 75%;
  vertical-align: 0.4em;
  position: initial;
}
&#10;#jipyxdnolg .gt_asterisk {
  font-size: 100%;
  vertical-align: 0;
}
&#10;#jipyxdnolg .gt_indent_1 {
  text-indent: 5px;
}
&#10;#jipyxdnolg .gt_indent_2 {
  text-indent: 10px;
}
&#10;#jipyxdnolg .gt_indent_3 {
  text-indent: 15px;
}
&#10;#jipyxdnolg .gt_indent_4 {
  text-indent: 20px;
}
&#10;#jipyxdnolg .gt_indent_5 {
  text-indent: 25px;
}
</style>
<table class="gt_table" data-quarto-disable-processing="false" data-quarto-bootstrap="false">
  <thead>
    <tr class="gt_col_headings gt_spanner_row">
      <th class="gt_center gt_columns_top_border gt_column_spanner_outer" rowspan="1" colspan="5" style="background-color: #C8C8C8; text-align: center; font-weight: bold;" scope="colgroup" id></th>
      <th class="gt_center gt_columns_top_border gt_column_spanner_outer" rowspan="1" colspan="9" style="background-color: #C8C8C8; text-align: center; font-weight: bold;" scope="colgroup" id="Stratifications">
        <span class="gt_column_spanner">Stratifications</span>
      </th>
    </tr>
    <tr class="gt_col_headings gt_spanner_row">
      <th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="2" colspan="1" style="text-align: center; font-weight: bold;" scope="col" id="CDM name">CDM name</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="2" colspan="1" style="text-align: center; font-weight: bold;" scope="col" id="Cohort name">Cohort name</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="2" colspan="1" style="text-align: center; font-weight: bold;" scope="col" id="Variable name">Variable name</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="2" colspan="1" style="text-align: center; font-weight: bold;" scope="col" id="Variable level">Variable level</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="2" colspan="1" style="text-align: center; font-weight: bold;" scope="col" id="Estimate name">Estimate name</th>
      <th class="gt_center gt_columns_top_border gt_column_spanner_outer" rowspan="1" colspan="1" style="background-color: #E1E1E1; text-align: center; font-weight: bold;" scope="col" id="Overall">
        <span class="gt_column_spanner">Overall</span>
      </th>
      <th class="gt_center gt_columns_top_border gt_column_spanner_outer" rowspan="1" colspan="4" style="background-color: #E1E1E1; text-align: center; font-weight: bold;" scope="colgroup" id="Age group and sex">
        <span class="gt_column_spanner">Age group and sex</span>
      </th>
      <th class="gt_center gt_columns_top_border gt_column_spanner_outer" rowspan="1" colspan="2" style="background-color: #E1E1E1; text-align: center; font-weight: bold;" scope="colgroup" id="Sex">
        <span class="gt_column_spanner">Sex</span>
      </th>
      <th class="gt_center gt_columns_top_border gt_column_spanner_outer" rowspan="1" colspan="2" style="background-color: #E1E1E1; text-align: center; font-weight: bold;" scope="colgroup" id="Age group">
        <span class="gt_column_spanner">Age group</span>
      </th>
    </tr>
    <tr class="gt_col_headings">
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" style="background-color: #E1E1E1; text-align: center; font-weight: bold;" scope="col" id="Overall">Overall</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" style="background-color: #E1E1E1; text-align: center; font-weight: bold;" scope="col" id="&amp;lt;40 and male">&lt;40 and male</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" style="background-color: #E1E1E1; text-align: center; font-weight: bold;" scope="col" id="&amp;gt;=40 and male">&gt;=40 and male</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" style="background-color: #E1E1E1; text-align: center; font-weight: bold;" scope="col" id="&amp;lt;40 and female">&lt;40 and female</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" style="background-color: #E1E1E1; text-align: center; font-weight: bold;" scope="col" id="&amp;gt;=40 and female">&gt;=40 and female</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" style="background-color: #E1E1E1; text-align: center; font-weight: bold;" scope="col" id="Male">Male</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" style="background-color: #E1E1E1; text-align: center; font-weight: bold;" scope="col" id="Female">Female</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" style="background-color: #E1E1E1; text-align: center; font-weight: bold;" scope="col" id="&amp;lt;40">&lt;40</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" style="background-color: #E1E1E1; text-align: center; font-weight: bold;" scope="col" id="&amp;gt;=40">&gt;=40</th>
    </tr>
  </thead>
  <tbody class="gt_table_body">
    <tr><td headers="CDM name" class="gt_row gt_left" style="text-align: left;">mock</td>
<td headers="Cohort name" class="gt_row gt_left" style="text-align: left; border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; border-top-width: 1px; border-top-style: solid; border-top-color: #D3D3D3; border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: #D3D3D3;">Cohort1</td>
<td headers="Variable name" class="gt_row gt_left" style="text-align: left; border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; border-top-width: 1px; border-top-style: solid; border-top-color: #D3D3D3; border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: #D3D3D3;">Number subjects</td>
<td headers="Variable level" class="gt_row gt_left" style="text-align: left; border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; border-top-width: 1px; border-top-style: solid; border-top-color: #D3D3D3; border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: #D3D3D3;">-</td>
<td headers="Estimate name" class="gt_row gt_left" style="text-align: left; border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; border-top-width: 1px; border-top-style: solid; border-top-color: #D3D3D3; border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: #D3D3D3;">N</td>
<td headers="[header]Stratifications
[header_level]Overall
[header_level]Overall" class="gt_row gt_right" style="text-align: right; border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; border-top-width: 1px; border-top-style: solid; border-top-color: #D3D3D3; border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: #D3D3D3;">5,862,563</td>
<td headers="[header]Stratifications
[header_level]Age group and sex
[header_level]<40 and male" class="gt_row gt_right" style="text-align: right; border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; border-top-width: 1px; border-top-style: solid; border-top-color: #D3D3D3; border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: #D3D3D3;">4,005,128</td>
<td headers="[header]Stratifications
[header_level]Age group and sex
[header_level]>=40 and male" class="gt_row gt_right" style="text-align: right; border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; border-top-width: 1px; border-top-style: solid; border-top-color: #D3D3D3; border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: #D3D3D3;">4,577,810</td>
<td headers="[header]Stratifications
[header_level]Age group and sex
[header_level]<40 and female" class="gt_row gt_right" style="text-align: right; border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; border-top-width: 1px; border-top-style: solid; border-top-color: #D3D3D3; border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: #D3D3D3;">1,243,292</td>
<td headers="[header]Stratifications
[header_level]Age group and sex
[header_level]>=40 and female" class="gt_row gt_right" style="text-align: right; border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; border-top-width: 1px; border-top-style: solid; border-top-color: #D3D3D3; border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: #D3D3D3;">3,474,582</td>
<td headers="[header]Stratifications
[header_level]Sex
[header_level]Male" class="gt_row gt_right" style="text-align: right; border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; border-top-width: 1px; border-top-style: solid; border-top-color: #D3D3D3; border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: #D3D3D3;">6,339,067</td>
<td headers="[header]Stratifications
[header_level]Sex
[header_level]Female" class="gt_row gt_right" style="text-align: right; border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; border-top-width: 1px; border-top-style: solid; border-top-color: #D3D3D3; border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: #D3D3D3;">3,622,743</td>
<td headers="[header]Stratifications
[header_level]Age group
[header_level]<40" class="gt_row gt_right" style="text-align: right; border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; border-top-width: 1px; border-top-style: solid; border-top-color: #D3D3D3; border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: #D3D3D3;">4,269,925</td>
<td headers="[header]Stratifications
[header_level]Age group
[header_level]>=40" class="gt_row gt_right" style="text-align: right;">4,488,269</td></tr>
    <tr><td headers="CDM name" class="gt_row gt_left" style="text-align: left; border-top-width: 1px; border-top-style: hidden; border-top-color: #000000;"></td>
<td headers="Cohort name" class="gt_row gt_left" style="text-align: left; border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; border-top-width: 1px; border-top-style: solid; border-top-color: #D3D3D3; border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: #D3D3D3;">Cohort2</td>
<td headers="Variable name" class="gt_row gt_left" style="text-align: left; border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; border-top-width: 1px; border-top-style: solid; border-top-color: #D3D3D3; border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: #D3D3D3;">Number subjects</td>
<td headers="Variable level" class="gt_row gt_left" style="text-align: left; border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; border-top-width: 1px; border-top-style: solid; border-top-color: #D3D3D3; border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: #D3D3D3;">-</td>
<td headers="Estimate name" class="gt_row gt_left" style="text-align: left; border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; border-top-width: 1px; border-top-style: solid; border-top-color: #D3D3D3; border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: #D3D3D3;">N</td>
<td headers="[header]Stratifications
[header_level]Overall
[header_level]Overall" class="gt_row gt_right" style="text-align: right; border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; border-top-width: 1px; border-top-style: solid; border-top-color: #D3D3D3; border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: #D3D3D3;">7,338,253</td>
<td headers="[header]Stratifications
[header_level]Age group and sex
[header_level]<40 and male" class="gt_row gt_right" style="text-align: right; border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; border-top-width: 1px; border-top-style: solid; border-top-color: #D3D3D3; border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: #D3D3D3;">3,239,250</td>
<td headers="[header]Stratifications
[header_level]Age group and sex
[header_level]>=40 and male" class="gt_row gt_right" style="text-align: right; border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; border-top-width: 1px; border-top-style: solid; border-top-color: #D3D3D3; border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: #D3D3D3;">3,785,678</td>
<td headers="[header]Stratifications
[header_level]Age group and sex
[header_level]<40 and female" class="gt_row gt_right" style="text-align: right; border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; border-top-width: 1px; border-top-style: solid; border-top-color: #D3D3D3; border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: #D3D3D3;">7,566,771</td>
<td headers="[header]Stratifications
[header_level]Age group and sex
[header_level]>=40 and female" class="gt_row gt_right" style="text-align: right; border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; border-top-width: 1px; border-top-style: solid; border-top-color: #D3D3D3; border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: #D3D3D3;">2,648,722</td>
<td headers="[header]Stratifications
[header_level]Sex
[header_level]Male" class="gt_row gt_right" style="text-align: right; border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; border-top-width: 1px; border-top-style: solid; border-top-color: #D3D3D3; border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: #D3D3D3;">3,926,397</td>
<td headers="[header]Stratifications
[header_level]Sex
[header_level]Female" class="gt_row gt_right" style="text-align: right; border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; border-top-width: 1px; border-top-style: solid; border-top-color: #D3D3D3; border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: #D3D3D3;">7,084,225</td>
<td headers="[header]Stratifications
[header_level]Age group
[header_level]<40" class="gt_row gt_right" style="text-align: right; border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; border-top-width: 1px; border-top-style: solid; border-top-color: #D3D3D3; border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: #D3D3D3;">2,675,841</td>
<td headers="[header]Stratifications
[header_level]Age group
[header_level]>=40" class="gt_row gt_right" style="text-align: right;">397,919</td></tr>
    <tr><td headers="CDM name" class="gt_row gt_left" style="text-align: left; border-top-width: 1px; border-top-style: hidden; border-top-color: #000000;"></td>
<td headers="Cohort name" class="gt_row gt_left" style="text-align: left; border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; border-top-width: 1px; border-top-style: solid; border-top-color: #D3D3D3; border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: #D3D3D3;">Cohort1</td>
<td headers="Variable name" class="gt_row gt_left" style="text-align: left; border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; border-top-width: 1px; border-top-style: solid; border-top-color: #D3D3D3; border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: #D3D3D3;">Age</td>
<td headers="Variable level" class="gt_row gt_left" style="text-align: left; border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; border-top-width: 1px; border-top-style: solid; border-top-color: #D3D3D3; border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: #D3D3D3;">-</td>
<td headers="Estimate name" class="gt_row gt_left" style="text-align: left; border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; border-top-width: 1px; border-top-style: solid; border-top-color: #D3D3D3; border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: #D3D3D3;">Mean (SD)</td>
<td headers="[header]Stratifications
[header_level]Overall
[header_level]Overall" class="gt_row gt_right" style="text-align: right; border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; border-top-width: 1px; border-top-style: solid; border-top-color: #D3D3D3; border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: #D3D3D3;">64.32 (2.59)</td>
<td headers="[header]Stratifications
[header_level]Age group and sex
[header_level]<40 and male" class="gt_row gt_right" style="text-align: right; border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; border-top-width: 1px; border-top-style: solid; border-top-color: #D3D3D3; border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: #D3D3D3;">28.61 (0.62)</td>
<td headers="[header]Stratifications
[header_level]Age group and sex
[header_level]>=40 and male" class="gt_row gt_right" style="text-align: right; border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; border-top-width: 1px; border-top-style: solid; border-top-color: #D3D3D3; border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: #D3D3D3;">9.79 (0.31)</td>
<td headers="[header]Stratifications
[header_level]Age group and sex
[header_level]<40 and female" class="gt_row gt_right" style="text-align: right; border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; border-top-width: 1px; border-top-style: solid; border-top-color: #D3D3D3; border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: #D3D3D3;">61.46 (0.86)</td>
<td headers="[header]Stratifications
[header_level]Age group and sex
[header_level]>=40 and female" class="gt_row gt_right" style="text-align: right; border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; border-top-width: 1px; border-top-style: solid; border-top-color: #D3D3D3; border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: #D3D3D3;">67.65 (2.72)</td>
<td headers="[header]Stratifications
[header_level]Sex
[header_level]Male" class="gt_row gt_right" style="text-align: right; border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; border-top-width: 1px; border-top-style: solid; border-top-color: #D3D3D3; border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: #D3D3D3;">0.04 (4.99)</td>
<td headers="[header]Stratifications
[header_level]Sex
[header_level]Female" class="gt_row gt_right" style="text-align: right; border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; border-top-width: 1px; border-top-style: solid; border-top-color: #D3D3D3; border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: #D3D3D3;">36.28 (5.74)</td>
<td headers="[header]Stratifications
[header_level]Age group
[header_level]<40" class="gt_row gt_right" style="text-align: right; border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; border-top-width: 1px; border-top-style: solid; border-top-color: #D3D3D3; border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: #D3D3D3;">30.98 (9.29)</td>
<td headers="[header]Stratifications
[header_level]Age group
[header_level]>=40" class="gt_row gt_right" style="text-align: right;">86.60 (8.84)</td></tr>
    <tr><td headers="CDM name" class="gt_row gt_left" style="text-align: left; border-top-width: 1px; border-top-style: hidden; border-top-color: #000000;"></td>
<td headers="Cohort name" class="gt_row gt_left" style="text-align: left; border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; border-top-width: 1px; border-top-style: solid; border-top-color: #D3D3D3; border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: #D3D3D3;">Cohort2</td>
<td headers="Variable name" class="gt_row gt_left" style="text-align: left; border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; border-top-width: 1px; border-top-style: solid; border-top-color: #D3D3D3; border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: #D3D3D3;">Age</td>
<td headers="Variable level" class="gt_row gt_left" style="text-align: left; border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; border-top-width: 1px; border-top-style: solid; border-top-color: #D3D3D3; border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: #D3D3D3;">-</td>
<td headers="Estimate name" class="gt_row gt_left" style="text-align: left; border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; border-top-width: 1px; border-top-style: solid; border-top-color: #D3D3D3; border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: #D3D3D3;">Mean (SD)</td>
<td headers="[header]Stratifications
[header_level]Overall
[header_level]Overall" class="gt_row gt_right" style="text-align: right; border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; border-top-width: 1px; border-top-style: solid; border-top-color: #D3D3D3; border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: #D3D3D3;">59.03 (3.10)</td>
<td headers="[header]Stratifications
[header_level]Age group and sex
[header_level]<40 and male" class="gt_row gt_right" style="text-align: right; border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; border-top-width: 1px; border-top-style: solid; border-top-color: #D3D3D3; border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: #D3D3D3;">88.39 (1.74)</td>
<td headers="[header]Stratifications
[header_level]Age group and sex
[header_level]>=40 and male" class="gt_row gt_right" style="text-align: right; border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; border-top-width: 1px; border-top-style: solid; border-top-color: #D3D3D3; border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: #D3D3D3;">68.65 (4.18)</td>
<td headers="[header]Stratifications
[header_level]Age group and sex
[header_level]<40 and female" class="gt_row gt_right" style="text-align: right; border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; border-top-width: 1px; border-top-style: solid; border-top-color: #D3D3D3; border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: #D3D3D3;">75.00 (4.37)</td>
<td headers="[header]Stratifications
[header_level]Age group and sex
[header_level]>=40 and female" class="gt_row gt_right" style="text-align: right; border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; border-top-width: 1px; border-top-style: solid; border-top-color: #D3D3D3; border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: #D3D3D3;">30.17 (7.24)</td>
<td headers="[header]Stratifications
[header_level]Sex
[header_level]Male" class="gt_row gt_right" style="text-align: right; border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; border-top-width: 1px; border-top-style: solid; border-top-color: #D3D3D3; border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: #D3D3D3;">38.60 (5.54)</td>
<td headers="[header]Stratifications
[header_level]Sex
[header_level]Female" class="gt_row gt_right" style="text-align: right; border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; border-top-width: 1px; border-top-style: solid; border-top-color: #D3D3D3; border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: #D3D3D3;">19.86 (2.11)</td>
<td headers="[header]Stratifications
[header_level]Age group
[header_level]<40" class="gt_row gt_right" style="text-align: right; border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; border-top-width: 1px; border-top-style: solid; border-top-color: #D3D3D3; border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: #D3D3D3;">99.64 (3.16)</td>
<td headers="[header]Stratifications
[header_level]Age group
[header_level]>=40" class="gt_row gt_right" style="text-align: right;">42.82 (3.62)</td></tr>
    <tr><td headers="CDM name" class="gt_row gt_left" style="text-align: left; border-top-width: 1px; border-top-style: hidden; border-top-color: #000000;"></td>
<td headers="Cohort name" class="gt_row gt_left" style="text-align: left; border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; border-top-width: 1px; border-top-style: solid; border-top-color: #D3D3D3; border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: #D3D3D3;">Cohort1</td>
<td headers="Variable name" class="gt_row gt_left" style="text-align: left; border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; border-top-width: 1px; border-top-style: solid; border-top-color: #D3D3D3; border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: #D3D3D3;">Medications</td>
<td headers="Variable level" class="gt_row gt_left" style="text-align: left; border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; border-top-width: 1px; border-top-style: solid; border-top-color: #D3D3D3; border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: #D3D3D3;">Amoxiciline</td>
<td headers="Estimate name" class="gt_row gt_left" style="text-align: left; border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; border-top-width: 1px; border-top-style: solid; border-top-color: #D3D3D3; border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: #D3D3D3;">N%</td>
<td headers="[header]Stratifications
[header_level]Overall
[header_level]Overall" class="gt_row gt_right" style="text-align: right; border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; border-top-width: 1px; border-top-style: solid; border-top-color: #D3D3D3; border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: #D3D3D3;">44,441 (79.56)</td>
<td headers="[header]Stratifications
[header_level]Age group and sex
[header_level]<40 and male" class="gt_row gt_right" style="text-align: right; border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; border-top-width: 1px; border-top-style: solid; border-top-color: #D3D3D3; border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: #D3D3D3;">13,047 (51.79)</td>
<td headers="[header]Stratifications
[header_level]Age group and sex
[header_level]>=40 and male" class="gt_row gt_right" style="text-align: right; border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; border-top-width: 1px; border-top-style: solid; border-top-color: #D3D3D3; border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: #D3D3D3;">37,180 (3.02)</td>
<td headers="[header]Stratifications
[header_level]Age group and sex
[header_level]<40 and female" class="gt_row gt_right" style="text-align: right; border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; border-top-width: 1px; border-top-style: solid; border-top-color: #D3D3D3; border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: #D3D3D3;">23,730 (90.69)</td>
<td headers="[header]Stratifications
[header_level]Age group and sex
[header_level]>=40 and female" class="gt_row gt_right" style="text-align: right; border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; border-top-width: 1px; border-top-style: solid; border-top-color: #D3D3D3; border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: #D3D3D3;">32,053 (30.22)</td>
<td headers="[header]Stratifications
[header_level]Sex
[header_level]Male" class="gt_row gt_right" style="text-align: right; border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; border-top-width: 1px; border-top-style: solid; border-top-color: #D3D3D3; border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: #D3D3D3;">87,025 (23.16)</td>
<td headers="[header]Stratifications
[header_level]Sex
[header_level]Female" class="gt_row gt_right" style="text-align: right; border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; border-top-width: 1px; border-top-style: solid; border-top-color: #D3D3D3; border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: #D3D3D3;">32,720 (63.64)</td>
<td headers="[header]Stratifications
[header_level]Age group
[header_level]<40" class="gt_row gt_right" style="text-align: right; border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; border-top-width: 1px; border-top-style: solid; border-top-color: #D3D3D3; border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: #D3D3D3;">32,043 (31.00)</td>
<td headers="[header]Stratifications
[header_level]Age group
[header_level]>=40" class="gt_row gt_right" style="text-align: right;">96,411 (82.58)</td></tr>
    <tr><td headers="CDM name" class="gt_row gt_left" style="text-align: left; border-top-width: 1px; border-top-style: hidden; border-top-color: #000000;"></td>
<td headers="Cohort name" class="gt_row gt_left" style="text-align: left; border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; border-top-width: 1px; border-top-style: solid; border-top-color: #D3D3D3; border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: #D3D3D3;">Cohort2</td>
<td headers="Variable name" class="gt_row gt_left" style="text-align: left; border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; border-top-width: 1px; border-top-style: solid; border-top-color: #D3D3D3; border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: #D3D3D3;">Medications</td>
<td headers="Variable level" class="gt_row gt_left" style="text-align: left; border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; border-top-width: 1px; border-top-style: solid; border-top-color: #D3D3D3; border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: #D3D3D3;">Amoxiciline</td>
<td headers="Estimate name" class="gt_row gt_left" style="text-align: left; border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; border-top-width: 1px; border-top-style: solid; border-top-color: #D3D3D3; border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: #D3D3D3;">N%</td>
<td headers="[header]Stratifications
[header_level]Overall
[header_level]Overall" class="gt_row gt_right" style="text-align: right; border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; border-top-width: 1px; border-top-style: solid; border-top-color: #D3D3D3; border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: #D3D3D3;">44,086 (61.73)</td>
<td headers="[header]Stratifications
[header_level]Age group and sex
[header_level]<40 and male" class="gt_row gt_right" style="text-align: right; border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; border-top-width: 1px; border-top-style: solid; border-top-color: #D3D3D3; border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: #D3D3D3;">37,138 (73.02)</td>
<td headers="[header]Stratifications
[header_level]Age group and sex
[header_level]>=40 and male" class="gt_row gt_right" style="text-align: right; border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; border-top-width: 1px; border-top-style: solid; border-top-color: #D3D3D3; border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: #D3D3D3;">39,951 (61.81)</td>
<td headers="[header]Stratifications
[header_level]Age group and sex
[header_level]<40 and female" class="gt_row gt_right" style="text-align: right; border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; border-top-width: 1px; border-top-style: solid; border-top-color: #D3D3D3; border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: #D3D3D3;">92,416 (64.94)</td>
<td headers="[header]Stratifications
[header_level]Age group and sex
[header_level]>=40 and female" class="gt_row gt_right" style="text-align: right; border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; border-top-width: 1px; border-top-style: solid; border-top-color: #D3D3D3; border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: #D3D3D3;">40,126 (34.93)</td>
<td headers="[header]Stratifications
[header_level]Sex
[header_level]Male" class="gt_row gt_right" style="text-align: right; border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; border-top-width: 1px; border-top-style: solid; border-top-color: #D3D3D3; border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: #D3D3D3;">85,213 (43.14)</td>
<td headers="[header]Stratifications
[header_level]Sex
[header_level]Female" class="gt_row gt_right" style="text-align: right; border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; border-top-width: 1px; border-top-style: solid; border-top-color: #D3D3D3; border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: #D3D3D3;">84,867 (2.40)</td>
<td headers="[header]Stratifications
[header_level]Age group
[header_level]<40" class="gt_row gt_right" style="text-align: right; border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; border-top-width: 1px; border-top-style: solid; border-top-color: #D3D3D3; border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: #D3D3D3;">64,939 (11.74)</td>
<td headers="[header]Stratifications
[header_level]Age group
[header_level]>=40" class="gt_row gt_right" style="text-align: right;">25,175 (35.97)</td></tr>
    <tr><td headers="CDM name" class="gt_row gt_left" style="text-align: left; border-top-width: 1px; border-top-style: hidden; border-top-color: #000000;"></td>
<td headers="Cohort name" class="gt_row gt_left" style="text-align: left; border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; border-top-width: 1px; border-top-style: solid; border-top-color: #D3D3D3; border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: #D3D3D3;">Cohort1</td>
<td headers="Variable name" class="gt_row gt_left" style="text-align: left; border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; border-top-width: 1px; border-top-style: solid; border-top-color: #D3D3D3; border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: #D3D3D3;">Medications</td>
<td headers="Variable level" class="gt_row gt_left" style="text-align: left; border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; border-top-width: 1px; border-top-style: solid; border-top-color: #D3D3D3; border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: #D3D3D3;">Ibuprofen</td>
<td headers="Estimate name" class="gt_row gt_left" style="text-align: left; border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; border-top-width: 1px; border-top-style: solid; border-top-color: #D3D3D3; border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: #D3D3D3;">N%</td>
<td headers="[header]Stratifications
[header_level]Overall
[header_level]Overall" class="gt_row gt_right" style="text-align: right; border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; border-top-width: 1px; border-top-style: solid; border-top-color: #D3D3D3; border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: #D3D3D3;">31,337 (81.28)</td>
<td headers="[header]Stratifications
[header_level]Age group and sex
[header_level]<40 and male" class="gt_row gt_right" style="text-align: right; border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; border-top-width: 1px; border-top-style: solid; border-top-color: #D3D3D3; border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: #D3D3D3;">52,944 (86.94)</td>
<td headers="[header]Stratifications
[header_level]Age group and sex
[header_level]>=40 and male" class="gt_row gt_right" style="text-align: right; border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; border-top-width: 1px; border-top-style: solid; border-top-color: #D3D3D3; border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: #D3D3D3;">80,692 (55.26)</td>
<td headers="[header]Stratifications
[header_level]Age group and sex
[header_level]<40 and female" class="gt_row gt_right" style="text-align: right; border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; border-top-width: 1px; border-top-style: solid; border-top-color: #D3D3D3; border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: #D3D3D3;">46,728 (43.84)</td>
<td headers="[header]Stratifications
[header_level]Age group and sex
[header_level]>=40 and female" class="gt_row gt_right" style="text-align: right; border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; border-top-width: 1px; border-top-style: solid; border-top-color: #D3D3D3; border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: #D3D3D3;">88,214 (37.83)</td>
<td headers="[header]Stratifications
[header_level]Sex
[header_level]Male" class="gt_row gt_right" style="text-align: right; border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; border-top-width: 1px; border-top-style: solid; border-top-color: #D3D3D3; border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: #D3D3D3;">7,832 (76.13)</td>
<td headers="[header]Stratifications
[header_level]Sex
[header_level]Female" class="gt_row gt_right" style="text-align: right; border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; border-top-width: 1px; border-top-style: solid; border-top-color: #D3D3D3; border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: #D3D3D3;">75,871 (99.44)</td>
<td headers="[header]Stratifications
[header_level]Age group
[header_level]<40" class="gt_row gt_right" style="text-align: right; border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; border-top-width: 1px; border-top-style: solid; border-top-color: #D3D3D3; border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: #D3D3D3;">98,550 (62.18)</td>
<td headers="[header]Stratifications
[header_level]Age group
[header_level]>=40" class="gt_row gt_right" style="text-align: right;">37,527 (14.41)</td></tr>
    <tr><td headers="CDM name" class="gt_row gt_left" style="text-align: left; border-top-width: 1px; border-top-style: hidden; border-top-color: #000000;"></td>
<td headers="Cohort name" class="gt_row gt_left" style="text-align: left; border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; border-top-width: 1px; border-top-style: solid; border-top-color: #D3D3D3; border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: #D3D3D3;">Cohort2</td>
<td headers="Variable name" class="gt_row gt_left" style="text-align: left; border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; border-top-width: 1px; border-top-style: solid; border-top-color: #D3D3D3; border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: #D3D3D3;">Medications</td>
<td headers="Variable level" class="gt_row gt_left" style="text-align: left; border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; border-top-width: 1px; border-top-style: solid; border-top-color: #D3D3D3; border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: #D3D3D3;">Ibuprofen</td>
<td headers="Estimate name" class="gt_row gt_left" style="text-align: left; border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; border-top-width: 1px; border-top-style: solid; border-top-color: #D3D3D3; border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: #D3D3D3;">N%</td>
<td headers="[header]Stratifications
[header_level]Overall
[header_level]Overall" class="gt_row gt_right" style="text-align: right; border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; border-top-width: 1px; border-top-style: solid; border-top-color: #D3D3D3; border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: #D3D3D3;">49,201 (94.97)</td>
<td headers="[header]Stratifications
[header_level]Age group and sex
[header_level]<40 and male" class="gt_row gt_right" style="text-align: right; border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; border-top-width: 1px; border-top-style: solid; border-top-color: #D3D3D3; border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: #D3D3D3;">72,681 (14.52)</td>
<td headers="[header]Stratifications
[header_level]Age group and sex
[header_level]>=40 and male" class="gt_row gt_right" style="text-align: right; border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; border-top-width: 1px; border-top-style: solid; border-top-color: #D3D3D3; border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: #D3D3D3;">86,983 (66.56)</td>
<td headers="[header]Stratifications
[header_level]Age group and sex
[header_level]<40 and female" class="gt_row gt_right" style="text-align: right; border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; border-top-width: 1px; border-top-style: solid; border-top-color: #D3D3D3; border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: #D3D3D3;">99,386 (7.00)</td>
<td headers="[header]Stratifications
[header_level]Age group and sex
[header_level]>=40 and female" class="gt_row gt_right" style="text-align: right; border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; border-top-width: 1px; border-top-style: solid; border-top-color: #D3D3D3; border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: #D3D3D3;">68,179 (69.97)</td>
<td headers="[header]Stratifications
[header_level]Sex
[header_level]Male" class="gt_row gt_right" style="text-align: right; border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; border-top-width: 1px; border-top-style: solid; border-top-color: #D3D3D3; border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: #D3D3D3;">70,328 (98.88)</td>
<td headers="[header]Stratifications
[header_level]Sex
[header_level]Female" class="gt_row gt_right" style="text-align: right; border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; border-top-width: 1px; border-top-style: solid; border-top-color: #D3D3D3; border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: #D3D3D3;">56,236 (92.82)</td>
<td headers="[header]Stratifications
[header_level]Age group
[header_level]<40" class="gt_row gt_right" style="text-align: right; border-left-width: 1px; border-left-style: solid; border-left-color: #D3D3D3; border-right-width: 1px; border-right-style: solid; border-right-color: #D3D3D3; border-top-width: 1px; border-top-style: solid; border-top-color: #D3D3D3; border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: #D3D3D3;">71,041 (49.63)</td>
<td headers="[header]Stratifications
[header_level]Age group
[header_level]>=40" class="gt_row gt_right" style="text-align: right;">94,255 (27.75)</td></tr>
  </tbody>
  &#10;  
</table>
</div>

In the code snipped showed, we specified how to group and display the
estimates with `formatEstimateName`. Also, we created a header based on
the stratifications with `header`, and we split the name-level paired
columns group and additional (refer to the “split and unite functions”
vignette for more information on splitting).

## Custom formatting - Example usage

The function `formatTable()` is wrapped around other functions of the
package. These can be implemented in a pipeline for additional
customisation of the summarised_result.

### 1. formatEstimateValue()

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
#> Columns: 16
#> $ result_id        <int> 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,…
#> $ cdm_name         <chr> "mock", "mock", "mock", "mock", "mock", "mock", "mock…
#> $ result_type      <chr> "mock_summarised_result", "mock_summarised_result", "…
#> $ package_name     <chr> "visOmopResults", "visOmopResults", "visOmopResults",…
#> $ package_version  <chr> "0.2.0", "0.2.0", "0.2.0", "0.2.0", "0.2.0", "0.2.0",…
#> $ group_name       <chr> "cohort_name", "cohort_name", "cohort_name", "cohort_…
#> $ group_level      <chr> "cohort1", "cohort1", "cohort1", "cohort1", "cohort1"…
#> $ strata_name      <chr> "overall", "age_group &&& sex", "age_group &&& sex", …
#> $ strata_level     <chr> "overall", "<40 &&& Male", ">=40 &&& Male", "<40 &&& …
#> $ variable_name    <chr> "number subjects", "number subjects", "number subject…
#> $ variable_level   <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N…
#> $ estimate_name    <chr> "count", "count", "count", "count", "count", "count",…
#> $ estimate_type    <chr> "integer", "integer", "integer", "integer", "integer"…
#> $ estimate_value   <chr> "5,862,563", "4,005,128", "4,577,810", "1,243,292", "…
#> $ additional_name  <chr> "overall", "overall", "overall", "overall", "overall"…
#> $ additional_level <chr> "overall", "overall", "overall", "overall", "overall"…
```

### 2. formatEstimateName()

With this function we can transform the *estimate_name* and
*estimate_value* columns. For example, it allows to consolidate into one
row counts and percentages related to the same variable within the same
group and strata. It’s worth noting that the *estimate_name* is enclosed
within \<…\> in the `estimateNameFormat` argument.

``` r
result <- result |> formatEstimateName(
  estimateNameFormat = c("N (%)" = "<count> (<percentage>%)",
                         "N" = "<count>",
                         "Mean (SD)" = "<mean> (<sd>)"),
  keepNotFormatted = FALSE)
```

``` r
result |> dplyr::glimpse()
#> Rows: 72
#> Columns: 16
#> $ result_id        <int> 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,…
#> $ cdm_name         <chr> "mock", "mock", "mock", "mock", "mock", "mock", "mock…
#> $ result_type      <chr> "mock_summarised_result", "mock_summarised_result", "…
#> $ package_name     <chr> "visOmopResults", "visOmopResults", "visOmopResults",…
#> $ package_version  <chr> "0.2.0", "0.2.0", "0.2.0", "0.2.0", "0.2.0", "0.2.0",…
#> $ group_name       <chr> "cohort_name", "cohort_name", "cohort_name", "cohort_…
#> $ group_level      <chr> "cohort1", "cohort1", "cohort1", "cohort1", "cohort1"…
#> $ strata_name      <chr> "overall", "age_group &&& sex", "age_group &&& sex", …
#> $ strata_level     <chr> "overall", "<40 &&& Male", ">=40 &&& Male", "<40 &&& …
#> $ variable_name    <chr> "number subjects", "number subjects", "number subject…
#> $ variable_level   <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N…
#> $ estimate_name    <chr> "N", "N", "N", "N", "N", "N", "N", "N", "N", "N", "N"…
#> $ estimate_type    <chr> "character", "character", "character", "character", "…
#> $ estimate_value   <chr> "5,862,563", "4,005,128", "4,577,810", "1,243,292", "…
#> $ additional_name  <chr> "overall", "overall", "overall", "overall", "overall"…
#> $ additional_level <chr> "overall", "overall", "overall", "overall", "overall"…
```

### 3. formatHeader()

Next step is to format our table before transforming to gt object. We
will pivot *strata_name* and *strata_level* columns to have the strata
groups as columns under the header “Study strata”.

``` r
result <- result |>
  formatHeader(header = c("Study strata", "strata_name", "strata_level"),
               delim = "\n", 
               includeHeaderName = FALSE,
               includeHeaderKey = TRUE)
```

``` r
result |> dplyr::glimpse()
#> Rows: 8
#> Columns: 22
#> $ result_id                                                                              <int> …
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
#> $ `[header]Study strata\n[header_level]age_group &&& sex\n[header_level]<40 &&& Male`    <chr> …
#> $ `[header]Study strata\n[header_level]age_group &&& sex\n[header_level]>=40 &&& Male`   <chr> …
#> $ `[header]Study strata\n[header_level]age_group &&& sex\n[header_level]<40 &&& Female`  <chr> …
#> $ `[header]Study strata\n[header_level]age_group &&& sex\n[header_level]>=40 &&& Female` <chr> …
#> $ `[header]Study strata\n[header_level]sex\n[header_level]Male`                          <chr> …
#> $ `[header]Study strata\n[header_level]sex\n[header_level]Female`                        <chr> …
#> $ `[header]Study strata\n[header_level]age_group\n[header_level]<40`                     <chr> …
#> $ `[header]Study strata\n[header_level]age_group\n[header_level]>=40`                    <chr> …
```

### 4. gtTable()

Finally, we convert the transformed *summarised_result* object in steps
1, 2, and 3, into a nice gt object. We use the default visOmopResults
style. Additionally, we separate data into groups specified by
*group_level* column to differentiate between cohort1 and cohort2.

``` r
gtResult <- result |>
  dplyr::select(-c("result_type", "package_name", "package_version", 
                   "group_name", "additional_name", "additional_level",
                   "estimate_type", "result_id")) |>
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
