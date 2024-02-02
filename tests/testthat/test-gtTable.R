test_that("gtTable", {

  table_to_format <- mockSummarisedResult() |>
    formatTable(header = c("Study cohorts", "group_level", "Study strata", "strata_name", "strata_level"),
               includeHeaderName = FALSE)
  # Input 1 ----
  # Title but no subtitle
  # Styles
  gtResult <- gtTable(
    table_to_format,
    style = list(
      "header" = list(
        gt::cell_fill(color = "#c8c8c8"),
        gt::cell_text(weight = "bold")
      ),
      "header_name" = list(gt::cell_fill(color = "#d9d9d9"),
                           gt::cell_text(weight = "bold")),
      "header_level" = list(gt::cell_fill(color = "#e1e1e1"),
                            gt::cell_text(weight = "bold")),
      "column_name" = list(gt::cell_text(weight = "bold")),
      "title" = list(gt::cell_text(weight = "bold", color = "blue"))
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
  expect_equal(
    gtResult$`_spanners`$spanner_label |> unlist(),
    c("overall", "age_group and sex", "sex", "age_group", "overall", "age_group and sex",
      "sex", "age_group", "Study strata", "cohort1", "cohort2", "Study cohorts")
  )
  expect_true(sum(gtResult$`_spanners`$spanner_level == 1) == 8)
  expect_true(sum(gtResult$`_spanners`$spanner_level == 2) == 1)
  expect_true(sum(gtResult$`_spanners`$spanner_level == 3) == 2)
  expect_true(sum(gtResult$`_spanners`$spanner_level == 4) == 1)
  # spanner styles
  expect_equal(gtResult$`_styles`$styles[gtResult$`_styles`$grpname %in% gtResult$`_spanners`$spanner_id[gtResult$`_spanners`$spanner_level %in% c(1,3)]] |>
                 unlist() |> unique(),
               c("#E1E1E1", "bold"))
  expect_equal(gtResult$`_styles`$styles[gtResult$`_styles`$grpname %in% gtResult$`_spanners`$spanner_id[gtResult$`_spanners`$spanner_level %in% c(2,4)]] |>
                 unlist() |> unique(),
               c("#C8C8C8", "bold"))
  # title
  expect_true(gtResult$`_heading`$title == "Test 1")
  expect_true(is.null(gtResult$`_heading`$subtitle))
  expect_equal(gtResult$`_styles`$styles[gtResult$`_styles`$locname == "title"] |> unlist(),
               c("cell_text.color" = "#0000FF", "cell_text.weight" = "bold"))
  # column names
  expect_equal(unlist(gtResult$`_styles`$styles[gtResult$`_styles`$locname == "columns_columns"])[1:36] |> unique(), c("#E1E1E1", "bold"))
  expect_true(unlist(gtResult$`_styles`$styles[gtResult$`_styles`$locname == "columns_columns"])[37:47] |> unique() == "bold")
  expect_false(lapply(gtResult$`_boxhead`$column_label, function(x){grepl("\\[header_level\\]", x)}) |> unlist() |> unique())
  # na
  expect_identical(gtResult$`_substitutions`, list())
  # Group labels
  expect_true(is.null(gtResult$`_stub_df`$group_label |> unlist()))
  expect_false(gtResult$`_options`$value[gtResult$`_options`$parameter == "row_group_as_column"] |> unlist())

  # Input 2 ----
  table_to_format <- mockSummarisedResult() |>
    formatEstimateName(estimateNameFormat = c("N (%)" = "<count> (<percentage>%)",
                                  "N" = "<count>")) |>
    formatTable(header = c("strata_name", "strata_level"),
               includeHeaderName = TRUE)
  gtResult <- gtTable(
    table_to_format,
    style = list(
      "subtitle" = list(gt::cell_text(weight = "lighter", size = "large", color = "blue")),
      "body" = list(gt::cell_text(color = "red"), gt::cell_borders(sides = "all")),
      "group_label" = list(gt::cell_fill(color = "#e1e1e1")),
      "header_name" = list(gt::cell_fill(color = "black"), gt::cell_text(color = "white")),
      "column_name" = list(gt::cell_text(weight = "bold"))
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
  expect_equal(
    gtResult$`_spanners`$spanner_label |> unlist(),
    c("strata_level", "overall", "age_group and sex", "sex", "age_group", "strata_name")
  )
  expect_true(sum(gtResult$`_spanners`$spanner_level == 1) == 1)
  expect_true(sum(gtResult$`_spanners`$spanner_level == 2) == 4)
  expect_true(sum(gtResult$`_spanners`$spanner_level == 3) == 1)
  # spanner styles
  expect_equal(gtResult$`_styles`$styles[gtResult$`_styles`$grpname %in% gtResult$`_spanners`$spanner_id[gtResult$`_spanners`$spanner_level %in% c(1,3)]] |>
                 unlist() |> unique(),
               c("#000000", "#FFFFFF"))
  expect_true(is.null(gtResult$`_styles`$styles[gtResult$`_styles`$grpname %in% gtResult$`_spanners`$spanner_id[gtResult$`_spanners`$spanner_level == 2]] |>
                 unlist() |> unique()))
  # title and subtitle
  expect_true(gtResult$`_heading`$title == "Title test 2")
  expect_true(gtResult$`_heading`$subtitle == "Subtitle for test 2")
  expect_true(is.null(gtResult$`_styles`$styles[gtResult$`_styles`$locname == "title"] |> unlist()))
  expect_equal(gtResult$`_styles`$styles[gtResult$`_styles`$locname == "subtitle"] |> unlist(),
               c("cell_text.color" = "#0000FF", "cell_text.size" = "large", "cell_text.weight" = "lighter"))
  # column names
  expect_true(length(gtResult$`_styles`$styles[gtResult$`_styles`$locname == "columns_columns"] |> unlist()) == 11)
  expect_false(lapply(gtResult$`_boxhead`$column_label, function(x){grepl("\\[header\\]|\\[header_name\\]", x)}) |> unlist() |> unique())
  # na
  expect_false(is.null(gtResult$`_substitutions`[[1]]$func$default))
  # Group labels
  expect_equal(gtResult$`_stub_df`$group_label |> unlist() |> unique(), c("cohort1", "cohort2"))
  expect_false(gtResult$`_options`$value[gtResult$`_options`$parameter == "row_group_as_column"] |> unlist())
  expect_equal(gtResult$`_styles`$styles[gtResult$`_styles`$locname == "row_groups"] |> unlist() |> unique(),
               c("#E1E1E1"))
  # caption
  expect_equal(gtResult$`_options`[2, "value"] |> unlist(), c("value" = "*This* is the caption"))
  expect_equal(gtResult$`_options`$value[gtResult$`_options`$parameter == "table_caption"][[1]] |> attr("class"),
               "from_markdown")
  # body
  body_style <- gtResult$`_styles`$styles[gtResult$`_styles`$locname == "data" & gtResult$`_styles`$rownum %in% 2:8] |> unlist()
  expect_equal(body_style[names(body_style) %in% c("cell_text.color", "cell_border_top.color", "cell_border_top.style")] |> unique(),
               c("solid","#D3D3D3", "#FF0000", "#000000"))

  # Input 3 ----
  table_to_format <- mockSummarisedResult() |>
    formatEstimateName(estimateNameFormat = c("N (%)" = "<count> (<percentage>%)",
                                  "N" = "<count>")) |>
    formatTable(header = c("strata_name", "strata_level"),
               delim = ":",
               includeHeaderName = TRUE)
  gtResult <- gtTable(
    table_to_format,
    delim = ":",
    style = list(
      "subtitle" = list(gt::cell_text(weight = "lighter", size = "large", color = "blue")),
      "body" = list(gt::cell_text(color = "red"), gt::cell_borders(sides = "all")),
      "group_label" = list(gt::cell_fill(color = "#e1e1e1")),
      "header_name" = list(gt::cell_fill(color = "black"), gt::cell_text(color = "white"))
    ),
    na = "-",
    title = "Title test 2",
    subtitle = "Subtitle for test 2",
    caption = "*This* is the caption",
    groupNameCol = "group_level",
    groupNameAsColumn = TRUE,
    groupOrder = c("cohort2", "cohort1")
  )
  # groupNameAsColumn
  expect_true(gtResult$`_options`$value[gtResult$`_options`$parameter == "row_group_as_column"] |> unlist())
  # groupOrder
  expect_identical(gtResult$`_row_groups`, c( "cohort2", "cohort1"))

  # Wrong inputs ----
  expect_error(gtTable(
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

test_that("gtTable, test default styles and NULL", {
  table_to_format <- mockSummarisedResult() |>
    formatTable(header = c("Study cohorts", "group_level", "Study strata", "strata_name", "strata_level"),
                includeHeaderName = FALSE)
  # Input 1: NULL ----
  gtResult <- gtTable(
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

  # style
  expect_true(gtResult$`_styles`$styles[1][[1]]$cell_text$align == "right")
  expect_true(gtResult$`_styles`$styles[203][[1]]$cell_text$align == "left")

  # Input 2 ----
  table_to_format <- mockSummarisedResult() |>
    formatEstimateName(estimateNameFormat = c("N (%)" = "<count> (<percentage>%)",
                                              "N" = "<count>")) |>
    formatTable(header = c("strata", "strata_name", "strata_level"),
                includeHeaderName = TRUE)
  gtResult <- gtTable(
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

  # spanner styles
  expect_equal(gtResult$`_styles`$styles[gtResult$`_styles`$grpname %in% gtResult$`_spanners`$spanner_id[gtResult$`_spanners`$spanner_level %in% c(1,3)]] |>
                 unlist() |> unique(),
               c("#D9D9D9", "center", "bold"))
  expect_equal(gtResult$`_styles`$styles[gtResult$`_styles`$grpname %in% gtResult$`_spanners`$spanner_id[gtResult$`_spanners`$spanner_level == 2]] |>
                 unlist() |> unique(),
               c("#E1E1E1", "center", "bold"))
  expect_equal(gtResult$`_styles`$styles[gtResult$`_styles`$grpname %in% gtResult$`_spanners`$spanner_id[gtResult$`_spanners`$spanner_level == 4]] |>
                 unlist() |> unique(),
               c("#C8C8C8", "center", "bold"))
  # title
  expect_equal(gtResult$`_styles`$styles[gtResult$`_styles`$locname == "title"] |> unlist() |> unique(),
               c("15", "center", "bold"))
  expect_equal(gtResult$`_styles`$styles[gtResult$`_styles`$locname == "subtitle"] |> unlist() |> unique(),
               c("12", "center", "bold"))
  # column names
  expect_equal(unlist(gtResult$`_styles`$styles[gtResult$`_styles`$locname == "columns_columns"])[1:27] |> unique(),
               c("#E1E1E1", "center", "bold"))
  expect_equal(unlist(gtResult$`_styles`$styles[gtResult$`_styles`$locname == "columns_columns"])[28:49] |> unique(),
              c("center", "bold"))
  expect_false(lapply(gtResult$`_boxhead`$column_label, function(x){grepl("\\[header_level\\]", x)}) |> unlist() |> unique())

  # Group labels
  expect_equal(gtResult$`_styles`$styles[gtResult$`_styles`$locname == "row_groups"] |> unlist() |> unique(),
               c("#E9E9E9", "bold"))


  #Input 3: woring name style ----
  expect_warning(
    gtResult <- gtTable(
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
test_that("gtTable, test colsToMergeRows", {
  table_to_format<- mockSummarisedResult() |>
    formatTable(header = c("strata_name", "strata_level"))
  # colsToMergeRows = "all"
  gtResult <- gtTable(
    table_to_format,
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
  expect_equal(gtResult$`_data`$cdm_name,
               c("mock", "", "", "", "", "", "", "mock", "", "", "", "", "", ""))
  expect_equal(gtResult$`_data`$result_type,
               c(NA_character_, "", "", "", "", "", "", NA_character_, "", "", "", "", "", ""))
  expect_equal(gtResult$`_data`$variable_level,
               c(NA_character_, NA_character_, "", "Amoxiciline", "", "Ibuprofen", "", NA_character_, NA_character_, "", "Amoxiciline",
                 "","Ibuprofen",  ""  ))
  expect_equal(gtResult$`_data`$group_level|> levels(),
               c("cohort1", "cohort2"))

  # colsToMergeRows = c("cdm_name", "variable_name")
  gtResult <- gtTable(
    table_to_format,
    style = "default",
    na = "-",
    title = "Title test 2",
    subtitle = "Subtitle for test 2",
    caption = "*This* is the caption",
    groupNameCol = "group_level",
    groupNameAsColumn = TRUE,
    groupOrder = NULL,
    colsToMergeRows = c("cdm_name", "variable_level")
  )
  expect_equal(gtResult$`_data`$cdm_name,
               c("mock", "", "", "", "", "", "", "mock", "", "", "", "", "", ""))
  expect_equal(gtResult$`_data`$result_type,
               rep(NA_character_, 14))
  expect_equal(gtResult$`_data`$variable_level,
               c(NA_character_, "", "", "Amoxiciline", "", "Ibuprofen", "", NA_character_, "", "", "Amoxiciline",
                 "","Ibuprofen",  ""  ))
  expect_equal(gtResult$`_data`$group_level|> levels(),
               c("cohort1", "cohort2"))

  # no groupNameCol
  gtResult <- gtTable(
    table_to_format,
    style = "default",
    na = "-",
    title = "Title test 2",
    subtitle = "Subtitle for test 2",
    caption = "*This* is the caption",
    groupNameCol = NULL,
    groupNameAsColumn = FALSE,
    groupOrder = NULL,
    colsToMergeRows = "all_columns"
  )
  expect_equal(gtResult$`_data`$cdm_name,
               c("mock", "", "", "", "", "", "", "", "", "", "", "", "", ""))
  expect_equal(gtResult$`_data`$result_type,
               c(NA_character_, "", "", "", "", "", "", "", "", "", "", "", "", ""))
  expect_equal(gtResult$`_data`$variable_level,
               c(NA_character_, NA_character_, NA_character_, NA_character_, NA_character_, NA_character_,
                 "Amoxiciline", "Amoxiciline", "Amoxiciline", "Amoxiciline", "Ibuprofen", "Ibuprofen",
                 "Ibuprofen","Ibuprofen"))
  expect_null(gtResult$`_data`$group_level|> levels())
})


