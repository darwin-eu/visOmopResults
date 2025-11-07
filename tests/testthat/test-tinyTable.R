test_that("tinytable", {
  skip_on_cran()
  setGlobalTableOptions()
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
    caption = NULL,
    groupColumn = NULL,
    groupAsColumn = FALSE,
    groupOrder = NULL
  )

  # Snapshot
  expect_snapshot(tinytableInternal)

  # Input 2 ----
  table_to_format <- mockSummarisedResult() |>
    dplyr::union_all(mockSummarisedResult() |> dplyr::mutate(group_level = dplyr::if_else(group_level == "cohort1", "cohort3", "cohort4"))) |>
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
    caption = "*This* is the caption",
    groupColumn = list("group_level" = "group_level"),
    groupAsColumn = FALSE,
    groupOrder = NULL,
    merge = "all_columns"
  )

  # Snapshot
  expect_snapshot(tinytableInternal)

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
    caption = "*This* is the caption",
    groupColumn = list("group_level" = "group_level"),
    groupAsColumn = TRUE,
    groupOrder = c("cohort2", "cohort1")
  )
  # groupAsColumn
  expect_equal(tinytableInternal@data$group_level, c(rep("cohort2", 5), rep("cohort1", 5)))
})
