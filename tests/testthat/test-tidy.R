test_that("tidy", {
  mocksum <- mockSummarisedResult() |>
  # settings
  dplyr::union_all(
    dplyr::tibble(
      result_id = as.integer(1),
      "cdm_name" = "mock",
      "result_type" = "mock_summarised_result",
      "package_name" = "visOmopResults",
      "package_version" = utils::packageVersion("visOmopResults") |>
        as.character(),
      "group_name" = "overall",
      "group_level" = "overall",
      "strata_name" = "overall",
      "strata_level" = "overall",
      "variable_name" = "settings",
      "variable_level" = NA_character_,
      "estimate_name" = "mock_default",
      "estimate_type" = "logical",
      "estimate_value" = "TRUE",
      "additional_name" = "overall",
      "additional_level" = "overall"
    )
  )

  expect_no_error(res0 <- tidy(x = mocksum, pivotEstimatesBy = "estimate_name"))
  expect_true(nrow(res0 |> dplyr::filter(.data$variable_name == "settings")) == 0)
  expect_true(all(c("cohort_name", "age_group", "sex", "mock_default", "count",
                    "mean", "sd", "percentage") %in% colnames(res0)))
  expect_true(class(res0$percentage) == "numeric")
  expect_true(class(res0$mean) == "numeric")
  expect_true(class(res0$count) == "integer")

  expect_no_error(res1 <- tidy(mocksum, splitGroup = FALSE, splitAdditional = FALSE,
                               splitStrata = FALSE, pivotEstimatesBy = c("variable_name", "variable_level", "estimate_name")))
  expect_true(all(c("group_name", "group_level", "strata_name", "strata_level",
                    "additional_name", "additional_level", "mock_default") %in%
                    colnames(res1)))
  expect_true(all(c("number subjects_NA_count", "age_NA_mean", "age_NA_sd", "Medications_Amoxiciline_count",
                    "Medications_Amoxiciline_percentage", "Medications_Ibuprofen_count",
                    "Medications_Ibuprofen_percentage", "mock_default") %in% colnames(res1)))

  expect_no_error(res2 <- tidy(mocksum |> dplyr::filter(variable_name != "settings"),
                               splitGroup = FALSE,
                               splitAdditional = FALSE,
                               pivotEstimatesBy = c("variable_name", "estimate_name"),
                               nameStyle = "{estimate_name}__{variable_name}"))
  expect_false("mock_default" %in% colnames(res2))
  expect_false("logic__settings" %in% colnames(res2))
  expect_true(all(c("count__number subjects", "mean__age", "sd__age",
                    "count__Medications", "percentage__Medications") %in% colnames(res2)))
  expect_true(class(res2$percentage__Medications) == "numeric")
  expect_true(class(res2$mean__age) == "numeric")
  expect_true(class(res2$count__Medications) == "integer")

  expect_no_error(res3 <- tidy(mocksum, splitGroup = FALSE, splitAdditional = FALSE, splitStrata = FALSE,
                                pivotEstimatesBy = NULL))
  expect_true(all(colnames(res3) %in% c(colnames(mocksum), "mock_default")))

})
