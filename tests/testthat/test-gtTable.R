test_that("gtTable", {
  table_to_format <- mockSummarisedResult() |>
    formatHeader(header = c("Study cohorts", "group_level", "Study strata", "strata_name", "strata_level"),
                 includeHeaderName = FALSE) |>
    dplyr::select(-result_id)
  # Input 1 ----
  # Title but no subtitle
  # Styles
  gtTableInternal <- gtTableInternal(
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
    groupColumn = NULL,
    groupAsColumn = FALSE,
    groupOrder = NULL
  )

  # Spanners
  expect_equal(
    gtTableInternal$`_spanners`$spanner_label |> unlist(),
    c("overall", "age_group &&& sex", "sex", "age_group", "overall", "age_group &&& sex",
      "sex", "age_group", "Study strata", "cohort1", "cohort2", "Study cohorts")
  )
  expect_true(sum(gtTableInternal$`_spanners`$spanner_level == 1) == 8)
  expect_true(sum(gtTableInternal$`_spanners`$spanner_level == 2) == 1)
  expect_true(sum(gtTableInternal$`_spanners`$spanner_level == 3) == 2)
  expect_true(sum(gtTableInternal$`_spanners`$spanner_level == 4) == 1)
  # spanner styles
  expect_equal(gtTableInternal$`_styles`$styles[gtTableInternal$`_styles`$grpname %in% gtTableInternal$`_spanners`$spanner_id[gtTableInternal$`_spanners`$spanner_level %in% c(1,3)]] |>
                 unlist() |> unique(),
               c("#E1E1E1", "bold"))
  expect_equal(gtTableInternal$`_styles`$styles[gtTableInternal$`_styles`$grpname %in% gtTableInternal$`_spanners`$spanner_id[gtTableInternal$`_spanners`$spanner_level %in% c(2,4)]] |>
                 unlist() |> unique(),
               c("#C8C8C8", "bold"))
  # title
  expect_true(gtTableInternal$`_heading`$title == "Test 1")
  expect_true(is.null(gtTableInternal$`_heading`$subtitle))
  expect_equal(gtTableInternal$`_styles`$styles[gtTableInternal$`_styles`$locname == "title"] |> unlist(),
               c("cell_text.color" = "#0000FF", "cell_text.weight" = "bold"))
  # column names
  expect_equal(unlist(gtTableInternal$`_styles`$styles[gtTableInternal$`_styles`$locname == "columns_columns"])[1:36] |> unique(), c("#E1E1E1", "bold"))
  expect_true(unlist(gtTableInternal$`_styles`$styles[gtTableInternal$`_styles`$locname == "columns_columns"])[37:44] |> unique() == "bold")
  expect_false(lapply(gtTableInternal$`_boxhead`$column_label, function(x){grepl("\\[header_level\\]", x)}) |> unlist() |> unique())
  # na
  expect_identical(gtTableInternal$`_substitutions`, list())
  # Group labels
  expect_true(is.null(gtTableInternal$`_stub_df`$group_label |> unlist()))
  expect_false(gtTableInternal$`_options`$value[gtTableInternal$`_options`$parameter == "row_group_as_column"] |> unlist())

  # Input 2 ----
  table_to_format <- mockSummarisedResult() |>
    formatEstimateName(estimateName = c("N (%)" = "<count> (<percentage>%)",
                                        "N" = "<count>")) |>
    formatHeader(header = c("strata_name", "strata_level"),
                 includeHeaderName = TRUE) |>
    dplyr::select(-result_id)
  gtTableInternal <- gtTableInternal(
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
    groupColumn = list("group_level" = "group_level"),
    groupAsColumn = FALSE,
    groupOrder = NULL
  )

  # Spanners
  expect_equal(
    gtTableInternal$`_spanners`$spanner_label |> unlist(),
    c("strata_level", "overall", "age_group &&& sex", "sex", "age_group", "strata_name")
  )
  expect_true(sum(gtTableInternal$`_spanners`$spanner_level == 1) == 1)
  expect_true(sum(gtTableInternal$`_spanners`$spanner_level == 2) == 4)
  expect_true(sum(gtTableInternal$`_spanners`$spanner_level == 3) == 1)
  # spanner styles
  expect_equal(gtTableInternal$`_styles`$styles[gtTableInternal$`_styles`$grpname %in% gtTableInternal$`_spanners`$spanner_id[gtTableInternal$`_spanners`$spanner_level %in% c(1,3)]] |>
                 unlist() |> unique(),
               c("#000000", "#FFFFFF"))
  expect_true(is.null(gtTableInternal$`_styles`$styles[gtTableInternal$`_styles`$grpname %in% gtTableInternal$`_spanners`$spanner_id[gtTableInternal$`_spanners`$spanner_level == 2]] |>
                        unlist() |> unique()))
  # title &&& subtitle
  expect_true(gtTableInternal$`_heading`$title == "Title test 2")
  expect_true(gtTableInternal$`_heading`$subtitle == "Subtitle for test 2")
  expect_true(is.null(gtTableInternal$`_styles`$styles[gtTableInternal$`_styles`$locname == "title"] |> unlist()))
  expect_equal(gtTableInternal$`_styles`$styles[gtTableInternal$`_styles`$locname == "subtitle"] |> unlist(),
               c("cell_text.color" = "#0000FF", "cell_text.size" = "large", "cell_text.weight" = "lighter"))
  # column names
  expect_true(length(gtTableInternal$`_styles`$styles[gtTableInternal$`_styles`$locname == "columns_columns"] |> unlist()) == 8)
  expect_false(lapply(gtTableInternal$`_boxhead`$column_label, function(x){grepl("\\[header\\]|\\[header_name\\]", x)}) |> unlist() |> unique())
  # na
  expect_equal(unique(gtTableInternal$`_data`$variable_level[1:3]), "-")
  # Group labels
  expect_equal(gtTableInternal$`_stub_df`$group_label |> unlist() |> unique(), c("cohort1", "cohort2"))
  expect_false(gtTableInternal$`_options`$value[gtTableInternal$`_options`$parameter == "row_group_as_column"] |> unlist())
  expect_equal(gtTableInternal$`_styles`$styles[gtTableInternal$`_styles`$locname == "row_groups"] |> unlist() |> unique(),
               c("#E1E1E1"))
  # caption
  expect_equal(gtTableInternal$`_options`$value[gtTableInternal$`_options`$parameter == "table_caption"][[1]] |> attr("class"),
               "from_markdown")
  # body
  body_style <- gtTableInternal$`_styles`$styles[gtTableInternal$`_styles`$locname == "data" & gtTableInternal$`_styles`$rownum %in% 2:8] |> unlist()
  expect_equal(body_style[names(body_style) %in% c("cell_text.color", "cell_border_top.color", "cell_border_top.style")] |> unique(),
               c("solid","#D3D3D3", "#FF0000", "#000000"))

  # Input 3 ----
  table_to_format <- mockSummarisedResult() |>
    formatEstimateName(estimateName = c("N (%)" = "<count> (<percentage>%)",
                                        "N" = "<count>")) |>
    formatHeader(header = c("strata_name", "strata_level"),
                 delim = ":",
                 includeHeaderName = TRUE) |>
    dplyr::select(-result_id)
  gtTableInternal <- gtTableInternal(
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
    groupColumn = list("group_level" = "group_level"),
    groupAsColumn = TRUE,
    groupOrder = c("cohort2", "cohort1")
  )
  # groupAsColumn
  expect_true(gtTableInternal$`_options`$value[gtTableInternal$`_options`$parameter == "row_group_as_column"] |> unlist())
  # groupOrder
  expect_identical(gtTableInternal$`_row_groups`, c( "cohort2", "cohort1"))
})

