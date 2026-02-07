# Columns for the table functions

Names of the columns that can be used in the input arguments for the
table functions.

## Usage

``` r
tableColumns(result)
```

## Arguments

- result:

  A `<summarised_result>` object.

## Value

A character vector of supported columns for tables.

## Examples

``` r
result <- mockSummarisedResult()
tableColumns(result)
#> [1] "cdm_name"       "cohort_name"    "age_group"      "sex"           
#> [5] "variable_name"  "variable_level" "estimate_name" 
```
