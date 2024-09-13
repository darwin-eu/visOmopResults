test_that("visOmopTable", {
  result <- mockSummarisedResult()
  expect_message(
    expect_no_error(
      gt1 <- visOmopTable(
        result = result,
        formatEstimateName = character(),
        header = character(),
        groupColumn = NULL,
        type = "gt",
        settingsColumns = character(),
        hide = c("result_id", "estimate_type"),
        .options = list())
    )
  )
  expect_true("gt_tbl" %in% class(gt1))
  expect_true(all(c("CDM name", "Cohort name", "Age group", "Sex", "Variable name", "Variable level", "Estimate name", "Estimate value") %in%
                    colnames(gt1$`_data`)))

  expect_message(
    expect_no_error(
      gt2 <- visOmopTable(
        result = result,
        formatEstimateName = c("N%" = "<count> (<percentage>)", "N" = "<count>"),
        header = c("strata"),
        groupColumn = NULL,
        type = "gt",
        .options = list())
    )
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

  expect_message(
    expect_no_error(
      fx1 <- visOmopTable(
        result = result,
        formatEstimateName = c("N%" = "<count> (<percentage>)", "N" = "<count>", "<mean>, <sd>"),
        header = c("group", "estimate"),
        groupColumn = NULL,
        type = "flextable",
        hide = c("result_id", "estimate_type", "cdm_name"),
        .options = list(includeHeaderName = FALSE))
    )
  )
  expect_true("flextable" == class(fx1))
  expect_true(all(c(
    'Age group', 'Sex', 'Variable name', 'Variable level', 'cohort1\nN', 'cohort2\nN',
    'cohort1\nmean, sd', 'cohort2\nmean, sd', 'cohort1\nN%', 'cohort2\nN%'
  ) %in% colnames(fx1$body$dataset)))
  expect_true(nrow(fx1$body$dataset) == 36)

  expect_message(
    expect_no_error(
      fx2 <- visOmopTable(
        result = result,
        formatEstimateName = c("N%" = "<count> (<percentage>)", "N" = "<count>", "<mean>, <sd>"),
        header = c("variable", "estimate"),
        groupColumn = NULL,
        type = "flextable",
        hide = c("result_id", "estimate_type", "cdm_name"),
        .options = list(includeHeaderName = TRUE))
    )
  )
  expect_true("flextable" == class(fx2))
  expect_true(all(c(
    'Cohort name', 'Age group', 'Sex', 'Variable name\nnumber subjects\nVariable level\n-\nEstimate name\nN',
    'Variable name\nage\nVariable level\n-\nEstimate name\nmean, sd',
    'Variable name\nMedications\nVariable level\nAmoxiciline\nEstimate name\nN%',
    'Variable name\nMedications\nVariable level\nIbuprofen\nEstimate name\nN%'
  ) %in% colnames(fx2$body$dataset)))
  expect_true(nrow(fx2$body$dataset) == 18)

  expect_message(
    expect_no_error(
      fx3 <- visOmopTable(
        result = result,
        formatEstimateName = c("N%" = "<count> (<percentage>)", "N" = "<count>", "<mean>, <sd>"),
        header = c("strata", "estimate"),
        groupColumn = "cohort_name",
        type = "flextable",
        hide = c("result_id", "estimate_type", "cdm_name"),
        .options = list())
    )
  )
  expect_true("flextable" == class(fx3))
  expect_true(all(c(
    'Cohort name', 'Variable name', 'Variable level', 'Age group\noverall\nSex\noverall\nEstimate name\nN',
    'Age group\n<40\nSex\nMale\nEstimate name\nN', 'Age group\n>=40\nSex\nMale\nEstimate name\nN',
    'Age group\n<40\nSex\nFemale\nEstimate name\nN', 'Age group\n>=40\nSex\nFemale\nEstimate name\nN',
    'Age group\noverall\nSex\nMale\nEstimate name\nN', 'Age group\noverall\nSex\nFemale\nEstimate name\nN',
    'Age group\n<40\nSex\noverall\nEstimate name\nN', 'Age group\n>=40\nSex\noverall\nEstimate name\nN',
    'Age group\noverall\nSex\noverall\nEstimate name\nmean, sd', 'Age group\n<40\nSex\nMale\nEstimate name\nmean, sd',
    'Age group\n>=40\nSex\nMale\nEstimate name\nmean, sd', 'Age group\n<40\nSex\nFemale\nEstimate name\nmean, sd',
    'Age group\n>=40\nSex\nFemale\nEstimate name\nmean, sd', 'Age group\noverall\nSex\nMale\nEstimate name\nmean, sd',
    'Age group\noverall\nSex\nFemale\nEstimate name\nmean, sd', 'Age group\n<40\nSex\noverall\nEstimate name\nmean, sd',
    'Age group\n>=40\nSex\noverall\nEstimate name\nmean, sd', 'Age group\noverall\nSex\noverall\nEstimate name\nN%',
    'Age group\n<40\nSex\nMale\nEstimate name\nN%', 'Age group\n>=40\nSex\nMale\nEstimate name\nN%',
    'Age group\n<40\nSex\nFemale\nEstimate name\nN%', 'Age group\n>=40\nSex\nFemale\nEstimate name\nN%',
    'Age group\noverall\nSex\nMale\nEstimate name\nN%', 'Age group\noverall\nSex\nFemale\nEstimate name\nN%',
    'Age group\n<40\nSex\noverall\nEstimate name\nN%', 'Age group\n>=40\nSex\noverall\nEstimate name\nN%'
  ) %in% colnames(fx3$body$dataset)))
  expect_true(nrow(fx3$body$dataset) == 10)

  # settings ----
  result <- mockSummarisedResult() |>
    omopgenerics::suppress(10000000)
  expect_no_error(
    tib1 <- visOmopTable(
      result = result,
      formatEstimateName = c("N%" = "<count> (<percentage>)", "N" = "<count>", "<mean>, <sd>"),
      header = c("group", "settings"),
      settingsColumns = colnames(settings(result)),
      groupColumn = NULL,
      type = "tibble",
      hide = c("result_id", "estimate_type", "cdm_name"),
      .options = list())
  )
  expect_true(all(c("tbl_df", "tbl", "data.frame") %in% class(tib1)))
  expect_true(all(c(
    'Age group', 'Sex', 'Variable name', 'Variable level', 'Estimate name',
    glue::glue('[header_name]Cohort name\n[header_level]cohort1\n[header_name]Result type\n[header_level]mock_summarised_result\n[header_name]Package name\n[header_level]visOmopResults\n[header_name]Package version\n[header_level]{utils::packageVersion("visOmopResults")}\n[header_name]Min cell count\n[header_level]10000000'),
    glue::glue('[header_name]Cohort name\n[header_level]cohort2\n[header_name]Result type\n[header_level]mock_summarised_result\n[header_name]Package name\n[header_level]visOmopResults\n[header_name]Package version\n[header_level]{utils::packageVersion("visOmopResults")}\n[header_name]Min cell count\n[header_level]10000000'))  %in% colnames(tib1)))
  expect_true(all(tib1[,6] |> dplyr::pull() |> unique() == c("<10,000,000", "<10,000,000, <10,000,000", "<10,000,000 (<10,000,000)")))

  # woring group column
  expect_error(
    visOmopTable(
      result = result,
      formatEstimateName = c("N%" = "<count> (<percentage>)", "N" = "<count>", "<mean>, <sd>"),
      header = c("group", "settings"),
      groupColumn = "hola",
      type = "tibble",
      hide = c("result_id", "estimate_type", "cdm_name"),
      .options = list())
  )
})

test_that("renameColumn works", {
  result <- mockSummarisedResult()
  expect_message(
    expect_no_error(
      gt1 <- visOmopTable(
        result = result,
        formatEstimateName = character(),
        header = character(),
        groupColumn = NULL,
        type = "gt",
        renameColumns = c("Database name" = "cdm_name"),
        hide = c("result_id", "estimate_type"),
        .options = list())
    )
  )
  expect_true(all(
    colnames(gt1$`_data`) ==
      c("Database name", "Cohort name", "Age group", "Sex", "Variable name",
        "Variable level", "Estimate name", "Estimate value")
  ))

  expect_no_error(
    gt2 <- visOmopTable(
      result = result,
      formatEstimateName = character(),
      header = c("cdm_name", "strata"),
      groupColumn = NULL,
      type = "gt",
      renameColumns = c("Database name" = "cdm_name", "changeName" = "variable_name"),
      hide = c("result_id", "estimate_type"),
      .options = list())
  )
  expect_true(all(colnames(gt2$`_data`)[1:2] == c("Cohort name", "changeName")))
  expect_true(all(colnames(gt2$`_data`)[5] == "[header_name]Database name\n[header_level]mock\n[header_name]Age group\n[header_level]overall\n[header_name]Sex\n[header_level]overall"))

  expect_message(
    expect_warning(
      fx1 <- visOmopTable(
        result = result,
        formatEstimateName = character(),
        header = c("cdm_name", "strata"),
        groupColumn = NULL,
        split = c("group", "strata", "additional"),
        type = "flextable",
        renameColumns = c("Database name" = "cdm_name", "changeName" = "name"),
        hide = c("result_id", "estimate_type"),
        .options = list())
    )
  )

  # more than 1 group column
  fx2 <- visOmopTable(
    result = result,
    formatEstimateName = character(),
    header = c("strata"),
    type = "flextable",
    groupColumn = c("cdm_name", "cohort_name"),
    renameColumns = c("Database name" = "cdm_name", "changeName" = "variable_name"),
    hide = c("result_id", "estimate_type"),
    .options = list())
  expect_true(colnames(fx2$body$dataset)[1] == "Cdm name; Cohort name")

  # more than 1 group column
  fx3 <- visOmopTable(
    result = result,
    formatEstimateName = character(),
    header = c("strata"),
    split = c("group", "strata", "additional"),
    type = "flextable",
    groupColumn = list("group" = c("cdm_name", "cohort_name")),
    renameColumns = c("Database name" = "cdm_name", "changeName" = "variable_name"),
    hide = c("result_id", "estimate_type"),
    .options = list())
  expect_true(colnames(fx3$body$dataset)[1] == "group")
})


test_that("empty result",{

  result = omopgenerics::emptySummarisedResult()
  type = "gt"
  formatEstimateName = c(
    "N (%)" = "<count> (<percentage>%)",
    "N" = "<count>",
    "Median [Q25 - Q75]" = "<median> [<q25> - <q75>]",
    "Mean (SD)" = "<mean> (<sd>)",
    "Range" = "<min> to <max>"
  )
  header = c("group")
  split = c("group", "strata")
  groupColumn = NULL
  hide = c(
    "result_id", "estimate_type",
    "additional_name", "additional_level"
  )
  .options = list()

  expect_warning({
    res0 <-  visOmopResults::visOmopTable(
      result = result,
      formatEstimateName = formatEstimateName,
      header = header,
      groupColumn = groupColumn,
      split = split,
      type = type,
      hide = hide,
      .options = .options
    )

  }, "Empty summarized results provided.")

})
