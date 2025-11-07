test_that("test it works", {
  skip_on_cran()
  result <- mockSummarisedResult() |>
    formatEstimateName(estimateName = c("N (%)" = "<count> (<percentage>%)",
                                        "N" = "<count>")) |>
    formatHeader(header = c("strata", "strata_name", "strata_level"),
                 includeHeaderName = TRUE)
  gt <- formatTable(result)
  expect_true("gt_tbl" %in% class(gt))

  # check style of columns_columns
  styleColumns <- gt$`_styles`$styles[gt$`_styles`$locname == "columns_columns"]

  # style of the last 9 cells
  # background color
  backgroundColor <- styleColumns[1:9] |>
    purrr::map_chr(\(x) x$cell_fill$color) |>
    unique()
  expect_identical("#E1E1E1", backgroundColor)
  # align center
  align <- styleColumns[1:9] |>
    purrr::map_chr(\(x) x$cell_text$align) |>
    unique()
  expect_identical("center", align)
  # bold text
  weight <- styleColumns[1:9] |>
    purrr::map_chr(\(x) x$cell_text$weight) |>
    unique()
  expect_identical("bold", weight)

  # style of the other cells
  # align center
  align <- styleColumns[10:19] |>
    purrr::map_chr(\(x) x$cell_text$align) |>
    unique()
  expect_identical("center", align)
  # bold text
  weight <- styleColumns[10:19] |>
    purrr::map_chr(\(x) x$cell_text$weight) |>
    unique()
  expect_identical("bold", weight)

  # expect no header_level in header
  headerLevel <- gt$`_boxhead`$column_label |>
    unlist() |>
    purrr::keep(\(x) grepl(pattern = "\\[header_level\\]", x = x))
  expect_true(length(headerLevel) == 0)

  # check style of the spanners

  # spanners 1 and 3
  styleColumns <- gt$`_styles`$styles[gt$`_styles`$grpname %in% gt$`_spanners`$spanner_id[gt$`_spanners`$spanner_level %in% c(1,3)]]
  # background color
  backgroundColor <- styleColumns |>
    purrr::map_chr(\(x) x$cell_fill$color) |>
    unique()
  expect_identical("#D9D9D9", backgroundColor)
  # align center
  align <- styleColumns |>
    purrr::map_chr(\(x) x$cell_text$align) |>
    unique()
  expect_identical("center", align)
  # bold text
  weight <- styleColumns |>
    purrr::map_chr(\(x) x$cell_text$weight) |>
    unique()
  expect_identical("bold", weight)

  # spanner 2
  styleColumns <- gt$`_styles`$styles[gt$`_styles`$grpname %in% gt$`_spanners`$spanner_id[gt$`_spanners`$spanner_level == 2]]
  # background color
  backgroundColor <- styleColumns |>
    purrr::map_chr(\(x) x$cell_fill$color) |>
    unique()
  expect_identical("#E1E1E1", backgroundColor)
  # align center
  align <- styleColumns |>
    purrr::map_chr(\(x) x$cell_text$align) |>
    unique()
  expect_identical("center", align)
  # bold text
  weight <- styleColumns |>
    purrr::map_chr(\(x) x$cell_text$weight) |>
    unique()
  expect_identical("bold", weight)

  # spanner 4
  styleColumns <- gt$`_styles`$styles[gt$`_styles`$grpname %in% gt$`_spanners`$spanner_id[gt$`_spanners`$spanner_level == 4]]
  # background color
  backgroundColor <- styleColumns |>
    purrr::map_chr(\(x) x$cell_fill$color) |>
    unique()
  expect_identical("#C8C8C8", backgroundColor)
  # align center
  align <- styleColumns |>
    purrr::map_chr(\(x) x$cell_text$align) |>
    unique()
  expect_identical("center", align)
  # bold text
  weight <- styleColumns |>
    purrr::map_chr(\(x) x$cell_text$weight) |>
    unique()
  expect_identical("bold", weight)

  fx <- formatTable(result, type = "flextable")
  expect_true("flextable" %in% class(fx))
  # Spanner styles
  header_col_style <- fx$header$styles$cells$background.color$data[, "strata\nstrata_name\noverall\nstrata_level\noverall"]
  expect_equal(header_col_style, c("#c8c8c8", "#d9d9d9", "#e1e1e1", "#d9d9d9", "#e1e1e1"))
  expect_equal(fx$header$styles$cells$background.color$data[, "cdm_name"] |> unique(), "#e1e1e1")
  expect_equal(fx$header$styles$cells$border.width.top$data[, "cdm_name"] |> unique(), c(1))
  expect_equal(fx$header$styles$cells$border.color.left$data[, "cdm_name"] |> unique(), "#c8c8c8")
  expect_true(fx$header$styles$text$bold$data[, "cdm_name"] |> unique())
  expect_equal(fx$header$styles$text$color$data[, "cdm_name"] |> unique(), "black")
  expect_equal(fx$header$styles$text$color$data[, "cdm_name"] |> unique(), "black")
  expect_equal(fx$header$styles$text$font.size$data[, "cdm_name"] |> unique(), c(10))

  # body
  expect_equal(fx$body$styles$cells$border.width.top$data[, "cdm_name"] |> unique(), 1)
  expect_equal(fx$body$styles$cells$border.color.left$data[, "cdm_name"] |> unique(), "#c8c8c8")
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
  expect_identical(
    res,
    result |>
      dplyr::mutate(
        dplyr::across(dplyr::where(~ is.numeric(.x)), ~ as.character(.x)),
        dplyr::across(colnames(result), ~ dplyr::if_else(is.na(.x), "\u2013", .x))
      )
  )
})

