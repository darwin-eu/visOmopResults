test_that("visTable with SR", {
  result <- mockSummarisedResult()
  # TEST IT WORKS
  gt1 <- visTable(
    result = result,
    estimateName = character(),
    header = character(),
    groupColumn = NULL,
    type = "gt",
    hide = NULL,
    .options = list())
  fx1 <- visTable(
    result = result,
    estimateName = character(),
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
    estimateName = c("n" = "<count>", "mean(sd)" = "<mean> (<sd>)"),
    header = c("strata_name", "strata_level"),
    groupColumn = c("cdm_name", "group_level"),
    type = "gt",
    rename = c("Database name" = "cdm_name", "Cohort name" = "group_level", "Strata" = "strata_name"),
    hide = c("result_id", "group_name"),
    .options = list(includeHeaderName = TRUE)
  )
  expect_true("gt_tbl" %in% class(gt2))
  expect_equal(
    colnames(gt2$`_data`),
    c(
      'Database name; Cohort name', 'Variable name', 'Variable level', 'Estimate name',
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
    estimateName = c("n" = "<count>", "mean(sd)" = "<mean> (<sd>)"),
    header = c("strata_name", "strata_level"),
    groupColumn = c("cdm_name", "group_level"),
    type = "flextable",
    rename = c("Database name" = "cdm_name", "Cohort name" = "group_level", "Strata" = "strata_name"),
    hide = c("result_id", "group_name"),
    .options = list(includeHeaderName = TRUE)
  )
  expect_true("flextable" == class(fx2))
  expect_equal(
    colnames(fx2$body$dataset),
    c(
      'Variable name', 'Variable level', 'Estimate name', 'Estimate type', 'Additional name',
      'Additional level', 'Strata\noverall\nStrata level\noverall',
      'Strata\nage_group &&& sex\nStrata level\n<40 &&& Male',
      'Strata\nage_group &&& sex\nStrata level\n>=40 &&& Male',
      'Strata\nage_group &&& sex\nStrata level\n<40 &&& Female',
      'Strata\nage_group &&& sex\nStrata level\n>=40 &&& Female',
      'Strata\nsex\nStrata level\nMale', 'Strata\nsex\nStrata level\nFemale',
      'Strata\nage_group\nStrata level\n<40', 'Strata\nage_group\nStrata level\n>=40')
  )

  tib1 <- visTable(
    result,
    estimateName = c("n" = "<count>", "mean(sd)" = "<mean> (<sd>)"),
    header = c("strata_name", "strata_level"),
    groupColumn = c("cdm_name", "group_level"),
    type = "tibble",
    rename = c("Database name" = "cdm_name", "Cohort name" = "group_level", "Estimate" = "estimate_value"),
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
    estimateName = c("n" = "<count>", "mean(sd)" = "<mean> (<sd>)"),
    # header = c("strata_name", "strata_level"),
    groupColumn = c("cdm_name", "group_level"),
    type = "tibble",
    rename = c("Database name" = "cdm_name", "Cohort name" = "group_level", "Estimate" = "estimate_value"),
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

test_that("validate header works", {
  x <- dplyr::tibble(
    a = "same_value",
    b = c("category 1", "category 1", "category 2", "category 2"),
    c = c("header 1", "header 2", "header 1", "header 2"),
    estimate_value = c("value for 1", "value for 2", "value for 1", "value for 2")
  )
  expect_warning(newX <- visTable(x, header = "c", hide = "b", type = "tibble"))
  expect_true("B" %in% colnames(newX))
})

test_that("global options works", {
  result <- mockSummarisedResult()
  setGlobalTableOptions("darwin", "tinytable")
  tab <- visTable(result, header = "strata_level")
  expect_true(class(tab)[1] == "tinytable")
  tab <- visTable(result, type = "gt")
  expect_true(class(tab)[1] == "gt_tbl")
  setGlobalTableOptions()
})

test_that("warnings", {
  result <- mockSummarisedResult()
  expect_message(visTable(result, type = "reactable", .options = list(caption = "HI")))
  expect_message(visTable(result, type = "tinytable", .options = list(title = "HI")))
  expect_message(visTable(result, type = "datatable", .options = list(title = "HI")))
  expect_message(visTable(result, type = "tibble", .options = list(title = "HI")))
  expect_no_message(visTable(result, type = "reactable"))
  expect_no_message(visTable(result, type = "tinytable"))
  expect_no_message(visTable(result, type = "datatable"))
  expect_no_message(visTable(result, type = "tibble"))
})
