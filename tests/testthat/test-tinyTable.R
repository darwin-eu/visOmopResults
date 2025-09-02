test_that("tinytable", {
  table_to_format <- mockSummarisedResult() |>
    formatHeader(header = c("Study cohorts", "group_level", "Study strata", "strata_name", "strata_level"),
                 includeHeaderName = FALSE) |>
    dplyr::select(-result_id)
  # Input 1 ----
  # Title but no subtitle
  # Styles
  tinytableInternal <- tinytableInternal(
    table_to_format,
    style = list(
      "header" = list(background = "#c8c8c8", bold = FALSE),
      "header_name" = list(background = "#d9d9d9", bold = TRUE),
      "header_level" = list(background = "#e1e1e1", bold = TRUE),
      "column_name" = list(bold = TRUE),
      "title" = list(gt::cell_text(weight = "bold", color = "blue"))
    ),
    na = NULL,
    title = "Test 1",
    subtitle = NULL,
    caption = NULL,
    groupColumn = NULL,
    groupAsColumn = FALSE,
    groupOrder = NULL
  )

  # Spanners and column names
  expect_true(tinytableInternal@nhead == 5)
  expect_equal(
    tinytableInternal@names,
    c('cdm_name', 'group_name', 'variable_name', 'variable_level', 'estimate_name',
      'estimate_type', 'additional_name', 'additional_level', 'overall', '<40 &&& Male',
      '>=40 &&& Male', '<40 &&& Female', '>=40 &&& Female', 'Male', 'Female', '<40',
      '>=40', 'overall', '<40 &&& Male', '>=40 &&& Male', '<40 &&& Female',
      '>=40 &&& Female', 'Male', 'Female', '<40', '>=40')
  )
  # spanner styles
  expect_equal(
    getTinytableStyle(tinytableInternal, -1, 9),
    dplyr::tibble(
      "i" = -1, "j" = 9, "tabularray" = factor(""), "color" = NA, "background" = "#e1e1e1",
      "fontsize" = NA, "alignv" = NA, "line" = NA, "line_color" = NA,
      "line_width" = NA, "bold" = TRUE, "italic" = FALSE, "monospace" = FALSE,
      "strikeout" = FALSE, "underline" = FALSE, "indent" = NA, "colspan" = NA,
      "rowspan" = NA, "bootstrap_css" = NA, "align" = NA
    )
  )
  expect_equal(
    getTinytableStyle(tinytableInternal, -2, 9),
    dplyr::tibble(
      "i" = -2, "j" = 9, "tabularray" = factor(""), "color" = NA, "background" = "#c8c8c8",
      "fontsize" = NA, "alignv" = NA, "line" = NA, "line_color" = NA,
      "line_width" = NA, "bold" = FALSE, "italic" = FALSE, "monospace" = FALSE,
      "strikeout" = FALSE, "underline" = FALSE, "indent" = NA, "colspan" = NA,
      "rowspan" = NA, "bootstrap_css" = NA, "align" = NA
    )
  )
  # column names
  expect_equal(
    getTinytableStyle(tinytableInternal, 0, 2),
    dplyr::tibble(
      "i" = 0, "j" = 2, "tabularray" = factor(""), "color" = NA, "background" = NA_character_,
      "fontsize" = NA, "alignv" = NA, "line" = NA, "line_color" = NA,
      "line_width" = NA, "bold" = TRUE, "italic" = FALSE, "monospace" = FALSE,
      "strikeout" = FALSE, "underline" = FALSE, "indent" = NA, "colspan" = NA,
      "rowspan" = NA, "bootstrap_css" = NA, "align" = NA
    )
  )
  # na
  expect_true(is.na(tinytableInternal@data$variable_level[1]))
  # Group labels
  expect_true(length(tinytableInternal@group_data_i) == 0)

  # Input 2 ----
  table_to_format <- mockSummarisedResult() |>
    formatEstimateName(estimateName = c("N (%)" = "<count> (<percentage>%)",
                                        "N" = "<count>")) |>
    formatHeader(header = c("strata_name", "strata_level"),
                 includeHeaderName = TRUE) |>
    dplyr::select(-result_id)
  tinytableInternal <- tinytableInternal(
    table_to_format,
    style = list(
      "header" = list(
        "bold" = TRUE, background = "#003399", line = "bt", line_color = "white", color = "white"
      ),
      "header_name" = list(
        "bold" = TRUE, background = "#003399", line = "bt", line_color = "white", color = "white"
      ),
      "header_level" = list(
        "bold" = TRUE, background = "#003399", line = "bt", line_color = "white", color = "white"
      ),
      "column_name" = list(
        "bold" = TRUE, background = "#003399", line = "lbtr", line_color = "#003399", color = "white"
      ),
      "group_label" = list(
        "bold" = TRUE, background = "#4a64bd", line = "lbtr", line_color = "#003399", color = "white"
      ),
      "body" = list(line = "lbtr", line_color = "#003399")
    ),
    na = "-",
    title = "Title test 2",
    subtitle = "Subtitle for test 2",
    caption = "*This* is the caption",
    groupColumn = list("group_level" = "group_level"),
    groupAsColumn = FALSE,
    groupOrder = NULL,
    merge = "all_columns"
  )

  # Spanners and column names
  expect_true(tinytableInternal@nhead == 4)
  expect_equal(
    tinytableInternal@names,
    c('cdm_name', 'group_name', 'variable_name', 'variable_level', 'estimate_name',
      'estimate_type', 'additional_name', 'additional_level', 'overall', '<40 &&& Male',
      '>=40 &&& Male', '<40 &&& Female', '>=40 &&& Female', 'Male', 'Female', '<40', '>=40')
  )
  # spanner styles
  expect_equal(
    getTinytableStyle(tinytableInternal, -1, 9),
    dplyr::tibble(
      "i" = -1, "j" = 9, "tabularray" = factor(""), "color" = "white", "background" = "#003399",
      "fontsize" = NA, "alignv" = NA, "line" = "bt", "line_color" = "white",
      "line_width" = 0.1, "bold" = TRUE, "italic" = FALSE, "monospace" = FALSE,
      "strikeout" = FALSE, "underline" = FALSE, "indent" = NA, "colspan" = NA_integer_,
      "rowspan" = NA_integer_, "bootstrap_css" = NA, "align" = NA
    ),
    ignore_attr = TRUE
  )
  expect_equal(
    getTinytableStyle(tinytableInternal, -2, 9),
    dplyr::tibble(
      "i" = -2, "j" = 9, "tabularray" = factor(""), "color" = "white", "background" = "#003399",
      "fontsize" = NA, "alignv" = NA, "line" = "bt", "line_color" = "white",
      "line_width" = 0.1, "bold" = TRUE, "italic" = FALSE, "monospace" = FALSE,
      "strikeout" = FALSE, "underline" = FALSE, "indent" = NA, "colspan" = NA_integer_,
      "rowspan" = NA_integer_, "bootstrap_css" = NA, "align" = NA
    ),
    ignore_attr = TRUE
  )
  # column names
  expect_equal(
    getTinytableStyle(tinytableInternal, 0, 2),
    dplyr::tibble(
      "i" = 0, "j" = 2, "tabularray" = factor(""), "color" = "white", "background" = "#003399",
      "fontsize" = NA, "alignv" = NA, "line" = "lbtr", "line_color" = "#003399",
      "line_width" = 0.1, "bold" = TRUE, "italic" = FALSE, "monospace" = FALSE,
      "strikeout" = FALSE, "underline" = FALSE, "indent" = NA, "colspan" = NA_integer_,
      "rowspan" = NA_integer_, "bootstrap_css" = NA, "align" = NA
    ),
    ignore_attr = TRUE
  )
  # na
  expect_true(tinytableInternal@data$variable_level[1] == "-")
  # Group labels
  expect_equal(tinytableInternal@group_index_i, c(1, 7), ignore_attr = TRUE)

  # caption
  expect_true(tinytableInternal@caption == "*This* is the caption")

  # Input 3 ----
  table_to_format <- mockSummarisedResult() |>
    formatEstimateName(estimateName = c("N (%)" = "<count> (<percentage>%)",
                                        "N" = "<count>")) |>
    formatHeader(header = c("strata_name", "strata_level"),
                 delim = ":",
                 includeHeaderName = TRUE) |>
    dplyr::select(-result_id)
  tinytableInternal <- tinytableInternal(
    table_to_format,
    delim = ":",
    style = list(
      "body" = list(line_color = "red", line = "lbtr"),
      "group_label" = list(background = "#e1e1e1"),
      "header_name" = list(background = "black", color = "white")
    ),
    na = "-",
    title = "Title test 2",
    subtitle = "Subtitle for test 2",
    caption = "*This* is the caption",
    groupColumn = list("group_level" = "group_level"),
    groupAsColumn = TRUE,
    groupOrder = c("cohort2", "cohort1")
  )
  # groupAsColumn
  expect_equal(tinytableInternal@data$group_level, c(rep("cohort2", 5), rep("cohort1", 5)))
})
