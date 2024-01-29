test_that("formatEstimateName", {

  result <- mockSummarisedResult()

  # input 1 ----
  result_output <-  formatEstimateName(result,
                                       estimateNameFormat = c("N (%)" = "<count> (<percentage>%)",
                                                  "N" = "<count>"),
                                       keepNotFormatted = TRUE)|>
    dplyr::mutate(id = dplyr::row_number())
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
  # estimate_name order
  expect_true(mean(result_output$id[result_output$estimate_name == "N (%)"]) <
                mean(result_output$id[result_output$estimate_name == "N"]))
  expect_true(mean(result_output$id[result_output$estimate_name == "N"]) <
                mean(result_output$id[result_output$estimate_name == "mean"]))
  # useNewFormatOrder false
  result_output <-  formatEstimateName(result,
                                       estimateNameFormat = c("N (%)" = "<count> (<percentage>%)",
                                                              "N" = "<count>"),
                                       keepNotFormatted = TRUE,
                                       useNewFormatOrder = FALSE)|>
    dplyr::mutate(id = dplyr::row_number())
  expect_false(mean(result_output$id[result_output$estimate_name == "N (%)"]) <
                mean(result_output$id[result_output$estimate_name == "N"]))
  expect_true(mean(result_output$id[result_output$estimate_name == "N (%)"]) >
                mean(result_output$id[result_output$estimate_name == "mean"]))


  # input 2 ----
  result_output <-  formatEstimateName(result,
                                       estimateNameFormat = c("<mean> (<sd>)",
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
  row_vars <- dplyr::tibble(group_level = "cohort2", strata_name = "age_group and sex", strata_level = "<40 and Male")
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
  expect_warning(expect_warning(result_output <- formatEstimateName(
    result,
    estimateNameFormat = c("N (%)" = "<count> (<notAKey>%)",
                           "N" = "<count>",
                           "<alsoNotAkey>",
                           "%" = "<percentage>"),
    keepNotFormatted = FALSE), "has not been formatted."), "has not been formatted.")
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

  # Wrong input ----
  expect_error(result |> dplyr::select(-"cdm_name") |> formatEstimateName())
  expect_error(formatEstimateName(result,
                                  estimateNameFormat = c("N" = "count",
                                                         "N (%)" = "count (percentage%)"),
                                  keepNotFormatted = FALSE))
  expect_warning(formatEstimateName(result,
                                    estimateNameFormat = c("N" = "<count>",
                                                           "N (%)" = "count (<lala>%)"),
                                    keepNotFormatted = TRUE),
                 "has not been formatted.")
  expect_warning(formatEstimateName(result,
                     estimateNameFormat = c("N" = "count",
                                            "N (%)" = "<count> (<percentage>%)"),
                     keepNotFormatted = FALSE),
                 "does not contain an estimate name indicated by <...>")
  expect_error(formatEstimateName(result,
                                  estimateNameFormat = NA,
                                  keepNotFormatted = TRUE))
})
