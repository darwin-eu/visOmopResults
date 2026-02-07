test_that("visOmopTable", {
  result <- mockSummarisedResult()
  expect_no_error(
    gt1 <- visOmopTable(
      result = result,
      estimateName = character(),
      header = character(),
      groupColumn = NULL,
      type = "gt",
      settingsColumn = character(),
      hide = c("result_id", "estimate_type"),
      .options = list())
  )
  expect_true("gt_tbl" %in% class(gt1))
  expect_true(all(c("CDM name", "Cohort name", "Age group", "Sex", "Variable name", "Variable level", "Estimate name", "Estimate value") %in%
                    colnames(gt1$`_data`)))

  expect_no_error(
    gt2 <- visOmopTable(
      result = result,
      estimateName = c("N%" = "<count> (<percentage>)", "N" = "<count>"),
      header = c("strata"),
      groupColumn = NULL,
      type = "gt",
      .options = list())
  )
  expect_true("gt_tbl" %in% class(gt2))
  expect_true(all(c(
    'CDM name', 'Cohort name', 'Variable name', 'Variable level', 'Estimate name',
    '[header_name]Age group\n[header_level]overall\n[header_name]Sex\n[header_level]overall',
    '[header_name]Age group\n[header_level]<40\n[header_name]Sex\n[header_level]Male',
    '[header_name]Age group\n[header_level]>=40\n[header_name]Sex\n[header_level]Male',
    '[header_name]Age group\n[header_level]<40\n[header_name]Sex\n[header_level]Female',
    '[header_name]Age group\n[header_level]>=40\n[header_name]Sex\n[header_level]Female',
    '[header_name]Age group\n[header_level]overall\n[header_name]Sex\n[header_level]Male',
    '[header_name]Age group\n[header_level]overall\n[header_name]Sex\n[header_level]Female',
    '[header_name]Age group\n[header_level]<40\n[header_name]Sex\n[header_level]overall',
    '[header_name]Age group\n[header_level]>=40\n[header_name]Sex\n[header_level]overall'
  ) %in% colnames(gt2$`_data`)))
  expect_true(nrow(gt2$`_data`) == 10)

  expect_no_error(
    fx1 <- visOmopTable(
      result = result,
      estimateName = c("N%" = "<count> (<percentage>)", "N" = "<count>", "<mean>, <sd>"),
      header = c("group", "estimate"),
      groupColumn = NULL,
      type = "flextable",
      hide = c("result_id", "estimate_type", "cdm_name"),
      .options = list(includeHeaderName = FALSE))
  )
  expect_true("flextable" == class(fx1))
  expect_true(all(c(
    'Age group', 'Sex', 'Variable name', 'Variable level', 'cohort1\nN', 'cohort2\nN',
    'cohort1\nmean, sd', 'cohort2\nmean, sd', 'cohort1\nN%', 'cohort2\nN%'
  ) %in% colnames(fx1$body$dataset)))
  expect_true(nrow(fx1$body$dataset) == 36)

  expect_no_error(
    fx2 <- visOmopTable(
      result = result,
      estimateName = c("N%" = "<count> (<percentage>)", "N" = "<count>", "<mean>, <sd>"),
      header = c("variable", "estimate"),
      groupColumn = NULL,
      type = "flextable",
      hide = c("result_id", "estimate_type", "cdm_name"),
      .options = list(includeHeaderName = TRUE))
  )
  expect_true("flextable" == class(fx2))
  expect_true(all(c(
    'Cohort name', 'Age group', 'Sex', 'Variable name\nnumber subjects\nVariable level\n–\nEstimate name\nN',
    'Variable name\nage\nVariable level\n–\nEstimate name\nmean, sd',
    'Variable name\nMedications\nVariable level\nAmoxiciline\nEstimate name\nN%',
    'Variable name\nMedications\nVariable level\nIbuprofen\nEstimate name\nN%'
  ) %in% colnames(fx2$body$dataset)))
  expect_true(nrow(fx2$body$dataset) == 18)

  expect_no_error(
    fx3 <- visOmopTable(
      result = result,
      estimateName = c("N%" = "<count> (<percentage>)", "N" = "<count>", "<mean>, <sd>"),
      header = c("strata", "estimate"),
      groupColumn = "cohort_name",
      type = "flextable",
      hide = c("result_id", "estimate_type", "cdm_name"),
      .options = list())
  )
  expect_true("flextable" == class(fx3))
  expect_true(all(c(
    'Variable name', 'Variable level',
    'Age group\noverall\nSex\noverall\nEstimate name\nN',
    'Age group\n<40\nSex\nMale\nEstimate name\nN',
    'Age group\n>=40\nSex\nMale\nEstimate name\nN',
    'Age group\n<40\nSex\nFemale\nEstimate name\nN',
    'Age group\n>=40\nSex\nFemale\nEstimate name\nN',
    'Age group\noverall\nSex\nMale\nEstimate name\nN',
    'Age group\noverall\nSex\nFemale\nEstimate name\nN',
    'Age group\n<40\nSex\noverall\nEstimate name\nN',
    'Age group\n>=40\nSex\noverall\nEstimate name\nN',
    'Age group\noverall\nSex\noverall\nEstimate name\nmean, sd',
    'Age group\n<40\nSex\nMale\nEstimate name\nmean, sd',
    'Age group\n>=40\nSex\nMale\nEstimate name\nmean, sd',
    'Age group\n<40\nSex\nFemale\nEstimate name\nmean, sd',
    'Age group\n>=40\nSex\nFemale\nEstimate name\nmean, sd',
    'Age group\noverall\nSex\nMale\nEstimate name\nmean, sd',
    'Age group\noverall\nSex\nFemale\nEstimate name\nmean, sd',
    'Age group\n<40\nSex\noverall\nEstimate name\nmean, sd',
    'Age group\n>=40\nSex\noverall\nEstimate name\nmean, sd',
    'Age group\noverall\nSex\noverall\nEstimate name\nN%',
    'Age group\n<40\nSex\nMale\nEstimate name\nN%',
    'Age group\n>=40\nSex\nMale\nEstimate name\nN%',
    'Age group\n<40\nSex\nFemale\nEstimate name\nN%',
    'Age group\n>=40\nSex\nFemale\nEstimate name\nN%',
    'Age group\noverall\nSex\nMale\nEstimate name\nN%',
    'Age group\noverall\nSex\nFemale\nEstimate name\nN%',
    'Age group\n<40\nSex\noverall\nEstimate name\nN%',
    'Age group\n>=40\nSex\noverall\nEstimate name\nN%'
  ) %in% colnames(fx3$body$dataset)))
  expect_true(nrow(fx3$body$dataset) == 10)

  # settings ----
  result <- mockSummarisedResult() |>
    omopgenerics::suppress(10000000)
  expect_no_error(
    tib1 <- visOmopTable(
      result = result,
      estimateName = c("N%" = "<count> (<percentage>)", "N" = "<count>", "<mean>, <sd>"),
      header = c("group", "settings"),
      settingsColumn = settingsColumns(result),
      groupColumn = NULL,
      type = "tibble",
      hide = c("result_id", "estimate_type", "cdm_name"),
      .options = list())
  )
  expect_true(all(c("tbl_df", "tbl", "data.frame") %in% class(tib1)))
  expect_true(all(c(
    'Age group', 'Sex', 'Variable name', 'Variable level', 'Estimate name', '[header_name]Cohort name\n[header_level]cohort1', '[header_name]Cohort name\n[header_level]cohort2') %in% colnames(tib1)))
  expect_equal(tib1[,6] |> dplyr::pull() |> unique() |> sort(), c("-", "<10,000,000"))

  result$estimate_value[1:3] <- NA_character_

  expect_equal(visOmopTable(result, type = "tibble")$`Estimate value`[1:6],c(
    "–", "–", "–", "<10,000,000", "<10,000,000", "<10,000,000"
  ))

  # woring group column
  expect_error(
    visOmopTable(
      result = result,
      estimateName = c("N%" = "<count> (<percentage>)", "N" = "<count>", "<mean>, <sd>"),
      header = c("group", "settings"),
      groupColumn = "hola",
      type = "tibble",
      hide = c("result_id", "estimate_type", "cdm_name"),
      .options = list()
    )
  )

  # not defined style
  expect_error(
    visOmopTable(
      result = result,
      estimateName = c("N%" = "<count> (<percentage>)", "N" = "<count>", "<mean>, <sd>"),
      header = c("group", "settings"),
      hide = c("result_id", "estimate_type", "cdm_name"),
      style = "HAHA"
    )
  )

  # no path for .yml
  expect_error(
    visOmopTable(
      result = result,
      estimateName = c("N%" = "<count> (<percentage>)", "N" = "<count>", "<mean>, <sd>"),
      header = c("group", "settings"),
      hide = c("result_id", "estimate_type", "cdm_name"),
      style = "HAHA.yml"
    )
  )

})

