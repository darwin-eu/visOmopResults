# Additional table formatting options for `visOmopTable()` and `visTable()`

This function provides a list of allowed inputs for the `.option`
argument in
[`visOmopTable()`](https://darwin-eu.github.io/visOmopResults/reference/visOmopTable.md)
and
[`visTable()`](https://darwin-eu.github.io/visOmopResults/reference/visTable.md),
and their corresponding default values.

## Usage

``` r
tableOptions()
```

## Value

A named list of default options for table customisation.

## Examples

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
#> 
```
