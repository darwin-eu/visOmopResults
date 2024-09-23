test_that("formatHeader", {
  result <- mockSummarisedResult()

  # Include headers + noncolumn names----
  result_output <- formatHeader(result = result,
                             header = c("group_name", "group_level", "strata", "strata_name", "strata_level"),
                             includeHeaderName = TRUE)

  # column: group_name\ncohort_name\ngroup_level\ncohort2\nstrata\nstrata_name\nsex\nstrata_level\nMale
  values_in <- result |>
    dplyr::filter(.data$group_level == "cohort2" & .data$strata_level == "Male") |>
    dplyr::select(all_of(names(result)[! names(result) %in% c("group_name", "group_level", "strata", "strata_name", "strata_level")]))

  values_out <- result_output |>
    dplyr::select(all_of(c(names(result)[! names(result) %in% c("group_name", "group_level", "strata", "strata_name", "strata_level", "estimate_value")],
                           "estimate_value" = "[header_name]group_name\n[header_level]cohort_name\n[header_name]group_level\n[header_level]cohort2\n[header]strata\n[header_name]strata_name\n[header_level]sex\n[header_name]strata_level\n[header_level]Male")))
  expect_true(values_in |> dplyr::anti_join(values_out, by = names(values_in)) |> nrow() == 0)

  # class
  expect_false("summarised_result" %in% class(result_output))

  # column: group_name\ncohort_name\ngroup_level\ncohort1\nstrata\nstrata_name\nage_group &&& sex\nstrata_level\n>=40 &&& Female
  values_in <- result |>
    dplyr::filter(.data$group_level == "cohort1" & .data$strata_level == ">=40 &&& Female") |>
    dplyr::select(all_of(names(result)[! names(result) %in% c("group_name", "group_level", "strata", "strata_name", "strata_level")]))

  values_out <- result_output |>
    dplyr::select(all_of(c(names(result)[! names(result) %in% c("group_name", "group_level", "strata", "strata_name", "strata_level", "estimate_value")],
                           "estimate_value" = "[header_name]group_name\n[header_level]cohort_name\n[header_name]group_level\n[header_level]cohort1\n[header]strata\n[header_name]strata_name\n[header_level]age_group &&& sex\n[header_name]strata_level\n[header_level]>=40 &&& Female")))
  expect_true(values_in |> dplyr::anti_join(values_out, by = names(values_in)) |> nrow() == 0)

  # names in header ----
  result_output <- formatHeader(result = result,
                               header = c("Group name" = "group_name", "group_level", "strata", "strata_name", "strata_level"),
                               includeHeaderName = TRUE)

  # column: group_name\ncohort_name\ngroup_level\ncohort2\nstrata\nstrata_name\nsex\nstrata_level\nMale
  values_in <- result |>
    dplyr::filter(.data$group_level == "cohort2" & .data$strata_level == "Male") |>
    dplyr::select(all_of(names(result)[! names(result) %in% c("group_name", "group_level", "strata", "strata_name", "strata_level")]))

  values_out <- result_output |>
    dplyr::select(all_of(c(names(result)[! names(result) %in% c("group_name", "group_level", "strata", "strata_name", "strata_level", "estimate_value")],
                           "estimate_value" = "[header_name]Group name\n[header_level]cohort_name\n[header_name]group_level\n[header_level]cohort2\n[header]strata\n[header_name]strata_name\n[header_level]sex\n[header_name]strata_level\n[header_level]Male")))
  expect_true(values_in |> dplyr::anti_join(values_out, by = names(values_in)) |> nrow() == 0)


  # Not include headers + noncolumn names----
  result_output <- formatHeader(result = result,
                              header = c("group_name", "group_level", "strata", "strata_name", "strata_level"),
                              includeHeaderName = FALSE)

  # column: cohort_name\ncohort2\nstrata\nsex\nMale
  values_in <- result |>
    dplyr::filter(.data$group_level == "cohort2" & .data$strata_level == "Male") |>
    dplyr::select(all_of(names(result)[! names(result) %in% c("group_name", "group_level", "strata", "strata_name", "strata_level")]))

  values_out <- result_output |>
    dplyr::select(all_of(c(names(result)[! names(result) %in% c("group_name", "group_level", "strata", "strata_name", "strata_level", "estimate_value")],
                           "estimate_value" = "[header_level]cohort_name\n[header_level]cohort2\n[header]strata\n[header_level]sex\n[header_level]Male")))
  expect_true(values_in |> dplyr::anti_join(values_out, by = names(values_in)) |> nrow() == 0)

  # Named header ----
  result_output <- formatHeader(result = result,
                               header = c("group_name", "Group level" = "group_level", "strata", "strata_name", "strata_level"),
                               includeHeaderName = FALSE)

  # column: cohort_name\ncohort1\nstrata\nage_group &&& sex\n>=40 &&& Female
  values_in <- result |>
    dplyr::filter(.data$group_level == "cohort1" & .data$strata_level == ">=40 &&& Female") |>
    dplyr::select(all_of(names(result)[! names(result) %in% c("group_name", "group_level", "strata", "strata_name", "strata_level")]))

  values_out <- result_output |>
    dplyr::select(all_of(c(names(result)[! names(result) %in% c("group_name", "group_level", "strata", "strata_name", "strata_level", "estimate_value")],
                           "estimate_value" = "[header_level]cohort_name\n[header_level]cohort1\n[header]strata\n[header_level]age_group &&& sex\n[header_level]>=40 &&& Female")))
  expect_true(values_in |> dplyr::anti_join(values_out, by = names(values_in)) |> nrow() == 0)

  # Not include headers + only column names----
  result_output <- formatHeader(result = result,
                              header = c("group_name", "group_level"),
                              includeHeaderName = FALSE)
  # column: cohort_name\ncohort1
  values_in <- result |>
    dplyr::filter(.data$group_level == "cohort1") |>
    dplyr::select(all_of(names(result)[! names(result) %in% c("group_name", "group_level")]))

  values_out <- result_output |>
    dplyr::select(all_of(c(names(result)[! names(result) %in% c("group_name", "group_level", "estimate_value")],
                           "estimate_value" = "[header_level]cohort_name\n[header_level]cohort1")))
  expect_true(values_in |> dplyr::anti_join(values_out, by = names(values_in)) |> nrow() == 0)

  # Not include headers + noncolumn names----
  result_output <- formatHeader(result = result,
                              header = c("test_spanHeader", "group_name", "next_row", "group_level", "end_spanner"),
                              includeHeaderName = TRUE)
  # column: cohort_name\ncohort1
  values_in <- result |>
    dplyr::filter(.data$group_level == "cohort1") |>
    dplyr::select(all_of(names(result)[! names(result) %in% c("group_name", "group_level")]))

  values_out <- result_output |>
    dplyr::select(all_of(c(names(result)[! names(result) %in% c("group_name", "group_level", "estimate_value")],
                           "estimate_value" = "[header]test_spanHeader\n[header_name]group_name\n[header_level]cohort_name\n[header]next_row\n[header_name]group_level\n[header_level]cohort1\n[header]end_spanner")))
  expect_true(values_in |> dplyr::anti_join(values_out, by = names(values_in)) |> nrow() == 0)

  # Not include headers + noncolumn names + named header----
  result_output <- formatHeader(result = result,
                               header = c("TEST" = "test_spanHeader", "group_name", "next_row", "test_level" = "group_level", "end_spanner"),
                               includeHeaderName = TRUE)
  # column: cohort_name\ncohort1
  values_in <- result |>
    dplyr::filter(.data$group_level == "cohort1") |>
    dplyr::select(all_of(names(result)[! names(result) %in% c("group_name", "group_level")]))

  values_out <- result_output |>
    dplyr::select(all_of(c(names(result)[! names(result) %in% c("group_name", "group_level", "estimate_value")],
                           "estimate_value" = "[header]TEST\n[header_name]group_name\n[header_level]cohort_name\n[header]next_row\n[header_name]test_level\n[header_level]cohort1\n[header]end_spanner")))
  expect_true(values_in |> dplyr::anti_join(values_out, by = names(values_in)) |> nrow() == 0)


  # not column names ----
  result_output <- formatHeader(result = result,
                              header = c("test_spanHeader", "end_spanner"),
                              delim = ":",
                              includeHeaderName = TRUE)
  class(result_output) <- class(result)
  expect_equal(
    result_output,
    result |>
      dplyr::relocate("estimate_value", .after = dplyr::last_col()) |>
      dplyr::rename("[header]test_spanHeader:[header]end_spanner" = "estimate_value")
  )

  # not column name + named header ----
  result_output <- formatHeader(result = result,
                               header = c("test" = "test_spanHeader", "end" = "end_spanner"),
                               delim = ":",
                               includeHeaderName = TRUE)
  expect_true(
    result_output |>
      dplyr::anti_join(result |> dplyr::rename("[header]test_spanHeader:[header]end_spanner" = "estimate_value"),
                       by = colnames(result_output)) |>
      nrow() == 0
  )

  expect_false("summarised_result" %in% class(result_output))

  # Empty input ----
  expect_no_error(res <- formatHeader(result = result,
                                      header = NULL,
                                      includeHeaderName = TRUE))
  expect_identical(result, res)

  expect_no_error(res <- formatHeader(result = result,
                                      header = character(0),
                                      includeHeaderName = TRUE))
  expect_identical(result, res)

  # Wrong input ----
  expect_error(formatHeader(result = result,
                          header = NA,
                          includeHeaderName = TRUE))

})

