# Changelog

## visOmopResults 1.4.1

CRAN release: 2026-02-02

- Handling not registered fonts for `ggplot2` without `extrafont`
  package
- Numeric `estimate_value` column for `reactable` and `datatable`
- Update style format for compatibility with `brand.yml`

## visOmopResults 1.4.0

CRAN release: 2025-11-07

- Added option to define styles with `.yml` files using the `brand.yml`
  framework
- Dropped `tableStyleCode()`
- Added vignette on styles
- Changed default argument `type` and `style` to NULL to use global
  options in higher level functions

## visOmopResults 1.3.1

CRAN release: 2025-10-09

- Improve and fix documentation

## visOmopResults 1.3.0

CRAN release: 2025-10-05

- Support `plotly` for plots
- Function
  [`tableStyle()`](https://darwin-eu.github.io/visOmopResults/reference/tableStyle.md)
  renamed to `tableStyleCode()`
- Added functions to get allowed pre-defined package styles:
  [`tableStyle()`](https://darwin-eu.github.io/visOmopResults/reference/tableStyle.md)
  and
  [`plotStyle()`](https://darwin-eu.github.io/visOmopResults/reference/plotStyle.md)
- Added function to get allowed plot types:
  [`plotType()`](https://darwin-eu.github.io/visOmopResults/reference/plotType.md)
- Modified “darwin” style to be aligned with the style defined by
  DARWIN-EU®
- Added vignettes on how to use the package for Quarto reports and Shiny
  Apps
- Support for stack bar plots in
  [`barPlot()`](https://darwin-eu.github.io/visOmopResults/reference/barPlot.md)

## visOmopResults 1.2.0

CRAN release: 2025-09-02

- Support `tinytable`
- Add argument `style` for plots
- Add function
  [`setGlobalPlotOptions()`](https://darwin-eu.github.io/visOmopResults/reference/setGlobalPlotOptions.md)
  to set global arguments to plots
- Add function
  [`setGlobalTableOptions()`](https://darwin-eu.github.io/visOmopResults/reference/setGlobalTableOptions.md)
  to set global arguments to tables
- Union borders from merged cells in flextable

## visOmopResults 1.1.1

CRAN release: 2025-06-19

- Fix that all table types were required to be installed even if not
  used
- `columnOrder` when non-table columns passed, throw warning instead of
  error
- `columnOrder` when missing table columns adds them at the end instead
  of throwing error

## visOmopResults 1.1.0

CRAN release: 2025-05-21

- Support `reactable`
- Add darwin style

## visOmopResults 1.0.2

CRAN release: 2025-03-06

- Header pivotting - warning and addition of needed columns to get
  unique estimates in cells
- Fixed headers in datatable
- Show min cell counts only for counts, set the other estimates to NA

## visOmopResults 1.0.1

CRAN release: 2025-02-27

- Obscure percentage when there are less than five counts
- `formatMinCellCount` function

## visOmopResults 1.0.0

CRAN release: 2025-01-15

- Stable release of the package
- Added a `NEWS.md` file to track changes to the package.
