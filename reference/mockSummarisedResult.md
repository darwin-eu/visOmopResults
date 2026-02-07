# A `<summarised_result>` object filled with mock data

Creates an object of the class `<summarised_result>` with mock data for
illustration purposes.

## Usage

``` r
mockSummarisedResult()
```

## Value

An object of the class `<summarised_result>` with mock data.

## Examples

``` r
mockSummarisedResult()
#> # A tibble: 126 × 13
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
#> # ℹ 116 more rows
#> # ℹ 7 more variables: variable_name <chr>, variable_level <chr>,
#> #   estimate_name <chr>, estimate_type <chr>, estimate_value <chr>,
#> #   additional_name <chr>, additional_level <chr>

```
