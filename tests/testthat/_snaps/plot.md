# Function returns a ggplot object

    Code
      barPlot(dplyr::union_all(result, dplyr::mutate(result, variable_name = "age2")),
      x = "cohort_name", y = "mean", facet = c("age_group", "sex"))
    Condition
      Error in `barPlot()`:
      ! The summarised_result contains data for more than one variable, please filter the result to the variable of interest

