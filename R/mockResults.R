# Copyright 2025 DARWIN EU®
#
# This file is part of visOmopResults
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

#' A `<summarised_result>` object filled with mock data
#' @return An object of the class `<summarised_result>` with mock data.
#' @description Creates an object of the class `<summarised_result>` with mock data
#' for illustration purposes.
#'
#' @export
#'
#' @examples
#' mockSummarisedResult()
#'
#'
mockSummarisedResult <- function() {
  set.seed(1)
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
        "variable_name" = "age",
        "variable_level" = NA_character_,
        "estimate_name" = "mean",
        "estimate_type" = "numeric",
        "estimate_value" = c(100*stats::runif(18)) |> as.character(),
        "additional_name" = "overall",
        "additional_level" = "overall"
      )
    )|>
    # age - standard deviation
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
        "estimate_name" = "sd",
        "estimate_type" = "numeric",
        "estimate_value" = c(10*stats::runif(18)) |> as.character(),
        "additional_name" = "overall",
        "additional_level" = "overall"
      )
    ) |>
    # medication - count
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
        "variable_name" = "Medications",
        "variable_level" = "Amoxiciline",
        "estimate_name" = "count",
        "estimate_type" = "integer",
        "estimate_value" = round(100000*stats::runif(18)) |> as.character(),
        "additional_name" = "overall",
        "additional_level" = "overall"
      )
    ) |>
    # medication - percentage
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
        "variable_name" = "Medications",
        "variable_level" = "Amoxiciline",
        "estimate_name" = "percentage",
        "estimate_type" = "percentage",
        "estimate_value" = c(100*stats::runif(18)) |> as.character(),
        "additional_name" = "overall",
        "additional_level" = "overall"
      )
    ) |>
    # medication - count
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
        "variable_name" = "Medications",
        "variable_level" = "Ibuprofen",
        "estimate_name" = "count",
        "estimate_type" = "integer",
        "estimate_value" = round(100000*stats::runif(18)) |> as.character(),
        "additional_name" = "overall",
        "additional_level" = "overall"
      )
    ) |>
    # medication - percentage
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
        "variable_name" = "Medications",
        "variable_level" = "Ibuprofen",
        "estimate_name" = "percentage",
        "estimate_type" = "percentage",
        "estimate_value" = c(100*stats::runif(18)) |> as.character(),
        "additional_name" = "overall",
        "additional_level" = "overall"
      )
    ) |>
    dplyr::mutate(result_id = as.integer(1)) |>
    omopgenerics::newSummarisedResult(
      settings = dplyr::tibble(
        "result_id" = as.integer(1),
        "result_type" = "mock_summarised_result",
        "package_name" = "visOmopResults",
        "package_version" = utils::packageVersion("visOmopResults") |>
          as.character()
      )
    )
  set.seed(NULL)
  return(result)
}

#' List of mock results
#'
#' @format A list of mock results for quarto and shiny vignette examples
"data"
