test_that("formatEstimateName", {

  result <- mockSummarisedResult()

  # input 1 ----
  result_output <-  formatEstimateName(result,
                                       estimateName = c("N (%)" = "<count> (<percentage>%)",
                                                              "N" = "<count>"),
                                       keepNotFormatted = TRUE)
  # check count as "N"
  expect_identical(unique(result_output$estimate_name[result_output$variable_name == "number subjects"]),
                   "N")
  # check count (percentage%) as N (%)
  expect_identical(unique(result_output$estimate_name[result_output$variable_name == "Medications"]),
                   "N (%)")
  # check keep not formatted
  expect_true(result_output |>
                dplyr::filter(.data$estimate_name %in% c("mean", "sd")) |>
                nrow() > 0)
  # check estimates
  row_vars <- dplyr::tibble(group_level = "cohort1", strata_name = "overall", strata_level = "overall")
  estimates_out <- result_output |> dplyr::inner_join(row_vars, by = colnames(row_vars))
  estimates_in  <- result |> dplyr::inner_join(row_vars, by = colnames(row_vars))
  ## number subjects
  expect_identical(estimates_out$estimate_value[estimates_out$variable_name == "number subjects"],
                   estimates_in$estimate_value[estimates_in$variable_name == "number subjects"])
  ## mean
  expect_identical(estimates_out$estimate_value[estimates_out$variable_name == "age"],
                   estimates_in$estimate_value[estimates_in$variable_name == "age"])
  ## count (percentage%)
  expect_identical(estimates_out$estimate_value[estimates_out$variable_name == "Medications"],
                   paste0(
                     estimates_in$estimate_value[estimates_in$variable_name == "Medications" &  estimates_in$estimate_name == "count"],
                     " (",
                     estimates_in$estimate_value[estimates_in$variable_name == "Medications" &  estimates_in$estimate_name == "percentage"],
                     "%)"))
  # attributes mantained:
  expect_true(nrow(settings(result_output)) == 1)
  expect_true(inherits(result_output, "summarised_result"))

  # input 2 ----
  result_output <-  formatEstimateName(result,
                                       estimateName = c("<mean> (<sd>)",
                                                              "N%" = "<count> (<percentage> %)"),
                                       keepNotFormatted = FALSE)
  # Check not keep formatted
  expect_true(result_output |>
                dplyr::filter(.data$estimate_name == "number subjects") |>
                nrow() == 0)
  # Check medications as "N%"
  expect_identical(unique(result_output$estimate_name[result_output$variable_name == "Medications"]),
                   "N%")
  # Check age as median (sd)
  expect_identical(unique(result_output$estimate_name[result_output$variable_name == "age"]),
                   "mean (sd)")
  # check estimates
  row_vars <- dplyr::tibble(group_level = "cohort2", strata_name = "age_group &&& sex", strata_level = "<40 &&& Male")
  estimates_out <- result_output |> dplyr::inner_join(row_vars, by = colnames(row_vars))
  estimates_in  <- result |> dplyr::inner_join(row_vars, by = colnames(row_vars))
  ## mean
  expect_identical(estimates_out$estimate_value[estimates_out$variable_name == "age"],
                   paste0(
                     estimates_in$estimate_value[estimates_in$variable_name == "age" &  estimates_in$estimate_name == "mean"],
                     " (",
                     estimates_in$estimate_value[estimates_in$variable_name == "age" &  estimates_in$estimate_name == "sd"],
                     ")"))
  ## count (percentage%)
  expect_identical(estimates_out$estimate_value[estimates_out$variable_name == "Medications"],
                   paste0(
                     estimates_in$estimate_value[estimates_in$variable_name == "Medications" &  estimates_in$estimate_name == "count"],
                     " (",
                     estimates_in$estimate_value[estimates_in$variable_name == "Medications" &  estimates_in$estimate_name == "percentage"],
                     " %)"))
  # Input 3 ----
  expect_message(expect_message(
    result_output <- formatEstimateName(
      result,
      estimateName = c("N (%)" = "<count> (<notAKey>%)",
                             "N" = "<count>",
                             "<alsoNotAkey>",
                             "%" = "<percentage>"),
      keepNotFormatted = FALSE)
  ))
  # check count as "N"
  expect_identical(unique(result_output$estimate_name[result_output$variable_name == "number subjects"]),
                   "N")
  # check count (percentage%) as N (%)
  expect_identical(unique(result_output$estimate_name[result_output$variable_name == "Medications"]),
                   c("N", "%"))
  # check keep not formatted
  expect_true(result_output |>
                dplyr::filter(.data$estimate_name %in% c("mean", "sd")) |>
                nrow() == 0)
  # check estimates
  row_vars <- dplyr::tibble(group_level = "cohort1", strata_name = "overall", strata_level = "overall")
  estimates_out <- result_output |> dplyr::inner_join(row_vars, by = colnames(row_vars))
  estimates_in  <- result |> dplyr::inner_join(row_vars, by = colnames(row_vars))
  ## number subjects
  expect_identical(estimates_out$estimate_value[estimates_out$variable_name == "number subjects"],
                   paste0(estimates_in$estimate_value[estimates_in$variable_name == "number subjects"]))

  expect_no_error(result |> dplyr::select(-"cdm_name") |> formatEstimateName())

  # NA value ---
  result <- mockSummarisedResult() |> dplyr::filter(grepl("mean|sd", estimate_name),  strata_level == "overall")
  result$estimate_value[1] <- NA_character_
  res <- formatEstimateName(
    result,
    estimateName = "<mean> (<sd>)",
    keepNotFormatted = TRUE,
    useFormatOrder = TRUE)
  expect_true(is.na(res$estimate_value[1]))

  # Class ----
  expect_true(inherits(res, "summarised_result"))
  class(result) <- c("tbl_df", "tbl", "data.frame")
  res <- formatEstimateName(
    result,
    estimateName = "<mean> (<sd>)",
    keepNotFormatted = TRUE,
    useFormatOrder = TRUE)
  expect_false(inherits(res, "summarised_result"))

  # Wrong input ----
  expect_error(result |> dplyr::select(-"estimate_name") |> formatEstimateName())
  expect_error(formatEstimateName(result,
                                  estimateName = c("N" = "count",
                                                         "N (%)" = "count (percentage%)"),
                                  keepNotFormatted = FALSE))
  expect_message(formatEstimateName(result,
                                    estimateName = c("N" = "<count>",
                                                           "N (%)" = "count (<lala>%)"),
                                    keepNotFormatted = TRUE),
                 "has not been formatted.")
  expect_message(formatEstimateName(result,
                                    estimateName = c("N" = "count",
                                                           "N (%)" = "<count> (<percentage>%)"),
                                    keepNotFormatted = FALSE),
                 "does not contain an estimate name indicated by <...>")
  expect_error(formatEstimateName(result,
                                  estimateName = NA,
                                  keepNotFormatted = TRUE))
})

