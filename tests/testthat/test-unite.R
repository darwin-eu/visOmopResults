test_that("uniteGroup", {
  tib <- dplyr::tibble(
    age = c(NA, ">40", "<=40", NA, NA, NA, NA, NA, ">40", "<=40"),
    sex = c(NA, NA, NA, "F", "M", NA, NA, NA, "F", "M"),
    region = c(NA, NA, NA, NA, NA, "North", "South", "Center", NA, NA)
  )

  expect_error(tib |> uniteGroup(NA_character_))
  expect_error(tib |> uniteNameLevel(name = "expo_group", level = "exposure_level"))
  expect_error(tib |> uniteNameLevel(level = NA_character_))
  expect_error(tib |> uniteNameLevel(level = "a"))


  expect_no_error(res0 <- uniteNameLevel(tib,
                                         c("age", "sex", "region"),
                                         keep = FALSE))
  expect_equal(colnames(res0),
               c("group_name", "group_level"))
  expect_true(res0[1,1] == "overall")
  expect_true(res0[1,2] == "overall")
  expect_equal(res0$group_name[grepl("40", res0$group_level)] |> unique(),
               c("age", "age &&& sex"))
  expect_equal(res0$group_name[grepl("region", res0$group_name)] |> unique(),
               "region")

  expect_no_error(res1 <- uniteNameLevel(tib,
                                         c("age", "sex", "region"),
                                         keep = TRUE))
  expect_equal(colnames(res1),
               c("age", "sex", "region", "group_name", "group_level"))
  expect_true(all(is.na(res1[1,1:3])))

  expect_no_error(res2 <- uniteNameLevel(tib,
                                         c("age", "sex", "region"),
                                         keep = FALSE,
                                         removeNA = FALSE))
  expect_true(res2$group_level[1] == "NA &&& NA &&& NA")
  expect_true(res2$group_level[2] == ">40 &&& NA &&& NA")
})