test_that("gtTable, test default styles and NULL", {
  table_to_format <- mockSummarisedResult() |>
    formatHeader(header = c("Study cohorts", "group_level", "Study strata", "strata_name", "strata_level"),
                 includeHeaderName = FALSE) |>
    dplyr::select(-result_id)
  # Input 1: NULL ----
  gtTableInternal <- gtTableInternal(
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

  # style
  expect_true(gtTableInternal$`_styles`$styles[1][[1]]$cell_text$align == "right")
  expect_true(gtTableInternal$`_styles`$styles[182][[1]]$cell_text$align == "left")

  # Input 2 ----
  table_to_format <- mockSummarisedResult() |>
    formatEstimateName(estimateName = c("N (%)" = "<count> (<percentage>%)",
                                        "N" = "<count>")) |>
    formatHeader(header = c("strata", "strata_name", "strata_level"),
                 includeHeaderName = TRUE) |>
    dplyr::select(-result_id)
  gtTableInternal <- gtTableInternal(
    table_to_format,
    style = validateStyle(style = "default", obj = "table", type = "gt"),
    na = "-",
    title = "Title test 2",
    subtitle = "Subtitle for test 2",
    caption = "*This* is the caption",
    groupColumn = list("group_level" = "group_level"),
    groupAsColumn = FALSE,
    groupOrder = NULL
  )

  # spanner styles

  # spanner 1 3
  styleSpanner13 <- gtTableInternal$`_styles`$styles[gtTableInternal$`_styles`$grpname %in% gtTableInternal$`_spanners`$spanner_id[gtTableInternal$`_spanners`$spanner_level %in% c(1,3)]]
  # background color
  backgroundColor <- styleSpanner13 |>
    purrr::map_chr(\(x) x$cell_fill$color) |>
    unique()
  expect_identical("#D9D9D9", backgroundColor)
  # align
  align <- styleSpanner13 |>
    purrr::map_chr(\(x) x$cell_text$align) |>
    unique()
  expect_identical("center", align)
  # weight
  weight <- styleSpanner13 |>
    purrr::map_chr(\(x) x$cell_text$weight) |>
    unique()
  expect_identical("bold", weight)

  # spanner 2
  styleSpanner2 <- gtTableInternal$`_styles`$styles[gtTableInternal$`_styles`$grpname %in% gtTableInternal$`_spanners`$spanner_id[gtTableInternal$`_spanners`$spanner_level == 2]]
  # background color
  backgroundColor <- styleSpanner2 |>
    purrr::map_chr(\(x) x$cell_fill$color) |>
    unique()
  expect_identical("#E1E1E1", backgroundColor)
  # align
  align <- styleSpanner2 |>
    purrr::map_chr(\(x) x$cell_text$align) |>
    unique()
  expect_identical("center", align)
  # weight
  weight <- styleSpanner2 |>
    purrr::map_chr(\(x) x$cell_text$weight) |>
    unique()
  expect_identical("bold", weight)

  # spanner 4
  styleSpanner4 <- gtTableInternal$`_styles`$styles[gtTableInternal$`_styles`$grpname %in% gtTableInternal$`_spanners`$spanner_id[gtTableInternal$`_spanners`$spanner_level == 4]]
  # background color
  backgroundColor <- styleSpanner4 |>
    purrr::map_chr(\(x) x$cell_fill$color) |>
    unique()
  expect_identical("#C8C8C8", backgroundColor)
  # align
  align <- styleSpanner4 |>
    purrr::map_chr(\(x) x$cell_text$align) |>
    unique()
  expect_identical("center", align)
  # weight
  weight <- styleSpanner4 |>
    purrr::map_chr(\(x) x$cell_text$weight) |>
    unique()
  expect_identical("bold", weight)

  # title
  styleTitle <- gtTableInternal$`_styles`$styles[gtTableInternal$`_styles`$locname == "title"]
  # font size
  fontSize <- styleTitle |>
    purrr::map_dbl(\(x) x$cell_text$size) |>
    unique()
  expect_identical(15, fontSize)
  # align
  align <- styleTitle |>
    purrr::map_chr(\(x) x$cell_text$align) |>
    unique()
  expect_identical("center", align)
  # weight
  weight <- styleTitle |>
    purrr::map_chr(\(x) x$cell_text$weight) |>
    unique()
  expect_identical("bold", weight)

  # subtitle
  styleSubtitle <- gtTableInternal$`_styles`$styles[gtTableInternal$`_styles`$locname == "subtitle"]
  # font size
  fontSize <- styleSubtitle |>
    purrr::map_dbl(\(x) x$cell_text$size) |>
    unique()
  expect_identical(12, fontSize)
  # align
  align <- styleSubtitle |>
    purrr::map_chr(\(x) x$cell_text$align) |>
    unique()
  expect_identical("center", align)
  # weight
  weight <- styleSubtitle |>
    purrr::map_chr(\(x) x$cell_text$weight) |>
    unique()
  expect_identical("bold", weight)

  # column names
  styleColumns <- gtTableInternal$`_styles`$styles[gtTableInternal$`_styles`$locname == "columns_columns"]
  # background last 9 columns
  backgroundColor <- styleColumns[1:9] |>
    purrr::map_chr(\(x) x$cell_fill$color) |>
    unique()
  expect_identical("#E1E1E1", backgroundColor)
  # align last 9 columns
  align <- styleColumns[1:9] |>
    purrr::map_chr(\(x) x$cell_text$align) |>
    unique()
  expect_identical("center", align)
  # weight last 9 columns
  weight <- styleColumns[1:9] |>
    purrr::map_chr(\(x) x$cell_text$weight) |>
    unique()
  expect_identical("bold", weight)
  # align first 8 columns
  align <- styleColumns[10:17] |>
    purrr::map_chr(\(x) x$cell_text$align) |>
    unique()
  expect_identical("center", align)
  # weight first 8 columns
  weight <- styleColumns[10:17] |>
    purrr::map_chr(\(x) x$cell_text$weight) |>
    unique()
  expect_identical("bold", weight)

  expect_false(lapply(gtTableInternal$`_boxhead`$column_label, function(x){grepl("\\[header_level\\]", x)}) |> unlist() |> unique())

  # Group labels
  styleGroupLabel <- gtTableInternal$`_styles`$styles[gtTableInternal$`_styles`$locname == "row_groups"]
  # background
  backgroundColor <- styleGroupLabel |>
    purrr::map_chr(\(x) x$cell_fill$color) |>
    unique()
  expect_identical("#E9E9E9", backgroundColor)
  # weight
  weight <- styleGroupLabel |>
    purrr::map_chr(\(x) x$cell_text$weight) |>
    unique()
  expect_identical("bold", weight)
})

test_that("gtTable, test merge", {
  table_to_format<- mockSummarisedResult() |>
    formatHeader(header = c("strata_name", "strata_level")) |>
    dplyr::select(-result_id)
  # merge = "all"
  gtTableInternal <- gtTableInternal(
    table_to_format,
    style = validateStyle(style = "default", obj = "table", type = "gt"),
    na = "-",
    title = "Title test 2",
    subtitle = "Subtitle for test 2",
    caption = "*This* is the caption",
    groupColumn = list("group_level" = "group_level"),
    groupAsColumn = FALSE,
    groupOrder = NULL,
    merge = "all_columns"
  )
  expect_equal(gtTableInternal$`_data`$cdm_name,
               c("mock", "", "", "", "", "", "", "mock", "", "", "", "", "", ""))
  expect_equal(gtTableInternal$`_data`$variable_level,
               c("-", "-", "", "Amoxiciline", "", "Ibuprofen", "", "-", "-", "", "Amoxiciline",
                 "","Ibuprofen",  ""  ))
  expect_equal(gtTableInternal$`_data`$group_level|> levels(),
               c("cohort1", "cohort2"))

  # merge = c("cdm_name", "variable_name")
  gtTableInternal <- gtTableInternal(
    table_to_format,
    style = validateStyle(style = "default", obj = "table", type = "gt"),
    na = "-",
    title = "Title test 2",
    subtitle = "Subtitle for test 2",
    caption = "*This* is the caption",
    groupColumn = list("group_level" = "group_level"),
    groupAsColumn = TRUE,
    groupOrder = NULL,
    merge = c("cdm_name", "variable_level")
  )
  expect_equal(gtTableInternal$`_data`$cdm_name,
               c("mock", "", "", "", "", "", "", "mock", "", "", "", "", "", ""))
  expect_equal(gtTableInternal$`_data`$variable_level,
               c("-", "", "", "Amoxiciline", "", "Ibuprofen", "", "-", "", "", "Amoxiciline",
                 "","Ibuprofen",  ""  ))
  expect_equal(gtTableInternal$`_data`$group_level|> levels(),
               c("cohort1", "cohort2"))

  # no groupColumn
  gtTableInternal <- gtTableInternal(
    table_to_format,
    style = validateStyle(style = "default", obj = "table", type = "gt"),
    na = "-",
    title = "Title test 2",
    subtitle = "Subtitle for test 2",
    caption = "*This* is the caption",
    groupColumn = NULL,
    groupAsColumn = FALSE,
    groupOrder = NULL,
    merge = "all_columns"
  )
  expect_equal(gtTableInternal$`_data`$cdm_name,
               c("mock", "", "", "", "", "", "", "", "", "", "", "", "", ""))
  expect_equal(gtTableInternal$`_data`$variable_level,
               c("-", "-", "-", "-", "-", "-",
                 "Amoxiciline", "Amoxiciline", "Amoxiciline", "Amoxiciline", "Ibuprofen", "Ibuprofen",
                 "Ibuprofen","Ibuprofen"))
  expect_null(gtTableInternal$`_data`$group_level|> levels())
})

test_that("groupColumn",{
  table_to_format<- mockSummarisedResult() |>
    formatHeader(header = c("strata_name", "strata_level")) |>
    dplyr::select(-result_id)

  gtTableInternal <- gtTableInternal(
    table_to_format,
    style = validateStyle(style = "default", obj = "table", type = "gt"),
    na = "-",
    title = "Title test 2",
    subtitle = "Subtitle for test 2",
    caption = "*This* is the caption",
    groupColumn = list("group_name_group_level" = c("group_name", "group_level")),
    groupAsColumn = TRUE,
    groupOrder = NULL,
    merge = "all_columns"
  )

  expect_equal(gtTableInternal$`_data`$cdm_name,
               c("mock", "", "", "", "", "", "", "mock", "", "", "", "", "", ""))
  expect_equal(gtTableInternal$`_data`$variable_level,
               c("-", "-", "", "Amoxiciline", "", "Ibuprofen", "", "-", "-", "", "Amoxiciline",
                 "","Ibuprofen",  ""  ))
  expect_equal(gtTableInternal$`_data`$group_name_group_level |> levels(),
               c('cohort_name; cohort1', 'cohort_name; cohort2'))

  gtTableInternal <- gtTableInternal(
    table_to_format,
    style = validateStyle(style = "default", obj = "table", type = "gt"),
    na = "-",
    title = "Title test 2",
    subtitle = "Subtitle for test 2",
    caption = "*This* is the caption",
    groupColumn = list("hi_there" = c("group_name", "group_level")),
    groupAsColumn = TRUE,
    groupOrder = NULL,
    merge = "all_columns"
  )
  expect_equal(gtTableInternal$`_data`$hi_there |> levels(),
               c('cohort_name; cohort1', 'cohort_name; cohort2'))
})

