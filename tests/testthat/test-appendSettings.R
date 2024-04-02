test_that("appendSettings", {
  result <- mockSummarisedResult()[1,] |>
    dplyr::mutate(
      mock_default = TRUE,
      isTest = 1
    )
  result <- result |>
    dplyr::union_all(
      result |>
        dplyr::mutate(result_id = as.integer(2), isTest = 0))

  res0 <- appendSettings(result, colsSettings = c("mock_default", "isTest"))
  expect_true(nrow(res0) == 6)
  expect_true(res0$estimate_type[res0$result_id == 1 & res0$estimate_name == "mock_default"] == "logical")
  expect_true(res0$estimate_type[res0$result_id == 1 & res0$estimate_name == "isTest"] == "numeric")

  res1 <- appendSettings(result |> dplyr::select(-"result_id"), colsSettings = c("mock_default", "isTest"))
  expect_equal(res0, res1)

  expect_error(appendSettings(result |> dplyr::mutate("result_id" = as.integer(1)), colsSettings = c("mock_default", "isTest")))

  res2 <- appendSettings(result |> dplyr::select(-"result_id", -"group_name"), colsSettings = c("mock_default", "isTest"))
  expect_equal(res0 |> dplyr::select(-"group_name"), res2)

  result <- result |> dplyr::mutate("hi" = "HI")
  res3 <- appendSettings(result, colsSettings = c("mock_default", "isTest"))
  expect_true(all(unique(res3$hi) %in% c(NA_character_, "HI")))

  result <- mockSummarisedResult()[1,] |>
    dplyr::mutate(
      mock_default = TRUE,
      isTest = 1
    )
  result <- result |>
    dplyr::union_all(
      result |>
        dplyr::mutate(result_id = as.integer(2), package_name = "testing"))
  res4 <- appendSettings(result, colsSettings = c("mock_default", "isTest"))

  expect_equal(res4[res4$package_name == "visOmopResults", c(2,3,5:ncol(res4))], res4[res4$package_name == "testing", c(2,3,5:ncol(res4))])
})