test_that("formatEstimateName, useFormatOrder", {
  result <-
    # number subjects
    dplyr::tibble(
      "cdm_name" = "mock",
      "group_name" = "cohort_name",
      "group_level" = c(rep("cohort1", 9), rep("cohort2", 9)),
      "strata_name" = rep(c(
        "overall", rep("age_group &&& sex", 4), rep("sex", 2), rep("age_group", 2)
      ), 2),
      "strata_level" = rep(c(
        "overall", "<40 &&& Male", ">=40 &&& Male", "<40 &&& Female",
        ">=40 &&& Female", "Male", "Female", "<40", ">=40"
      ), 2),
      "variable_name" = "age",
      "variable_level" = NA_character_,
      "estimate_name" = "number subjects",
      "estimate_type" = "numeric",
      "estimate_value" = c(100*stats::runif(18)) |> as.character(),
      "additional_name" = "overall",
      "additional_level" = "overall"
    )|>
    dplyr::union_all(
      # age - mean
      dplyr::tibble(
        "cdm_name" = "mock",
        "group_name" = "cohort_name",
        "group_level" = c(rep("cohort1", 9), rep("cohort2", 9)),
        "strata_name" = rep(c(
          "overall", rep("age_group &&& sex", 4), rep("sex", 2), rep("age_group", 2)
        ), 2),
        "strata_level" = rep(c(
          "overall", "<40 &&& Male", ">=40 &&& Male", "<40 &&& Female",
          ">=40 &&& Female", "Male", "Female", "<40", ">=40"
        ), 2),
        "variable_name" = "age",
        "variable_level" = NA_character_,
        "estimate_name" = "min",
        "estimate_type" = "numeric",
        "estimate_value" = c(100*stats::runif(18)) |> as.character(),
        "additional_name" = "overall",
        "additional_level" = "overall"
      )
    )|>
    dplyr::union_all(
      # age - mean
      dplyr::tibble(
        "cdm_name" = "mock",
        "group_name" = "cohort_name",
        "group_level" = c(rep("cohort1", 9), rep("cohort2", 9)),
        "strata_name" = rep(c(
          "overall", rep("age_group &&& sex", 4), rep("sex", 2), rep("age_group", 2)
        ), 2),
        "strata_level" = rep(c(
          "overall", "<40 &&& Male", ">=40 &&& Male", "<40 &&& Female",
          ">=40 &&& Female", "Male", "Female", "<40", ">=40"
        ), 2),
        "variable_name" = "age",
        "variable_level" = NA_character_,
        "estimate_name" = "mean",
        "estimate_type" = "numeric",
        "estimate_value" = c(100*stats::runif(18)) |> as.character(),
        "additional_name" = "overall",
        "additional_level" = "overall"
      )
    )|>
    # age - max
    dplyr::union_all(
      dplyr::tibble(
        "cdm_name" = "mock",
        "group_name" = "cohort_name",
        "group_level" = c(rep("cohort1", 9), rep("cohort2", 9)),
        "strata_name" = rep(c(
          "overall", rep("age_group &&& sex", 4), rep("sex", 2), rep("age_group", 2)
        ), 2),
        "strata_level" = rep(c(
          "overall", "<40 &&& Male", ">=40 &&& Male", "<40 &&& Female",
          ">=40 &&& Female", "Male", "Female", "<40", ">=40"
        ), 2),
        "variable_name" = "age",
        "variable_level" = NA_character_,
        "estimate_name" = "max",
        "estimate_type" = "numeric",
        "estimate_value" = c(100*stats::runif(18)) |> as.character(),
        "additional_name" = "overall",
        "additional_level" = "overall"
      )
    ) |>
    dplyr::mutate(result_id = "1") |>
    omopgenerics::newSummarisedResult(
      settings = dplyr::tibble(
        "result_id" = as.integer(1),
        "result_type" = "mock_test",
        "package_name" = "visOmopResults",
        "package_version" = utils::packageVersion("visOmopResults") |>
          as.character(),
      )
    )

  # FALSE ----
  result_output <-  formatEstimateName(result,
                                       estimateName = c("<mean>",
                                                              "range" = "[<min> - <max>]"),
                                       keepNotFormatted = TRUE,
                                       useFormatOrder = FALSE)

  expect_true(all(which(result_output$estimate_name %in% "number subjets") <
                    which(result_output$estimate_name %in% "mean")))
  expect_true(all(which(result_output$estimate_name %in% "number subjets") <
                    which(result_output$estimate_name %in% "range")))
  expect_true(all(which(result_output$estimate_name %in% "range") <
                    which(result_output$estimate_name %in% "mean")))

  # TRUE ----
  result_output <-  formatEstimateName(result,
                                       estimateName = c("<mean>",
                                                              "range" = "[<min> - <max>]"),
                                       keepNotFormatted = TRUE,
                                       useFormatOrder = TRUE)

  expect_false(any(which(result_output$estimate_name %in% "range") <
                     which(result_output$estimate_name %in% "mean")))
  expect_false(any(which(result_output$estimate_name %in% "number subjets") <
                     which(result_output$estimate_name %in% "mean")))
  expect_false(any(which(result_output$estimate_name %in% "number subjets") <
                     which(result_output$estimate_name %in% "range")))

})

