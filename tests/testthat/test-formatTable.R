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
})
