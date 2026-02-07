# Supported table classes

This function returns the supported table classes that can be used in
the `type` argument of
[`visOmopTable()`](https://darwin-eu.github.io/visOmopResults/reference/visOmopTable.md),
[`visTable()`](https://darwin-eu.github.io/visOmopResults/reference/visTable.md),
and
[`formatTable()`](https://darwin-eu.github.io/visOmopResults/reference/formatTable.md)
functions.

## Usage

``` r
tableType()
```

## Value

A character vector of supported table types.

## Examples

``` r
tableType()
#> [1] "gt"        "flextable" "tibble"    "datatable" "reactable" "tinytable"
```
