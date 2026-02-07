# Creates a flextable or gt object from a dataframe

Creates a flextable object from a dataframe using a delimiter to span
the header, and allows to easily customise table style.

## Usage

``` r
formatTable(
  x,
  type = NULL,
  delim = "\n",
  style = NULL,
  na = "–",
  title = NULL,
  subtitle = NULL,
  caption = NULL,
  groupColumn = NULL,
  groupAsColumn = FALSE,
  groupOrder = NULL,
  merge = "all_columns"
)
```

## Arguments

- x:

  A dataframe.

- type:

  Character string specifying the desired output table format. See
  [`tableType()`](https://darwin-eu.github.io/visOmopResults/reference/tableType.md)
  for supported table types. If `type = NULL`, global options (set via
  [`setGlobalTableOptions()`](https://darwin-eu.github.io/visOmopResults/reference/setGlobalTableOptions.md))
  will be used if available; otherwise, a default `'gt'` table is
  created.

- delim:

  Delimiter to separate headers.

- style:

  Defines the visual formatting of the table. This argument can be
  provided in one of the following ways:

  1.  **Pre-defined style:** Use the name of a built-in style (e.g.,
      `"darwin"`). See
      [`tableStyle()`](https://darwin-eu.github.io/visOmopResults/reference/tableStyle.md)
      for available options.

  2.  **YAML file path:** Provide the path to an existing `.yml` file
      defining a new style.

  3.  **List of custome R code:** Supply a block of custom R code or a
      named list describing styles for each table section. This code
      must be specific to the selected table type. If `style = NULL`,
      the function will use global options (see
      [`setGlobalTableOptions()`](https://darwin-eu.github.io/visOmopResults/reference/setGlobalTableOptions.md))
      or an existing `_brand.yml` file (if found); otherwise, the
      default style is applied. For more details, see the *Styles*
      vignette on the package website.

- na:

  How to display missing values. Not used for "datatable" and
  "reactable".

- title:

  Title of the table, or NULL for no title. Not used for "datatable".

- subtitle:

  Subtitle of the table, or NULL for no subtitle. Not used for
  "datatable" and "reactable".

- caption:

  Caption for the table, or NULL for no caption. Text in markdown
  formatting style (e.g. `*Your caption here*` for caption in italics).
  Not used for "reactable".

- groupColumn:

  Columns to use as group labels, to see options use
  `tableColumns(result)`. By default, the name of the new group will be
  the tidy\* column names separated by ";". To specify a custom group
  name, use a named list such as: list("newGroupName" =
  c("variable_name", "variable_level")).

  \*tidy: The tidy format applied to column names replaces "\_" with a
  space and converts to sentence case. Use `rename` to customise
  specific column names.

- groupAsColumn:

  Whether to display the group labels as a column (TRUE) or rows
  (FALSE). Not used for "datatable" and "reactable"

- groupOrder:

  Order in which to display group labels. Not used for "datatable" and
  "reactable".

- merge:

  Names of the columns to merge vertically when consecutive row cells
  have identical values. Alternatively, use "all_columns" to apply this
  merging to all columns, or use NULL to indicate no merging. Not used
  for "datatable" and "reactable".

## Value

A formatted table of the class selected in "type" argument.

## Examples

``` r
# Example 1
mockSummarisedResult() |>
  formatEstimateValue(decimals = c(integer = 0, numeric = 1)) |>
  formatHeader(
    header = c("Study strata", "strata_name", "strata_level"),
    includeHeaderName = FALSE
  ) |>
  formatTable(
    type = "flextable",
    style = "default",
    na = "--",
    title = "fxTable example",
    subtitle = NULL,
    caption = NULL,
    groupColumn = "group_level",
    groupAsColumn = TRUE,
    groupOrder = c("cohort1", "cohort2"),
    merge = "all_columns"
  )


.cl-b6f99694{table-layout:auto;}.cl-b6efdcf8{font-family:'Arial';font-size:15pt;font-weight:bold;font-style:normal;text-decoration:none;color:rgba(0, 0, 0, 1.00);background-color:transparent;}.cl-b6efdd0c{font-family:'Arial';font-size:10pt;font-weight:bold;font-style:normal;text-decoration:none;color:rgba(0, 0, 0, 1.00);background-color:transparent;}.cl-b6efdd0d{font-family:'Arial';font-size:10pt;font-weight:normal;font-style:normal;text-decoration:none;color:rgba(0, 0, 0, 1.00);background-color:transparent;}.cl-b6f35cac{margin:0;text-align:center;border-bottom: 0 solid rgba(0, 0, 0, 1.00);border-top: 0 solid rgba(0, 0, 0, 1.00);border-left: 0 solid rgba(0, 0, 0, 1.00);border-right: 0 solid rgba(0, 0, 0, 1.00);padding-bottom:3pt;padding-top:3pt;padding-left:3pt;padding-right:3pt;line-height: 1;background-color:transparent;}.cl-b6f35cc0{margin:0;text-align:left;border-bottom: 0 solid rgba(0, 0, 0, 1.00);border-top: 0 solid rgba(0, 0, 0, 1.00);border-left: 0 solid rgba(0, 0, 0, 1.00);border-right: 0 solid rgba(0, 0, 0, 1.00);padding-bottom:3pt;padding-top:3pt;padding-left:3pt;padding-right:3pt;line-height: 1;background-color:transparent;}.cl-b6f38be6{background-color:transparent;vertical-align: middle;border-bottom: 1pt solid rgba(225, 225, 225, 1.00);border-top: 1pt solid rgba(225, 225, 225, 1.00);border-left: 1pt solid rgba(225, 225, 225, 1.00);border-right: 1pt solid rgba(225, 225, 225, 1.00);margin-bottom:0;margin-top:0;margin-left:0;margin-right:0;}.cl-b6f38bf0{background-color:rgba(225, 225, 225, 1.00);vertical-align: middle;border-bottom: 1pt solid rgba(200, 200, 200, 1.00);border-top: 1pt solid rgba(200, 200, 200, 1.00);border-left: 1pt solid rgba(200, 200, 200, 1.00);border-right: 1pt solid rgba(200, 200, 200, 1.00);margin-bottom:0;margin-top:0;margin-left:0;margin-right:0;}.cl-b6f38bf1{background-color:rgba(200, 200, 200, 1.00);vertical-align: middle;border-bottom: 1pt solid rgba(200, 200, 200, 1.00);border-top: 1pt solid rgba(200, 200, 200, 1.00);border-left: 1pt solid rgba(200, 200, 200, 1.00);border-right: 1pt solid rgba(200, 200, 200, 1.00);margin-bottom:0;margin-top:0;margin-left:0;margin-right:0;}.cl-b6f38bf2{background-color:rgba(233, 233, 233, 1.00);vertical-align: middle;border-bottom: 1pt solid rgba(200, 200, 200, 1.00);border-top: 1pt solid rgba(200, 200, 200, 1.00);border-left: 1pt solid rgba(200, 200, 200, 1.00);border-right: 1pt solid rgba(200, 200, 200, 1.00);margin-bottom:0;margin-top:0;margin-left:0;margin-right:0;}.cl-b6f38bfa{background-color:transparent;vertical-align: middle;border-bottom: 1pt solid rgba(255, 255, 255, 0.00);border-top: 1pt solid rgba(200, 200, 200, 1.00);border-left: 1pt solid rgba(200, 200, 200, 1.00);border-right: 1pt solid rgba(200, 200, 200, 1.00);margin-bottom:0;margin-top:0;margin-left:0;margin-right:0;}.cl-b6f38c04{background-color:transparent;vertical-align: middle;border-bottom: 1pt solid rgba(200, 200, 200, 1.00);border-top: 1pt solid rgba(200, 200, 200, 1.00);border-left: 1pt solid rgba(200, 200, 200, 1.00);border-right: 1pt solid rgba(200, 200, 200, 1.00);margin-bottom:0;margin-top:0;margin-left:0;margin-right:0;}


fxTable example
```

group_level

result_id

cdm_name

group_name

variable_name

variable_level

estimate_name

estimate_type

additional_name

additional_level

Study strata

overall

age_group &&& sex

sex

age_group

overall

\<40 &&& Male

\>=40 &&& Male

\<40 &&& Female

\>=40 &&& Female

Male

Female

\<40

\>=40

cohort1

1

mock

cohort_name

number subjects

--

count

integer

overall

overall

2,655,087

3,721,239

5,728,534

9,082,078

2,016,819

8,983,897

9,446,753

6,607,978

6,291,140

age

--

mean

numeric

overall

overall

38.0

77.7

93.5

21.2

65.2

12.6

26.7

38.6

1.3

sd

numeric

overall

overall

7.9

1.1

7.2

4.1

8.2

6.5

7.8

5.5

5.3

Medications

Amoxiciline

count

integer

overall

overall

7,068

9,947

31,627

51,863

66,201

40,683

91,288

29,360

45,907

percentage

percentage

overall

overall

34.668348915875

33.3774930797517

47.6351245073602

89.2198335845023

86.4339470630512

38.9989543473348

77.7320698834956

96.0617997217923

43.4659484773874

Ibuprofen

count

integer

overall

overall

23,963

5,893

64,229

87,627

77,891

79,731

45,527

41,008

81,087

percentage

percentage

overall

overall

92.4074469832703

59.876096714288

97.6170694921166

73.1792511884123

35.6726912083104

43.1473690550774

14.8211560677737

1.30775754805654

71.5566066093743

cohort2

1

mock

cohort_name

number subjects

--

count

integer

overall

overall

617,863

2,059,746

1,765,568

6,870,228

3,841,037

7,698,414

4,976,992

7,176,185

9,919,061

age

--

mean

numeric

overall

overall

38.2

87.0

34.0

48.2

60.0

49.4

18.6

82.7

66.8

sd

numeric

overall

overall

7.9

0.2

4.8

7.3

6.9

4.8

8.6

4.4

2.4

Medications

Amoxiciline

count

integer

overall

overall

33,239

65,087

25,802

47,855

76,631

8,425

87,532

33,907

83,944

percentage

percentage

overall

overall

71.2514678714797

39.9994368897751

32.5352151878178

75.7087148027495

20.2692255144939

71.1121222469956

12.1691921027377

24.5488513959572

14.330437942408

Ibuprofen

count

integer

overall

overall

60,493

65,472

35,320

27,026

99,268

63,349

21,321

12,937

47,812

percentage

percentage

overall

overall

10.3184235747904

44.6284348610789

64.0101045137271

99.1838620044291

49.5593577856198

48.4349524369463

17.3442334868014

75.4820944508538

45.3895489219576

\# Example 2
[mockSummarisedResult](https://darwin-eu.github.io/visOmopResults/reference/mockSummarisedResult.md)()
\|\>
[formatEstimateValue](https://darwin-eu.github.io/visOmopResults/reference/formatEstimateValue.md)(decimals
= [c](https://rdrr.io/r/base/c.html)(integer = 0, numeric = 1)) \|\>
[formatHeader](https://darwin-eu.github.io/visOmopResults/reference/formatHeader.md)(header
= [c](https://rdrr.io/r/base/c.html)("Study strata", "strata_name",
"strata_level"), includeHeaderName = FALSE) \|\> formatTable( type =
"gt", style = [list](https://rdrr.io/r/base/list.html)("header" =
[list](https://rdrr.io/r/base/list.html)(
gt::[cell_fill](https://gt.rstudio.com/reference/cell_fill.html)(color =
"#d9d9d9"),
gt::[cell_text](https://gt.rstudio.com/reference/cell_text.html)(weight
= "bold")), "header_level" =
[list](https://rdrr.io/r/base/list.html)(gt::[cell_fill](https://gt.rstudio.com/reference/cell_fill.html)(color
= "#e1e1e1"),
gt::[cell_text](https://gt.rstudio.com/reference/cell_text.html)(weight
= "bold")), "column_name" =
[list](https://rdrr.io/r/base/list.html)(gt::[cell_text](https://gt.rstudio.com/reference/cell_text.html)(weight
= "bold")), "title" =
[list](https://rdrr.io/r/base/list.html)(gt::[cell_text](https://gt.rstudio.com/reference/cell_text.html)(weight
= "bold"),
gt::[cell_fill](https://gt.rstudio.com/reference/cell_fill.html)(color =
"#c8c8c8")), "group_label" =
gt::[cell_fill](https://gt.rstudio.com/reference/cell_fill.html)(color =
"#e1e1e1")), na = "--", title = "gtTable example", subtitle = NULL,
caption = NULL, groupColumn = "group_level", groupAsColumn = FALSE,
groupOrder = [c](https://rdrr.io/r/base/c.html)("cohort1", "cohort2"),
merge = "all_columns" )

[TABLE]