test_that("empty format",{
  result <- mockSummarisedResult()
  expect_no_error(res0 <- formatEstimateName(
    result,
    estimateName = character(0),
    keepNotFormatted = TRUE,
    useFormatOrder = TRUE)
  )
  expect_true(res0 |> dplyr::anti_join(result, by = colnames(res0)) |> nrow() == 0)
  expect_no_error(res1 <- formatEstimateName(
    result,
    estimateName = NULL,
    keepNotFormatted = TRUE,
    useFormatOrder = TRUE)
  )
  expect_identical(res1, result)
})

test_that("not a summarised result",{
  result <- dplyr::tibble(
    variable = "variable",
    estimate_type = c("integer", "numeric"),
    estimate_name = c("count", "percentage"),
    estimate_value = c("100", "50.1")
  )
  res0 <- formatEstimateName(
    result,
    estimateName = c("N (%)" = "<count> (<percentage>%)")
  )
  expect_true(nrow(res0) == 1)
  expect_equal(class(result), class(res0))
})

test_that("common key word",{
  result <- dplyr::tibble(
    "cdm_name" = "mock",
    "group_name" = "cohort_name",
    "group_level" = c(rep("cohort1", 9), rep("cohort2", 9)),
    "strata_name" = rep(c(
      "overall", rep("age_group &&& sex", 4), rep("sex", 2), rep("age_group", 2)
    ), 2),
    "strata_level" = rep(c(
      "overall", "<40 &&& Male", ">=40 &&& Male", "<40 &&& Female",
      ">=40 &&& Female", "Male", "Female", "<40", ">=40"
    ), 2),
    "variable_name" = "number subjects",
    "variable_level" = NA_character_,
    "estimate_name" = "count",
    "estimate_type" = "integer",
    "estimate_value" = round(10000000*stats::runif(18)) |> as.character(),
    "additional_name" = "overall",
    "additional_level" = "overall"
  ) |>
    # age - mean
    dplyr::union_all(
      dplyr::tibble(
        "cdm_name" = "mock",
        "group_name" = "cohort_name",
        "group_level" = c(rep("cohort1", 9), rep("cohort2", 9)),
        "strata_name" = rep(c(
          "overall", rep("age_group &&& sex", 4), rep("sex", 2), rep("age_group", 2)
        ), 2),
        "strata_level" = rep(c(
          "overall", "<40 &&& Male", ">=40 &&& Male", "<40 &&& Female",
          ">=40 &&& Female", "Male", "Female", "<40", ">=40"
        ), 2),
        "variable_name" = "number subjects",
        "variable_level" = NA_character_,
        "estimate_name" = "count_95CI_lower",
        "estimate_type" = "integer",
        "estimate_value" = round(10000000*stats::runif(18)) |> as.character(),
        "additional_name" = "overall",
        "additional_level" = "overall"
      )
    )
  res <- formatEstimateName(result, estimateName = "<count> <count_95CI_lower>")
  expect_true(unique(res$estimate_name) == "count count_95CI_lower")

  result <- dplyr::tibble(
    "cdm_name" = "mock",
    "group_name" = "cohort_name",
    "group_level" = c(rep("cohort1", 9), rep("cohort2", 9)),
    "strata_name" = rep(c(
      "overall", rep("age_group &&& sex", 4), rep("sex", 2), rep("age_group", 2)
    ), 2),
    "strata_level" = rep(c(
      "overall", "<40 &&& Male", ">=40 &&& Male", "<40 &&& Female",
      ">=40 &&& Female", "Male", "Female", "<40", ">=40"
    ), 2),
    "variable_name" = "number subjects",
    "variable_level" = NA_character_,
    "estimate_name" = "count",
    "estimate_type" = "integer",
    "estimate_value" = round(10000000*stats::runif(18)) |> as.character(),
    "additional_name" = "overall",
    "additional_level" = "overall"
  ) |>
    # age - mean
    dplyr::union_all(
      dplyr::tibble(
        "cdm_name" = "mock",
        "group_name" = "cohort_name",
        "group_level" = c(rep("cohort1", 9), rep("cohort2", 9)),
        "strata_name" = rep(c(
          "overall", rep("age_group &&& sex", 4), rep("sex", 2), rep("age_group", 2)
        ), 2),
        "strata_level" = rep(c(
          "overall", "<40 &&& Male", ">=40 &&& Male", "<40 &&& Female",
          ">=40 &&& Female", "Male", "Female", "<40", ">=40"
        ), 2),
        "variable_name" = "number subjects",
        "variable_level" = NA_character_,
        "estimate_name" = "95CI_lower_count",
        "estimate_type" = "integer",
        "estimate_value" = round(10000000*stats::runif(18)) |> as.character(),
        "additional_name" = "overall",
        "additional_level" = "overall"
      )
    )
  res <- formatEstimateName(result, estimateName = "<count> <95CI_lower_count>")
  expect_true(unique(res$estimate_name) == "count 95CI_lower_count")
})