test_that("renameColumn works", {
  result <- mockSummarisedResult()
  expect_no_error(
    gt1 <- visOmopTable(
      result = result,
      estimateName = character(),
      header = character(),
      groupColumn = NULL,
      type = "gt",
      rename = c("Database name" = "cdm_name"),
      hide = c("result_id", "estimate_type"),
      .options = list())
  )
  expect_true(all(
    colnames(gt1$`_data`) ==
      c("Database name", "Cohort name", "Age group", "Sex", "Variable name",
        "Variable level", "Estimate name", "Estimate value")
  ))

  expect_no_error(
    gt2 <- visOmopTable(
      result = result,
      estimateName = character(),
      header = c("cdm_name", "strata"),
      groupColumn = NULL,
      type = "gt",
      rename = c("Database name" = "cdm_name", "changeName" = "variable_name"),
      hide = c("result_id", "estimate_type"),
      .options = list())
  )
  expect_true(all(colnames(gt2$`_data`)[1:2] == c("Cohort name", "changeName")))
  expect_true(all(colnames(gt2$`_data`)[5] == "[header_name]Database name\n[header_level]mock\n[header_name]Age group\n[header_level]overall\n[header_name]Sex\n[header_level]overall"))
  expect_warning(
    fx1 <- visOmopTable(
      result = result,
      estimateName = character(),
      header = c("cdm_name", "Sex"),
      groupColumn = NULL,
      type = "flextable",
      rename = c("Database name" = "cdm_name", "changeName" = "name"),
      hide = c("result_id", "estimate_type"),
      .options = list())
  )

  # more than 1 group column
  fx2 <- visOmopTable(
    result = result,
    estimateName = character(),
    header = c("strata"),
    type = "flextable",
    groupColumn = c("cdm_name", "cohort_name"),
    rename = c("Database name" = "cdm_name", "changeName" = "variable_name"),
    hide = c("result_id", "estimate_type"),
    .options = list())
  expect_true(colnames(fx2$body$dataset)[1] == "changeName")
  expect_equal(colnames(fx1$body$dataset),
               c("Cohort name", "Age group", "Variable name", "Variable level",
                 "Estimate name", "Database name\nmock\nSex\noverall",
                 "Database name\nmock\nSex\nMale", "Database name\nmock\nSex\nFemale"))

  # more than 1 group column
  fx3 <- visOmopTable(
    result = result,
    estimateName = character(),
    header = c("strata"),
    type = "flextable",
    groupColumn = list("group" = c("cdm_name", "cohort_name")),
    rename = c("Database name" = "cdm_name", "changeName" = "variable_name"),
    hide = c("result_id", "estimate_type"),
    .options = list())
  expect_true(colnames(fx3$body$dataset)[1] == "changeName")
})

