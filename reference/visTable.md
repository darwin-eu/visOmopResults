# Generate a formatted table from a `<data.table>`

This function combines the functionalities of
[`formatEstimateValue()`](https://darwin-eu.github.io/visOmopResults/reference/formatEstimateValue.md),
[`formatEstimateName()`](https://darwin-eu.github.io/visOmopResults/reference/formatEstimateName.md),
[`formatHeader()`](https://darwin-eu.github.io/visOmopResults/reference/formatHeader.md),
and
[`formatTable()`](https://darwin-eu.github.io/visOmopResults/reference/formatTable.md)
into a single function. While it does not require the input table to be
a `<summarised_result>`, it does expect specific fields to apply some
formatting functionalities.

## Usage

``` r
visTable(
  result,
  estimateName = character(),
  header = character(),
  groupColumn = character(),
  rename = character(),
  type = NULL,
  hide = character(),
  style = NULL,
  .options = list()
)
```

## Arguments

- result:

  A table to format.

- estimateName:

  A named list of estimate names to join, sorted by computation order.
  Use `<...>` to indicate estimate names.

- header:

  A vector specifying the elements to include in the header. The order
  of elements matters, with the first being the topmost header. The
  vector elements can be column names or labels for overall headers. The
  table must contain an `estimate_value` column to pivot the headers.

- groupColumn:

  Columns to use as group labels, to see options use
  `tableColumns(result)`. By default, the name of the new group will be
  the tidy\* column names separated by ";". To specify a custom group
  name, use a named list such as: list("newGroupName" =
  c("variable_name", "variable_level")).

  \*tidy: The tidy format applied to column names replaces "\_" with a
  space and converts to sentence case. Use `rename` to customise
  specific column names.

- rename:

  A named vector to customise column names, e.g., c("Database name" =
  "cdm_name"). The function renames all column names not specified here
  into a tidy\* format.

- type:

  Character string specifying the desired output table format. See
  [`tableType()`](https://darwin-eu.github.io/visOmopResults/reference/tableType.md)
  for supported table types. If `type = NULL`, global options (set via
  [`setGlobalTableOptions()`](https://darwin-eu.github.io/visOmopResults/reference/setGlobalTableOptions.md))
  will be used if available; otherwise, a default `'gt'` table is
  created.

- hide:

  Columns to drop from the output table.

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

- .options:

  A named list with additional formatting options.
  [`visOmopResults::tableOptions()`](https://darwin-eu.github.io/visOmopResults/reference/tableOptions.md)
  shows allowed arguments and their default values.

## Value

A formatted table of the class selected in "type" argument.

## Examples

``` r
result <- mockSummarisedResult()
result |>
  visTable(
    estimateName = c("N%" = "<count> (<percentage>)",
                     "N" = "<count>",
                     "Mean (SD)" = "<mean> (<sd>)"),
    header = c("Estimate"),
    rename = c("Database name" = "cdm_name"),
    groupColumn = c("strata_name", "strata_level"),
    hide = c("additional_name", "additional_level", "estimate_type", "result_type")
  )


  

Result id
```

Database name

Group name

Group level

Variable name

Variable level

Estimate name

Estimate

overall; overall

1

mock

cohort_name

cohort1

number subjects

–

N

2,655,087

cohort2

number subjects

–

N

617,863

cohort1

age

–

Mean (SD)

38.00 (7.94)

cohort2

age

–

Mean (SD)

38.24 (7.89)

cohort1

Medications

Amoxiciline

N%

7,068 (34.67)

cohort2

Medications

Amoxiciline

N%

33,239 (71.25)

cohort1

Medications

Ibuprofen

N%

23,963 (92.41)

cohort2

Medications

Ibuprofen

N%

60,493 (10.32)

age_group &&& sex; \<40 &&& Male

1

mock

cohort_name

cohort1

number subjects

–

N

3,721,239

cohort2

number subjects

–

N

2,059,746

cohort1

age

–

Mean (SD)

77.74 (1.08)

cohort2

age

–

Mean (SD)

86.97 (0.23)

cohort1

Medications

Amoxiciline

N%

9,947 (33.38)

cohort2

Medications

Amoxiciline

N%

65,087 (40.00)

cohort1

Medications

Ibuprofen

N%

5,893 (59.88)

cohort2

Medications

Ibuprofen

N%

65,472 (44.63)

age_group &&& sex; \>=40 &&& Male

1

mock

cohort_name

cohort1

number subjects

–

N

5,728,534

cohort2

number subjects

–

N

1,765,568

cohort1

age

–

Mean (SD)

93.47 (7.24)

cohort2

age

–

Mean (SD)

34.03 (4.77)

cohort1

Medications

Amoxiciline

N%

31,627 (47.64)

cohort2

Medications

Amoxiciline

N%

25,802 (32.54)

cohort1

Medications

Ibuprofen

N%

64,229 (97.62)

cohort2

Medications

Ibuprofen

N%

35,320 (64.01)

age_group &&& sex; \<40 &&& Female

1

mock

cohort_name

cohort1

number subjects

–

N

9,082,078

cohort2

number subjects

–

N

6,870,228

cohort1

age

–

Mean (SD)

21.21 (4.11)

cohort2

age

–

Mean (SD)

48.21 (7.32)

cohort1

Medications

Amoxiciline

N%

51,863 (89.22)

cohort2

Medications

Amoxiciline

N%

47,855 (75.71)

cohort1

Medications

Ibuprofen

N%

87,627 (73.18)

cohort2

Medications

Ibuprofen

N%

27,026 (99.18)

age_group &&& sex; \>=40 &&& Female

1

mock

cohort_name

cohort1

number subjects

–

N

2,016,819

cohort2

number subjects

–

N

3,841,037

cohort1

age

–

Mean (SD)

65.17 (8.21)

cohort2

age

–

Mean (SD)

59.96 (6.93)

cohort1

Medications

Amoxiciline

N%

66,201 (86.43)

cohort2

Medications

Amoxiciline

N%

76,631 (20.27)

cohort1

Medications

Ibuprofen

N%

77,891 (35.67)

cohort2

Medications

Ibuprofen

N%

99,268 (49.56)

sex; Male

1

mock

cohort_name

cohort1

number subjects

–

N

8,983,897

cohort2

number subjects

–

N

7,698,414

cohort1

age

–

Mean (SD)

12.56 (6.47)

cohort2

age

–

Mean (SD)

49.35 (4.78)

cohort1

Medications

Amoxiciline

N%

40,683 (39.00)

cohort2

Medications

Amoxiciline

N%

8,425 (71.11)

cohort1

Medications

Ibuprofen

N%

79,731 (43.15)

cohort2

Medications

Ibuprofen

N%

63,349 (48.43)

sex; Female

1

mock

cohort_name

cohort1

number subjects

–

N

9,446,753

cohort2

number subjects

–

N

4,976,992

cohort1

age

–

Mean (SD)

26.72 (7.83)

cohort2

age

–

Mean (SD)

18.62 (8.61)

cohort1

Medications

Amoxiciline

N%

91,288 (77.73)

cohort2

Medications

Amoxiciline

N%

87,532 (12.17)

cohort1

Medications

Ibuprofen

N%

45,527 (14.82)

cohort2

Medications

Ibuprofen

N%

21,321 (17.34)

age_group; \<40

1

mock

cohort_name

cohort1

number subjects

–

N

6,607,978

cohort2

number subjects

–

N

7,176,185

cohort1

age

–

Mean (SD)

38.61 (5.53)

cohort2

age

–

Mean (SD)

82.74 (4.38)

cohort1

Medications

Amoxiciline

N%

29,360 (96.06)

cohort2

Medications

Amoxiciline

N%

33,907 (24.55)

cohort1

Medications

Ibuprofen

N%

41,008 (1.31)

cohort2

Medications

Ibuprofen

N%

12,937 (75.48)

age_group; \>=40

1

mock

cohort_name

cohort1

number subjects

–

N

6,291,140

cohort2

number subjects

–

N

9,919,061

cohort1

age

–

Mean (SD)

1.34 (5.30)

cohort2

age

–

Mean (SD)

66.85 (2.45)

cohort1

Medications

Amoxiciline

N%

45,907 (43.47)

cohort2

Medications

Amoxiciline

N%

83,944 (14.33)

cohort1

Medications

Ibuprofen

N%

81,087 (71.56)

cohort2

Medications

Ibuprofen

N%

47,812 (45.39)
