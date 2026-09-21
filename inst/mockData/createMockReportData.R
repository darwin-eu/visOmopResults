CDMConnector::requireEunomia()
con <- DBI::dbConnect(duckdb::duckdb(dbdir = CDMConnector::eunomiaDir()))
cdm <- CDMConnector::cdmFromCon(con = con,
                                cdmSchema = "main",
                                writeSchema = "main",
                                cdmName = "my_duckdb_database")

cdm <- IncidencePrevalence::generateDenominatorCohortSet(
  cdm = cdm,
  name = "denominator",
  cohortDateRange = as.Date(c("2008-01-01", "2018-01-01")),
  daysPriorObservation = 180
)
cdm$denominator <- cdm$denominator |>
  PatientProfiles::addSex(name = "denominator")
cdm$outcome <- CohortConstructor::conceptCohort(
  cdm = cdm,
  conceptSet = list("outcome" = c(1125315, 1127078, 1127433, 40229134, 40231925, 40162522, 19133768)),
  name = "outcome"
)
incidence <- IncidencePrevalence::estimateIncidence(
  cdm = cdm,
  denominatorTable = "denominator",
  outcomeTable = "outcome",
  interval = "years",
  repeatedEvents = TRUE,
  outcomeWashout = 180,
  completeDatabaseIntervals = TRUE,
  strata = list("sex")
)
cdm$comorbidities <- cdm$outcome |>
  CohortConstructor::copyCohorts(name = "comorbidities", n = 3) |>
  CohortConstructor::renameCohort(cohortId = 1:3, newCohortName = c("HIV", "Asthma", "Depression")) |>
  CohortConstructor::sampleCohorts(500, 1) |>
  CohortConstructor::sampleCohorts(1300, 2)
cdm$comedications <- cdm$outcome |>
  CohortConstructor::copyCohorts(name = "comedications", n = 2) |>
  CohortConstructor::renameCohort(cohortId = 1:2, newCohortName = c("Antidiabetes", "Opioids")) |>
  CohortConstructor::sampleCohorts(800, 1) |>
  CohortConstructor::sampleCohorts(1500, 2)
summarised_characteristics <- cdm$denominator |>
  CohortCharacteristics::summariseCharacteristics(
    strata = list("sex"),
    cohortIntersectFlag = list(
      list(targetCohortTable = "comorbidities", window = c(-Inf, 0)),
      list(targetCohortTable = "comedications", window = c(-180, 0))
    )
  )
large_scale_characteristics <- cdm$denominator |>
  CohortCharacteristics::summariseLargeScaleCharacteristics(
    strata = list("sex"),
    eventInWindow = c("condition_occurrence", "observation"),
    episodeInWindow = "drug_exposure"
  ) |>
  omopgenerics::tidy() |>
  dplyr::select(!c("analysis", "table_name", "type")) |>
  dplyr::rename("concept_name" = "variable_name", "window" = "variable_level")
measurement_change <- dplyr::tibble(
  cohort_name = c("denominator"),
  sex = c(rep("overall", 3), rep("male", 3), rep("female", 3)),
  variable_name = rep(c("value_before", "value_after", "change_in_value"), 3),
  median = c(60, 58, -2, 65, 66, 1, 53, 50, -3),
  min = c(24, 22, -2, 30, 33, 3, 20, 19, -1),
  max = c(117, 108, -9, 120, 117, -3, 100, 100, 0),
  q25 = c(55, 55, 0, 61, 62, 1, 48, 47, -1),
  q75 = c(77.25, 72, -5.25, 80, 79, -1, 59, 60, 1)
)
data <- list(incidence = incidence, summarised_characteristics = summarised_characteristics, measurement_change = measurement_change, large_scale_characteristics = large_scale_characteristics)
usethis::use_data(data, internal = FALSE, overwrite = TRUE)
