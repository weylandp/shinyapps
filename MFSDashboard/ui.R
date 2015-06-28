library(DT)
library(shiny)
library(ggplot2)
library(leaflet)
library(htmltools)
library(shinydashboard)
tagCPUE<-read.csv("Tag_vCPUE.csv")
dashboardPage(
  dashboardHeader(title = "WDFW Marine Fish Science"),
  dashboardSidebar(
    sidebarMenu(
      menuItem("Dashboard", tabName = "dashboard"),
      menuItem("Coastal Unit", icon = icon("th") ,
               menuItem("Research", icon = icon("th") ,
                        menuItem("Nearshore Tag Survey", icon = icon("th") ,
                                 menuSubItem ("Data", tabName = "tagdata", icon = icon("table")),
                                 menuSubItem ("Trends", tabName = "tagTrends", icon = icon("line-chart")), 
                                 menuSubItem ("Maps", tabName = "tagmaps", icon = icon("globe",lib = "font-awesome"))),
                        menuSubItem("Yelloweye Survey",tabName = "yeyesurvey")),
               menuItem("Biological Data System")),   
      menuItem("Puget Sound Unit", icon = icon("th") ,
        menuSubItem("ROV Survey",tabName = "rovsurvey"),
        menuSubItem("PS Trawl",tabName = "pstrawl")),
      menuItem("Fish Ticket", tabName = "ft"),
      menuItem("MFS Documents", tabName = "mfsdocs")
    )
  ),
  dashboardBody(
    tabItems(
      tabItem(tabName= "tagmaps",
              fluidRow(
                column(3,
                       sliderInput('tagCPUEyear', 'Year', min = min(tagCPUE$SetYear), max = max(tagCPUE$SetYear), value= c(max(tagCPUE$SetYear)-5,max(tagCPUE$SetYear) ), sep="", step = 1)
                ),
                column(3,
                       selectInput('tagCPUEspecies', 'Species', levels(factor(tagCPUE$CommonName)), multiple = TRUE))),
              tabBox(title = "Nearshore Tag Maps",   
                  tabPanel("CPUE",
                         leafletOutput('tagccpuemapPlot', height = '800px')
                         )         
              )
      )
    )
    
  )
)