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
})
