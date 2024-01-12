test_that("formatEstimateValue", {

  result <- mockSummarisedResult()

  result_output <- formatEstimateValue(result,
                                       decimals = c(
                                         integer = 0, numeric = 2, percentage = 1,
                                         proportion = 3
                                       ),
                                       decimalMark = "@",
                                       bigMark = "=")

  # Test big Mark ----
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


  # Test decimals ----
  # check estimate types
  expect_true(all(result_output |>
                    dplyr::filter(grepl("@", .data$estimate_value)) |>
                    dplyr::distinct(estimate_type) |>
                    dplyr::pull() %in%
                    c("numeric", "percentage", "proportion")))

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
  ## proportion
  proportion <- result_output$estimate_value[result_output$estimate_type == "proportion"]
  if (length(proportion) > 0) {
    expect_true(lapply(strsplit(proportion, "@"), function(x) {x[[2]]}) |>
                  unlist() |> nchar() |> mean() == 3)
  }
})
