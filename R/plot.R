
plotInternal <- function() {
  errorMessage <- checkmate::makeAssertCollection()
  checkmate::assertTRUE(inherits(data, "summarised_result"))
  all_vars <- c(xAxis, yAxis, facetVarX, facetVarY, colorVars)
  checkmate::assertTRUE(all(all_vars[!is.null(all_vars)] %in% colnames(data)))
  if (plotStyle == "density" & xAxis != "estimate_value") {
    stop(sprintf("If plotStyle is set to 'density', xAxis must be 'estimate_value'."))
  }

  checkmate::assertVector(facetVarX, add = errorMessage, null.ok = TRUE)
  checkmate::assertVector(facetVarY, add = errorMessage, null.ok = TRUE)
  # checkmate::assertList(options, add = errorMessage, null.ok = TRUE)


  if (nrow(data) == 0) {
    return(ggplot2::ggplot() +
             ggplot2::theme_void() +
             ggplot2::labs(title = "Empty Data Provided", subtitle = "No data available for plotting."))
  }


  if (plotStyle == "boxplot") {
    if (!all(c("q25", "median", "q75", "min", "max") %in% data$estimate_name)) {
      return(
        ggplot2::ggplot() +
          ggplot2::theme_void() +
          ggplot2::labs(
            title = "No Data Provided",
            subtitle = "Boxplot needs to have min max q25 q75 in estimate_name"
          )
      )
    }
  }
  data <- data |>
    dplyr::mutate(color_combined = construct_color_variable(data, colorVars))

  if (is.null(facetVarX)) {
    warning("facetVarX put as NULL, plot overall")
    data$overall <- "overall"
    facetVarX <- "overall"
  }

  if (is.null(facetVarY)) {
    warning("facetVarY put as NULL, plot overall")
    data$overall <- "overall"
    facetVarY <- "overall"
  }

  data <- data |>
    dplyr::mutate(
      facet_combined_x = construct_variable(data, facetVarX),
      facet_combined_y = construct_variable(data, facetVarY)
    )

  # if (!is.null(facetOrder)) {
  #   if (!is.null(facetVars)) {
  #     checkmate::assertTRUE(all(facetOrder %in% data$facet_combined), add = errorMessage)
  #     data$facet_combined <- factor(data$facet_combined, levels = facetOrder)
  #     data$facet_combined <- droplevels(data$facet_combined)
  #     data <- data[!is.na(data$facet_combined), ]
  #   } else {
  #     errorMessage <- c(errorMessage, "please provide facetVars before specify facetOrder")
  #   } # drop the levels user did not specify! (Albert request)
  # }


  checkmate::assertTRUE(any(xAxis == "estimate_value", yAxis == "estimate_value"), add = errorMessage)


  checkmate::reportAssertions(collection = errorMessage)



  df_dates <- data |> dplyr::filter(.data$estimate_type == "date")
  if (plotStyle != "density") {
    df_non_dates <- data |>
      dplyr::filter(!(.data$estimate_type %in% c("date", "logical"))) |>
      dplyr::mutate(estimate_value = round(as.numeric(.data$estimate_value), 2))
    if (nrow(df_non_dates) > 0) {
      df_non_dates <- df_non_dates |>
        dplyr::mutate(
          estimate_value =
            dplyr::if_else(.data$estimate_name == "percentage",
                           .data$estimate_value / 100,
                           .data$estimate_value
            )
        )
    }
  } else {
    df_non_dates <- data |>
      dplyr::filter(!(.data$estimate_type %in% c("date", "logical")))
  }



  # # Prepare for custom colors if provided
  # custom_colors <- NULL
  # if (!is.null(colorNames) && length(colorNames) == length(unique(df_non_dates$color_combined))) {
  #   custom_colors <- stats::setNames(colorNames, unique(df_non_dates$color_combined))
  # } else if (!is.null(colorNames)) {
  #   stop("Length of colorNames does not match the number of unique combinations in
  #         colorVars column provided")
  # }


  # Start constructing the plot
  if (plotStyle == "scatterplot") {
    if (nrow(df_non_dates) > 0) {
      df_percent <- df_non_dates |> dplyr::filter(.data$estimate_name == "percentage")
      df_non_percent <- df_non_dates |> dplyr::filter(.data$estimate_name != "percentage")

      make_plot <- function(data, is_percent = FALSE) {
        if ("color_combined" %in% names(data)) {
          plot <- data |> ggplot2::ggplot() +
            ggplot2::geom_point(ggplot2::aes(
              x = !!rlang::sym(xAxis),
              y = !!rlang::sym(yAxis),
              color = .data$color_combined
            ))
          plot <- plot + ggplot2::labs(color = "Color")
        } else {
          plot <- data |> ggplot2::ggplot() +
            ggplot2::geom_point(ggplot2::aes(
              x = !!rlang::sym(xAxis),
              y = !!rlang::sym(yAxis)
            ))
        }

        if (is_percent) {
          if (xAxis == "estimate_value") {
            plot <- plot + ggplot2::scale_x_continuous(
              labels = scales::percent_format(accuracy = 1)
            )
          } else if (yAxis == "estiamte_value") {
            plot <- plot + ggplot2::scale_y_continuous(
              labels = scales::percent_format(accuracy = 1)
            )
          }
        }

        return(plot)
      }

      p_percent <- if (nrow(df_percent) > 0) {
        make_plot(df_percent, TRUE)
      } else {
        NULL
      }
      p_non_percent <- if (nrow(df_non_percent) > 0) {
        make_plot(df_non_percent, FALSE)
      } else {
        NULL
      }
    } else {
      p_percent <- p_non_percent <- NULL
    }
  } else if (plotStyle == "barplot" || plotStyle == "density") {
    if (nrow(df_non_dates) > 0) {
      # Separate data based on 'estimate_name'
      df_percent <- df_non_dates |> dplyr::filter(.data$estimate_name == "percentage")
      df_non_percent <- df_non_dates |> dplyr::filter(.data$estimate_name != "percentage")

      # Function to create bar plots
      create_bar_plot <- function(data, plotStyle, is_percent = FALSE) {
        if (plotStyle == "barplot") {
          if ("color_combined" %in% names(data)) {
            plot <- data |> ggplot2::ggplot(ggplot2::aes(
              x = !!rlang::sym(xAxis),
              y = !!rlang::sym(yAxis),
              fill = .data$color_combined
            )) +
              ggplot2::geom_col() +
              ggplot2::labs(fill = "Color")
          } else {
            plot <- ggplot2::ggplot(data, ggplot2::aes(
              x = !!rlang::sym(xAxis),
              y = !!rlang::sym(yAxis)
            )) +
              ggplot2::geom_col()
          }


          # Apply percent formatting if data is 'percentage' and for the correct axis
          if (is_percent) {
            if (xAxis == "estimate_value") {
              plot <- plot + ggplot2::scale_x_continuous(
                labels = scales::percent_format(accuracy = 1)
              )
            } else if (yAxis == "estimate_value") {
              plot <- plot + ggplot2::scale_y_continuous(
                labels = scales::percent_format(accuracy = 1)
              )
            }
          }
        } else if (plotStyle == "density") {
          data <- data |>
            dplyr::filter(.data$variable_name == "density") |>
            dplyr::mutate(estimate_value = as.numeric(.data$estimate_value))
          group_columns <- data |>
            dplyr::select(-c(
              "estimate_value", "estimate_name", "variable_level",
              if ("facet_combined_x" %in% names(df_non_dates)) "facet_combined_x" else NULL,
              if ("facet_combined_y" %in% names(df_non_dates)) "facet_combined_y" else NULL,
              if ("color_combined" %in% names(df_non_dates)) "color_combined" else NULL
            )) |>
            dplyr::summarise(dplyr::across(dplyr::everything(), ~ dplyr::n_distinct(.) > 1)) |>
            dplyr::select(dplyr::where(~.)) |>
            names()

          data$group_identifier <- interaction(data |>
                                                 dplyr::select(dplyr::all_of(group_columns)))

          density_data_wide <- data |>
            dplyr::mutate(estimate_value = as.list(.data$estimate_value)) |>
            tidyr::pivot_wider(names_from = "estimate_name", values_from = "estimate_value") |>
            tidyr::unnest(dplyr::everything())

          if ("color_combined" %in% names(density_data_wide)) {
            plot <- density_data_wide |>
              ggplot2::ggplot() +
              ggplot2::geom_line( # or geom_area() for filled areas
                ggplot2::aes(
                  x = .data$x, # Assuming 'x' is your data column
                  y = .data$y, # Pre-calculated density or other metric
                  group = .data$group_identifier, # Grouping variable
                  color = .data$color_combined # Use color to differentiate if it's a line plot
                  # fill = color_combined # Use fill instead of color if it's geom_area()
                )
              ) +
              ggplot2::labs(color = "Color")
          } else {
            plot <- density_data_wide |>
              ggplot2::ggplot() +
              ggplot2::geom_line( # or geom_area() for filled areas
                ggplot2::aes(
                  x = .data$x, # Assuming 'x' is your data column
                  y = .data$y, # Pre-calculated density or other metric
                  group = .data$group_identifier, # Grouping variable
                  # fill = color_combined # Use fill instead of color if it's geom_area()
                )
              ) +
              ggplot2::labs(color = "Color")
          }
        }

        return(plot)
      }

      if (plotStyle == "barplot") {
        # Create plots
        p_percent <- if (nrow(df_percent) > 0) {
          create_bar_plot(df_percent,
                          plotStyle = "barplot",
                          is_percent = TRUE
          )
        } else {
          NULL
        }
        p_non_percent <- if (nrow(df_non_percent) > 0) {
          create_bar_plot(df_non_percent,
                          plotStyle = "barplot",
                          is_percent = FALSE
          )
        } else {
          NULL
        }
      } else if (plotStyle == "density") {
        p_percent <- NULL
        p_non_percent <- if (nrow(df_non_percent) > 0) {
          create_bar_plot(df_non_percent,
                          is_percent = FALSE,
                          plotStyle = "density"
          )
        }
      }
    }
  } else if (plotStyle == "boxplot") {
    if (nrow(df_non_dates) > 0) {
      df_non_dates <- df_non_dates |>
        dplyr::filter(.data$estimate_name %in% c("q25", "median", "q75", "min", "max")) |>
        dplyr::mutate(
          estimate_value = as.numeric(.data$estimate_value),
          estimate_type = "numeric"
        )
      non_numeric_cols <- df_non_dates |>
        dplyr::select(-c(
          "estimate_value", "estimate_name",
          if ("facet_combined_x" %in% names(df_non_dates)) "facet_combined_x" else NULL,
          if ("facet_combined_y" %in% names(df_non_dates)) "facet_combined_y" else NULL,
          if ("color_combined" %in% names(df_non_dates)) "color_combined" else NULL
        )) |>
        dplyr::summarise(dplyr::across(dplyr::everything(), ~ dplyr::n_distinct(.) > 1)) |>
        dplyr::select(dplyr::where(~.)) |>
        names()

      df_non_dates_wide <- df_non_dates |>
        tidyr::pivot_wider(
          id_cols = dplyr::all_of(colnames(
            df_non_dates |>
              dplyr::select(-c("estimate_name", "estimate_value"))
          )),
          names_from = "estimate_name",
          values_from = "estimate_value"
        )


      if(length(non_numeric_cols) > 0){
        df_non_dates_wide$group_identifier <- interaction(df_non_dates_wide |>
                                                            dplyr::select(dplyr::all_of(non_numeric_cols)))} else{
                                                              df_non_dates_wide$group_identifier <- "overall"
                                                            }
    }

    if (nrow(df_dates) > 0) {
      df_dates <- df_dates |>
        dplyr::filter(.data$estimate_name %in% c("q25", "median", "q75", "min", "max")) |>
        dplyr::mutate(estimate_value = as.Date(.data$estimate_value))

      df_dates_wide <- df_dates |>
        tidyr::pivot_wider(
          id_cols = dplyr::all_of(colnames(df_dates |>
                                             dplyr::select(-c(
                                               "estimate_name",
                                               "estimate_value"
                                             )))),
          names_from = "estimate_name", values_from = "estimate_value"
        )
      if(length(non_numeric_cols) > 0){
        df_dates_wide$group_identifier <- interaction(df_dates_wide |>
                                                        dplyr::select(
                                                          dplyr::all_of(non_numeric_cols)
                                                        ))} else {
                                                          df_dates_wide$group_identifier <- "overall"
                                                        }
    }




    # Check if the dataframe has rows to plot
    if (nrow(df_non_dates) > 0) {
      xcol <- ifelse(xAxis == "estimate_value", yAxis, xAxis)
      p_non_dates <- df_non_dates_wide |> ggplot2::ggplot(
        ggplot2::aes(x = .data[[xcol]])) + ggplot2::labs(
          title = "Non-Date Data",
          x = "Variable and Group Level",
          y = "Quantile Values"
        )
      # +
      # ggplot2::theme(axis.text.x = ggplot2::element_text(angle = 45, hjust = 1))

      if ("color_combined" %in% names(df_non_dates_wide)) {
        if (!all(is.na(df_non_dates_wide$color_combined))) {
          p_non_dates <- p_non_dates + ggplot2::aes(color = .data$color_combined) +
            ggplot2::labs(color = "Color")

        }
      }


      p_non_dates <- p_non_dates + ggplot2::geom_boxplot(
        ggplot2::aes(
          group = .data$group_identifier,
          lower = .data$q25,
          upper = .data$q75,
          middle = .data$median,
          ymin = .data$min,
          ymax = .data$max
        ),
        stat = "identity"
      ) +
        ggplot2::labs(
          title = "Non-Date Data", x = "Variable and Group Level",
          y = "Quantile Values"
        )

      # Determine if the plot should be horizontal or vertical based on 'estimate_value'
      if (xAxis == "estimate_value") {
        # Horizontal plot
        p_non_dates <- p_non_dates +
          ggplot2::coord_flip()
      }
    } else {
      # Setup for empty data
      p_non_dates <- NULL
    }


    if (nrow(df_dates) > 0) {
      xcol <- ifelse(xAxis == "estimate_value", yAxis, xAxis)

      p_dates <- df_dates_wide |> ggplot2::ggplot(
        ggplot2::aes(x = .data[[xcol]])) +
        ggplot2::labs(
          title = "Date Data",
          x = "Variable and Group Level",
          y = "Quantile Values"
        )

      if ("color_combined" %in% names(df_dates_wide)) {
        if (!all(is.na(df_dates_wide$color_combined))) {
          p_dates <- p_dates + ggplot2::aes(color = .data$color_combined) +
            ggplot2::labs(color = "Color")
        }
      }

      p_dates <- p_dates + ggplot2::geom_boxplot(
        ggplot2::aes(
          group = .data$group_identifier,
          lower = .data$q25,
          upper = .data$q75,
          middle = .data$median,
          ymin = .data$min,
          ymax = .data$max
        ),
        stat = "identity"
      ) +
        ggplot2::labs(
          title = "Date Data", x = "Variable and Group Level",
          y = "Quantile Values"
        )
      # Determine if the plot should be horizontal or vertical based on 'estimate_value'
      if (xAxis == "estimate_value") {
        # Horizontal plot
        p_dates <- p_dates +
          ggplot2::coord_flip()
      }
    } else {
      p_dates <- NULL
    }
  }



  if (suppressWarnings(!is.null(data$facet_combined_x) || !is.null(data$facet_combined_y))) {
    if (plotStyle == "scatterplot") {
      # Apply facet grid if either plot exists
      if (!is.null(p_percent) || !is.null(p_non_percent)) {
        if (!is.null(p_percent)) {
          theme_modification <- ggplot2::theme(
            axis.text.x = ggplot2::element_text(
              angle = 90,
              hjust = 1,
              vjust = 0.5
            )
          )

          facet_x_exists <- "facet_combined_x" %in% names(df_percent)
          facet_y_exists <- "facet_combined_y" %in% names(df_percent)

          # Construct the faceting formula based on the existence of the variables
          facet_formula <- paste0(
            ifelse(facet_y_exists, "facet_combined_y", "."),
            " ~ ",
            ifelse(facet_x_exists, "facet_combined_x", ".")
          )
          p_percent <- p_percent + ggplot2::facet_grid(
            rows = facet_formula,
            scales = "free"
          )
          if (vertical_x) {
            p_percent <- p_percent + theme_modification
          }
        }

        if (!is.null(p_non_percent)) {
          facet_x_exists <- "facet_combined_x" %in% names(df_non_percent)
          facet_y_exists <- "facet_combined_y" %in% names(df_non_percent)

          # Construct the faceting formula based on the existence of the variables
          facet_formula <- paste0(
            ifelse(facet_y_exists, "facet_combined_y", "."),
            " ~ ",
            ifelse(facet_x_exists, "facet_combined_x", ".")
          )
          p_non_percent <- p_non_percent + ggplot2::facet_grid(
            rows = facet_formula,
            scales = "free"
          )
          if (vertical_x) {
            p_non_percent <- p_non_percent + theme_modification
          }
        }
      }

      # Combine the plots or select the appropriate one
      p <- if (!is.null(p_percent) && !is.null(p_non_percent)) {
        ggpubr::ggarrange(p_percent, p_non_percent, nrow = 2)
      } else if (!is.null(p_percent)) {
        p_percent
      } else if (!is.null(p_non_percent)) {
        p_non_percent
      } else {
        ggplot2::ggplot() +
          ggplot2::theme_void() +
          ggplot2::labs(
            title = "No Numeric Data Provided",
            subtitle = "Scatterplot only supported numeric values"
          )
      }
    } else if (plotStyle == "boxplot") {
      if (!is.null(p_dates)) {
        facet_x_exists <- "facet_combined_x" %in% names(df_dates)
        facet_y_exists <- "facet_combined_y" %in% names(df_dates)

        # Construct the faceting formula based on the existence of the variables
        facet_formula <- paste0(
          ifelse(facet_y_exists, "facet_combined_y", "."),
          " ~ ",
          ifelse(facet_x_exists, "facet_combined_x", ".")
        )

        p_dates <- p_dates +
          ggplot2::facet_grid(rows = facet_formula, scales = "free")
        if (vertical_x) {
          p_dates <- p_dates + ggplot2::theme(axis.text.x = ggplot2::element_text(
            angle = 90,
            hjust = 1,
            vjust = 0.5
          ))
        }
      }
      if (!is.null(p_non_dates)) {
        facet_x_exists <- "facet_combined_x" %in% names(df_non_dates)
        facet_y_exists <- "facet_combined_y" %in% names(df_non_dates)

        # Construct the faceting formula based on the existence of the variables
        facet_formula <- paste0(
          ifelse(facet_y_exists, "facet_combined_y", "."),
          " ~ ",
          ifelse(facet_x_exists, "facet_combined_x", ".")
        )

        p_non_dates <- p_non_dates +
          ggplot2::facet_grid(rows = facet_formula, scales = "free")
        if (vertical_x) {
          p_non_dates <- p_non_dates + ggplot2::theme(
            axis.text.x =
              ggplot2::element_text(
                angle = 90,
                hjust = 1,
                vjust = 0.5
              )
          )
        }
      }


      p <- if (!is.null(p_dates) && !is.null(p_non_dates)) {
        ggpubr::ggarrange(p_dates, p_non_dates, nrow = 2)
      } else if (!is.null(p_dates)) {
        p_dates
      } else if (!is.null(p_non_dates)) {
        p_non_dates
      } else {
        ggplot2::ggplot() +
          ggplot2::theme_void() +
          ggplot2::labs(
            title = "No Data Provided",
            subtitle = "Boxplot needs to have min max q25 q75 in estimate_name"
          )
      }
    } else if (plotStyle == "barplot" || plotStyle == "density") {
      if (!is.null(p_percent)) {
        facet_x_exists <- "facet_combined_x" %in% names(df_percent)
        facet_y_exists <- "facet_combined_y" %in% names(df_percent)

        # Construct the faceting formula based on the existence of the variables
        facet_formula <- paste0(
          ifelse(facet_y_exists, "facet_combined_y", "."),
          " ~ ",
          ifelse(facet_x_exists, "facet_combined_x", ".")
        )

        p_percent <- p_percent +
          ggplot2::facet_grid(rows = facet_formula, scales = "free")

        if (vertical_x) {
          p_percent <- p_percent + ggplot2::theme(axis.text.x = ggplot2::element_text(
            angle = 90,
            hjust = 1,
            vjust = 0.5
          ))
        }
      }

      if (!is.null(p_non_percent)) {
        facet_x_exists <- "facet_combined_x" %in% names(df_non_percent)
        facet_y_exists <- "facet_combined_y" %in% names(df_non_percent)

        # Construct the faceting formula based on the existence of the variables
        facet_formula <- paste0(
          ifelse(facet_y_exists, "facet_combined_y", "."),
          " ~ ",
          ifelse(facet_x_exists, "facet_combined_x", ".")
        )


        p_non_percent <- p_non_percent +
          ggplot2::facet_grid(rows = facet_formula, scales = "free")
        if (vertical_x) {
          p_non_percent <- p_non_percent +
            ggplot2::theme(axis.text.x = ggplot2::element_text(
              angle = 90,
              hjust = 1,
              vjust = 0.5
            ))
        }
      }


      # Combine the plots
      p <- if (!is.null(p_percent) && !is.null(p_non_percent)) {
        ggpubr::ggarrange(p_percent, p_non_percent, nrow = 2)
      } else if (!is.null(p_percent)) {
        p_percent
      } else if (!is.null(p_non_percent)) {
        p_non_percent
      } else {
        ggplot2::ggplot() +
          ggplot2::theme_void() +
          ggplot2::labs(
            title = "No Numeric Data Provided"
          )
      }
    }
  } else {
    if (plotStyle == "barplot" || plotStyle == "density" || plotStyle == "scatterplot") {
      p <- if (!is.null(p_percent) && !is.null(p_non_percent)) {
        if (vertical_x) {
          p_percent <- p_percent +
            ggplot2::theme(axis.text.x = ggplot2::element_text(
              angle = 90,
              hjust = 1,
              vjust = 0.5
            ))
          p_non_percent <- p_non_percent +
            ggplot2::theme(axis.text.x = ggplot2::element_text(
              angle = 90,
              hjust = 1,
              vjust = 0.5
            ))
        }
        ggpubr::ggarrange(p_percent, p_non_percent, nrow = 2)
      } else if (!is.null(p_percent)) {
        if (vertical_x) {
          p_percent <- p_percent +
            ggplot2::theme(axis.text.x = ggplot2::element_text(
              angle = 90,
              hjust = 1,
              vjust = 0.5
            ))
        }
        p_percent
      } else if (!is.null(p_non_percent)) {
        if (vertical_x) {
          p_non_percent <- p_non_percent +
            ggplot2::theme(axis.text.x = ggplot2::element_text(
              angle = 90,
              hjust = 1,
              vjust = 0.5
            ))
        }
        p_non_percent
      } else {
        ggplot2::ggplot() +
          ggplot2::theme_void() +
          ggplot2::labs(
            title = "No Numeric Data Provided"
          )
      }
    } else if (plotStyle == "boxplot") {
      if (!is.null(p_dates) || !is.null(p_non_dates)) {
        if (!is.null(p_dates) && is.null(p_non_dates)) {
          if (vertical_x) {
            p_dates <- p_dates +
              ggplot2::theme(axis.text.x = ggplot2::element_text(
                angle = 90,
                hjust = 1,
                vjust = 0.5
              ))
          }
          p <- p_dates
        } else if (is.null(p_dates) && !is.null(p_non_dates)) {
          if (vertical_x) {
            p_non_dates <- p_non_dates +
              ggplot2::theme(axis.text.x = ggplot2::element_text(
                angle = 90,
                hjust = 1,
                vjust = 0.5
              ))
          }
          p <- p_non_dates
        } else {
          if (vertical_x) {
            p_dates <- p_dates +
              ggplot2::theme(axis.text.x = ggplot2::element_text(
                angle = 90,
                hjust = 1,
                vjust = 0.5
              ))
            p_non_dates <- p_non_dates +
              ggplot2::theme(axis.text.x = ggplot2::element_text(
                angle = 90,
                hjust = 1,
                vjust = 0.5
              ))
          }
          p <- ggpubr::ggarrange(p_dates, p_non_dates, nrow = 2)
        }
      }
    }
  }

  # Apply additional options
  # if (!is.null(options) && length(options) > 0) {
  #   for (option in options) {
  #     p <- p + option
  #   }
  # }

  return(p)
}

