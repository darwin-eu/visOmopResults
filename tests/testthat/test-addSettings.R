test_that("addSettings", {
  x <- dplyr::tibble(
    "result_id" = as.integer(c(1, 2)),
    "cdm_name" = c("cprd", "eunomia"),
    "result_type" = "summarised_characteristics",
    "package_name" = "PatientProfiles",
    "package_version" = "0.4.0",
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
  expect_no_error(res <- newSummarisedResult(x = x, settings = dplyr::tibble(
    "result_id" = c(1, 2), "custom" = c("A", "B")
  )))

  expect_identical(
    sort(colnames(settings(res))),
    c("cdm_name", "custom", "package_name", "package_version", "result_id",
      "result_type")
  )

  expect_no_error(ress <- res |> addSettings())
  expect_true(all(colnames(settings(res)) %in% colnames(ress)))
  expect_identical(settings(ress), settings(res))
  expect_identical(ress, ress |> addSettings())

  res1 <- res |> filterSettings(cdm_name == "cprd")
  expect_true(nrow(res1) == 1)
  expect_true(res1$result_id == 1)

  res2 <- res |> filterSettings(custom == "B")
  expect_true(nrow(res2) == 1)
  expect_true(res2$result_id == 2)

})
