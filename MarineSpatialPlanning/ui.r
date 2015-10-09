library(shinydashboard)
library(shiny)
library(shinyBS)
library(rpivotTable)
library(DT)
dashboardPage(
  dashboardHeader(title = "MSP"),
  dashboardSidebar(
    sidebarMenu(
      selectInput('exampleInput', 'Select Example', c('Example 1', 'Example 2', 'Example 3', 'Example 4')),
      menuItem("MSP Demo", icon = icon("th"),
               menuSubItem ("Data", tabName = "mspdatatab", icon = icon("table")),
               menuSubItem ("Plots", tabName = "mspplotstab", icon = icon("line-chart")),
               menuSubItem ("Pivot Table", tabName = "msppivottab", icon = icon("table"))
              
      )
    )
  ),
  dashboardBody(
    tags$head(tags$style(
      type = 'text/css',
      '#msppivotplot{ overflow-x: scroll; }'
    )),
    tabItems(
      tabItem(tabName= "mspdatatab",
              fluidRow(
                DT::dataTableOutput('mspdatatable'))),
      tabItem(tabName= "msppivottab",
              fluidRow(
                rpivotTableOutput('msppivotplot', height="100%"))),
      tabItem(tabName= "mspplotstab",
              fluidRow(
                plotOutput('mspplot', width='100%', height =550)))
    )
  )
)