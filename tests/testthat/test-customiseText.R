test_that("customiseText works", {
  # vectors
  expect_equal(
    customiseText(c("some_column_name", "another_column")),
    c("Some column name", "Another column")
  )

  expect_equal(
    customiseText(x = c("some_column", "another_column"),
              custom = c("Custom Name" = "another_column")),
    c("Some column", "Custom Name")
  )

  expect_equal(
    customiseText(x = c("some_column", "another_column"), keep = "another_column"),
    c("Some column", "another_column")
  )

  # in df
  df <- dplyr::tibble(
    some_column = c("hi_there", "rename_me", "example", "to_keep"),
    another_column = 1:4,
    to_keep = "as_is"
  ) |>
    dplyr::mutate(
      "some_column" = customiseText(some_column, custom = c("EXAMPLE" = "example"), keep = "to_keep")
    ) |>
    dplyr::rename_with(.fn = ~ customiseText(.x, keep = "to_keep"))
  expect_equal(
    df,
    dplyr::tibble(
      "Some column" = c("Hi there", "Rename me", "EXAMPLE", "to_keep"),
      "Another column" = 1:4,
      "to_keep" = "as_is"
    )
  )

  # other functions
  expect_equal(
    customiseText("hi_removeMe_there", fun = \(x)gsub("_removeMe_", " ", x)),
    "hi there"
  )
})