test_that("don't want scientific",{
  res <- visOmopResults::visOmopTable(
    result = dplyr::tibble(
      result_id = 1L,
      cdm_name = "test",
      group_name =
        "overall",
      group_level = "overall",
      strata_name = "overall",
      strata_level = "overall",
      variable_name = "Number subjects",
      variable_level = NA_character_,
      estimate_name = "count",
      estimate_type = "integer",
      estimate_value = "100000",
      additional_name = "overall",

      additional_level = "overall"
    ) |> omopgenerics::newSummarisedResult(),
    estimateName = c(N = "<count>"),
    header = "cdm_name",
    hide = NULL
  )
  expect_true(res$`_data`$`[header_name]CDM name\n[header_level]test` == "100,000")
})

test_that("estimates at the end", {
  result <- mockSummarisedResult() |>
    dplyr::mutate(
      "additional_name" = "something_name",
      "additional_level" ="something_level"
    ) |>
    dplyr::select(omopgenerics::resultColumns()) |>
    omopgenerics::newSummarisedResult(settings = NULL)
  tab <- visOmopTable(result, settingsColumn = "package_name", type = "tibble")
  expect_equal(
    colnames(tab),
    c('CDM name', 'Cohort name', 'Age group', 'Sex', 'Variable name',
      'Variable level', 'Something name', 'Package name', 'Estimate name',
      'Estimate value')
  )
})

