test_that("formatEstimateValue", {

  result <- mockSummarisedResult()

  # default decimal input ----
  result_output <- formatEstimateValue(result,
                                       decimals = c(
                                         integer = 0, numeric = 2, percentage = 1,
                                         proportion = 3
                                       ),
                                       decimalMark = "@",
                                       bigMark = "=")

  ## Test big Mark ----
  counts_in  <- result$estimate_value[result_output$estimate_type == "integer"]
  counts_out <- result_output$estimate_value[result_output$estimate_type == "integer"]

  zeroMarks_out <- base::paste(counts_out[base::nchar(counts_in) < 4], collapse = "")
  zeroMarks_out <- nchar(zeroMarks_out) - nchar(gsub("=", "", zeroMarks_out))

  oneMark_in  <- sum(base::nchar(counts_in) < 7 & base::nchar(counts_in) > 3)
  oneMark_out <- base::paste(counts_out[base::nchar(counts_in) < 7 & base::nchar(counts_in) > 3], collapse = "")
  oneMark_out <- nchar(oneMark_out) - nchar(gsub("=", "", oneMark_out))

  twoMarks_in  <- sum(base::nchar(counts_in) == 7)*2
  twoMarks_out <- base::paste(counts_out[base::nchar(counts_in) == 7], collapse = "")
  twoMarks_out <- nchar(twoMarks_out) - nchar(gsub("=", "", twoMarks_out))

  # check nummber of marks
  expect_equal(0, zeroMarks_out)
  expect_equal(oneMark_in, oneMark_out)
  expect_equal(twoMarks_in, twoMarks_out)
  # check type of mark
  expect_identical(as.integer(counts_in), as.integer(base::gsub("=", "", counts_out)))

  ## Test decimals (default input) ----
  # check estimate types
  expect_equal(result_output |>
                    dplyr::filter(grepl("@", .data$estimate_value)) |>
                    dplyr::distinct(estimate_type) |>
                    dplyr::pull(),
                    c("numeric", "percentage"))

  # check number of decimals
  ## numeric
  numeric <- result_output$estimate_value[result_output$estimate_type == "numeric"]
  if (length(numeric) > 0) {
    expect_true(lapply(strsplit(numeric, "@"), function(x) {x[[2]]}) |>
                  unlist() |> nchar() |> mean() == 2)
  }
  ## percentage
  percentage <- result_output$estimate_value[result_output$estimate_type == "percentage"]
  if (length(percentage) > 0) {
    expect_true(lapply(strsplit(percentage, "@"), function(x) {x[[2]]}) |>
                  unlist() |> nchar() |> mean() == 1)
  }

  # Test decimals ----
  result_output <- formatEstimateValue(result,
                                       decimals = c(
                                         integer = 3, numeric = 0
                                       ),
                                       decimalMark = "_",
                                       bigMark = "%")
  # check estimate types
  expect_true(result_output |>
                    dplyr::filter(grepl("_", .data$estimate_value)) |>
                    dplyr::distinct(estimate_type) |>
                    dplyr::pull() == "integer")

  # check number of decimals
  ## integer
  integer <- result_output$estimate_value[result_output$estimate_type == "integer"]
  if (length(integer) > 0) {
    expect_true(lapply(strsplit(integer, "_"), function(x) {x[[2]]}) |>
                  unlist() |> nchar() |> mean() == 3)
  }
  ## numeric
  numeric <- result_output$estimate_value[result_output$estimate_type == "numeric"]
  if (length(numeric) > 0) {
    expect_false(all(grepl("_", numeric)))
  }
  ## percentage
  expect_identical(result_output$estimate_value[result_output$estimate_type == "percentage"],
                   result$estimate_value[result$estimate_type == "percentage"])

  # Test decimals ----
  result_output <- formatEstimateValue(result,
                                       decimals = 4,
                                       decimalMark = "_",
                                       bigMark = "%")
  # check estimate types
  expect_true(all(result_output |>
                    dplyr::filter(grepl("_", .data$estimate_value)) |>
                    dplyr::distinct(estimate_type) |>
                    dplyr::pull() ==
                    unique(result$estimate_type)))

  # check number of decimals
    expect_true(lapply(strsplit(result_output$estimate_value, "_"), function(x) {x[[2]]}) |>
                  unlist() |> nchar() |> mean() == 4)


    # Estimate name input ----
    result_output <- formatEstimateValue(result,
                                         decimals = c(mean = 2, sd = 3, count = 0))

    # check number of decimals
    ## mean
    mean <- result_output$estimate_value[result_output$estimate_name == "mean"]
    if (length(mean) > 0) {
      expect_true(lapply(strsplit(mean, ".", fixed = TRUE), function(x) {x[[2]]}) |>
                    unlist() |> nchar() |> mean() == 2)
    }
    ## sd
    sd <- result_output$estimate_value[result_output$estimate_name == "sd"]
    if (length(sd) > 0) {
      expect_true(lapply(strsplit(sd, ".", fixed = TRUE), function(x) {x[[2]]}) |>
                    unlist() |> nchar() |> mean() == 3)
    }
    ## count
    count <- result_output$estimate_value[result_output$estimate_name == "count"]
    if (length(count) > 0) {
      expect_false(all(grepl(".", count, fixed = TRUE)))
    }
    ## percentage
    expect_identical(result_output$estimate_value[result_output$estimate_name == "percentage"],
                     result$estimate_value[result$estimate_name == "percentage"])

    # Hierarchy ----
    result_output <- formatEstimateValue(result,
                                         decimals = c(numeric = 2, mean = 3))
    mean <- result_output$estimate_value[result_output$estimate_name == "mean"]
    if (length(mean) > 0) {
      expect_true(lapply(strsplit(mean, ".", fixed = TRUE), function(x) {x[[2]]}) |>
                    unlist() |> nchar() |> mean() == 3)
    }
    numeric <- result_output$estimate_value[result_output$estimate_type == "numeric" & result_output$estimate_name != "mean"]
    if (length(numeric) > 0) {
      expect_true(lapply(strsplit(numeric, ".", fixed = TRUE), function(x) {x[[2]]}) |>
                    unlist() |> nchar() |> mean() == 2)
    }

    ## Test NULL decimals ----
    result_output <- formatEstimateValue(result,
                                         decimals = NULL,
                                         decimalMark = "..",
                                         bigMark = ",")

    ## count
    counts_in  <- result$estimate_value[result_output$estimate_type == "integer"]
    counts_out <- result_output$estimate_value[result_output$estimate_type == "integer"]

    zeroMarks_out <- base::paste(counts_out[base::nchar(counts_in) < 4], collapse = "")
    zeroMarks_out <- nchar(zeroMarks_out) - nchar(gsub("=", "", zeroMarks_out))

    oneMark_in  <- sum(base::nchar(counts_in) < 7 & base::nchar(counts_in) > 3)
    oneMark_out <- base::paste(counts_out[base::nchar(counts_in) < 7 & base::nchar(counts_in) > 3], collapse = "")
    oneMark_out <- nchar(oneMark_out) - nchar(gsub("=", "", oneMark_out))

    twoMarks_in  <- sum(base::nchar(counts_in) == 7)*2
    twoMarks_out <- base::paste(counts_out[base::nchar(counts_in) == 7], collapse = "")
    twoMarks_out <- nchar(twoMarks_out) - nchar(gsub("=", "", twoMarks_out))

    if (length(counts_out) > 0) {
      expect_false(all(grepl("..", counts_out, fixed = TRUE)))
    }
    ## mean
    mean_in <- result$estimate_value[result$estimate_name == "mean"]
    mean_out <- result_output$estimate_value[result_output$estimate_name == "mean"]
    if (length(mean) > 0) {
      expect_equal(mean_out, base::format(as.numeric(mean_in), decimal.mark = "..", trim = TRUE, justify = "none"))
    }
    ## sd
    sd_in <- result$estimate_value[result$estimate_name == "sd"]
    sd_out <- result_output$estimate_value[result_output$estimate_name == "sd"]
    if (length(sd) > 0) {
      expect_equal(sd_out, base::format(as.numeric(sd_in), decimal.mark = "..", trim = TRUE, justify = "none"))
    }

    ## Test NULL bigMark ----
    result_output <- formatEstimateValue(result,
                                         decimals = 0,
                                         decimalMark = ".",
                                         bigMark = NULL)
    expect_equal(result_output$estimate_value[result_output$estimate_name == "count"],
                 result$estimate_value[result$estimate_name == "count"])

    ## Test NULL decimals + NULL bigMark ----
    result_output <- formatEstimateValue(result,
                                         decimals = NULL,
                                         decimalMark = ".",
                                         bigMark = NULL)
    expect_equal(result_output$estimate_value[result_output$estimate_name == "count"],
                 result$estimate_value[result$estimate_name == "count"])
    ## mean
    mean_in <- result$estimate_value[result$estimate_name == "mean"]
    mean_out <- result_output$estimate_value[result_output$estimate_name == "mean"]
    if (length(mean) > 0) {
      expect_equal(mean_out, base::format(as.numeric(mean_in), decimal.mark = ".", trim = TRUE, justify = "none"))
    }
    ## sd
    sd_in <- result$estimate_value[result$estimate_name == "sd"]
    sd_out <- result_output$estimate_value[result_output$estimate_name == "sd"]
    if (length(sd) > 0) {
      expect_equal(sd_out, base::format(as.numeric(sd_in), decimal.mark = ".", trim = TRUE, justify = "none"))
    }

    # no warning when estimate value is NA
    result <- mockSummarisedResult() |>
      dplyr::union_all(dplyr::tibble(
        "cdm_name" = "mock",
        "result_type" = NA_character_,
        "package_name" = "visOmopResults",
        "package_version" = utils::packageVersion("visOmopResults") |>
          as.character(),
        "group_name" = "cohort_name",
        "group_level" = "cohort3",
        "strata_name" = rep(c(
          "overall", rep("age_group and sex", 4), rep("sex", 2), rep("age_group", 2)
        ), 2),
        "strata_level" = rep(c(
          "overall", "<40 and Male", ">=40 and Male", "<40 and Female",
          ">=40 and Female", "Male", "Female", "<40", ">=40"
        ), 2),
        "variable_name" = "number subjects",
        "variable_level" = NA_character_,
        "estimate_name" = "count",
        "estimate_type" = "integer",
        "estimate_value" = NA_character_,
        "additional_name" = "overall",
        "additional_level" = "overall"
      ))

    expect_no_warning(formatEstimateValue(result,
                                         decimals = 2,
                                         decimalMark = ".",
                                         bigMark = ","))

    # Wroing input ----
    expect_error(formatEstimateValue(result,
                                     decimals = NA,
                                     decimalMark = "_",
                                     bigMark = "%"))
    expect_error(formatEstimateValue(result,
                                     decimals = c("hola" = 0),
                                     decimalMark = "_",
                                     bigMark = "%"))
    expect_error(formatEstimateValue(result,
                                     decimals = 2,
                                     decimalMark = NA,
                                     bigMark = "%"))
    expect_error(formatEstimateValue(result,
                                     decimals = c(count = 1, lala = 0)),
                 "lala do not correspont to estimate_type or estimate_name values.")
    expect_error(formatEstimateValue(result,
                                     decimals = 1,
                                     decimalMark = NULL,
                                     bigMark = ","))
})
