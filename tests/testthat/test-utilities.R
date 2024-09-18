test_that("check utilities", {
  expect_error(validateSummarisedResult(1))
})
test_that("helper table functions", {
  expect_equal(names(optionsTable()), c(
    'decimals', 'decimalMark', 'bigMark', 'keepNotFormatted', 'useFormatOrder',
    'delim', 'includeHeaderName', 'includeHeaderKey', 'style', 'na', 'title',
    'subtitle', 'caption', 'groupAsColumn', 'groupOrder', 'merge'
  ))
  expect_equal(
    gtStyle(),
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
    flextableStyle(),
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
})
