# Columns for the plot functions

Names of the columns that can be used in the input arguments for the
plot functions.

## Usage

``` r
plotColumns(result)
```

## Arguments

- result:

  A `<summarised_result>` object.

## Value

A character vector of supported columns for plots.

## Examples

``` r
result <- mockSummarisedResult()
plotColumns(result)
#>  [1] "cdm_name"       "cohort_name"    "age_group"      "sex"           
#>  [5] "variable_name"  "variable_level" "count"          "mean"          
#>  [9] "sd"             "percentage"    
```