test_that("columnOrder and factor", {
  result <- mockSummarisedResult()
  expect_message(expect_message(
    visOmopTable(
      result,
      settingsColumn = "package_name",
      columnOrder = c("cdm_name", "cohort_name", "age_group", "sex", "variable_name", "variable_level", "count", "mean", "sd", "percentage"),
      type = "tibble"
    )
  ))

  table <- visOmopTable(
    result,
    settingsColumn = "package_name",
    columnOrder = c("cdm_name", "cohort_name", "age_group", "sex", "variable_name", "variable_level", "package_name", "estimate_name"),
    type = "tibble"
  )
  expect_true(all(colnames(table) == c('CDM name', 'Cohort name', 'Age group', 'Sex', 'Variable name', 'Variable level', 'Package name', 'Estimate name', 'Estimate value')))

  table <- visOmopTable(
    result,
    settingsColumn = "package_name",
    columnOrder = c("cdm_name", "cohort_name", "estimate_value", "age_group", "sex", "variable_name", "variable_level", "package_name", "estimate_name"),
    type = "tibble"
  )
  expect_true(all(colnames(table) == c('CDM name', 'Cohort name', 'Estimate value', 'Age group', 'Sex', 'Variable name', 'Variable level', 'Package name', 'Estimate name')))

  table <- visOmopTable(
    result,
    header = "estimate_name",
    settingsColumn = "package_name",
    columnOrder = c("cdm_name", "cohort_name", "estimate_value", "age_group", "sex", "variable_name", "variable_level", "package_name", "estimate_name"),
    type = "tibble"
  )
  expect_true(all(colnames(table) == c('CDM name', 'Cohort name', 'Age group', 'Sex', 'Variable name', 'Variable level', 'Package name', '[header_name]Estimate name\n[header_level]count', '[header_name]Estimate name\n[header_level]mean', '[header_name]Estimate name\n[header_level]sd', '[header_name]Estimate name\n[header_level]percentage')))

  table <- visOmopTable(
    result,
    header = "estimate_name",
    settingsColumn = "package_name",
    factor = list("sex" = c("overall", "Female", "Male", "hi"), "age_group" = c("overall", "<40", ">=40")),
    type = "tibble"
  )
  expect_true(all(table$Sex |> unique() == c("overall", "Female", "Male")))
  expect_true(all(table$`Age group` |> unique() == c("overall", "<40", ">=40")))

  expect_error(
    visOmopTable(
      result,
      header = "estimate_name",
      settingsColumn = "package_name",
      factor = list("sex" = c("overall", "Female"), "age_group" = c("overall", "<40", ">=40")),
      type = "tibble"
    )
  )
})

test_that("empty table", {
  gt <- visOmopTable(omopgenerics::emptySummarisedResult(), type = "gt")
  fx <- visOmopTable(omopgenerics::emptySummarisedResult(), type = "flextable")
  tib <- visOmopTable(omopgenerics::emptySummarisedResult(), type = "tibble")
  expect_true(nrow(gt$`_data`) == 0)
  expect_true(fx$body$col_keys == "Table has no data")
  expect_true(nrow(tib) == 0)
})

