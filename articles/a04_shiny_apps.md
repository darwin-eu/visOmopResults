# Shiny Apps

This vignette shows how to render **interactive plots** and **tabular
results** in Shiny using the visOmopResults package and functions that
build on it. Specifically, we will demonstrate:

- **Small/static tables** → `gt`, for compact, fixed results such as
  cohort counts or characteristics.

- **Large/dynamic tables** → `DT` or `reactable`, for large results or
  those that require sorting/filtering to interpret.

- **Plots** → build with `ggplot2` and (optionally) wrap with
  [`plotly::ggplotly()`](https://rdrr.io/pkg/plotly/man/ggplotly.html)
  for interactivity in shiny.

## Set up

Load packages and mock data.

``` r
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

# Mock results in visOmopResults
data <- visOmopResults::data

# Remove global options (just in case we have them from previous work)
setGlobalPlotOptions(style = NULL, type = NULL)
setGlobalTableOptions(style = NULL, type = NULL)
```

### Mock data

We will use 3 different mock results, which are:

- **Baseline characteristics** from the `CohortCharacteristics` package

- **Incidence** results from the `IncidencePrevalence` package

- **Large scale characterisation**, which is not a `<summarised_result>`

## Shiny App: User Inteface

The Shiny app has three panels, one for each result. All allow filtering
by sex strata and provide panel-specific visualization options:

**- Baseline characteristics:** shows a `gt` table with controls for
headers, groups, and hidden columns..

**- Large Scale characteristics:** renders as a `datatable` or
`reactable`, with options to group or hide columns.

**- Incidence:** displays a static `ggplot` or interactive `plotly`
plot, with options for colouring, faceting, and ribbons.

### Example UI Code

``` r
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
```

## Shiny App: Server

#### 1) Baseline characteristics

The server filters results by the selected sex and creates a `gt` table
using the
[`tableCharacteristics()`](https://darwin-eu.github.io/CohortCharacteristics/reference/tableCharacteristics.html)
function from the `CohortCharacteristics` package. This function is
built on **visOmopResults**, which ensures consistent styling and
supports arguments to define headers, group columns, and hide columns.

If you have your own `<summarised_result>` table, which don’t has a
dedicated table function, you can instead use
[`visOmopTable()`](https://darwin-eu.github.io/visOmopResults/reference/visOmopTable.md)
to generate a `gt` table in Shiny. This allows you to group estimates
and configure header, group, and hidden column options in a similar way.

#### 2) Large Scale characteristics

These results are not in `<summarised_result>` format, as shown below:

``` r
data$large_scale_characteristics
#> # A tibble: 952 × 8
#>    cdm_name    cohort_name sex   concept_name window concept_id count percentage
#>    <chr>       <chr>       <chr> <chr>        <chr>  <chr>      <int>      <dbl>
#>  1 my_duckdb_… denominato… over… Acute aller… -inf … 4084167      113       4.41
#>  2 my_duckdb_… denominato… over… Acute bacte… -inf … 4294548      607      23.7 
#>  3 my_duckdb_… denominato… over… Acute bronc… -inf … 260139      2303      89.8 
#>  4 my_duckdb_… denominato… over… Acute chole… -inf … 198809        29       1.13
#>  5 my_duckdb_… denominato… over… Acute viral… -inf … 4112343     2388      93.1 
#>  6 my_duckdb_… denominato… over… Alzheimer's… -inf … 378419        15       0.59
#>  7 my_duckdb_… denominato… over… Anemia       -inf … 439777        73       2.85
#>  8 my_duckdb_… denominato… over… Angiodyspla… -inf … 4310024      281      11.0 
#>  9 my_duckdb_… denominato… over… Appendicitis -inf … 440448       125       4.88
#> 10 my_duckdb_… denominato… over… Atopic derm… -inf … 133834        54       2.11
#> # ℹ 942 more rows
```

In this case, we use
[`visTable()`](https://darwin-eu.github.io/visOmopResults/reference/visTable.md)
to generate tables as either a `datatable` or a `reactable`, depending
on the user’s choice in the UI. The table type is specified with the
type argument.

For both table types, we pass the UI-selected columns to `groupColumn`
and `hide.` We do not generate a header for this result, as it would
require restructuring the estimates into a single “estimate_value”
column.

The look and behaviour of the tables can be customised through the style
argument. Available options can be explored with:

- `tableStyle("datatable")`

- `tableStyle("reactable")`

In this vignette, we modify the `datatable` style in the server code so
filters appear at the top of the table instead of the default bottom.

#### 3) Incidence

For incidence results, we use the
[`plotIncidence()`](https://darwin-eu.github.io/IncidencePrevalence/reference/plotIncidence.html)
function from the `IncidencePrevalence` package. This function creates a
`ggplot` object, which can be rendered as a static plot with
`plotOutput` or as an interactive plot with `plotlyOutput`. Users can
also select which columns to use for colouring and faceting, and whether
to display confidence interval ribbons.

For other results—whether `<summarised_reuslt>` class or not—you can
generate plots in a similar way by using the plotting functions
available in `visOmopResults.`

### Example Server Code

> Note: Both `CohortCharacteristics` and `IncidencePrevalence` functions
> for plotting and tabulation are built on `visOmopResults`, which means
> they share a consistent interface and style.

``` r
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
```

## Run App

To run the Shiny app, copy the code chunks provided in this vignette
into a script named **`app.R`**, and add the following line at the end:

``` r
shinyApp(ui, server)
```

You can find the complete code run the ShinyApp
[here](https://github.com/darwin-eu/visOmopResults/blob/main/inst/app.R).
