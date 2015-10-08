library(shinydashboard)
library(shinyBS)
dashboardPage(
  dashboardHeader(title = "WDFW Marine Fish Science"),
  dashboardSidebar(
    sidebarMenu(
      menuItem("Dashboard", tabName = "dashboard"),
      menuItem("MSP Demo", icon = icon("th"),
               menuSubItem ("Data", tabName = "mspdata", icon = icon("table")),
               menuSubItem ("Plots", tabName = "mspplots", icon = icon("line-chart")),
               menuSubItem ("Pivot Table", tabName = "msppivot", icon = icon("table"))
              
      )
    )
  ),
  dashboardBody(
    tabItems(
      tabItem(tabName= "mspdata")
    )
  )
)