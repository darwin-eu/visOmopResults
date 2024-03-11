test_that("splitGroup", {
  tib <- dplyr::tibble(
    group_name = c("cohort_name", "cohort_name &&& age", "age &&& sex"),
    group_level = c("acetaminophen", "ibuprofen &&& 10 to 19", "20 to 29 &&& Male"),
    x = c("cohort_name", "cohort_name &&& age", "age &&& sex"),
    y = c("acetaminophen", "ibuprofen &&& 10 to 19", "20 to 29 &&& Male"),
    z = c(1, 2, 3),
    a = c("a", "b", "c")
  )
  expect_error(tib |> splitGroup(NA_character_))
  expect_no_error(res0 <- tib |> splitGroup())
  expect_false("group_name" %in% colnames(res0))
  expect_false("group_level" %in% colnames(res0))
  expect_true(all(c("cohort_name", "age", "sex") %in% colnames(res0)))
  expect_equal(res0$cohort_name, c("acetaminophen", "ibuprofen", "overall"))
  expect_equal(res0$age, c("overall", "10 to 19", "20 to 29"))
  expect_equal(res0$sex, c("overall", "overall", "Male"))
  expect_no_error(res1 <- tib |> splitNameLevel(keep = TRUE))
  expect_true("group_name" %in% colnames(res1))
  expect_true("group_level" %in% colnames(res1))
  expect_true(all(c("cohort_name", "age", "sex") %in% colnames(res1)))
  expect_warning(tib |> splitNameLevel(keep = TRUE) |> splitGroup())
  expect_no_error(res2 <- tib |> splitNameLevel(name = "x", level = "y", keep = TRUE))
  cols <- colnames(res1) |> sort()
  expect_equal(
    res1 |> dplyr::select(dplyr::all_of(cols)),
    res2 |> dplyr::select(dplyr::all_of(cols))
  )
  expect_error(tib |> splitNameLevel(name = "expo_group", level = "exposure_level"))
  expect_error(tib |> splitNameLevel(level = NA_character_))
  expect_error(tib |> splitNameLevel(level = "a"))
  expect_no_error(res3 <- tib |> splitNameLevel(name = "x", level = "y", keep = TRUE, fill = "Any"))
  expect_true(all(res2$age[res2$age != "overall"] == res3$age[res2$age != "overall"]))
  expect_true(all(res2$sex[res2$sex != "overall"] == res3$sex[res2$sex != "overall"]))
  expect_true(all(res3$age[res2$age == "overall"] == "Any"))
  expect_true(all(res3$sex[res2$sex == "overall"] == "Any"))

  tib <- dplyr::tibble(
    group_name = c("overall", "cohort_name &&& age", "age &&& sex"),
    group_level = c("overall", "ibuprofen &&& 10 to 19", "20 to 29 &&& Male"),
    z = c(1, 2, 3),
    a = c("a", "b", "c")
  )
  expect_false("overall" %in% colnames(splitGroup(tib)))
  expect_true(all(groupColumns(tib) == c("cohort_name", "age", "sex")))
})
