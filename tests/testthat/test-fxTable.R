test_that("fxTable", {
  table_to_format <- mockSummarisedResult() |>
    spanHeader(header = c("Study cohorts", "group_level", "Study strata", "strata_name", "strata_level"),
               includeHeaderName = FALSE)
  # Input 1 ----
  # Title but no subtitle
  # Styles
  fxResult <- fxTable(
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
    groupNameCol = NULL,
    groupNameAsColumn = FALSE,
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
  expect_equal(fxResult$header$styles$cells$border.width.top$data[, "cdm_name"] |> unique(), 2)
  expect_equal(fxResult$header$styles$cells$border.color.left$data[, "cdm_name"] |> unique(), "gray")
  expect_equal(fxResult$header$styles$text$bold$data[, "cdm_name"] |> unique(), TRUE)
  expect_equal(fxResult$header$styles$text$color$data[, "cdm_name"][1], "blue")

  # na
  expect_equal(fxResult$body$dataset$result_type |> unique(), as.character(NA))

  # default fxTable format
  expect_equal(fxResult$body$styles$cells$border.width.top$data[, "cdm_name"] |> unique(), 1)
  expect_equal(fxResult$body$styles$cells$border.color.left$data[, "cdm_name"] |> unique(), "gray")
  expect_equal(fxResult$body$styles$cells$background.color$data[, "cdm_name"] |> unique(), "transparent")

  # caption
  expect_null(fxResult$caption$value)


  # Input 2 ----
  table_to_format <- mockSummarisedResult() |>
    formatEstimateName(estimateNameFormat = c("N (%)" = "<count> (<percentage>%)",
                                              "N" = "<count>")) |>
    spanHeader(header = c("strata_name", "strata_level"),
               includeHeaderName = TRUE)
  fxResult <- fxTable(
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
    groupNameCol = "group_level",
    groupNameAsColumn = FALSE,
    groupOrder = NULL
  )

  # Spanners
  header_col_1 <- fxResult$header$dataset[, "strata_name\noverall\nstrata_level\noverall"] # overall
  expect_equal(header_col_1, c("Title test 2", "Subtitle for test 2", "strata_name", "overall",
                                  "strata_level", "strata_name\noverall\nstrata_level\noverall"))

  # Spanner styles
  header_col_style <- fxResult$header$styles$cells$background.color$data[, "strata_name\noverall\nstrata_level\noverall"]
  expect_equal(header_col_style, c("black", "black", "black", "transparent", "black", "transparent"))
  expect_equal(fxResult$header$styles$cells$background.color$data[, "cdm_name"] |> unique(), "transparent")
  expect_equal(fxResult$header$styles$cells$border.width.top$data[, "cdm_name"] |> unique(), 2)
  expect_equal(fxResult$header$styles$cells$border.color.left$data[, "cdm_name"] |> unique(), "gray")
  expect_equal(fxResult$header$styles$text$bold$data[, "cdm_name"] |> unique(), TRUE)
  expect_equal(fxResult$header$styles$text$color$data[, "cdm_name"], c("black", "blue", "black", "black", "black", "black"))
  expect_equal(fxResult$header$styles$text$color$data[, "strata_name\nage_group\nstrata_level\n>=40"],
               c("black", "blue", "white", "black", "white", "black"))

  # na
  expect_equal(fxResult$body$dataset$result_type |> unique(), c(as.character(NA), "-"))

  # body
  expect_equal(fxResult$body$styles$cells$border.width.top$data[, "cdm_name"] |> unique(), c(0,1))
  expect_equal(fxResult$body$styles$cells$border.color.left$data[, "cdm_name"] |> unique(), "black")
  expect_equal(fxResult$body$styles$cells$background.color$data[, "cdm_name"],
               c("#e1e1e1", "transparent", "transparent", "transparent", "transparent", "#e1e1e1",
                 "transparent", "transparent", "transparent", "transparent"))
  expect_equal(fxResult$body$styles$text$color$data[, "cdm_name"] |> unique(), "red")

  # caption
  expect_equal(fxResult$caption$value, "*This* is the caption")

  # group label
  expect_equal(fxResult$body$spans$rows[1,], c(1, 20, rep(0, 19)))
  expect_equal(fxResult$body$spans$rows[6,], c(1, 20, rep(0, 19)))
  expect_equal(fxResult$body$spans$rows[3,], rep(1, 21))

  # Input 3 ----
  table_to_format <- mockSummarisedResult() |>
    formatEstimateName(estimateNameFormat = c("N (%)" = "<count> (<percentage>%)",
                                              "N" = "<count>")) |>
    spanHeader(header = c("strata_name", "strata_level"),
               delim = ":",
               includeHeaderName = TRUE)
  fxResult <- fxTable(
    table_to_format,
    delim = ":",
    style = list(
      "subtitle" = list("text" = officer::fp_text(bold = TRUE, font.size = 12, color = "blue")),
      "body" = list("text" = officer::fp_text(color = "red"), "cell" = officer::fp_cell(border = officer::fp_border())),
      "group_label" = list("cell" = officer::fp_cell(background.color = "#e1e1e1")),
      "header_name" = list("cell" = officer::fp_cell(background.color = "black"), "text" = officer::fp_text(color = "white"))
    ),
    na = "-",
    title = "Title test 2",
    subtitle = "Subtitle for test 2",
    caption = "*This* is the caption",
    groupNameCol = "group_level",
    groupNameAsColumn = TRUE,
    groupOrder = c("cohort2", "cohort1")
  )

  # group label
  expect_equal(fxResult$body$spans$columns[,1], c(4, rep(0,3), 4, rep(0,3)))
  expect_equal(fxResult$body$dataset[,1] |>  levels(), c("cohort2", "cohort1"))
  expect_equal(fxResult$body$spans$rows[3,], rep(1, 21))
  expect_equal(fxResult$body$styles$cells$background.color$data[,1] |> unique(), "#e1e1e1")
  expect_equal(fxResult$body$styles$cells$background.color$data[,2] |> unique(), "transparent")

  # Wrong inputs ----
  expect_error(fxTable(
    table_to_format,
    style = NA,
    na = "-",
    title = "Title test 2",
    subtitle = "Subtitle for test 2",
    caption = "*This* is the caption",
    groupNameCol = "group_level",
    groupNameAsColumn = TRUE,
    groupOrder = c("cohort2", "cohort1")
  ))
})
