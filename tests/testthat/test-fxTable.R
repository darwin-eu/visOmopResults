test_that("fxTableInternal", {
  table_to_format <- mockSummarisedResult() |>
    formatHeader(header = c("Study cohorts", "group_level", "Study strata", "strata_name", "strata_level"),
                 includeHeaderName = FALSE) |>
    dplyr::select(-result_id)
  # Input 1 ----
  # Title but no subtitle
  # Styles
  fxResult <- fxTableInternal(
    table_to_format,
    style = list(
      "header" = list( "cell" = officer::fp_cell(background.color = "#c8c8c8"),
                       "text" = officer::fp_text(bold = TRUE)),
      "header_name" = list("cell" = officer::fp_cell(background.color = "#d9d9d9"),
                           "text" = officer::fp_text(bold = TRUE)),
      "header_level" = list("cell" = officer::fp_cell(background.color = "#e1e1e1"),
                            "text" = officer::fp_text(bold = TRUE)),
      "column_name" = list("text" = officer::fp_text(bold = TRUE)),
      "title" = list("text" = officer::fp_text(bold = TRUE, color = "blue"))
    ),
    na = NULL,
    title = "Test 1",
    subtitle = NULL,
    caption = NULL,
    groupColumn = NULL,
    groupAsColumn = FALSE,
    groupOrder = NULL
  )

  # Spanners
  header_col_1 <- fxResult$header$dataset[, "Study cohorts\ncohort1\nStudy strata\noverall\noverall"] # cohort 1 - overall
  expect_equal(header_col_1, c("Test 1", "Study cohorts", "cohort1", "Study strata", "overall",
                               "Study cohorts\ncohort1\nStudy strata\noverall\noverall"))

  # Spanner styles
  header_col_style <- fxResult$header$styles$cells$background.color$data[, "Study cohorts\ncohort1\nStudy strata\noverall\noverall"]
  expect_equal(header_col_style, c("#c8c8c8", "#c8c8c8", "#e1e1e1", "#c8c8c8", "#e1e1e1", "#e1e1e1"))
  expect_equal(fxResult$header$styles$cells$background.color$data[, "cdm_name"] |> unique(), "transparent")
  expect_equal(fxResult$header$styles$cells$border.width.top$data[, "cdm_name"] |> unique(), c(1.5, 0))
  expect_equal(fxResult$header$styles$cells$border.color.left$data[, "cdm_name"] |> unique(), "black")
  expect_equal(fxResult$header$styles$text$bold$data[, "cdm_name"] |> unique(), TRUE)
  expect_equal(fxResult$header$styles$text$color$data[, "cdm_name"][1], "blue")

  # default fxTableInternal format
  expect_equal(fxResult$body$styles$cells$border.width.top$data[, "cdm_name"] |> unique(), 0)
  expect_equal(fxResult$body$styles$cells$border.color.left$data[, "cdm_name"] |> unique(), "black")
  expect_equal(fxResult$body$styles$cells$background.color$data[, "cdm_name"] |> unique(), "transparent")

  # caption
  expect_null(fxResult$caption$value)

  # Alignment
  expect_equal(fxResult$body$styles$pars$text.align$data[1,9:26] |> unique(), "left")
  expect_equal(fxResult$body$styles$pars$text.align$data[3,9:26] |> unique(), "left")
  expect_equal(fxResult$body$styles$pars$text.align$data[5,9:26] |> unique(), "left")
  expect_equal(fxResult$body$styles$pars$text.align$data[1,1:8] |> unique(), "left")
  expect_equal(fxResult$body$styles$pars$text.align$data[3,1:8] |> unique(), "left")
  expect_equal(fxResult$body$styles$pars$text.align$data[5,1:8] |> unique(), "left")

  # Input 2 ----
  table_to_format <- mockSummarisedResult() |>
    formatEstimateName(estimateName = c("N (%)" = "<count> (<percentage>%)",
                                        "N" = "<count>")) |>
    formatHeader(header = c("strata_name", "strata_level"),
                 includeHeaderName = TRUE) |>
    dplyr::select(-result_id)
  fxResult <- fxTableInternal(
    table_to_format,
    style = list(
      "subtitle" = list("text" = officer::fp_text(bold = TRUE, font.size = 12, color = "blue")),
      "body" = list("text" = officer::fp_text(color = "red"), "cell" = officer::fp_cell(border = officer::fp_border())),
      "group_label" = list("cell" = officer::fp_cell(background.color = "#e1e1e1")),
      "header_name" = list("cell" = officer::fp_cell(background.color = "black"), "text" = officer::fp_text(color = "white")),
      "column_name" = list("text" = officer::fp_text(bold = TRUE))
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

  # Spanners
  header_col_1 <- fxResult$header$dataset[, "strata_name\noverall\nstrata_level\noverall"] # overall
  expect_equal(header_col_1, c("Title test 2", "Subtitle for test 2", "strata_name", "overall",
                               "strata_level", "strata_name\noverall\nstrata_level\noverall"))

  # Spanner styles
  header_col_style <- fxResult$header$styles$cells$background.color$data[, "strata_name\noverall\nstrata_level\noverall"]
  expect_equal(header_col_style, c("black", "black", "black", "transparent", "black", "transparent"))
  expect_equal(fxResult$header$styles$cells$background.color$data[, "cdm_name"] |> unique(), "transparent")
  expect_equal(fxResult$header$styles$cells$border.width.top$data[, "cdm_name"] |> unique(), c(1.5, 0))
  expect_equal(fxResult$header$styles$cells$border.color.left$data[, "cdm_name"] |> unique(), "black")
  expect_equal(fxResult$header$styles$text$bold$data[, "cdm_name"] |> unique(), TRUE)
  expect_equal(fxResult$header$styles$text$color$data[, "cdm_name"], c("black", "blue", "black", "black", "black", "black"))
  expect_equal(fxResult$header$styles$text$color$data[, "strata_name\nage_group\nstrata_level\n>=40"],
               c("white", "blue", "white", "black", "white", "black"))

  # body
  expect_equal(fxResult$body$styles$cells$border.width.top$data[, "cdm_name"] |> unique(), c(0,1))
  expect_equal(fxResult$body$styles$cells$border.color.left$data[, "cdm_name"] |> unique(), "black")
  expect_equal(fxResult$body$styles$cells$background.color$data[, "cdm_name"],
               c("#e1e1e1", "transparent", "transparent", "transparent", "transparent", "transparent",
                 "#e1e1e1", "transparent", "transparent", "transparent", "transparent", "transparent"))
  expect_equal(fxResult$body$styles$text$color$data[, "cdm_name"] |> unique(), "red")

  # caption
  expect_equal(fxResult$caption$value, "*This* is the caption")

  # group label
  expect_equal(fxResult$body$spans$rows[1,], c(17, rep(0, 16)))
  expect_equal(fxResult$body$spans$rows[7,], c(17, rep(0, 16)))
  expect_equal(fxResult$body$spans$rows[3,], rep(1, 17))

  # Input 3 ----
  table_to_format <- mockSummarisedResult() |>
    formatEstimateName(estimateName = c("N (%)" = "<count> (<percentage>%)",
                                        "N" = "<count>")) |>
    formatHeader(header = c("strata_name", "strata_level"),
                 delim = ":",
                 includeHeaderName = TRUE) |>
    dplyr::select(-result_id)
  fxResult <- fxTableInternal(
    table_to_format,
    delim = ":",
    style = list(
      "subtitle" = list("text" = officer::fp_text(bold = TRUE, font.size = 12, color = "blue")),
      "body" = list("text" = officer::fp_text(color = "red"), "cell" = officer::fp_cell(border = officer::fp_border())),
      "group_label" = list("cell" = officer::fp_cell(background.color = "#e1e1e1", border = officer::fp_border(color = "black"))),
      "header_name" = list("cell" = officer::fp_cell(background.color = "black"), "text" = officer::fp_text(color = "white"))
    ),
    na = "-",
    title = "Title test 2",
    subtitle = "Subtitle for test 2",
    caption = "*This* is the caption",
    groupColumn = list("group_level" = "group_level"),
    groupAsColumn = TRUE,
    groupOrder = c("cohort2", "cohort1")
  )

  # group label
  expect_equal(fxResult$body$spans$columns[,1], c(5, rep(0,4), 5, rep(0,4)))
  expect_equal(fxResult$body$dataset[,1] |>  levels(), c("cohort2", "cohort1"))
  expect_equal(fxResult$body$spans$rows[3,], rep(1, 18))
  expect_equal(fxResult$body$styles$cells$background.color$data[,1] |> unique(), "#e1e1e1")
  expect_equal(fxResult$body$styles$cells$background.color$data[,2] |> unique(), "transparent")
})

test_that("fxTableInternal, test default styles and NULL", {
  table_to_format <- mockSummarisedResult() |>
    formatHeader(header = c("Study cohorts", "group_level", "Study strata", "strata_name", "strata_level"),
                 includeHeaderName = FALSE) |>
    dplyr::select(-result_id)
  # Input 1: NULL ----
  fxResult <- fxTableInternal(
    table_to_format,
    style = NULL,
    na = NULL,
    title = "Test 1",
    subtitle = NULL,
    caption = NULL,
    groupColumn = NULL,
    groupAsColumn = FALSE,
    groupOrder = NULL
  )

  # Spanner styles
  expect_equal(unique(fxResult$header$styles$cells$background.color$data[, "Study cohorts\ncohort1\nStudy strata\noverall\noverall"]),
               "transparent")
  expect_equal(fxResult$header$styles$cells$background.color$data[, "cdm_name"] |> unique(), "transparent")
  expect_equal(fxResult$header$styles$cells$border.width.top$data[2,] |> unique(), 1.5)
  expect_equal(fxResult$header$styles$cells$border.width.top$data[3,] |> unique(), 0)
  expect_equal(fxResult$header$styles$cells$border.color.left$data[, "cdm_name"] |> unique(), "black")
  expect_equal(fxResult$header$styles$cells$border.color.left$data[2:6, "cdm_name"] |> unique(), "black")
  expect_false(fxResult$header$styles$text$bold$data[1, "cdm_name"] |> unique())
  expect_false(fxResult$header$styles$text$bold$data[2:6, "cdm_name"] |> unique())

  # default fxTableInternal format
  expect_equal(fxResult$body$styles$cells$border.width.top$data[, "cdm_name"] |> unique(), 0)
  expect_equal(fxResult$body$styles$cells$border.color.left$data[, "cdm_name"] |> unique(), "black")
  expect_equal(fxResult$body$styles$cells$background.color$data[, "cdm_name"] |> unique(), "transparent")

  # Input 2 ----
  table_to_format <- mockSummarisedResult() |>
    formatEstimateName(estimateName = c("N (%)" = "<count> (<percentage>%)",
                                        "N" = "<count>")) |>
    formatHeader(header = c("Strata", "strata_name", "strata_level"),
                 includeHeaderName = TRUE) |>
    dplyr::select(-result_id)
  style <- validateStyle(style = "default", obj = "table", type = "flextable")
  fxResult <- fxTableInternal(
    table_to_format,
    style = style,
    na = "-",
    title = "Title test 2",
    subtitle = "Subtitle for test 2",
    caption = "*This* is the caption",
    groupColumn = list("group_level" = "group_level"),
    groupAsColumn = FALSE,
    groupOrder = NULL
  )

  # Spanner styles
  header_col_style <- fxResult$header$styles$cells$background.color$data[, "Strata\nstrata_name\noverall\nstrata_level\noverall"]
  expect_equal(header_col_style, c("transparent", "transparent", "#c8c8c8", "#d9d9d9", "#e1e1e1", "#d9d9d9", "#e1e1e1"))
  expect_equal(fxResult$header$styles$cells$background.color$data[, "cdm_name"] |> unique(), c("transparent", "#e1e1e1"))
  expect_equal(fxResult$header$styles$cells$border.width.top$data[, "cdm_name"] |> unique(), c(1))
  expect_equal(fxResult$header$styles$cells$border.color.left$data[, "cdm_name"] |> unique(), c("#e1e1e1", "#c8c8c8"))
  expect_true(fxResult$header$styles$text$bold$data[, "cdm_name"] |> unique())
  expect_equal(fxResult$header$styles$text$color$data[, "cdm_name"] |> unique(), "black")
  expect_equal(fxResult$header$styles$text$color$data[, "cdm_name"] |> unique(), "black")
  expect_equal(fxResult$header$styles$text$font.size$data[, "cdm_name"] |> unique(), c(15, 12, 10))

  # body
  expect_equal(fxResult$body$styles$cells$border.width.top$data[, "cdm_name"] |> unique(), 1)
  expect_equal(fxResult$body$styles$cells$border.color.left$data[, "cdm_name"] |> unique(), "#c8c8c8")
  expect_equal(fxResult$body$styles$cells$background.color$data[, "cdm_name"],
               c("#e9e9e9", "transparent", "transparent", "transparent", "transparent","transparent",
                 "#e9e9e9","transparent", "transparent", "transparent", "transparent", "transparent"))
  expect_equal(fxResult$body$styles$text$color$data[, "cdm_name"] |> unique(), "black")
})

test_that("fxTableInternal, test merge", {
  table_to_format<- mockSummarisedResult() |>
    formatHeader(header = c("strata_name", "strata_level")) |>
    dplyr::select(-result_id)
  style <- validateStyle(style = "default", obj = "table", type = "flextable")
  fxResult <- fxTableInternal(
    x = table_to_format,
    style = style,
    na = "-",
    title = "Title test 2",
    subtitle = "Subtitle for test 2",
    caption = "*This* is the caption",
    groupColumn = list("group_level" = "group_level"),
    groupAsColumn = FALSE,
    groupOrder = NULL,
    merge = "all_columns"
  )

  expect_equal(fxResult$body$styles$cells$border.color.top$data[,1] |> unique(),
               c("#c8c8c8"))
  expect_equal(fxResult$body$styles$cells$border.color.top$data[,2] |> unique(),
               c("#c8c8c8"))
  expect_equal(fxResult$body$styles$cells$border.color.top$data[,5] |> unique(),
               c("#c8c8c8"))
  expect_equal(fxResult$body$styles$cells$border.color.top$data[,16] |> unique(),
               c("#c8c8c8"))

  # merge = c("cdm_name", "variable_name")
  fxResult <- fxTableInternal(
    table_to_format,
    style =  style,
    na = "-",
    title = "Title test 2",
    subtitle = "Subtitle for test 2",
    caption = "*This* is the caption",
    groupColumn = list("group_level" = "group_level"),
    groupAsColumn = FALSE,
    groupOrder = NULL,
    merge = c("cdm_name", "variable_name")
  )
  expect_equal(fxResult$body$styles$cells$border.color.top$data[,1] |> unique(),
               c("#c8c8c8"))
  expect_equal(fxResult$body$styles$cells$border.color.top$data[,2] |> unique(),
               c("#c8c8c8"))
  expect_equal(fxResult$body$styles$cells$border.color.top$data[,4] |> unique(),
               c("#c8c8c8"))
})

test_that("multiple groupColumn", {
  table_to_format <- mockSummarisedResult() |>
    formatEstimateName(estimateName = c("N (%)" = "<count> (<percentage>%)",
                                        "N" = "<count>")) |>
    formatHeader(header = c("strata_name", "strata_level"),
                 delim = ":",
                 includeHeaderName = TRUE) |>
    dplyr::select(-result_id)

  fxResult <- fxTableInternal(
    table_to_format,
    delim = ":",
    style = list(
      "subtitle" = list("text" = officer::fp_text(bold = TRUE, font.size = 12, color = "blue")),
      "body" = list("text" = officer::fp_text(color = "red"), "cell" = officer::fp_cell(border = officer::fp_border())),
      "group_label" = list("cell" = officer::fp_cell(background.color = "#e1e1e1"), "text" = officer::fp_text(color = "blue")),
      "header_name" = list("cell" = officer::fp_cell(background.color = "black"), "text" = officer::fp_text(color = "white"))
    ),
    na = "-",
    title = "Title test 2",
    subtitle = "Subtitle for test 2",
    caption = "*This* is the caption",
    groupColumn = list("group_name_group_level" = c("group_name", "group_level")),
    groupAsColumn = TRUE
  )

  # Spanners
  header_col_1 <- fxResult$header$dataset[, "strata_name:overall:strata_level:overall"] # overall
  expect_equal(header_col_1, c("Title test 2", "Subtitle for test 2", "strata_name", "overall",
                               "strata_level", "strata_name:overall:strata_level:overall"))

  # Spanner styles
  header_col_style <- fxResult$header$styles$cells$background.color$data[, "strata_name:overall:strata_level:overall"]
  expect_equal(header_col_style, c("black", "black", "black", "transparent", "black", "transparent"))
  expect_equal(fxResult$header$styles$cells$background.color$data[, "cdm_name"] |> unique(), "transparent")
  expect_equal(fxResult$header$styles$cells$border.width.top$data[, "cdm_name"] |> unique(), c(1.5, 0))
  expect_equal(fxResult$header$styles$cells$border.color.left$data[, "cdm_name"] |> unique(), "black")
  expect_equal(all(fxResult$header$styles$text$bold$data[, "cdm_name"] == c(FALSE, TRUE, FALSE, FALSE, FALSE, FALSE)), TRUE)
  expect_equal(fxResult$header$styles$text$color$data[, "cdm_name"], c("black", "blue", "black", "black", "black", "black"))
  expect_equal(fxResult$header$styles$text$color$data[, "strata_name:age_group:strata_level:>=40"],
               c("white", "blue", "white", "black", "white", "black"))

  # body
  expect_equal(fxResult$body$styles$cells$border.width.top$data[, "cdm_name"] |> unique(), 1)
  expect_equal(fxResult$body$styles$cells$border.color.left$data[, "cdm_name"] |> unique(), "black")
  expect_equal(fxResult$body$styles$text$color$data[, "cdm_name"] |> unique(), "red")
  expect_equal(fxResult$body$styles$cells$border.width.top$data[, "group_name_group_level"] |> unique(), 0)
  expect_equal(fxResult$body$styles$cells$border.color.left$data[, "group_name_group_level"] |> unique(), "black")
  expect_equal(fxResult$body$styles$text$color$data[, "group_name_group_level"] |> unique(), "blue")

  # caption
  expect_equal(fxResult$caption$value, "*This* is the caption")

  # group label
  expect_equal(fxResult$body$spans$rows[1,], rep(1, 17))
})

test_that("abort when groupOrder doesn't match groupName", {
  x <- mockSummarisedResult()
  expect_error(fxTableInternal(x, groupColumn = c("variable_name", "variable_level"), groupOrder = "variable_name"))
})

test_that("", {
  expect_no_error(
    dplyr::tibble(
      cdm_name = "mock", age = c("under 40"), estimate_name = "count",
      estimate_type = "integer", estimate_value = "0"
    ) |>
      visTable(
        groupColumn = c("age", "cdm_name"), type = "flextable", hide = "estimate_type"
      )
  )
})
