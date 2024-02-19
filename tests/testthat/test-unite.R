test_that("splitGroup", {
  tib <- dplyr::tibble(
    cohort_name = c("cohort1", "cohort1", "cohort2", "cohort2"),
    prior_history = c(180, 365, 180, 365)
  )

  expect_error(tib |> uniteGroup(NA_character_))
  expect_no_error(res0 <- tib |> uniteGroup(c("cohort_name", "prior_history")))
  expect_true("group_name" %in% colnames(res0))
  expect_true("group_level" %in% colnames(res0))
  expect_true(unique(res0$group_name) == "cohort_name and prior_history")
  expect_equal(res0$group_level, c("cohort1 and 180", "cohort1 and 365", "cohort2 and 180", "cohort2 and 365"))

  expect_no_error(res1 <- uniteNameLevel(
    tib,
    cols = c("cohort_name", "prior_history"),
    name = "strata_name",
    level = "strata_level"))
  expect_true("strata_name" %in% colnames(res1))
  expect_true("strata_level" %in% colnames(res1))
  expect_true(unique(res1$strata_name) == "cohort_name and prior_history")
  expect_equal(res1$strata_level, c("cohort1 and 180", "cohort1 and 365", "cohort2 and 180", "cohort2 and 365"))

  expect_error(tib |> uniteNameLevel(name = "expo_group", level = "exposure_level"))
  expect_error(tib |> uniteNameLevel(level = NA_character_))
  expect_error(tib |> uniteNameLevel(level = "a"))
})
