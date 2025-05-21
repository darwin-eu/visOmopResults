test_that("check utilities", {
  expect_error(validateSummarisedResult(1))
})
test_that("helper table functions", {
  expect_equal(names(tableOptions()), c(
    'decimals', 'decimalMark', 'bigMark', 'keepNotFormatted', 'useFormatOrder',
    'delim', 'includeHeaderName', 'includeHeaderKey', 'na', 'title',
    'subtitle', 'caption', 'groupAsColumn', 'groupOrder', 'merge'
  ))
  expect_equal(
    tableStyle(type = "gt"),
    list(
      "header" = list(gt::cell_fill(color = "#c8c8c8"),
                      gt::cell_text(weight = "bold", align = "center")),
      "header_name" = list(gt::cell_fill(color = "#d9d9d9"),
                           gt::cell_text(weight = "bold", align = "center")),
      "header_level" = list(gt::cell_fill(color = "#e1e1e1"),
                            gt::cell_text(weight = "bold", align = "center")),
      "column_name" = list(gt::cell_text(weight = "bold", align = "center")),
      "group_label" = list(gt::cell_fill(color = "#e9e9e9"),
                           gt::cell_text(weight = "bold")),
      "title" = list(gt::cell_text(weight = "bold", size = 15, align = "center")),
      "subtitle" = list(gt::cell_text(weight = "bold", size = 12, align = "center")),
      "body" = list()
    ) |>
      rlang::expr()
  )
  expect_equal(
    tableStyle(type = "flextable"),
    list(
      "header" = list(
        "cell" = officer::fp_cell(background.color = "#c8c8c8"),
        "text" = officer::fp_text(bold = TRUE)
      ),
      "header_name" = list(
        "cell" = officer::fp_cell(background.color = "#d9d9d9"),
        "text" = officer::fp_text(bold = TRUE)
      ),
      "header_level" = list(
        "cell" = officer::fp_cell(background.color = "#e1e1e1"),
        "text" = officer::fp_text(bold = TRUE)
      ),
      "column_name" = list(
        "text" = officer::fp_text(bold = TRUE)
      ),
      "group_label" = list(
        "cell" = officer::fp_cell(
          background.color = "#e9e9e9",
          border = officer::fp_border(color = "gray")
        ),
        "text" = officer::fp_text(bold = TRUE)
      ),
      "title" = list(
        "text" = officer::fp_text(bold = TRUE, font.size = 15)
      ),
      "subtitle" = list(
        "text" = officer::fp_text(bold = TRUE, font.size = 12)
      ),
      "body" = list()
    ) |>
      rlang::expr()
  )

  expect_equal(
    tableStyle(type = "datatable"),
    list(caption = "caption-side: bottom; text-align: center;", scrollX = TRUE,
         scrollY = 400, scroller = TRUE, deferRender = TRUE, scrollCollapse = TRUE,
         fixedColumns = list(leftColumns = 1, rightColumns = 1), fixedHeader = TRUE,
         pageLength = 10, lengthMenu = c(5, 10, 20, 50, 100), filter = "bottom",
         searchHighlight = TRUE, rownames = FALSE) |>
      rlang::expr()
  )

  expect_equal(
    tableStyle(type = "reactable"),
    list(defaultColDef = reactable::colDef(sortable = TRUE, filterable = TRUE,
                                           resizable = TRUE), defaultColGroup = NULL, defaultSortOrder = "asc",
         defaultSorted = NULL, defaultPageSize = 10, defaultExpanded = TRUE,
         highlight = TRUE, outlined = FALSE, bordered = FALSE, borderless = FALSE,
         striped = TRUE, theme = NULL) |>
      rlang::expr()
  )

  expect_equal(
    tableStyle(type = "gt", style = "darwin"),
    list(
      "header" = list(
        gt::cell_fill(color = "#003399"),
        gt::cell_text(weight = "bold", color = "white", align = "center")
      ),
      "header_name" = list(
        gt::cell_fill(color = "#003399"),
        gt::cell_text(weight = "bold", color = "white", align = "center")
      ),
      "header_level" = list(
        gt::cell_fill(color = "#003399"),
        gt::cell_text(color = "white", weight = "bold", align = "center")
      ),
      "column_name" = list(
        gt::cell_fill(color = "#003399"),
        gt::cell_text(weight = "bold", color = "white", align = "center")
      ),
      "group_label" = list(
        gt::cell_fill(color = "#4a64bd"),
        gt::cell_borders(color = "#003399"),
        gt::cell_text(weight = "bold", color = "white")
      ),
      "title" = list(gt::cell_text(weight = "bold", size = 15, align = "center")),
      "subtitle" = list(
        gt::cell_text(weight = "bold", size = 12, align = "center")
      ),
      body = list(gt::cell_borders(color = "#003399"))
    ) |>
      rlang::expr()
  )

  expect_equal(
    tableStyle(type = "flextable", style = "darwin"),
    list(
      "header" = list(
        "cell" = officer::fp_cell(
          background.color = "#003399",
          border = officer::fp_border(color = "white")
        ),
        "text" = officer::fp_text(bold = TRUE, color = "white")
      ),
      "header_name" = list(
        "cell" = officer::fp_cell(
          background.color = "#003399",
          border = officer::fp_border(color = "white")
        ),
        "text" = officer::fp_text(bold = TRUE, color = "white")
      ),
      "header_level" = list(
        "cell" = officer::fp_cell(
          background.color = "#003399",
          border = officer::fp_border(color = "white"),
        ),
        "text" = officer::fp_text(bold = TRUE, color = "white")
      ),
      "column_name" = list(
        "cell" = officer::fp_cell(
          background.color = "#003399",
          border = officer::fp_border(color = "white"),
        ),
        "text" = officer::fp_text(bold = TRUE, color = "white")
      ),
      "group_label" = list(
        "cell" = officer::fp_cell(
          background.color = "#4a64bd",
          border = officer::fp_border(color = "#003399")
        ),
        "text" = officer::fp_text(bold = TRUE, color = "white")
      ),
      "title" = list(
        "text" = officer::fp_text(bold = TRUE, font.size = 15)
      ),
      "subtitle" = list(
        "text" = officer::fp_text(bold = TRUE, font.size = 12)
      ),
      "body" = list(
        "cell" = officer::fp_cell(border = officer::fp_border(color = "#003399"))
      )
    ) |>
      rlang::expr()
  )

  expect_error(tableStyle(type = "datatable", style = "darwin"))
  expect_error(tableStyle(type = "reactable", style = "darwin"))

  expect_true(all(c("tibble", "flextable", "gt") %in% tableType()))
})