test_that("validate header works", {
  res <- dplyr::tibble(
    result_id = c(1L, 2L),
    cdm_name = "test",
    group_name = "overall",
    group_level = "overall",
    strata_name = "overall",
    strata_level = "overall",
    variable_name = "Number subjects",
    variable_level = NA_character_,
    estimate_name = "count",
    estimate_type = "integer",
    estimate_value = c("10", "20"),
    additional_name = "overall",

    additional_level = "overall"
  ) |>
    omopgenerics::newSummarisedResult(
      settings = dplyr::tibble(
        result_id = 1:2L, package_name = NA_character_, package_version = NA_character_,
        result_type = "prova", for_header = c("res1", "res2")
      )
    )
  expect_warning(newX <- visOmopTable(res, header = "variable_name", type = "tibble"))
  expect_true("For header" %in% colnames(newX))

  res <- dplyr::tibble(
    result_id = 1L,
    cdm_name = "test",
    group_name = "overall",
    group_level = "overall",
    strata_name = "strata",
    strata_level = c("strata1", "strata2"),
    variable_name = "Number subjects",
    variable_level = NA_character_,
    estimate_name = "count",
    estimate_type = "integer",
    estimate_value = c("10", "20"),
    additional_name = "overall",
    additional_level = "overall"
  ) |>
    omopgenerics::newSummarisedResult(
      settings = dplyr::tibble(
        result_id = 1L, package_name = NA_character_, package_version = NA_character_,
        result_type = "prova"
      )
    )
  expect_warning(newX <- visOmopTable(res, header = "variable_name", type = "tibble", hide = "strata"))
  expect_true("Strata" %in% colnames(newX))
})

test_that("test styles", {
  skip_on_cran()
  # VISUAL STYLE INSPECTION IN DIFFERENT SCENARIOS
  res <- mockSummarisedResult()
  visOmopTable(res, header = c("HEADER", "strata"), style = "default")
  visOmopTable(res, style = "default", groupColumn = "cohort_name")
  visOmopTable(res, style = "default")
  visOmopTable(res, header = c("HEADER", "strata"), style = "darwin")
  visOmopTable(res, style = "darwin", groupColumn = "cohort_name")
  visOmopTable(res, style = "darwin")
  visOmopTable(res, header = c("HEADER", "strata"), style = "default", type = "flextable")
  visOmopTable(res, style = "default", groupColumn = "cohort_name", type = "flextable")
  visOmopTable(res, style = "default", type = "flextable")
  visOmopTable(res, header = c("HEADER", "strata"), style = "darwin", type = "flextable")
  visOmopTable(res, style = "darwin", groupColumn = "cohort_name", type = "flextable")
  visOmopTable(res, header = c("HEADER", "strata"), style = "default", type = "tinytable")
  visOmopTable(res, style = "default", groupColumn = "cohort_name", type = "tinytable")
  visOmopTable(res, style = "default", type = "tinytable")
  visOmopTable(res, header = c("HEADER", "strata"), style = "darwin", type = "tinytable")
  visOmopTable(res, style = "darwin", groupColumn = "cohort_name", type = "tinytable")
  visOmopTable(res, style = "darwin", type = "tinytable")

  # numeric estimates for datatable and reactable
  dt <- visOmopTable(res, type = "datatable")
  expect_true( dt$x$data$`Estimate value` |> class() == "numeric")
  rt <- visOmopTable(res, type = "reactable")
  expect_true(rt$x$tag$attribs$columns[[8]]$type == "numeric")
})

test_that("global options works", {
  result <- mockSummarisedResult()
  setGlobalTableOptions("darwin", "tinytable")
  tab <- visOmopTable(result, header = "strata_level")
  expect_true(class(tab)[1] == "tinytable")
  tab <- visOmopTable(result, type = "gt")
  expect_true(class(tab)[1] == "gt_tbl")
  options(visOmopResults.tableStyle = NULL)
  options(visOmopResults.tableType = NULL)
})
