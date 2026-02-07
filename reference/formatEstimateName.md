# Formats estimate_name and estimate_value column

Formats estimate_name and estimate_value columns by changing the name of
the estimate name and/or joining different estimates together in a
single row.

## Usage

``` r
formatEstimateName(
  result,
  estimateName = NULL,
  keepNotFormatted = TRUE,
  useFormatOrder = TRUE
)
```

## Arguments

- result:

  A `<summarised_result>`.

- estimateName:

  Named list of estimate name's to join, sorted by computation order.
  Indicate estimate_name's between \<...\>.

- keepNotFormatted:

  Whether to keep rows not formatted.

- useFormatOrder:

  Whether to use the order in which estimate names appear in the
  estimateName (TRUE), or use the order in the input dataframe (FALSE).

## Value

A `<summarised_result>` object.

## Examples

``` r
result <- mockSummarisedResult()
result |>
  formatEstimateName(
    estimateName = c(
      "N (%)" = "<count> (<percentage>%)", "N" = "<count>"
    ),
    keepNotFormatted = FALSE
  )
#> # A tibble: 54 × 13
#>    result_id cdm_name group_name  group_level strata_name       strata_level   
#>        <int> <chr>    <chr>       <chr>       <chr>             <chr>          
#>  1         1 mock     cohort_name cohort1     overall           overall        
#>  2         1 mock     cohort_name cohort1     age_group &&& sex <40 &&& Male   
#>  3         1 mock     cohort_name cohort1     age_group &&& sex >=40 &&& Male  
#>  4         1 mock     cohort_name cohort1     age_group &&& sex <40 &&& Female 
#>  5         1 mock     cohort_name cohort1     age_group &&& sex >=40 &&& Female
#>  6         1 mock     cohort_name cohort1     sex               Male           
#>  7         1 mock     cohort_name cohort1     sex               Female         
#>  8         1 mock     cohort_name cohort1     age_group         <40            
#>  9         1 mock     cohort_name cohort1     age_group         >=40           
#> 10         1 mock     cohort_name cohort2     overall           overall        
#> # ℹ 44 more rows
#> # ℹ 7 more variables: variable_name <chr>, variable_level <chr>,
#> #   estimate_name <chr>, estimate_type <chr>, estimate_value <chr>,
#> #   additional_name <chr>, additional_level <chr>
```
