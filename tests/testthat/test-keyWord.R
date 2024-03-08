test_that("multiplication works", {
  tib <- dplyr::tibble(
    group_name = c("cohort_name", "cohort_name and age", "age and sex"),
    group_level = c("acetaminophen", "ibuprofen and 10 to 19", "20 to 29 and Male"),
    x = c("cohort_name", "cohort_name and age", "age and sex"),
    y = c("acetaminophen", "ibuprofen and 10 to 19", "20 to 29 and Male"),
    z = c(1, 2, 3),
    a = c("a", "b", "c")
  )

  expect_no_error(res <- tib |> splitGroup())
  expect_true(all(c("cohort_name", "age", "sex") %in% colnames(res)))

  res1 <- tib |> groupColumns()
  expect_true(all(c("cohort_name", "age", "sex") %in% res1))
})
