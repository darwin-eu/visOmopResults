# FormatTable

<!-- badges: start -->

[![R-CMD-check](https://github.com/catalamarti/gtSummarisedResult/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/catalamarti/gtSummarisedResult/actions/workflows/R-CMD-check.yaml)
<!-- badges: end -->

## Package overview

FormatTable contains functions for formmating objects of the class "summarisedResult" (see R package [omopgenerics](https://cran.r-project.org/web/packages/omopgenerics/index.html). This package allows to manipulate them easly to obtain nice output tables in format gt or flextable to use in shiny apps, RMarkdown, Quarto...


## Installation

You can install the development version of FormatTable from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("oxford-pharmacoepi/formatTable")
```

## Example

In this example we show how to use the package to format a mock summarisedResult object into a nice gt or flextable object.

First we load the package and create a mock summarisedResult object.

``` r
library(formatTable)
library(dplyr)
result <- mockSummarisedResult() # mock summarisedResult object
result %>% glimpse()
```

#### 1. formatEstimateValue()
We use `formatEstimateValue` to transform the column estimate_value into our desired format. In this case, we use the deafult values of the function, which use 0 decimals for integer values, 2 for numeric, 1 for percentage and 3 for proportion. The function also defaults the decimal mark to "." and the thousand/millions separator to ".".

``` r
result <- result %>% formatEstimateValue()
```

#### 2. formatEstimateName()
The function `formatEstimateName` will allow us to tranform the estimate_name and estimate_value columns. For instance, we can join in the same row counts and percentages refering to the same variable (from the same group and strata). Notice, the estimate_name is written within <...> in the `estimateNameFormat` argument.
``` r
result <- result %>% formatEstimateName(
  estimateNameFormat = c("N (%)" = "<count> (<percentage>%)",
                         "N" = "<count>",
                         "Mean (SD)" = "<mean> (<sd>)"),
  keepNotFormatted = FALSE)
```

#### 3. spanHeader()
We can set the stratification into columns instead of rows using the ``

To make our result table more readble, we want to set new columns with the stratifications. We use `spanHeader` to do this. Each new column will have a descriptive name, with different labels separated by a deliminter that can be later use in gt and/or flextable objects to create a header. 
In the header input, we specify those columns we want to pivot in the order we want them. Additonally, we can state names not corresponding to table columns that we want to incorporate into the header at that position. Lastly, the boolean input "includeHeaderName" wheather to inclue the column name (e.g. "strata_name") as a header or not. In this example we set this to FALSE since we included our own headers ("Study cohorts" and "Study strata").
``` r
result <- result %>%
  spanHeader(header = c("Study cohorts", "group_level", "Study strata",
                         "strata_name", "strata_level"),
             delim = "\n", 
             includeHeaderName = FALSE)
```

#### 4. gtTable() 
Finally, we can convert the obtained `result` table to either a gt or flextable object using the function `gtTable` and `fxTable` respectively. For illustrative purposes, we are going to create a gt table object. 
We use the same delimiter object as in `spanHeader` in order to span the headers at the desired positions. Additonally, we wan to group data from the different group_level within the table, for which we use the  groupNameCol argument.
``` r
result <- result %>%
  gtTable(
    delim = "\n",
    style = list("header" = list(gt::cell_fill(color = "#c8c8c8"),
                                 gt::cell_text(weight = "bold")),
      "header_name" = list(gt::cell_fill(color = "#d9d9d9"),
                           gt::cell_text(weight = "bold")),
      "header_level" = list(gt::cell_fill(color = "#e1e1e1"),
                            gt::cell_text(weight = "bold")),
      "column_name" = list(gt::cell_text(weight = "bold")),
      "group_label" = list(gt::cell_fill(color = "#e9ecef"),
                           gt::cell_text(weight = "bold")),
      "title" = list(gt::cell_text(color = "blue", weight = "bold")
    ),
    na = "-",
    title = "My first gt table with FormatTable!),
    groupNameCol = "group_level",
    groupNameAsColumn = FALSE,
    groupOrder = c("cohort1", "cohort2")
    )
```
