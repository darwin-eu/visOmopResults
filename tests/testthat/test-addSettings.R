test_that("addSettings", {
  x <- dplyr::tibble(
    "result_id" = as.integer(c(1, 2)),
    "cdm_name" = c("cprd", "eunomia"),
    "group_name" = "sex",
    "group_level" = "male",
    "strata_name" = "sex",
    "strata_level" = "male",
    "variable_name" = "Age group",
    "variable_level" = "10 to 50",
    "estimate_name" = "count",
    "estimate_type" = "numeric",
    "estimate_value" = "5",
    "additional_name" = "overall",
    "additional_level" = "overall"
  )
  expect_no_error(res <- omopgenerics::newSummarisedResult(
    x = x,
    settings = dplyr::tibble(
      "result_id" = c(1, 2),
      "result_type" = "summarised_characteristics",
      "package_name" = c("omock", "visOmopResults"),
      "package_version" = "0.4.0",
      "custom" = c("A", "B"))
  ))

  expect_identical(
    sort(colnames(settings(res))),
    c("custom", "package_name", "package_version", "result_id",
      "result_type")
  )

  expect_no_error(ress <- res |> addSettings())
  expect_true(all(colnames(settings(res)) %in% colnames(ress)))
  expect_identical(settings(ress), settings(res))
  expect_identical(ress, ress |> addSettings())

  expect_equal(res, addSettings(res, NULL))

  expect_equal(
    addSettings(result = res, settingsColumns = "result_type") |> colnames(),
    c('result_id', 'cdm_name', 'group_name', 'group_level', 'strata_name',
      'strata_level', 'variable_name', 'variable_level', 'estimate_name',
      'estimate_type', 'estimate_value', 'additional_name', 'additional_level',
      'result_type')
  )
})
