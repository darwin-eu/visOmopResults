# test_that("formatSummarisedResult, formatEstimateValue", {
#   result <- mockSummarisedResult()
#
#   gtResult <- formatSummarisedResult(result,
#                                     tableType = "gt",
#                                     header = NULL,
#                                     estimateNameFormat = NULL,
#                                     style = NULL,
#                                     decimals = c(integer = 0, numeric = 2, percentage = 1, proportion = 3),
#                                     title = NULL,
#                                     subtitle = NULL,
#                                     caption = NULL,
#                                     .options = list(
#                                       "decimalMark" = "n",
#                                       "bigMark" = ":"
#                                     ))
#   ## Test big Mark ----
#   counts_in  <- result$estimate_value[gtResult$`_data`$estimate_type == "integer"]
#   counts_out <- gtResult$`_data`$estimate_value[gtResult$`_data`$estimate_type == "integer"]
#
#   zeroMarks_out <- base::paste(counts_out[base::nchar(counts_in) < 4], collapse = "")
#   zeroMarks_out <- nchar(zeroMarks_out) - nchar(gsub(":", "", zeroMarks_out))
#
#   oneMark_in  <- sum(base::nchar(counts_in) < 7 & base::nchar(counts_in) > 3)
#   oneMark_out <- base::paste(counts_out[base::nchar(counts_in) < 7 & base::nchar(counts_in) > 3], collapse = "")
#   oneMark_out <- nchar(oneMark_out) - nchar(gsub(":", "", oneMark_out))
#
#   twoMarks_in  <- sum(base::nchar(counts_in) == 7)*2
#   twoMarks_out <- base::paste(counts_out[base::nchar(counts_in) == 7], collapse = "")
#   twoMarks_out <- nchar(twoMarks_out) - nchar(gsub(":", "", twoMarks_out))
#
#   # check nummber of marks
#   expect_equal(0, zeroMarks_out)
#   expect_equal(oneMark_in, oneMark_out)
#   expect_equal(twoMarks_in, twoMarks_out)
#   # check type of mark
#   expect_identical(as.integer(counts_in), as.integer(base::gsub(":", "", counts_out)))
#
#   ## Test decimals (default input) ----
#   # check estimate types
#   expect_equal(gtResult$`_data` |>
#                  dplyr::filter(grepl("n", .data$estimate_value)) |>
#                  dplyr::distinct(estimate_type) |>
#                  dplyr::pull(),
#                c("numeric", "percentage"))
#
#   # check number of decimals
#   ## numeric
#   numeric <- gtResult$`_data`$estimate_value[gtResult$`_data`$estimate_type == "numeric"]
#   if (length(numeric) > 0) {
#     expect_true(lapply(strsplit(numeric, "n"), function(x) {x[[2]]}) |>
#                   unlist() |> nchar() |> mean() == 2)
#   }
#   ## percentage
#   percentage <- gtResult$`_data`$estimate_value[gtResult$`_data`$estimate_type == "percentage"]
#   if (length(percentage) > 0) {
#     expect_true(lapply(strsplit(percentage, "n"), function(x) {x[[2]]}) |>
#                   unlist() |> nchar() |> mean() == 1)
#   }
# })
#
# test_that("formatSummarisedResult, formatEstimateName", {
#   result <- mockSummarisedResult()
#
#   gtResult <- formatSummarisedResult(result,
#                                      tableType = "gt",
#                                      header = NULL,
#                                      estimateNameFormat = c("N (%)" = "<count> (<percentage>%)",
#                                                             "N" = "<count>"),
#                                      style = "default",
#                                      decimals = 0,
#                                      title = NULL,
#                                      subtitle = NULL,
#                                      caption = NULL,
#                                      .options = list(
#                                        "decimalMark" = "",
#                                        "bigMark" = ""
#                                      ))
#
#   # check count as "N"
#   expect_identical(unique(gtResult$`_data`$estimate_name[gtResult$`_data`$variable_name == "number subjects"]),
#                    "N")
#   # check count (percentage%) as N (%)
#   expect_identical(unique(gtResult$`_data`$estimate_name[gtResult$`_data`$variable_name == "Medications"]),
#                    "N (%)")
#   # check keep not formatted
#   expect_true(gtResult$`_data` |>
#                 dplyr::filter(.data$estimate_name %in% c("mean", "sd")) |>
#                 nrow() > 0)
#   # check estimates
#   row_vars <- dplyr::tibble(group_level = "cohort1", strata_name = "overall", strata_level = "overall")
#   estimates_out <- gtResult$`_data` |> dplyr::inner_join(row_vars, by = colnames(row_vars))
#   estimates_in  <- result |> dplyr::inner_join(row_vars, by = colnames(row_vars))
#   ## number subjects
#   expect_identical(as.numeric(estimates_out$estimate_value[estimates_out$variable_name == "number subjects"]),
#                    as.numeric(estimates_in$estimate_value[estimates_in$variable_name == "number subjects"]))
#   ## mean
#   expect_identical(as.numeric(estimates_out$estimate_value[estimates_out$variable_name == "age"]),
#                    round(as.numeric(estimates_in$estimate_value[estimates_in$variable_name == "age"])))
# })
#
# test_that("formatSummarisedResult, formatTable", {
#   result <- mockSummarisedResult()
#
#   gtResult <- formatSummarisedResult(result,
#                                      tableType = "gt",
#                                      header = c("group_name", "group_level", "strata", "strata_name", "strata_level"),
#                                      estimateNameFormat = NULL,
#                                      style = NULL,
#                                      decimals = 2,
#                                      title = NULL,
#                                      subtitle = NULL,
#                                      caption = NULL,
#                                      .options = list(
#                                        "includeHeaderName" = TRUE,
#                                        "bigMark" = ""
#                                      ))
#   # column: group_name\ncohort_name\ngroup_level\ncohort2\nstrata\nstrata_name\nsex\nstrata_level\nMale
#   values_in <- result |>
#     dplyr::filter(.data$group_level == "cohort2" & .data$strata_level == "Male") |>
#     dplyr::select(all_of(names(result)[! names(result) %in% c("group_name", "group_level", "strata", "strata_name", "strata_level")])) |>
#     dplyr::mutate(estimate_value = round(as.numeric(.data$estimate_value), 2))
#
#   values_out <- gtResult$`_data` |>
#     dplyr::select(all_of(c(names(result)[! names(result) %in% c("group_name", "group_level", "strata", "strata_name", "strata_level", "estimate_value")],
#                            "estimate_value" = "[header_name]group_name\n[header_level]cohort_name\n[header_name]group_level\n[header_level]cohort2\n[header]strata\n[header_name]strata_name\n[header_level]sex\n[header_name]strata_level\n[header_level]Male"))) |>
#     dplyr::mutate(estimate_value = as.numeric(.data$estimate_value))
#   expect_true(values_in |> dplyr::anti_join(values_out, by = names(values_in)) |> nrow() == 0)
#
#   # class
#   expect_false("summarised_result" %in% class(gtResult$`_data`))
#
#   # column: group_name\ncohort_name\ngroup_level\ncohort1\nstrata\nstrata_name\nage_group and sex\nstrata_level\n>=40 and Female
#   values_in <- result |>
#     dplyr::filter(.data$group_level == "cohort1" & .data$strata_level == ">=40 and Female") |>
#     dplyr::select(all_of(names(result)[! names(result) %in% c("group_name", "group_level", "strata", "strata_name", "strata_level")])) |>
#     dplyr::mutate(estimate_value = round(as.numeric(.data$estimate_value), 2))
#
#   values_out <- gtResult$`_data` |>
#     dplyr::select(all_of(c(names(result)[! names(result) %in% c("group_name", "group_level", "strata", "strata_name", "strata_level", "estimate_value")],
#                            "estimate_value" = "[header_name]group_name\n[header_level]cohort_name\n[header_name]group_level\n[header_level]cohort1\n[header]strata\n[header_name]strata_name\n[header_level]age_group and sex\n[header_name]strata_level\n[header_level]>=40 and Female"))) |>
#     dplyr::mutate(estimate_value = as.numeric(.data$estimate_value))
#
#   expect_true(values_in |> dplyr::anti_join(values_out, by = names(values_in)) |> nrow() == 0)
#
# })
#
# test_that("formatSummarisedResult, gtTable", {
#   result <- mockSummarisedResult()
#   gtResult <- formatSummarisedResult(result,
#                                      tableType = "gt",
#                                      header = c("Study cohorts", "group_level", "Study strata", "strata_name", "strata_level"),
#                                      estimateNameFormat = NULL,
#                                      style = list(
#                                        "header" = list(
#                                          gt::cell_fill(color = "#c8c8c8"),
#                                          gt::cell_text(weight = "bold")
#                                        ),
#                                        "header_name" = list(gt::cell_fill(color = "#d9d9d9"),
#                                                             gt::cell_text(weight = "bold")),
#                                        "header_level" = list(gt::cell_fill(color = "#e1e1e1"),
#                                                              gt::cell_text(weight = "bold")),
#                                        "column_name" = list(gt::cell_text(weight = "bold")),
#                                        "title" = list(gt::cell_text(weight = "bold", color = "blue"))
#                                      ),
#                                      decimals = 2,
#                                      title = "Test 1",
#                                      subtitle = NULL,
#                                      caption = NULL,
#                                      .options = list(
#                                        "includeHeaderName" = FALSE,
#                                        na = NULL
#                                      ))
#   # Spanners
#   expect_equal(
#     gtResult$`_spanners`$spanner_label |> unlist(),
#     c("overall", "age_group and sex", "sex", "age_group", "overall", "age_group and sex",
#       "sex", "age_group", "Study strata", "cohort1", "cohort2", "Study cohorts")
#   )
#   expect_true(sum(gtResult$`_spanners`$spanner_level == 1) == 8)
#   expect_true(sum(gtResult$`_spanners`$spanner_level == 2) == 1)
#   expect_true(sum(gtResult$`_spanners`$spanner_level == 3) == 2)
#   expect_true(sum(gtResult$`_spanners`$spanner_level == 4) == 1)
#   # spanner styles
#   expect_equal(gtResult$`_styles`$styles[gtResult$`_styles`$grpname %in% gtResult$`_spanners`$spanner_id[gtResult$`_spanners`$spanner_level %in% c(1,3)]] |>
#                  unlist() |> unique(),
#                c("#E1E1E1", "bold"))
#   expect_equal(gtResult$`_styles`$styles[gtResult$`_styles`$grpname %in% gtResult$`_spanners`$spanner_id[gtResult$`_spanners`$spanner_level %in% c(2,4)]] |>
#                  unlist() |> unique(),
#                c("#C8C8C8", "bold"))
#   # title
#   expect_true(gtResult$`_heading`$title == "Test 1")
#   expect_true(is.null(gtResult$`_heading`$subtitle))
#   expect_equal(gtResult$`_styles`$styles[gtResult$`_styles`$locname == "title"] |> unlist(),
#                c("cell_text.color" = "#0000FF", "cell_text.weight" = "bold"))
#   # column names
#   expect_equal(unlist(gtResult$`_styles`$styles[gtResult$`_styles`$locname == "columns_columns"]) [1:36] |> unique(), c("#E1E1E1", "bold"))
#   expect_false(lapply(gtResult$`_boxhead`$column_label, function(x){grepl("\\[header_level\\]", x)}) |> unlist() |> unique())
#   # na
#   expect_identical(gtResult$`_substitutions`, list())
#   # Group labels
#   expect_true(is.null(gtResult$`_stub_df`$group_label |> unlist()))
#   expect_false(gtResult$`_options`$value[gtResult$`_options`$parameter == "row_group_as_column"] |> unlist())
#
#
#   # Test 2 ----
#   gtResult <- formatSummarisedResult(result,
#                                      tableType = "gt",
#                                      header = c("strata_name", "strata_level"),
#                                      estimateNameFormat = c("N (%)" = "<count> (<percentage>%)",
#                                                             "N" = "<count>"),
#                                      style = list(
#                                        "subtitle" = list(gt::cell_text(weight = "lighter", size = "large", color = "blue")),
#                                        "body" = list(gt::cell_text(color = "red"), gt::cell_borders(sides = "all")),
#                                        "group_label" = list(gt::cell_fill(color = "#e1e1e1")),
#                                        "header_name" = list(gt::cell_fill(color = "black"), gt::cell_text(color = "white"))
#                                      ),
#                                      decimals = 2,
#                                      title = "Title test 2",
#                                      subtitle = "Subtitle for test 2",
#                                      caption = "*This* is the caption",
#                                      .options = list(
#                                        "includeHeaderName" = TRUE,
#                                        "na" = "-",
#                                        "groupNameCol" = "group_level",
#                                        "groupNameAsColumn" = FALSE,
#                                        "groupOrder" = NULL
#                                      ))
#   # Spanners
#   expect_equal(
#     gtResult$`_spanners`$spanner_label |> unlist(),
#     c("strata_level", "overall", "age_group and sex", "sex", "age_group", "strata_name")
#   )
#   expect_true(sum(gtResult$`_spanners`$spanner_level == 1) == 1)
#   expect_true(sum(gtResult$`_spanners`$spanner_level == 2) == 4)
#   expect_true(sum(gtResult$`_spanners`$spanner_level == 3) == 1)
#   # spanner styles
#   expect_equal(gtResult$`_styles`$styles[gtResult$`_styles`$grpname %in% gtResult$`_spanners`$spanner_id[gtResult$`_spanners`$spanner_level %in% c(1,3)]] |>
#                  unlist() |> unique(),
#                c("#000000", "#FFFFFF"))
#   expect_true(is.null(gtResult$`_styles`$styles[gtResult$`_styles`$grpname %in% gtResult$`_spanners`$spanner_id[gtResult$`_spanners`$spanner_level == 2]] |>
#                         unlist() |> unique()))
#   # title and subtitle
#   expect_true(gtResult$`_heading`$title == "Title test 2")
#   expect_true(gtResult$`_heading`$subtitle == "Subtitle for test 2")
#   expect_true(is.null(gtResult$`_styles`$styles[gtResult$`_styles`$locname == "title"] |> unlist()))
#   expect_equal(gtResult$`_styles`$styles[gtResult$`_styles`$locname == "subtitle"] |> unlist(),
#                c("cell_text.color" = "#0000FF", "cell_text.size" = "large", "cell_text.weight" = "lighter"))
#   # column names
#   expect_true(is.null(gtResult$`_styles`$styles[gtResult$`_styles`$locname == "columns_columns"] |> unlist()))
#   expect_false(lapply(gtResult$`_boxhead`$column_label, function(x){grepl("\\[header_level\\]", x)}) |> unlist() |> unique())
#   # na
#   expect_false(is.null(gtResult$`_substitutions`[[1]]$func$default))
#   # Group labels
#   expect_equal(gtResult$`_stub_df`$group_label |> unlist() |> unique(), c("cohort1", "cohort2"))
#   expect_false(gtResult$`_options`$value[gtResult$`_options`$parameter == "row_group_as_column"] |> unlist())
#   expect_equal(gtResult$`_styles`$styles[gtResult$`_styles`$locname == "row_groups"] |> unique() |> unlist(),
#                c("cell_fill.color" = "#E1E1E1"))
#   # caption
#   expect_equal(gtResult$`_options`[2, "value"] |> unlist(), c("value" = "*This* is the caption"))
#   expect_equal(gtResult$`_options`$value[gtResult$`_options`$parameter == "table_caption"][[1]] |> attr("class"),
#                "from_markdown")
#   # body
#   body_style <- gtResult$`_styles`$styles[gtResult$`_styles`$locname == "data" & gtResult$`_styles`$rownum %in% 2:8] |> unlist()
#   expect_equal(body_style[names(body_style) %in% c("cell_text.color", "cell_border_top.color", "cell_border_top.style")] |> unique(),
#                c("#FF0000", "solid", "#000000"))
#
#
#   # Test 3---
#   gtResult <- formatSummarisedResult(result,
#                                      tableType = "gt",
#                                      header = NULL,
#                                      estimateNameFormat = NULL,
#                                      style = NULL,
#                                      decimals = 2,
#                                      title = "Title test 3",
#                                      subtitle = NULL,
#                                      caption = NULL,
#                                      .options = list(
#                                        "includeHeaderName" = FALSE,
#                                        na = NULL
#                                      ))
#   # no style
#   # spanner styles
#   expect_true(nrow(gtResult$`_spanners`) == 0)
#   expect_null(unlist(gtResult$`_styles`$styles[gtResult$`_styles`$locname == "columns_columns"]) |> unique())
#   # title and subtitle
#   expect_true(gtResult$`_heading`$title == "Title test 3")
#   expect_null(gtResult$`_styles`$styles[gtResult$`_styles`$locname == "title"] |> unlist())
#   expect_null(gtResult$`_styles`$styles[gtResult$`_styles`$locname == "subtitle"] |> unlist())
#   # column names
#   expect_null(gtResult$`_styles`$styles[gtResult$`_styles`$locname == "columns_columns"] |> unlist())
#   expect_false(lapply(gtResult$`_boxhead`$column_label, function(x){grepl("\\[header_level\\]", x)}) |> unlist() |> unique())
#   # na
#   expect_equal(gtResult$`_substitutions`, list())
#   # body
#   expect_null(gtResult$`_styles`$styles[gtResult$`_styles`$locname == "data" & gtResult$`_styles`$rownum %in% 2:8] |> unlist())
#
#   # Test 4---
#   gtResult <- formatSummarisedResult(result,
#                                      tableType = "gt",
#                                      header = NULL,
#                                      estimateNameFormat = NULL,
#                                      style = "default",
#                                      decimals = 2,
#                                      title = "Title test 3",
#                                      subtitle = NULL,
#                                      caption = NULL,
#                                      .options = list(
#                                        "includeHeaderName" = FALSE,
#                                        na = NULL
#                                      ))
#   # no style
#   # spanner styles
#   expect_true(nrow(gtResult$`_spanners`) == 0)
#
#   # title and subtitle
#   expect_true(gtResult$`_heading`$title == "Title test 3")
#   expect_null(gtResult$`_styles`$styles[gtResult$`_styles`$locname == "title"] |> unlist())
#   expect_null(gtResult$`_styles`$styles[gtResult$`_styles`$locname == "subtitle"] |> unlist())
#   # column names
#   expect_equal(unlist(gtResult$`_styles`$styles[gtResult$`_styles`$locname == "columns_columns"]) |> unique(), "bold")
#   expect_false(lapply(gtResult$`_boxhead`$column_label, function(x){grepl("\\[header_level\\]", x)}) |> unlist() |> unique())
#   # na
#   expect_equal(gtResult$`_substitutions`, list())
#   # body
#   expect_null(gtResult$`_styles`$styles[gtResult$`_styles`$locname == "data" & gtResult$`_styles`$rownum %in% 2:8] |> unlist())
# })
#
# test_that("formatSummarisedResult, fxTable", {
#   # Test 1 ----
#   result <- mockSummarisedResult()
#   fxResult <- formatSummarisedResult(result,
#                                      tableType = "fx",
#                                      header = c("Study cohorts", "group_level", "Study strata", "strata_name", "strata_level"),
#                                      estimateNameFormat = NULL,
#                                      style = list(
#                                        "header" = list( "cell" = officer::fp_cell(background.color = "#c8c8c8"),
#                                                         "text" = officer::fp_text(bold = TRUE)),
#                                        "header_name" = list("cell" = officer::fp_cell(background.color = "#d9d9d9"),
#                                                             "text" = officer::fp_text(bold = TRUE)),
#                                        "header_level" = list("cell" = officer::fp_cell(background.color = "#e1e1e1"),
#                                                              "text" = officer::fp_text(bold = TRUE)),
#                                        "column_name" = list("text" = officer::fp_text(bold = TRUE)),
#                                        "title" = list("text" = officer::fp_text(bold = TRUE, color = "blue"))
#                                      ),
#                                      decimals = 2,
#                                      title = "Test 1",
#                                      subtitle = NULL,
#                                      caption = NULL,
#                                      .options = list(
#                                        "includeHeaderName" = FALSE,
#                                        na = NULL
#                                      ))
#   # Spanners
#   header_col_1 <- fxResult$header$dataset[, "Study cohorts\ncohort1\nStudy strata\noverall\noverall"] # cohort 1 - overall
#   expect_equal(header_col_1, c("Test 1", "Study cohorts", "cohort1", "Study strata", "overall",
#                                "Study cohorts\ncohort1\nStudy strata\noverall\noverall"))
#
#   # Spanner styles
#   header_col_style <- fxResult$header$styles$cells$background.color$data[, "Study cohorts\ncohort1\nStudy strata\noverall\noverall"]
#   expect_equal(header_col_style, c("#c8c8c8", "#c8c8c8", "#e1e1e1", "#c8c8c8", "#e1e1e1", "#e1e1e1"))
#   expect_equal(fxResult$header$styles$cells$background.color$data[, "cdm_name"] |> unique(), "transparent")
#   expect_equal(fxResult$header$styles$cells$border.width.top$data[, "cdm_name"] |> unique(), 2)
#   expect_equal(fxResult$header$styles$cells$border.color.left$data[, "cdm_name"] |> unique(), "gray")
#   expect_equal(fxResult$header$styles$text$bold$data[, "cdm_name"] |> unique(), TRUE)
#   expect_equal(fxResult$header$styles$text$color$data[, "cdm_name"][1], "blue")
#
#   # na
#   expect_equal(fxResult$body$dataset$result_type |> unique(), as.character(NA))
#
#   # default fxTable format
#   expect_equal(fxResult$body$styles$cells$border.width.top$data[, "cdm_name"] |> unique(), 1)
#   expect_equal(fxResult$body$styles$cells$border.color.left$data[, "cdm_name"] |> unique(), "gray")
#   expect_equal(fxResult$body$styles$cells$background.color$data[, "cdm_name"] |> unique(), "transparent")
#
#   # Test 2 ----
#   fxResult <- formatSummarisedResult(result,
#                                      tableType = "fx",
#                                      header = c("strata_name", "strata_level"),
#                                      estimateNameFormat = c("N (%)" = "<count> (<percentage>%)",
#                                                             "N" = "<count>"),
#                                      style = list(
#                                        "subtitle" = list("text" = officer::fp_text(bold = TRUE, font.size = 12, color = "blue")),
#                                        "body" = list("text" = officer::fp_text(color = "red"), "cell" = officer::fp_cell(border = officer::fp_border())),
#                                        "group_label" = list("cell" = officer::fp_cell(background.color = "#e1e1e1")),
#                                        "header_name" = list("cell" = officer::fp_cell(background.color = "black"), "text" = officer::fp_text(color = "white")),
#                                        "column_name" = list("text" = officer::fp_text(bold = TRUE))
#                                      ),
#                                      decimals = 2,
#                                      title = "Title test 2",
#                                      subtitle = "Subtitle for test 2",
#                                      caption = "*This* is the caption",
#                                      .options = list(
#                                        "includeHeaderName" = TRUE,
#                                        na = "-",
#                                        groupNameCol = "group_level",
#                                        groupNameAsColumn = FALSE,
#                                        groupOrder = NULL
#                                      ))
#
#   # Spanners
#   header_col_1 <- fxResult$header$dataset[, "strata_name\noverall\nstrata_level\noverall"] # overall
#   expect_equal(header_col_1, c("Title test 2", "Subtitle for test 2", "strata_name", "overall",
#                                "strata_level", "strata_name\noverall\nstrata_level\noverall"))
#
#   # Spanner styles
#   header_col_style <- fxResult$header$styles$cells$background.color$data[, "strata_name\noverall\nstrata_level\noverall"]
#   expect_equal(header_col_style, c("black", "black", "black", "transparent", "black", "transparent"))
#   expect_equal(fxResult$header$styles$cells$background.color$data[, "cdm_name"] |> unique(), "transparent")
#   expect_equal(fxResult$header$styles$cells$border.width.top$data[, "cdm_name"] |> unique(), 2)
#   expect_equal(fxResult$header$styles$cells$border.color.left$data[, "cdm_name"] |> unique(), "gray")
#   expect_equal(fxResult$header$styles$text$bold$data[, "cdm_name"] |> unique(), TRUE)
#   expect_equal(fxResult$header$styles$text$color$data[, "cdm_name"], c("black", "blue", "black", "black", "black", "black"))
#   expect_equal(fxResult$header$styles$text$color$data[, "strata_name\nage_group\nstrata_level\n>=40"],
#                c("black", "blue", "white", "black", "white", "black"))
#
#   # na
#   expect_equal(fxResult$body$dataset$result_type |> unique(), c(as.character(NA), "-"))
#
#   # body
#   expect_equal(fxResult$body$styles$cells$border.width.top$data[, "cdm_name"] |> unique(), c(0,1))
#   expect_equal(fxResult$body$styles$cells$border.color.left$data[, "cdm_name"] |> unique(), "black")
#   expect_equal(fxResult$body$styles$cells$background.color$data[, "cdm_name"],
#                c("#e1e1e1", "transparent", "transparent", "transparent", "transparent", "#e1e1e1",
#                  "transparent", "transparent", "transparent", "transparent"))
#   expect_equal(fxResult$body$styles$text$color$data[, "cdm_name"] |> unique(), "red")
#
#   # caption
#   expect_equal(fxResult$caption$value, "*This* is the caption")
#
#   # group label
#   expect_equal(fxResult$body$spans$rows[1,], c(1, 20, rep(0, 19)))
#   expect_equal(fxResult$body$spans$rows[6,], c(1, 20, rep(0, 19)))
#   expect_equal(fxResult$body$spans$rows[3,], rep(1, 21))
#
#   # Test 3 ----
#   fxResult <- formatSummarisedResult(result,
#                                      tableType = "fx",
#                                      header = c("strata_name", "strata_level"),
#                                      estimateNameFormat = NULL,
#                                      style = "default",
#                                      decimals = 2,
#                                      title = "Title test 2",
#                                      subtitle = "Subtitle for test 2",
#                                      caption = "*This* is the caption",
#                                      .options = list(
#                                        "includeHeaderName" = TRUE,
#                                        na = "-",
#                                        groupNameCol = "group_level",
#                                        groupNameAsColumn = TRUE,
#                                        groupOrder = NULL
#                                      ))
#
#   expect_equal(fxResult$header$styles$cells$background.color$data[,1] |> unique(), "transparent")
#   expect_equal(fxResult$header$styles$cells$background.color$data[,15],
#                c("#d9d9d9", "#d9d9d9", "#d9d9d9", "#e1e1e1", "#d9d9d9", "#e1e1e1"))
#   expect_equal(fxResult$body$spans$columns[,1], c(5, rep(0,4), 5, rep(0,4)))
#   expect_equal(fxResult$body$dataset[,1] |>  levels(), c("cohort1", "cohort2"))
#   expect_equal(fxResult$body$spans$rows[3,], rep(1, 21))
#   expect_equal(fxResult$body$styles$cells$background.color$data[,1] |> unique(), "#e9ecef")
#   expect_equal(fxResult$body$styles$cells$background.color$data[,2] |> unique(), "transparent")
# })
#
