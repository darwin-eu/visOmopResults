test_that("multiplication works", {
  # Create a sample tibble
  x <- dplyr::tibble(
    group = c("A", "A", "B", "B", "C", "C"),
    name = c("Alice", "Bob", "Charlie", "David", "Eve", "Frank"),
    age = c(25, 30, 35, 40, 22, 28),
    score = c(85, 90, 88, 92, 95, 87)
  )

  dt <- reactableInternal(x)
  expect_snapshot(dt$x)

  dt <- reactableInternal(x, groupColumn = list("group" = "group"))
  expect_snapshot(dt$x)


  dt <- reactableInternal(x, groupColumn = list("group" = "group"), groupOrder = c("B", "A", "C"))
  expect_snapshot(dt$x)
})

test_that("Multi-level headers generate correct HTML", {
  x <- dplyr::tibble(
    "cdm_name" = NA,
    "cohort_name\ncohort1\nsex\nmale" = NA,
    "cohort_name\ncohort1\nsex\nfemale" = NA,
    "cohort_name\ncohort2\nsex\nmale" = NA,
    "cohort_name\ncohort2\nsex\nfemale" = NA
  )
  expect_warning(dt <- reactableInternal(x))
  expect_snapshot(dt$x)

  x <- dplyr::tibble(
    "cdm_name" = c("A", "A", "B", "B", "C", "C"),
    "sex\nmale" = 1,
    "sex\nfemale" = 2,
    "cohort_name\ncohort1" = 3,
    "cohort_name\ncohort2" = 4
  )
  dt <- reactableInternal(x)
  expect_snapshot(dt$x)

  dt <- reactableInternal(x, groupColumn = list("cdm_name" = "cdm_name"))
  expect_snapshot(dt$x)
})
