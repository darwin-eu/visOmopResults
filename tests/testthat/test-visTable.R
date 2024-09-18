test_that("visTable with SR", {
  result <- mockSummarisedResult()
  # TEST IT WORKS
  gt1 <- visTable(
    result = result,
    formatEstimateName = character(),
    header = character(),
    groupColumn = NULL,
    type = "gt",
    hide = NULL,
    .options = list())
  fx1 <- visTable(
    result = result,
    formatEstimateName = character(),
    header = character(),
    groupColumn = NULL,
    type = "flextable",
    hide = NULL,
    .options = list())

  expect_true("gt_tbl" %in% class(gt1))
  expect_true("flextable" == class(fx1))
  expect_true(all(c(
    'Result id', 'Cdm name', 'Group name', 'Group level', 'Strata name', 'Strata level',
    'Variable name', 'Variable level', 'Estimate name', 'Estimate type', 'Estimate value',
    'Additional name', 'Additional level'
  ) %in% colnames(gt1$`_data`)))
  expect_equal(gt1$`_data` |> colnames(), fx1$body$dataset |> colnames())

  gt2 <- visTable(
    result,
    formatEstimateName = c("n" = "<count>", "mean(sd)" = "<mean> (<sd>)"),
    header = c("strata_name", "strata_level"),
    groupColumn = c("cdm_name", "group_level"),
    type = "gt",
    renameColumns = c("Database name" = "cdm_name", "Cohort name" = "group_level", "Strata" = "strata_name"),
    hide = c("result_id", "group_name"),
    .options = list(includeHeaderName = TRUE)
  )
  expect_true("gt_tbl" %in% class(gt2))
  expect_equal(
    colnames(gt2$`_data`),
    c(
      'Cdm name; Group level', 'Variable name', 'Variable level', 'Estimate name',
      'Estimate type', 'Additional name', 'Additional level',
      '[header_name]Strata\n[header_level]overall\n[header_name]Strata level\n[header_level]overall',
      '[header_name]Strata\n[header_level]age_group &&& sex\n[header_name]Strata level\n[header_level]<40 &&& Male',
      '[header_name]Strata\n[header_level]age_group &&& sex\n[header_name]Strata level\n[header_level]>=40 &&& Male',
      '[header_name]Strata\n[header_level]age_group &&& sex\n[header_name]Strata level\n[header_level]<40 &&& Female',
      '[header_name]Strata\n[header_level]age_group &&& sex\n[header_name]Strata level\n[header_level]>=40 &&& Female',
      '[header_name]Strata\n[header_level]sex\n[header_name]Strata level\n[header_level]Male',
      '[header_name]Strata\n[header_level]sex\n[header_name]Strata level\n[header_level]Female',
      '[header_name]Strata\n[header_level]age_group\n[header_name]Strata level\n[header_level]<40',
      '[header_name]Strata\n[header_level]age_group\n[header_name]Strata level\n[header_level]>=40')
  )

  fx2 <- visTable(
    result,
    formatEstimateName = c("n" = "<count>", "mean(sd)" = "<mean> (<sd>)"),
    header = c("strata_name", "strata_level"),
    groupColumn = c("cdm_name", "group_level"),
    type = "flextable",
    renameColumns = c("Database name" = "cdm_name", "Cohort name" = "group_level", "Strata" = "strata_name"),
    hide = c("result_id", "group_name"),
    .options = list(includeHeaderName = TRUE)
  )
  expect_true("flextable" == class(fx2))
  expect_equal(
    colnames(fx2$body$dataset),
    c(
      'Cdm name; Group level', 'Variable name', 'Variable level', 'Estimate name',
      'Estimate type', 'Additional name', 'Additional level', 'Strata\noverall\nStrata level\noverall',
      'Strata\nage_group &&& sex\nStrata level\n<40 &&& Male', 'Strata\nage_group &&& sex\nStrata level\n>=40 &&& Male',
      'Strata\nage_group &&& sex\nStrata level\n<40 &&& Female', 'Strata\nage_group &&& sex\nStrata level\n>=40 &&& Female',
      'Strata\nsex\nStrata level\nMale', 'Strata\nsex\nStrata level\nFemale', 'Strata\nage_group\nStrata level\n<40',
      'Strata\nage_group\nStrata level\n>=40')
  )

  tib1 <- visTable(
    result,
    formatEstimateName = c("n" = "<count>", "mean(sd)" = "<mean> (<sd>)"),
    header = c("strata_name", "strata_level"),
    groupColumn = c("cdm_name", "group_level"),
    type = "tibble",
    renameColumns = c("Database name" = "cdm_name", "Cohort name" = "group_level", "Estimate" = "estimate_value"),
    hide = c("result_id", "group_name", "estimate_type"),
    .options = list(includeHeaderName = TRUE)
  )
  expect_true(all(c("tbl_df", "tbl", "data.frame") == class(tib1)))
  expect_equal(
    colnames(tib1),
    c(
      'Database name', 'Cohort name', 'Variable name', 'Variable level', 'Estimate name',
      'Additional name', 'Additional level',
      '[header_name]Strata name\n[header_level]overall\n[header_name]Strata level\n[header_level]overall',
      '[header_name]Strata name\n[header_level]age_group &&& sex\n[header_name]Strata level\n[header_level]<40 &&& Male',
      '[header_name]Strata name\n[header_level]age_group &&& sex\n[header_name]Strata level\n[header_level]>=40 &&& Male',
      '[header_name]Strata name\n[header_level]age_group &&& sex\n[header_name]Strata level\n[header_level]<40 &&& Female',
      '[header_name]Strata name\n[header_level]age_group &&& sex\n[header_name]Strata level\n[header_level]>=40 &&& Female',
      '[header_name]Strata name\n[header_level]sex\n[header_name]Strata level\n[header_level]Male',
      '[header_name]Strata name\n[header_level]sex\n[header_name]Strata level\n[header_level]Female',
      '[header_name]Strata name\n[header_level]age_group\n[header_name]Strata level\n[header_level]<40',
      '[header_name]Strata name\n[header_level]age_group\n[header_name]Strata level\n[header_level]>=40')
  )

  tib2 <- visTable(
    result,
    formatEstimateName = c("n" = "<count>", "mean(sd)" = "<mean> (<sd>)"),
    # header = c("strata_name", "strata_level"),
    groupColumn = c("cdm_name", "group_level"),
    type = "tibble",
    renameColumns = c("Database name" = "cdm_name", "Cohort name" = "group_level", "Estimate" = "estimate_value"),
    hide = c("result_id", "group_name", "estimate_type"),
    .options = list(includeHeaderName = TRUE)
  )
  expect_true(all(c("tbl_df", "tbl", "data.frame") == class(tib2)))
  expect_equal(
    colnames(tib2),
    c(
      'Database name', 'Cohort name', 'Strata name', 'Strata level', 'Variable name',
      'Variable level', 'Estimate name', 'Estimate', 'Additional name', 'Additional level')
  )

  # expected errors
  expect_error(
    visTable(
      result,
      header = c("strata_name", "strata_level"),
      groupColumn = c("cdm_name", "group_level"),
      hide = c("result_id", "group_name", "estimate_type", "strata_level")
    )
  )
  expect_error(
    visTable(
      result,
      header = c("strata_name", "strata_level"),
      groupColumn = c("cdm_name", "group_level", "strata_level"),
      hide = c("result_id", "group_name", "estimate_type")
    )
  )
})