test_that("formatHeader. includeHeaderKey", {
  result <- mockSummarisedResult()

  # Include headers + noncolumn names----
  result_output <- formatHeader(result = result,
                               header = c("group_name", "group_level", "strata_name", "strata_level"),
                               includeHeaderName = TRUE,
                               includeHeaderKey = FALSE)

  # column: group_name\ncohort_name\ngroup_level\ncohort2\nstrata\nstrata_name\nsex\nstrata_level\nMale
  values_in <- result |>
    dplyr::filter(.data$group_level == "cohort2" & .data$strata_level == "Male") |>
    dplyr::select(all_of(names(result)[! names(result) %in% c("group_name", "group_level", "strata_name", "strata_level")]))

  values_out <- result_output |>
    dplyr::select(all_of(c(names(result)[! names(result) %in% c("group_name", "group_level", "strata_name", "strata_level", "estimate_value")],
                           "estimate_value" = "group_name\ncohort_name\ngroup_level\ncohort2\nstrata_name\nsex\nstrata_level\nMale")))
  expect_true(values_in |> dplyr::anti_join(values_out, by = names(values_in)) |> nrow() == 0)

  # class
  expect_false("summarised_result" %in% class(result_output))

  # column: group_name\ncohort_name\ngroup_level\ncohort1\nstrata\nstrata_name\nage_group &&& sex\nstrata_level\n>=40 &&& Female
  values_in <- result |>
    dplyr::filter(.data$group_level == "cohort1" & .data$strata_level == ">=40 &&& Female") |>
    dplyr::select(all_of(names(result)[! names(result) %in% c("group_name", "group_level", "strata", "strata_name", "strata_level")]))

  values_out <- result_output |>
    dplyr::select(all_of(c(names(result)[! names(result) %in% c("group_name", "group_level", "strata", "strata_name", "strata_level", "estimate_value")],
                           "estimate_value" = "group_name\ncohort_name\ngroup_level\ncohort1\nstrata_name\nage_group &&& sex\nstrata_level\n>=40 &&& Female")))
  expect_true(values_in |> dplyr::anti_join(values_out, by = names(values_in)) |> nrow() == 0)


  # Not include headers + only column names----
  result_output <- formatHeader(result = result,
                               header = c("group_name", "group_level"),
                               includeHeaderName = FALSE,
                               includeHeaderKey = FALSE)
  # column: cohort_name\ncohort1
  values_in <- result |>
    dplyr::filter(.data$group_level == "cohort1") |>
    dplyr::select(all_of(names(result)[! names(result) %in% c("group_name", "group_level")]))

  values_out <- result_output |>
    dplyr::select(all_of(c(names(result)[! names(result) %in% c("group_name", "group_level", "estimate_value")],
                           "estimate_value" = "cohort_name\ncohort1")))
  expect_true(values_in |> dplyr::anti_join(values_out, by = names(values_in)) |> nrow() == 0)

  # Not include headers + noncolumn names----
  result_output <- formatHeader(result = result,
                               header = c("test_spanHeader", "group_name", "next_row", "group_level", "end_spanner"),
                               includeHeaderName = TRUE,
                               includeHeaderKey = FALSE)
  # column: cohort_name\ncohort1
  values_in <- result |>
    dplyr::filter(.data$group_level == "cohort1") |>
    dplyr::select(all_of(names(result)[! names(result) %in% c("group_name", "group_level")]))

  values_out <- result_output |>
    dplyr::select(all_of(c(names(result)[! names(result) %in% c("group_name", "group_level", "estimate_value")],
                           "estimate_value" = "test_spanHeader\ngroup_name\ncohort_name\nnext_row\ngroup_level\ncohort1\nend_spanner")))
  expect_true(values_in |> dplyr::anti_join(values_out, by = names(values_in)) |> nrow() == 0)

  # Just not column name ----
  result_output <- formatHeader(result = result,
                               header = c("test_spanHeader", "end_spanner"),
                               delim = ":",
                               includeHeaderName = TRUE,
                               includeHeaderKey = FALSE)
  expect_true(
    result_output |>
      dplyr::anti_join(result |> dplyr::rename("test_spanHeader:end_spanner" = "estimate_value"),
                       by = colnames(result_output)) |>
      nrow() == 0
  )

  expect_false("summarised_result" %in% class(result_output))

  # Empty header ----
  result_output <- formatHeader(result = result,
                               header = character(),
                               delim = ":",
                               includeHeaderName = TRUE,
                               includeHeaderKey = FALSE)
  expect_identical(result, result_output)

  result_output <- formatHeader(result = result,
                               header = character(),
                               delim = ":",
                               includeHeaderName = TRUE,
                               includeHeaderKey = TRUE)
  expect_identical(result, result_output)

  # Wrong input ----
  expect_error(formatHeader(result = result,
                           header = NA,
                           includeHeaderName = TRUE))

})

test_that("formatHeader", {

result <- mockSummarisedResult()

expect_error(formatHeader(result,
    header = c("Study cohorts", "group_level", "Study strata", "strata_name",
               "strata_level", "Variables", "variable_name", "variable_level"
    ),
    includeHeaderName = FALSE))
})

