test_that("spanHeader", {
  result <- mockSummarisedResult()

  # Include headers + noncolumn names----
  result_output <- spanHeader(result = result,
                             header = c("group_name", "group_level", "strata", "strata_name", "strata_level"),
                             includeHeader = TRUE)

  # column: group_name\ncohort_name\ngroup_level\ncohort2\nstrata\nstrata_name\nsex\nstrata_level\nMale
  values_in <- result |>
    dplyr::filter(.data$group_level == "cohort2" & .data$strata_level == "Male") |>
    dplyr::select(all_of(names(result)[! names(result) %in% c("group_name", "group_level", "strata", "strata_name", "strata_level")]))

  values_out <- result_output |>
    dplyr::select(all_of(c(names(result)[! names(result) %in% c("group_name", "group_level", "strata", "strata_name", "strata_level", "estimate_value")],
                           "estimate_value" = "group_name\ncohort_name\ngroup_level\ncohort2\nstrata\nstrata_name\nsex\nstrata_level\nMale")))
  expect_true(values_in |> dplyr::anti_join(values_out, by = names(values_in)) |> nrow() == 0)

  # class
  expect_false("summarised_result" %in% class(result_output))

  # column: group_name\ncohort_name\ngroup_level\ncohort1\nstrata\nstrata_name\nage_group and sex\nstrata_level\n>=40 and Female
  values_in <- result |>
    dplyr::filter(.data$group_level == "cohort1" & .data$strata_level == ">=40 and Female") |>
    dplyr::select(all_of(names(result)[! names(result) %in% c("group_name", "group_level", "strata", "strata_name", "strata_level")]))

  values_out <- result_output |>
    dplyr::select(all_of(c(names(result)[! names(result) %in% c("group_name", "group_level", "strata", "strata_name", "strata_level", "estimate_value")],
                           "estimate_value" = "group_name\ncohort_name\ngroup_level\ncohort1\nstrata\nstrata_name\nage_group and sex\nstrata_level\n>=40 and Female")))
  expect_true(values_in |> dplyr::anti_join(values_out, by = names(values_in)) |> nrow() == 0)

  # Not include headers + noncolumn names----
  result_output <- spanHeader(result = result,
                              header = c("group_name", "group_level", "strata", "strata_name", "strata_level"),
                              includeHeader = FALSE)

  # column: cohort_name\ncohort2\nstrata\nsex\nMale
  values_in <- result |>
    dplyr::filter(.data$group_level == "cohort2" & .data$strata_level == "Male") |>
    dplyr::select(all_of(names(result)[! names(result) %in% c("group_name", "group_level", "strata", "strata_name", "strata_level")]))

  values_out <- result_output |>
    dplyr::select(all_of(c(names(result)[! names(result) %in% c("group_name", "group_level", "strata", "strata_name", "strata_level", "estimate_value")],
                           "estimate_value" = "cohort_name\ncohort2\nstrata\nsex\nMale")))
  expect_true(values_in |> dplyr::anti_join(values_out, by = names(values_in)) |> nrow() == 0)

  # column: cohort_name\ncohort1\nstrata\nage_group and sex\n>=40 and Female
  values_in <- result |>
    dplyr::filter(.data$group_level == "cohort1" & .data$strata_level == ">=40 and Female") |>
    dplyr::select(all_of(names(result)[! names(result) %in% c("group_name", "group_level", "strata", "strata_name", "strata_level")]))

  values_out <- result_output |>
    dplyr::select(all_of(c(names(result)[! names(result) %in% c("group_name", "group_level", "strata", "strata_name", "strata_level", "estimate_value")],
                           "estimate_value" = "cohort_name\ncohort1\nstrata\nage_group and sex\n>=40 and Female")))
  expect_true(values_in |> dplyr::anti_join(values_out, by = names(values_in)) |> nrow() == 0)

  # Not include headers + only column names----
  result_output <- spanHeader(result = result,
                              header = c("group_name", "group_level"),
                              includeHeader = FALSE)
  # column: cohort_name\ncohort1
  values_in <- result |>
    dplyr::filter(.data$group_level == "cohort1") |>
    dplyr::select(all_of(names(result)[! names(result) %in% c("group_name", "group_level")]))

  values_out <- result_output |>
    dplyr::select(all_of(c(names(result)[! names(result) %in% c("group_name", "group_level", "estimate_value")],
                           "estimate_value" = "cohort_name\ncohort1")))
  expect_true(values_in |> dplyr::anti_join(values_out, by = names(values_in)) |> nrow() == 0)

  # Not include headers + noncolumn names----
  result_output <- spanHeader(result = result,
                              header = c("test_spanHeader", "group_name", "next_row", "group_level", "end_spanner"),
                              includeHeader = TRUE)
  # column: cohort_name\ncohort1
  values_in <- result |>
    dplyr::filter(.data$group_level == "cohort1") |>
    dplyr::select(all_of(names(result)[! names(result) %in% c("group_name", "group_level")]))

  values_out <- result_output |>
    dplyr::select(all_of(c(names(result)[! names(result) %in% c("group_name", "group_level", "estimate_value")],
                           "estimate_value" = "test_spanHeader\ngroup_name\ncohort_name\nnext_row\ngroup_level\ncohort1\nend_spanner")))
  expect_true(values_in |> dplyr::anti_join(values_out, by = names(values_in)) |> nrow() == 0)

  # Just not column name ----
  result_output <- spanHeader(result = result,
                              header = c("test_spanHeader", "end_spanner"),
                              includeHeader = TRUE)
  expect_true(
    result_output |>
      dplyr::anti_join(result |> dplyr::rename("test_spanHeader\nend_spanner" = "estimate_value"),
                       by = colnames(result_output)) |>
      nrow() == 0
  )

  expect_false("summarised_result" %in% class(result_output))

  # Wrong input ----
  expect_error(spanHeader(result = result,
                          header = NULL,
                          includeHeader = TRUE))
  expect_error(spanHeader(result = result,
                          header = NA,
                          includeHeader = TRUE))

})