test_that("helper table functions", {
  expect_equal(names(optionsTable()), c(
    'decimals', 'decimalMark', 'bigMark', 'keepNotFormatted', 'useFormatOrder',
    'delim', 'includeHeaderName', 'includeHeaderKey', 'style', 'na', 'title',
    'subtitle', 'caption', 'groupAsColumn', 'groupOrder', 'merge'
  ))
  expect_equal(
    gtStyle(),
    list(
      "header" = list(gt::cell_fill(color = "#c8c8c8"),
                      gt::cell_text(weight = "bold", align = "center")),
      "header_name" = list(gt::cell_fill(color = "#d9d9d9"),
                           gt::cell_text(weight = "bold", align = "center")),
      "header_level" = list(gt::cell_fill(color = "#e1e1e1"),
                            gt::cell_text(weight = "bold", align = "center")),
      "column_name" = list(gt::cell_text(weight = "bold", align = "center")),
      "group_label" = list(gt::cell_fill(color = "#e9e9e9"),
                           gt::cell_text(weight = "bold")),
      "title" = list(gt::cell_text(weight = "bold", size = 15, align = "center")),
      "subtitle" = list(gt::cell_text(weight = "bold", size = 12, align = "center")),
      "body" = list()
    ) |>
      rlang::expr()
  )
  expect_equal(
    flextableStyle(),
    list(
      "header" = list(
        "cell" = officer::fp_cell(background.color = "#c8c8c8"),
        "text" = officer::fp_text(bold = TRUE)
      ),
      "header_name" = list(
        "cell" = officer::fp_cell(background.color = "#d9d9d9"),
        "text" = officer::fp_text(bold = TRUE)
      ),
      "header_level" = list(
        "cell" = officer::fp_cell(background.color = "#e1e1e1"),
        "text" = officer::fp_text(bold = TRUE)
      ),
      "column_name" = list(
        "text" = officer::fp_text(bold = TRUE)
      ),
      "group_label" = list(
        "cell" = officer::fp_cell(
          background.color = "#e9e9e9",
          border = officer::fp_border(color = "gray")
        ),
        "text" = officer::fp_text(bold = TRUE)
      ),
      "title" = list(
        "text" = officer::fp_text(bold = TRUE, font.size = 15)
      ),
      "subtitle" = list(
        "text" = officer::fp_text(bold = TRUE, font.size = 12)
      ),
      "body" = list()
    ) |>
      rlang::expr()
  )
})
