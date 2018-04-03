library(shiny)
library(shinydashboard)
library(googleAuthR)
library(DT)
library(dygraphs)
library(d3heatmap)
library(listviewer)
library(ggplot2)

header <- dashboardHeader(title = "PABED")

textareaInput <- function(inputId, label, value="", placeholder="", rows=2){
    tagList(
    div(strong(label), style="margin-top: 5px;"),
    tags$style(type="text/css", "textarea {width:100%; margin-top: 5px;}"),
    tags$textarea(id = inputId, placeholder = placeholder, rows = rows, value))
}

sidebar <- dashboardSidebar(
disable = TRUE
)

body <- dashboardBody(
fluidRow(
tabBox(width = 12,
tabPanel(tagList(shiny::icon("picture-o"), "Query Engine"),
fluidRow(
box(title="BigQuery SQL", status = "info", width=12, solidHeader = T,
textareaInput("bq_sql", "Enter BigQuery SQL Here", rows=4),
helpText("See Query Reference: https://cloud.google.com/bigquery/query-reference"),
uiOutput("fetch_data_button")
)
),
fluidRow(
##tabBox(width = 12,
##tabPanel("General Plots",
##fluidRow(
box(title = "Plot Output",
status = "success", width = 12, solidHeader = T,
selectInput("plot_type", "Plot Type",
choices = c("Scatter" = "scatter",
"Line" =  "line",
# "Density" = "density",
"Area" = "area",
"Bar" = "bar",
"Dotplot" = "dotplot"
# "Hex Plot" = "hexplot",
# "Violin" = "violin"
)),
fluidRow(
column(3,
selectInput("x_scat", "x-axis", choices=NULL)),
column(3,
selectInput("y_scat", "y-axis", choices=NULL)),
column(3,
selectInput("colour_scat", "Colour", choices=NULL)),
column(3,
selectInput("size_scat", "Size", choices=NULL))
),
plotOutput("ggplot_p", height = "600px"),
br()
)
)
),
## this needs its own tab as d3heatmaps doesn't play nicely with others
##tabPanel("Heatmap",
##fluidRow(
##box(title = "Plot Output",
##status = "success", width = 12, solidHeader = T,
##radioButtons("heat_col", "Color Direction", choices=c("column","row", "none"), inline = TRUE),
##helpText("Needs first column to contain categories and more than 2 other columns."),
##d3heatmapOutput("heatmap", height = 600),
##br()
##)
##)
##)
##)
##)
##),
tabPanel(tagList(shiny::icon("info-circle"), "Data"),
conditionalPanel("output.logged_in != 'Waiting'",
fluidRow(
box(title="BigQuery Project", status="success", width = 6, solidHeader = T,
selectInput("project_select", label = "Project",
choices = NULL ),
helpText("The default BigQuery project to use.")),
box(title="BigQuery Datasets", status="success", width = 6, solidHeader = T,
selectInput("dataset_select", label="Datasets",
choices = NULL),
helpText("The default BigQuery dataset to use."))
),
fluidRow(
box(title="BigQuery Tables", status="success", width=12, solidHeader = T,
DT::dataTableOutput("bq_tables"),
helpText("The tables within the selected dataset. Select a table row to see its schema")
)

),
fluidRow(
box(title = "Table Metadata", status = "success", width = 12, solidHeader = T,
jsoneditOutput("table_meta"))
),
br()
)  ## conditionalPanel
), ## tabPanel
br()
)
),
br(),
helpText("All BigQuery data is deleted once you log out or close the browser.  If you don't log out the access token will expire in ~60 mins."),
textOutput("logged_in")
)

dashboardPage(header, sidebar, body, skin = "black")
