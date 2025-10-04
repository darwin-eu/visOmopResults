# visOmopResults 1.3.0

* Support `plotly` for plots
* Function `tableStyle()` renamed to `tableStyleCode()`
* Added functions to get allowed pre-defined package styles: `tableStyle()` and `plotStyle()`
* Added function to get allowed plot types: `plotType()`
* Modified "darwin" style to be aligned with the style defined by DARWIN-EU®
* Added vignettes on how to use the package for Quarto reports and Shiny Apps
* Support for stack bar plots in `barPlot()`


# visOmopResults 1.2.0

* Support `tinytable`
* Add argument `style` for plots
* Add function `setGlobalPlotOptions()` to set global arguments to plots
* Add function `setGlobalTableOptions()` to set global arguments to tables
* Union borders from merged cells in flextable


# visOmopResults 1.1.1

* Fix that all table types were required to be installed even if not used 
* `columnOrder` when non-table columns passed, throw warning instead of error
* `columnOrder` when missing table columns adds them at the end instead of throwing error 

# visOmopResults 1.1.0

* Support `reactable` 
* Add darwin style 

# visOmopResults 1.0.2

* Header pivotting - warning and addition of needed columns to get unique estimates in cells
* Fixed headers in datatable 
* Show min cell counts only for counts, set the other estimates to NA

# visOmopResults 1.0.1

* Obscure percentage when there are less than five counts 
* `formatMinCellCount` function 

# visOmopResults 1.0.0

* Stable release of the package
* Added a `NEWS.md` file to track changes to the package.
