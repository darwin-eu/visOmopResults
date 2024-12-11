test_that("test it works", {
  result <- mockSummarisedResult() |>
    formatEstimateName(estimateName = c("N (%)" = "<count> (<percentage>%)",
                                        "N" = "<count>")) |>
    formatHeader(header = c("strata", "strata_name", "strata_level"),
                 includeHeaderName = TRUE)
  gt <- formatTable(result)
  expect_true("gt_tbl" %in% class(gt))
  # check correct style:
  expect_equal(unlist(gt$`_styles`$styles[gt$`_styles`$locname == "columns_columns"])[1:27] |> unique(),
               c("#E1E1E1", "center", "bold"))
  expect_equal(unlist(gt$`_styles`$styles[gt$`_styles`$locname == "columns_columns"])[28:43] |> unique(),
               c("center", "bold"))
  expect_false(lapply(gt$`_boxhead`$column_label, function(x){grepl("\\[header_level\\]", x)}) |> unlist() |> unique())
  expect_equal(gt$`_styles`$styles[gt$`_styles`$grpname %in% gt$`_spanners`$spanner_id[gt$`_spanners`$spanner_level %in% c(1,3)]] |>
                 unlist() |> unique(),
               c("#D9D9D9", "center", "bold"))
  expect_equal(gt$`_styles`$styles[gt$`_styles`$grpname %in% gt$`_spanners`$spanner_id[gt$`_spanners`$spanner_level == 2]] |>
                 unlist() |> unique(),
               c("#E1E1E1", "center", "bold"))
  expect_equal(gt$`_styles`$styles[gt$`_styles`$grpname %in% gt$`_spanners`$spanner_id[gt$`_spanners`$spanner_level == 4]] |>
                 unlist() |> unique(),
               c("#C8C8C8", "center", "bold"))

  fx <- formatTable(result, type = "flextable")
  expect_true("flextable" %in% class(fx))
  # Spanner styles
  header_col_style <- fx$header$styles$cells$background.color$data[, "strata\nstrata_name\noverall\nstrata_level\noverall"]
  expect_equal(header_col_style, c("#c8c8c8", "#d9d9d9", "#e1e1e1", "#d9d9d9", "#e1e1e1"))
  expect_equal(fx$header$styles$cells$background.color$data[, "cdm_name"] |> unique(), "transparent")
  expect_equal(fx$header$styles$cells$border.width.top$data[, "cdm_name"] |> unique(), 1.2)
  expect_equal(fx$header$styles$cells$border.color.left$data[, "cdm_name"] |> unique(), "gray")
  expect_true(fx$header$styles$text$bold$data[, "cdm_name"] |> unique())
  expect_equal(fx$header$styles$text$color$data[, "cdm_name"] |> unique(), "black")
  expect_equal(fx$header$styles$text$color$data[, "cdm_name"] |> unique(), "black")
  expect_equal(fx$header$styles$text$font.size$data[, "cdm_name"] |> unique(), c(10))

  # body
  expect_equal(fx$body$styles$cells$border.width.top$data[, "cdm_name"] |> unique(), 1)
  expect_equal(fx$body$styles$cells$border.color.left$data[, "cdm_name"] |> unique(), "gray")
  expect_equal(fx$body$styles$cells$background.color$data[, "cdm_name"],
               c("transparent", "transparent", "transparent", "transparent","transparent",
                 "transparent", "transparent", "transparent", "transparent", "transparent"))
  expect_equal(fx$body$styles$text$color$data[, "cdm_name"] |> unique(), "black")

  # wrong inputs
  expect_error(formatTable(result, type = "ha"))
  expect_error(formatTable(result, style = list("hi" = gt::cell_fill())))
  expect_message(result |> dplyr::group_by(cdm_name) |> formatTable())

  expect_error(formatTable(result, subtitle = "subtitle"))

  res <- formatTable(x = result, type = "tibble")
  expect_identical(res, result)
})

test_that("datatable works", {
  result <- mockSummarisedResult() |>
    filterStrata(strata_name == "sex") |>
    formatEstimateName(estimateName = c("N (%)" = "<count> (<percentage>%)",
                                        "N" = "<count>")) |>
    formatHeader(header = c("strata", "strata_name", "strata_level"),
                 includeHeaderName = TRUE)

  dt <- formatTable(result, type = "datatable")
  expect_true(all(c("datatables", "htmlwidget") %in% class(dt)))
  expect_identical(
    dt$x$container,
    "<table class='display'><thead><tr><tr><th rowspan='5'>result_id</th>\n<th rowspan='5'>cdm_name</th>\n<th rowspan='5'>group_name</th>\n<th rowspan='5'>group_level</th>\n<th rowspan='5'>variable_name</th>\n<th rowspan='5'>variable_level</th>\n<th rowspan='5'>estimate_name</th>\n<th rowspan='5'>estimate_type</th>\n<th rowspan='5'>additional_name</th>\n<th rowspan='5'>additional_level</th>\n<th colspan ='2'>strata</th></tr></tr>\n<tr><tr><th colspan ='2'>strata_name</th></tr></tr>\n<tr><tr><th colspan ='2'>sex</th></tr></tr>\n<tr><tr><th colspan ='2'>strata_level</th></tr></tr>\n<tr><th>Male</th>\n<th>Female</th></tr></thead></table>"
  )
  expect_identical(
    dt$x$caption,
    "<caption style=\"caption-side: bottom; text-align: center;\"></caption>"
  )
  expect_true(dt$x$filter == "bottom")
  expect_true(dt$x$class == "display")
  expect_true(dt$x$options$pageLength == 10)
  expect_identical(
    dt$x$options$fixedColumns,
    list(leftColumns = 0, rightColumns = 0)
  )

  dt <- formatTable(result, type = "datatable", style = list(scrollX = FALSE, filter = NULL, rownames = TRUE), delim = ".")
  expect_true(all(c("datatables", "htmlwidget") %in% class(dt)))
  expect_identical(
    dt$x$container,
    "<table class='display'><thead><tr><th>result_id</th>\n<th>cdm_name</th>\n<th>group_name</th>\n<th>group_level</th>\n<th>variable_name</th>\n<th>variable_level</th>\n<th>estimate_name</th>\n<th>estimate_type</th>\n<th>additional_name</th>\n<th>additional_level</th>\n<th>strata\nstrata_name\nsex\nstrata_level\nMale</th>\n<th>strata\nstrata_name\nsex\nstrata_level\nFemale</th></tr></thead></table>"
  )
  expect_identical(
    dt$x$caption,
    "<caption></caption>"
  )
  expect_true(dt$x$filter == "none")
  expect_true(dt$x$class == "display")
  expect_true(is.null(dt$x$options$pageLength))
  expect_true(is.null(dt$x$options$fixedColumns))

  dt <- formatTable(result, type = "datatable", groupColumn = "group_level", caption = "hi there")
  expect_identical(
    dt$x$caption,
    "<caption style=\"caption-side: bottom; text-align: center;\">hi there</caption>"
  )
  expect_true(dt$x$filter == "bottom")
  expect_true(colnames(dt$x$data)[1] == "group_level")
  expect_identical(
    dt$x$options$rowGroup, list(dataSrc = 1)
  )
})