construct_variable <- function(data, facet_vars) {
  if (!is.null(facet_vars) && length(facet_vars) > 1) {
    unique_val_vars <- sapply(facet_vars, function(var) {
      dplyr::n_distinct(data[[var]], na.rm = TRUE) > 1
    })

    valid_vars <- facet_vars[unique_val_vars]

    if (length(valid_vars) > 1) {
      return(as.factor(interaction(data |> dplyr::select(dplyr::all_of(valid_vars)), sep = ".")))
    } else if (length(valid_vars) == 1) {
      return(as.factor(data[[valid_vars]]))
    }
  } else if (!is.null(facet_vars) && length(facet_vars) == 1) {
    if (dplyr::n_distinct(data[[facet_vars]], na.rm = TRUE) > 1) {
      return(as.factor(data[[facet_vars]]))
    }
  }
  return(NULL)
}
construct_color_variable <- function(data, color_vars) {
  if (!is.null(color_vars) && length(color_vars) >= 1) {
    combined_factor <- interaction(dplyr::select(
      data,
      dplyr::all_of(color_vars)
    ), sep = ".")
    return(as.factor(combined_factor))
  }
  return(NULL)
}

#' Create a plot visualisation from a summarised result object.
#'
#' @param result A summarised result object.
#' @param x Column or estimate name that is used as x variable.
#' @param y Column or estimate name that is used as y variable
#' @param line Whether to plot a line using `geom_line`.
#' @param points Whether to plot points using `geom_point`.
#' @param ymin Lower limit of error bars, if provided is plot using
#' `geom_errorbar`.
#' @param ymax Upper limit of error bars, if provided is plot using
#' `geom_errorbar`.
#' @param facet Variables to facet by, a formula can be provided to specify
#' which variables should be used as rows and which ones as columns.
#' @param colour Columns to use to determine the colors.
#' @param splitStrata Whether to split strata within columns.
#' @param splitGroup Whether to split group within columns.
#' @param splitAdditional Whether to split additional within columns.
#'
#' @return A plot object.
#'
#' @export
#'
#' @examples
#' \donttest{
#' result <- mockSummarisedResult() |>
#'   dplyr::filter(variable_name == "age")
#'
#' plotScatter(
#'   result = result,
#'   x = "group",
#'   y = "mean",
#'   facet = "strata")
#' }
#'
plotScatter <- function(result,
                        x,
                        y,
                        line = TRUE,
                        points = TRUE,
                        ymin = NULL,
                        ymax = NULL,
                        facet = NULL,
                        colour = NULL,
                        splitStrata = TRUE,
                        splitGroup = TRUE,
                        splitAdditional = TRUE) {
  # check and prepare input
  omopgenerics::assertLogical(line, length = 1, call = call)
  omopgenerics::assertLogical(points, length = 1, call = call)
  res <- prepareInput(
    result = result, x = x, y = y, facet = facet, colour = colour,
    splitStrata = splitStrata, splitGroup = splitGroup,
    splitAdditional = splitAdditional, ymin = ymin, ymax = ymax)

  result <- res$result
  facet <- res$facet
  rm(res)

  aes <- "ggplot2::aes(x = .data$x, y = .data$y, colour = .data$xxx_colour, group = .data$xxx_group"
  if (!is.null(ymin)) aes <- paste0(aes, ", ymin = .data$ymin")
  if (!is.null(ymax)) aes <- paste0(aes, ", ymax = .data$ymax")
  aes <- paste0(aes, ")") |>
    glue::glue() |>
    rlang::parse_expr() |>
    eval()

  p <- ggplot2::ggplot(data = result, mapping = aes)
  if (line) p <- p + ggplot2::geom_line()
  if (!is.null(ymin) & !is.null(ymax)) p <- p + ggplot2::geom_errorbar()
  if (points) p <- p + ggplot2::geom_point()

  p <- plotFacet(p, facet)

  return(p)
}