test_that("No format in formatEstimateNameInternal", {

  result <- mockSummarisedResult()

  fen <- formatEstimateNameInternal(result, format = c())

  expect_identical(fen, result)

})

test_that("Empty results warning in formatEstimateNameInternal", {

  result <- omopgenerics::emptySummarisedResult()

  expect_warning(formatEstimateNameInternal(result, format = c("")))

})

test_that("test suppressed is kept", {
  result <- dplyr::tibble(
    result_id = 1L,
    cdm_name = "mock",
    cohort_name = "my_cohort",
    age_group = "<=40",
    variable_name = c(
      "number subjects", rep("age", 3), "Medications any time prior",
      "Medications any time prior"
    ),
    variable_level = c(rep(NA_character_, 4), rep("acetaminophen", 2)),
    estimate_name = c("count", "median", "q25", "q75", "count", "percentage"),
    estimate_type = c("integer", rep("numeric", 3), "integer", "percentage"),
    estimate_value = "-"
  ) |>
    omopgenerics::uniteGroup("cohort_name") |>
    omopgenerics::uniteStrata("age_group") |>
    omopgenerics::uniteAdditional() |>
    omopgenerics::newSummarisedResult(settings = dplyr::tibble(
      result_id = 1L, min_cell_count = "20", result_type = "",
      package_name = "", package_version = ""
    ))

  x <-  result |>
    formatEstimateName(estimateName = c(
      "N (%)" = "<count> (<percentage>%)", "N" = "<count>",
      "median [Q25 - Q75]" = "<median> [<q25> - <q75>]"
    ))

  x <-  result |>
    formatMinCellCount() |>
    formatEstimateName(estimateName = c(
      "N (%)" = "<count> (<percentage>%)", "N" = "<count>",
      "median [Q25 - Q75]" = "<median> [<q25> - <q75>]"
    ))

  x <- result |>
    visOmopTable(estimateName = c(
      "N (%)" = "<count> (<percentage>%)", "N" = "<count>",
      "median [Q25 - Q75]" = "<median> [<q25> - <q75>]"
    ))
})
