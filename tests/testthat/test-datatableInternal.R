test_that("multiplication works", {
  # Create a sample tibble
  x <- dplyr::tibble(
    group = c("A", "A", "B", "B", "C", "C"),
    name = c("Alice", "Bob", "Charlie", "David", "Eve", "Frank"),
    age = c(25, 30, 35, 40, 22, 28),
    score = c(85, 90, 88, 92, 95, 87)
  )

  dt <- datatableInternal(x)
  expect_snapshot(dt)

  dt <- datatableInternal(x, caption = "hi there", groupColumn = list("group" = "group"))
  expect_snapshot(dt)

  dt <- datatableInternal(x, caption = "hi there", groupColumn = list("group" = "group"), groupOrder = c("B", "C", "A"))
  expect_snapshot(dt)
})

test_that("Multi-level headers generate correct HTML", {
  x <- dplyr::tibble(
    "cdm_name" = NA,
    "cohort_name\ncohort1\nsex\nmale" = NA,
    "cohort_name\ncohort1\nsex\nfemale" = NA,
    "cohort_name\ncohort2\nsex\nmale" = NA,
    "cohort_name\ncohort2\nsex\nfemale" = NA
  )
  dt <- datatableInternal(x)
  expect_snapshot(dt)

  dt <- datatableInternal(x, caption = "hi there", groupColumn = list("cdm_name" = "cdm_name"))
  expect_snapshot(dt)
})

