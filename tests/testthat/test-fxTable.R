test_that("fxTable", {
  table_to_format <- mockSummarisedResult() |>
    formatTable(header = c("Study cohorts", "group_level", "Study strata", "strata_name", "strata_level"),
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
  expect_equal(fxResult$header$styles$cells$border.width.top$data[, "cdm_name"] |> unique(), 1.2)
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

  # Alignment
  expect_equal(fxResult$body$styles$pars$text.align$data[1,12:29] |> unique(), "right")
  expect_equal(fxResult$body$styles$pars$text.align$data[3,12:29] |> unique(), "right")
  expect_equal(fxResult$body$styles$pars$text.align$data[5,12:29] |> unique(), "right")
  expect_equal(fxResult$body$styles$pars$text.align$data[1,1:11] |> unique(), "left")
  expect_equal(fxResult$body$styles$pars$text.align$data[3,1:11] |> unique(), "left")
  expect_equal(fxResult$body$styles$pars$text.align$data[5,1:11] |> unique(), "left")

  # Input 2 ----
  table_to_format <- mockSummarisedResult() |>
    formatEstimateName(estimateNameFormat = c("N (%)" = "<count> (<percentage>%)",
                                              "N" = "<count>")) |>
    formatTable(header = c("strata_name", "strata_level"),
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
  expect_equal(fxResult$header$styles$cells$border.width.top$data[, "cdm_name"] |> unique(), 1.2)
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
               c("#e1e1e1", "transparent", "transparent", "transparent", "transparent", "transparent",
                 "#e1e1e1", "transparent", "transparent", "transparent", "transparent", "transparent"))
  expect_equal(fxResult$body$styles$text$color$data[, "cdm_name"] |> unique(), "red")

  # caption
  expect_equal(fxResult$caption$value, "*This* is the caption")

  # group label
  expect_equal(fxResult$body$spans$rows[1,], c(1, 20, rep(0, 19)))
  expect_equal(fxResult$body$spans$rows[7,], c(1, 20, rep(0, 19)))
  expect_equal(fxResult$body$spans$rows[3,], rep(1, 21))

  # Input 3 ----
  table_to_format <- mockSummarisedResult() |>
    formatEstimateName(estimateNameFormat = c("N (%)" = "<count> (<percentage>%)",
                                              "N" = "<count>")) |>
    formatTable(header = c("strata_name", "strata_level"),
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
  expect_equal(fxResult$body$spans$columns[,1], c(5, rep(0,4), 5, rep(0,4)))
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

test_that("fxTable, test default styles and NULL", {
  table_to_format <- mockSummarisedResult() |>
    formatTable(header = c("Study cohorts", "group_level", "Study strata", "strata_name", "strata_level"),
                includeHeaderName = FALSE)
  # Input 1: NULL ----
  fxResult <- fxTable(
    table_to_format,
    style = NULL,
    na = NULL,
    title = "Test 1",
    subtitle = NULL,
    caption = NULL,
    groupNameCol = NULL,
    groupNameAsColumn = FALSE,
    groupOrder = NULL
  )

  # Spanner styles
  expect_equal(unique(fxResult$header$styles$cells$background.color$data[, "Study cohorts\ncohort1\nStudy strata\noverall\noverall"]),
               "transparent")
  expect_equal(fxResult$header$styles$cells$background.color$data[, "cdm_name"] |> unique(), "transparent")
  expect_equal(fxResult$header$styles$cells$border.width.top$data[1,] |> unique(), 1.2)
  expect_equal(fxResult$header$styles$cells$border.width.top$data[2,] |> unique(), 1.2)
  expect_equal(fxResult$header$styles$cells$border.width.top$data[3,] |> unique(), 1.2)
  expect_equal(fxResult$header$styles$cells$border.color.left$data[, "cdm_name"] |> unique(), "gray")
  expect_equal(fxResult$header$styles$cells$border.color.left$data[2:6, "cdm_name"] |> unique(), "gray")
  expect_true(fxResult$header$styles$text$bold$data[1, "cdm_name"] |> unique())
  expect_false(fxResult$header$styles$text$bold$data[2:6, "cdm_name"] |> unique())


  # default fxTable format
  expect_equal(fxResult$body$styles$cells$border.width.top$data[, "cdm_name"] |> unique(), 1)
  expect_equal(fxResult$body$styles$cells$border.color.left$data[, "cdm_name"] |> unique(), "gray")
  expect_equal(fxResult$body$styles$cells$background.color$data[, "cdm_name"] |> unique(), "transparent")


  # Input 2 ----
  table_to_format <- mockSummarisedResult() |>
    formatEstimateName(estimateNameFormat = c("N (%)" = "<count> (<percentage>%)",
                                              "N" = "<count>")) |>
    formatTable(header = c("Strata", "strata_name", "strata_level"),
                includeHeaderName = TRUE)
  fxResult <- fxTable(
    table_to_format,
    style = "default",
    na = "-",
    title = "Title test 2",
    subtitle = "Subtitle for test 2",
    caption = "*This* is the caption",
    groupNameCol = "group_level",
    groupNameAsColumn = FALSE,
    groupOrder = NULL
  )

  # Spanner styles
  header_col_style <- fxResult$header$styles$cells$background.color$data[, "Strata\nstrata_name\noverall\nstrata_level\noverall"]
  expect_equal(header_col_style, c("#c8c8c8", "#c8c8c8", "#c8c8c8", "#d9d9d9", "#e1e1e1", "#d9d9d9", "#e1e1e1"))
  expect_equal(fxResult$header$styles$cells$background.color$data[, "cdm_name"] |> unique(), "transparent")
  expect_equal(fxResult$header$styles$cells$border.width.top$data[, "cdm_name"] |> unique(), 1.2)
  expect_equal(fxResult$header$styles$cells$border.color.left$data[, "cdm_name"] |> unique(), "gray")
  expect_true(fxResult$header$styles$text$bold$data[, "cdm_name"] |> unique())
  expect_equal(fxResult$header$styles$text$color$data[, "cdm_name"] |> unique(), "black")
  expect_equal(fxResult$header$styles$text$color$data[, "cdm_name"] |> unique(), "black")
  expect_equal(fxResult$header$styles$text$font.size$data[, "cdm_name"] |> unique(), c(15, 12, 10))

  # body
  expect_equal(fxResult$body$styles$cells$border.width.top$data[, "cdm_name"] |> unique(), 1)
  expect_equal(fxResult$body$styles$cells$border.color.left$data[, "cdm_name"] |> unique(), "gray")
  expect_equal(fxResult$body$styles$cells$background.color$data[, "cdm_name"],
               c("#e9e9e9", "transparent", "transparent", "transparent", "transparent","transparent",
                 "#e9e9e9","transparent", "transparent", "transparent", "transparent", "transparent"))
  expect_equal(fxResult$body$styles$text$color$data[, "cdm_name"] |> unique(), "black")

  #Input 3: woring name style ----
  expect_warning(
    fxResult <- fxTable(
      table_to_format,
      style = "heythere",
      na = "-",
      title = "Title test 2",
      subtitle = "Subtitle for test 2",
      caption = "*This* is the caption",
      groupNameCol = "group_level",
      groupNameAsColumn = FALSE,
      groupOrder = NULL
    ),
    "does not correspon to any of our defined styles. Returning default."
  )
})

test_that("fxTable, test colsToMergeRows", {
  table_to_format<- mockSummarisedResult() |>
  formatTable(header = c("strata_name", "strata_level"))
  # colsToMergeRows = "all"
  fxResult <- fxTable(
    x = table_to_format,
    style = "default",
    na = "-",
    title = "Title test 2",
    subtitle = "Subtitle for test 2",
    caption = "*This* is the caption",
    groupNameCol = "group_level",
    groupNameAsColumn = FALSE,
    groupOrder = NULL,
    colsToMergeRows = "all_columns"
  )

  expect_equal(fxResult$body$styles$cells$border.color.top$data[,1],
               c("gray", "black", "black", "black", "black", "black", "black", "black",
                 "gray", "black", "black", "black", "black", "black", "black", "black"))
  expect_equal(fxResult$body$styles$cells$border.color.top$data[,2],
               c("gray", "gray", "black", "black", "black", "black", "black", "black",
                 "gray", "gray", "black", "black", "black", "black", "black", "black"))
  expect_equal(fxResult$body$styles$cells$border.color.top$data[,7],
               c("gray", "gray", "gray", "black", "gray", "black", "black", "black",
                 "gray", "gray", "gray", "black", "gray", "black", "black", "black"))
  expect_equal(fxResult$body$styles$cells$border.color.top$data[,8],
               c("gray", "gray", "gray", "black", "gray", "black", "gray", "black",
                 "gray", "gray", "gray", "black", "gray", "black", "gray", "black"))
  expect_equal(fxResult$body$styles$cells$border.color.top$data[,19],
               c("gray", "gray", "gray", "gray", "gray", "gray", "gray", "gray",
                 "gray", "gray", "gray", "gray", "gray", "gray", "gray", "gray"))

  # colsToMergeRows = c("cdm_name", "variable_name")
  fxResult <- fxTable(
    table_to_format,
    style = "default",
    na = "-",
    title = "Title test 2",
    subtitle = "Subtitle for test 2",
    caption = "*This* is the caption",
    groupNameCol = "group_level",
    groupNameAsColumn = FALSE,
    groupOrder = NULL,
    colsToMergeRows = c("cdm_name", "variable_name")
  )
  expect_equal(fxResult$body$styles$cells$border.color.top$data[,1],
               c("gray", "black", "black", "black", "black", "black", "black", "black",
                 "gray", "black", "black", "black", "black", "black", "black", "black"))
  expect_equal(fxResult$body$styles$cells$border.color.top$data[,2],
               c("gray", "gray", "black", "black", "black", "black", "black", "black",
                 "gray", "gray", "black", "black", "black", "black", "black", "black"))
  expect_equal(fxResult$body$styles$cells$border.color.top$data[,7],
               c("gray", "gray", "gray", "black", "gray", "black", "black", "black",
                 "gray", "gray", "gray", "black", "gray", "black", "black", "black"))

  # Wroing input
  expect_warning(fxTable(
    table_to_format,
    style = "default",
    na = "-",
    title = "Title test 2",
    subtitle = "Subtitle for test 2",
    caption = "*This* is the caption",
    groupNameCol = "group_level",
    groupNameAsColumn = FALSE,
    groupOrder = NULL,
    colsToMergeRows = c("cdm_name", "lala")
  ), "lala is not a column in the dataframe.")
})
