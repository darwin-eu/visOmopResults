# Packages ----
library(shiny)
library(bslib)
library(sortable)
library(shinyWidgets)
library(gt)
library(DT)
library(reactable)
library(plotly)
library(dplyr)
library(visOmopResults)
library(IncidencePrevalence)
library(CohortCharacteristics)
library(shinycssloaders)

# Data ----
data <- visOmopResults::data
# No pre-defined type or style
setGlobalPlotOptions(style = NULL, type = NULL)
setGlobalTableOptions(style = NULL, type = NULL)

# UI ----
ui <- bslib::page_navbar(
  title = "visOmopResults for Shiny",
  window_title = "visOmopResults • Shiny",
  collapsible = TRUE,
  # Baseline Characteristics (GT table)
  bslib::nav_panel(
    title = "Baseline Characteristics",
    icon = icon("users-gear"),
    bslib::layout_sidebar(
      sidebar = bslib::sidebar(
        title = "Filters",
        shinyWidgets::pickerInput(
          inputId = "summarise_characteristics_sex",
          label = "Sex",
          choices = c("overall", "Male", "Female"),
          selected = "overall",
          multiple = TRUE
        ),
        width = 320,
        position = "left",
        open = TRUE
      ),
      bslib::card(
        full_screen = TRUE,
        bslib::card_header("Table layout"),
        bslib::layout_sidebar(
          sidebar = bslib::sidebar(
            title = "Arrange columns",
            sortable::bucket_list(
              header = NULL,
              group_name = "col-buckets",
              orientation = "horizontal",
              add_rank_list(
                text = "None",
                labels = c("variable_name", "variable_level", "estimate_name"),
                input_id = "summarise_characteristics_table_none"
              ),
              add_rank_list(
                text = "Header",
                labels = c("sex"),
                input_id = "summarise_characteristics_table_header"
              ),
              add_rank_list(
                text = "Group columns",
                labels = c("cdm_name", "cohort_name"),
                input_id = "summarise_characteristics_table_group_column"
              ),
              add_rank_list(
                text = "Hide",
                labels = "table_name",
                input_id = "summarise_characteristics_table_hide"
              )
            ),
            position = "right",
            width = 400,
            open = FALSE
          ),
          # GT output
          gt::gt_output("summarise_characteristics_table") |>
            shinycssloaders::withSpinner(type = 4)
        )
      )
    )
  ),
  # Large Scale Characterisation (DT / reactable)
  bslib::nav_panel(
    title = "Large Scale Characterisation",
    icon = icon("table"),
    bslib::layout_sidebar(
      sidebar = bslib::sidebar(
        # title = "Display options",
        shinyWidgets::pickerInput(
          inputId = "large_scale_sex",
          label = "Sex",
          choices = c("overall", "Male", "Female"),
          selected = "overall",
          multiple = TRUE
        ),
        radioButtons(
          "large_engine",
          "Renderer",
          choices = c("DT", "reactable"),
          inline = TRUE
        ),
        sortable::bucket_list(
          header = NULL,
          group_name = "col-buckets",
          orientation = "horizontal",
          add_rank_list(
            text = "None",
            labels = c("variable_name", "variable_level", "estimate_name"),
            input_id = "large_scale_none"
          ),
          add_rank_list(
            text = "Group columns",
            labels = c("cdm_name", "cohort_name"),
            input_id = "large_scale_group_column"
          ),
          add_rank_list(
            text = "Hide",
            labels = character(),
            input_id = "large_scale_hide"
          )
        ),
        width = 320
      ),
      bslib::card(
        full_screen = TRUE,
        bslib::card_header("Cohort characteristics (large-scale)"),
        conditionalPanel(
          "input.large_engine == 'DT'",
          DTOutput("large_dt") |> shinycssloaders::withSpinner(type = 4)
        ),
        conditionalPanel(
          "input.large_engine == 'reactable'",
          reactableOutput("large_reactable") |> shinycssloaders::withSpinner(type = 4)
        )
      )
    )
  ),
  # Incidence (ggplot → plotly)
  bslib::nav_panel(
    title = "Incidence",
    icon = icon("chart-line"),
    bslib::layout_sidebar(
      sidebar = bslib::sidebar(
        title = "Plot options",
        shinyWidgets::pickerInput(
          "incidence_sex",
          "Sex strata",
          choices = c("overall", "Male", "Female"),
          selected = "overall",
          multiple = TRUE
        ),
        shinyWidgets::pickerInput(
          inputId = "facet",
          label = "Facet",
          selected = "sex",
          multiple = TRUE,
          choices = c("cdm_name", "incidence_start_date", "sex", "outcome_cohort_name"),
        ),
        shinyWidgets::pickerInput(
          inputId = "colour",
          label = "Colour",
          selected = "outcome_cohort_name",
          multiple = TRUE,
          choices = c("cdm_name", "incidence_start_date",  "sex", "outcome_cohort_name")
        ),
        checkboxInput("inc_ribbon", "Show ribbon (CI)", TRUE),
        checkboxInput("interactive", "Interactive Plot", TRUE),
        width = 320
      ),
      bslib::card(
        full_screen = TRUE,
        bslib::card_header("Incidence over time"),
        uiOutput("incidence_plot", height = "520px") |> shinycssloaders::withSpinner(type = 4)
      )
    )
  )
)





# Server ----
server <- function(input, output, session) {
  # Baseline (GT)
  output$summarise_characteristics_table <- gt::render_gt({
    data$summarised_characteristics |>
      # filter results by sex
      filterStrata(sex %in% input$summarise_characteristics_sex) |>
      # create GT table
      CohortCharacteristics::tableCharacteristics(
        header = input$summarise_characteristics_table_header,
        groupColumn = input$summarise_characteristics_table_group_column,
        hide = input$summarise_characteristics_table_hide,
        type = "gt"
      )
  })

  # Large scale characteristics
  getLargeScaleResults <- reactive({
    data$large_scale_characteristics |>
      filter(.data$sex %in% input$large_scale_sex)
  })
  # To render as DT
  output$large_dt <- renderDT({
    getLargeScaleResults() |>
      visTable(
        hide = input$large_scale_hide,
        groupColumn = input$large_scale_group_column,
        type = "datatable",
        style = list(
          filter = "top",
          searchHighlight = TRUE,
          rownames = FALSE
        )
      )
  })
  # To render as reactable
  output$large_reactable <- reactable::renderReactable({
    getLargeScaleResults() |>
      visTable(
        hide = input$large_scale_hide,
        groupColumn = input$large_scale_group_column,
        type = "reactable",
        style = "default"
      )
  })

  # Incidence
  getIncidencePlot <- reactive({
    data$incidence |>
      filterStrata(sex %in% input$incidence_sex) |>
      plotIncidence(
        colour = input$colour,
        facet = input$facet,
        ribbon = input$inc_ribbon
      ) +
      theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust = 1))
  })
  output$incidence_plot <- renderUI({
    plt <- getIncidencePlot()
    if (input$interactive) {
      ggplotly(plt)
    } else {
      renderPlot(plt)
    }
  })
}

# Run Shiny ----
shinyApp(ui, server)