plotBoxplot <- function(result,
                        lower,
                        middle,
                        upper,
                        ymin = NULL,
                        ymax = NULL,
                        facet = NULL,
                        color = NULL,
                        splitStrata = TRUE,
                        splitGroup = TRUE,
                        splitAdditional = TRUE) {

}

plotBarplot <- function(result,
                        x,
                        y,
                        ymax = NULL,
                        ymin = NULL,
                        facet = NULL,
                        color = NULL,
                        splitStrata = TRUE,
                        splitGroup = TRUE,
                        splitAdditional = TRUE) {

}

prepareInput <- function(result,
                         x,
                         facet,
                         colour,
                         splitStrata,
                         splitGroup,
                         splitAdditional,
                         ...,
                         call = parent.frame()) {
  # result <- omopgenerics::validateResult(result, call = call)
  result <- result |>
    omopgenerics::newSummarisedResult() |>
    pivotEstimates()

  omopgenerics::assertLogical(splitStrata, length = 1, call = call)
  omopgenerics::assertLogical(splitGroup, length = 1, call = call)
  omopgenerics::assertLogical(splitAdditional, length = 1, call = call)

  # strata
  if (splitStrata) {
    strataCols <- strataColumns(result)
    result <- result |>
      splitStrata()
  } else {
    result <- result |>
      tidyr::unite(col = "strata", c("strata_name", "strata_level"))
    strataCols <- "strata"
  }

  # group
  if (splitGroup) {
    groupCols <- groupColumns(result)
    result <- result |>
      splitGroup()
  } else {
    result <- result |>
      tidyr::unite(col = "group", c("group_name", "group_level"))
    groupCols <- "group"
  }

  # additional
  if (splitAdditional) {
    additionalCols <- additionalColumns(result)
    result <- result |>
      splitAdditional()
  } else {
    result <- result |>
      tidyr::unite(col = "additional", c("additional_name", "additional_level"))
    additionalCols <- "additional"
  }

  optionsCols <- c(
    "cdm_name", "variable_name", "variable_level", strataCols, groupCols,
    additionalCols)

  facet <- validateFacetColour(
    x = facet, name = "facet", opts = optionsCols, strataCols = strataCols,
    groupCols = groupCols, additionalCals = additionalCals, call = call)
  facetCols <- getFacetCols(facet)

  colour <- validateFacetColour(
    x = colour, name = "colour", opts = optionsCols, strataCols = strataCols,
    groupCols = groupCols, additionalCals = additionalCals, call = call)
  if (length(colour) > 0) {
    result <- result |>
      tidyr::unite(col = "xxx_colour", dplyr::all_of(colour), remove = FALSE)
  } else {
    result <- result |>
      dplyr::mutate(xxx_colour = "all")
  }

  # variables
  variables <- list(...)
  for (k in seq_along(variables)) {
    nm <- names(variables)[k]
    val <- variables[[k]]
    msg <- "{nm} must be a character that points to a column in result." |>
      glue::glue()
    omopgenerics::assertCharacter(val, length = 1, call = call, msg = msg, null = TRUE)
    if (isFALSE(val %in% colnames(result))) {
      cli::cli_inform("column {val} with NA as it is not present in data.")
      result <- result |>
        dplyr::mutate(!!val := NA_real_)
    }
  }

  x <- validateFacetColour(
    x = x, name = "x", opts = optionsCols, strataCols = strataCols,
    groupCols = groupCols, additionalCals = additionalCals, call = call)

  group <- c(facetCols, colour, x)
  group <- optionsCols[!optionsCols %in% group]
  if (length(group) > 0) {
    result <- result |>
      tidyr::unite(col = "xxx_group", dplyr::all_of(group), remove = FALSE)
  } else {
    result <- result |>
      dplyr::mutate(xxx_group = "all")
  }

  if (length(x) > 1) {
    result <- result |>
      tidyr::unite(col = "x", dplyr::all_of(x), remove = FALSE)
  } else {
    result <- result |>
      dplyr::rename("x" = dplyr::all_of(x))
  }

  result <- result |>
    dplyr::select(dplyr::all_of(c(
      "x", facetCols, "xxx_group", "xxx_colour", unlist(variables)
    )))

  return(list(result = result, facet = facet))
}
validateFacetColour <- function(x, name, opts, strataCols, groupCols, additionalCals, call) {
  if (is.null(x)) return(NULL)
  mes <- "{name} must be character vector or a formula that can contain the following elements: {opts}."
  if (rlang::is_bare_formula(x)) {
    x <- x |> as.character()
    if (length(x) != 3) cli::cli_abort("{name} formula not recognised", call = call)
    element1 <- x[2] |> validateElement(opts, strataCols, groupCols, additionalCols)
    if (is.null(element1)) cli::cli_abort(message = mes, call = call)
    element2 <- x[3] |> validateElement(opts, strataCols, groupCols, additionalCols)
    if (is.null(element2)) cli::cli_abort(message = mes, call = call)
    x <- paste0(
      paste0(element1, collapse = " + "),
      " ~ ",
      paste0(element2, collapse = " + ")
    ) |>
      as.formula()
  } else if (is.character(x)) {
    x <- x |> validateElement(opts, strataCols, groupCols, additionalCols)
    if (is.null(x)) cli::cli_abort(message = mes, call = call)
  } else {
    cli::cli_abort(message = mes, call = call)
  }
  return(x)
}
validateElement <- function(element, opts, strataCols, groupCols, additionalCols) {
  if (element == ".") return(element)
  element <- element |> strsplit(split = "+", fixed = TRUE)
  element <- gsub(" ", "", element)
  element <- substituteValue(element, "strata", strataCols)
  element <- substituteValue(element, "group", groupCols)
  element <- substituteValue(element, "additional", additionalCols)
  if (!(length(element) == length(unique(element)) & all(element %in% opts))) {
    element <- NULL
  }
  return(element)
}
substituteValue <- function(x, value, newValue) {
  id <- which(x == value)
  lx <- length(x)
  if (length(id) > 1) return(NULL)
  if (length(id) == 1) {
    if (id == 1) {
      if (lx == 1) {
        x <- newValue
      } else {
        x <- c(newValue, x[-1])
      }
    } else if (id == lx) {
      x <- c(x[-id], newValue)
    } else {
      x <- c(x[1:(id-1)], newValue, x[(id+1):lx])
    }
  }
  return(x)
}
plotFacet <- function(p, facet) {
  if (!is.null(facet)) {
    if (is.character(facet)) {
      p <- p + ggplot2::facet_wrap(facets = facet)
    } else {
      p <- p + ggplot2::facet_grid(facet)
    }
  }
  return(p)
}
getFacetCols <- function(facet) {
  if (is.null(facet)) {
    facet <- character()
  } else if (rlang::is_bare_formula(facet)) {
    facet <- as.character(facet) |> strsplit(split = "+")
    facet <- facet[[-1]] |> unlist() |> unique()
  }
  return(facet)
}