test_that("datatable works", {
  skip_on_cran()
  setGlobalTableOptions()
  result <- mockSummarisedResult() |>
    filterStrata(strata_name == "sex") |>
    formatEstimateName(estimateName = c("N (%)" = "<count> (<percentage>%)",
                                        "N" = "<count>")) |>
    formatHeader(header = c("strata", "strata_name", "strata_level"),
                 includeHeaderName = TRUE)

  dt <- formatTable(result, type = "datatable")
  expect_snapshot(dt)

  dt <- formatTable(result, type = "datatable", style = list(scrollX = FALSE, filter = NULL, rownames = TRUE), delim = ".")
  expect_snapshot(dt)

  dt <- formatTable(result, type = "datatable", groupColumn = "group_level", caption = "hi there")
  expect_snapshot(dt)
})

test_that("reactable works", {
  skip_on_cran()
  result <- mockSummarisedResult() |>
    filterStrata(strata_name == "sex") |>
    formatEstimateName(estimateName = c("N (%)" = "<count> (<percentage>%)",
                                        "N" = "<count>")) |>
    formatHeader(header = c("strata_level"),
                 includeHeaderName = TRUE)

  dt <- formatTable(result, type = "reactable")
  expect_snapshot(dt$x)


  dt <- formatTable(result,
                    type = "reactable",
                    style = list("outlined" = TRUE, "bordered" = TRUE, defaultSorted = "Male"),
                    delim = "\n")
  expect_snapshot(dt$x)

  dt <- formatTable(result, type = "reactable", groupColumn = "group_level", delim = ".")
  expect_snapshot(dt$x)
})

test_that("global options works", {
  skip_on_cran()
  result <- mockSummarisedResult() |>
    filterStrata(strata_name == "sex") |>
    formatEstimateName(estimateName = c("N (%)" = "<count> (<percentage>%)",
                                        "N" = "<count>")) |>
    formatHeader(header = c("strata_level"),
                 includeHeaderName = TRUE)
  setGlobalTableOptions("darwin", "tinytable")
  tab <- formatTable(result)
  expect_true(class(tab)[1] == "tinytable")
  tab <- formatTable(result, type = "gt")
  expect_true(class(tab)[1] == "gt_tbl")
  options(visOmopResults.tableStyle = NULL)
  options(visOmopResults.tableType = NULL)
})
