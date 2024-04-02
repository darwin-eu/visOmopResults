test_that("pivotSettings", {
  result <- mockSummarisedResult()[1,] |>
    # settings
    dplyr::union_all(
      dplyr::tibble(
        "result_id" = as.integer(1),
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

  result <- result |> dplyr::union_all(result |> dplyr::mutate(result_id = as.integer(2)))

  res  <- pivotSettings(result)

  expect_true(nrow(res) == 2)
  expect_true(all(is.logical(res$mock_default)))
})
