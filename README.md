
<!-- README.md is generated from README.Rmd. Please edit that file -->

# visOmopResults <img src="man/figures/logo.png" align="right" height="200"/>

<!-- badges: start -->

[![R-CMD-check](https://github.com/darwin-eu/visOmopResults/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/darwin-eu/visOmopResults/actions/workflows/R-CMD-check.yaml)
[![CRAN
status](https://www.r-pkg.org/badges/version/visOmopResults)](https://CRAN.R-project.org/package=visOmopResults)
[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
[![Codecov test
coverage](https://codecov.io/gh/darwin-eu/visOmopResults/branch/main/graph/badge.svg)](https://app.codecov.io/gh/darwin-eu/visOmopResults?branch=main)
<!-- badges: end -->

## Package overview

**visOmopResults** offers a set of functions tailored to format objects
of class `<summarised_result>` (as defined in
[omopgenerics](https://cran.r-project.org/package=omopgenerics)
package).

It provides functionality to: **transform** data, create **table**
visualizations, and generate **plot** visualizations. These
visualizations are highly versatile for reporting results through Shiny
apps, RMarkdown, Quarto, and more, supporting various output formats
such as HTML, PNG, Word, and PDF.

## Let’s get started

You can install the latest version of visOmopResults from CRAN:

``` r
install.packages("visOmopResults")
```

Or you can install the development version from
[GitHub](https://github.com/darwin-eu/visOmopResults) with:

``` r
# install.packages("pak")
pak::pkg_install("darwin-eu/visOmopResults")
```

The *<summarised_result>* is a standardised output format utilized
across various packages, including:

- [CohortCharacteristics](https://cran.r-project.org/package=CohortCharacteristics)
- [DrugUtilisation](https://cran.r-project.org/package=DrugUtilisation)
- [IncidencePrevalence](https://cran.r-project.org/package=IncidencePrevalence)
- [PatientProfiles](https://cran.r-project.org/package=PatientProfiles)
- [CodelistGenerator](https://cran.r-project.org/package=CodelistGenerator)
- [CohortSurvival](https://cran.r-project.org/package=CohortSurvival)
- [CohortSymmetry](https://cran.r-project.org/package=CohortSymmetry)
- [omopSketch](https://cran.r-project.org/package=omopSketch)
- [PhenotypeR](https://cran.r-project.org/package=PhenotypeR)

Although this standard output format is essential, it can sometimes be
challenging to manage. The *visOmopResults* package aims to simplify
this process. To demonstrate the package’s functionality, let’s start by
using some mock result:

``` r
library(visOmopResults)
result <- mockSummarisedResult()
```

## Transformation of a `<summarised_result>` object

A tidy version of the summarised can be obtained with the tidy function:

``` r
tidy(result)
#> # A tibble: 72 × 13
#>    cdm_name cohort_name age_group sex     variable_name   variable_level   count
#>    <chr>    <chr>       <chr>     <chr>   <chr>           <chr>            <int>
#>  1 mock     cohort1     overall   overall number subjects <NA>           1348839
#>  2 mock     cohort1     <40       Male    number subjects <NA>           1966995
#>  3 mock     cohort1     >=40      Male    number subjects <NA>           4455875
#>  4 mock     cohort1     <40       Female  number subjects <NA>           7942969
#>  5 mock     cohort1     >=40      Female  number subjects <NA>           1392213
#>  6 mock     cohort1     overall   Male    number subjects <NA>           1513680
#>  7 mock     cohort1     overall   Female  number subjects <NA>           8052240
#>  8 mock     cohort1     <40       overall number subjects <NA>           7809694
#>  9 mock     cohort1     >=40      overall number subjects <NA>           9470519
#> 10 mock     cohort2     overall   overall number subjects <NA>           6718175
#> # ℹ 62 more rows
#> # ℹ 6 more variables: mean <dbl>, sd <dbl>, percentage <dbl>,
#> #   result_type <chr>, package_name <chr>, package_version <chr>
```

This tidy format is no longer standardized but offers easier
manipulation. While `tidy()` provides a straightforward transformation,
the more customizable sibling function `tidySummarisedResult()` allows
you to specify exactly how you’d like to tidy your `<summarised_result>`
object:

``` r
result |>
  tidySummarisedResult(
    splitStrata = FALSE,
    settingsColumns = "package_name", 
    pivotEstimatesBy = NULL
  )
#> # A tibble: 126 × 11
#>    result_id cdm_name cohort_name strata_name       strata_level   variable_name
#>        <int> <chr>    <chr>       <chr>             <chr>          <chr>        
#>  1         1 mock     cohort1     overall           overall        number subje…
#>  2         1 mock     cohort1     age_group &&& sex <40 &&& Male   number subje…
#>  3         1 mock     cohort1     age_group &&& sex >=40 &&& Male  number subje…
#>  4         1 mock     cohort1     age_group &&& sex <40 &&& Female number subje…
#>  5         1 mock     cohort1     age_group &&& sex >=40 &&& Fema… number subje…
#>  6         1 mock     cohort1     sex               Male           number subje…
#>  7         1 mock     cohort1     sex               Female         number subje…
#>  8         1 mock     cohort1     age_group         <40            number subje…
#>  9         1 mock     cohort1     age_group         >=40           number subje…
#> 10         1 mock     cohort2     overall           overall        number subje…
#> # ℹ 116 more rows
#> # ℹ 5 more variables: variable_level <chr>, estimate_name <chr>,
#> #   estimate_type <chr>, estimate_value <chr>, package_name <chr>
```

## Filter a `<summarised_result>` object

A `<summarised_result>` object is essentially a `<data.frame>`, so it
can be filtered easily using `dplyr::filter()`. However, filtering
variables within name-level structures or those present in the settings
can be challenging. The following functions simplify this process:

- `filterSettings()`
- `filterGroup()`
- `filterStrata()`
- `filterAdditional()`

Here are some examples on how to use them:

``` r
result |>
  filterSettings(package_name == "visOmopResults")
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

``` r
result |>
  filterSettings(package_name == "other")
#> # A tibble: 0 × 13
#> # ℹ 13 variables: result_id <int>, cdm_name <chr>, group_name <chr>,
#> #   group_level <chr>, strata_name <chr>, strata_level <chr>,
#> #   variable_name <chr>, variable_level <chr>, estimate_name <chr>,
#> #   estimate_type <chr>, estimate_value <chr>, additional_name <chr>,
#> #   additional_level <chr>
```

``` r
result |>
  filterStrata(sex == "Female")
#> # A tibble: 42 × 13
#>    result_id cdm_name group_name  group_level strata_name       strata_level   
#>        <int> <chr>    <chr>       <chr>       <chr>             <chr>          
#>  1         1 mock     cohort_name cohort1     age_group &&& sex <40 &&& Female 
#>  2         1 mock     cohort_name cohort1     age_group &&& sex >=40 &&& Female
#>  3         1 mock     cohort_name cohort1     sex               Female         
#>  4         1 mock     cohort_name cohort2     age_group &&& sex <40 &&& Female 
#>  5         1 mock     cohort_name cohort2     age_group &&& sex >=40 &&& Female
#>  6         1 mock     cohort_name cohort2     sex               Female         
#>  7         1 mock     cohort_name cohort1     age_group &&& sex <40 &&& Female 
#>  8         1 mock     cohort_name cohort1     age_group &&& sex >=40 &&& Female
#>  9         1 mock     cohort_name cohort1     sex               Female         
#> 10         1 mock     cohort_name cohort2     age_group &&& sex <40 &&& Female 
#> # ℹ 32 more rows
#> # ℹ 7 more variables: variable_name <chr>, variable_level <chr>,
#> #   estimate_name <chr>, estimate_type <chr>, estimate_value <chr>,
#> #   additional_name <chr>, additional_level <chr>
```

## Tables visualisations

Currently all table functionalities are built around 3 packages:
[tibble](https://cran.r-project.org/package=tibble),
[gt](https://cran.r-project.org/package=gt), and
[flextable](https://cran.r-project.org/package=flextable).

There are two main functions:

- `visOmopTable()`: Creates a well-formatted table specifically from a
  `<summarised_result>` object.
- `visTable()`: Creates a nicely formatted table from any `<data.frame>`
  object.

Let’s see a simple example:

``` r
result |>
  visOmopTable(
    type = "flextable", # to change to gt when issue 223 is fixed
    estimateName = c(
      "N(%)" = "<count> (<percentage>%)", 
      "N" = "<count>", 
      "mean (sd)" = "<mean> (<sd>)"),
    header = c("sex"),
    settingsColumns = NULL,
    groupColumn = c("cohort_name", "age_group"),
    rename = c("Variable" = "variable_name", " " = "variable_level"),
    hide = "cdm_name"
  )
```

<img src="man/figures/README-unnamed-chunk-10-1.png" width="100%" />

## Plots visualisations

Currently all plot functionalities are built around
[ggplot2](https://cran.r-project.org/package=ggplot2). The output of
these plot functions is a `<ggplot2>` object that can be further
customised.

There are three plotting functions:

- `plotScatter()` to create a scatter plot.
- `plotBar()` to create a bar plot.
- `plotBox()` to create a box plot.

Let’s see how we can create a simple boxplot for age using this tool:

``` r
library(dplyr)
result |>
  filter(variable_name == "number subjects") |>
  filterStrata(sex != "overall") |>
  barPlot(x = "age_group", 
          y = "count",
          facet = "cohort_name", 
          colour = "sex")
```

<img src="man/figures/README-unnamed-chunk-11-1.png" width="100%" />
