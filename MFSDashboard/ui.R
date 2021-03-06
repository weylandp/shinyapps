library(DT)
library(shiny)
library(ggplot2)
library(leaflet)
library(htmltools)
library(shinydashboard)
library(shinyBS)
library(googleVis)
library(data.table)
tagCPUE<-fread("Tag_vCPUE.csv")
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
      menuItem("Fish Ticket", icon = icon("th"),
        menuSubItem("Trends", icon = icon("line-chart"), tabName = "ftTrends")) ,
                 
      menuItem("MFS Documents", tabName = "mfsdocs")
    )
  ),
  dashboardBody(
    tabItems(
      tabItem(tabName= "tagmaps",
              fluidRow(
                box(title = "Filters", width = 12, collapsible = TRUE, solidHeader = TRUE,
                    column(6,
                      sliderInput('tagCPUEyear', 'Year', width='100%', min = min(tagCPUE$SetYear), max = max(tagCPUE$SetYear), value= c(max(tagCPUE$SetYear)-5,max(tagCPUE$SetYear) ), sep="", step = 1)),
                    column(6,   
                      selectInput('tagCPUEspecies', 'Species', width='100%',levels(factor(tagCPUE$CommonName)), multiple = TRUE))
                    )),
              
                fluidRow(
                
                  tabBox(title = "Nearshore Tag Maps",  width = 12,
                    tabPanel("CPUE",
                           leafletOutput('tagccpuemapPlot', width='100%', height =550)
                      )   
                    )
                
                )
      ),
      tabItem(tabName= "tagTrends",
              fluidRow(
                box(title = "Filters", width = 12, collapsible = TRUE, solidHeader = TRUE,
                    column(6,
                           sliderInput('tagCPUEPlotyear', 'Year', width='100%', min = min(tagCPUE$SetYear), max = max(tagCPUE$SetYear), value= c(max(tagCPUE$SetYear)-5,max(tagCPUE$SetYear) ), sep="", step = 1)),
                    column(6,   
                           selectInput('tagCPUEPlotspecies', 'Species', width='100%',levels(factor(tagCPUE$CommonName)), multiple = TRUE))
                )),
              
              fluidRow(
                
                tabBox(title = "Nearshore Tag Trends",  width = 12,
                       tabPanel("CPUE",
                                selectInput('cpuePlotFacetType', "Facet by", c("PCA","Season","PCA and Season")),
                                plotOutput('tagccpuePlot', width='100%', height =550)
                       )   
                )
                
              )
      ),
      tabItem(tabName= "tagdata",
              bsModal("modalExample", "CPUE Data Table", "tabButTagCPUE", size = "large",
                      "Each record represents a fishing set. Column FishCount represent the total number of fish caught during that set. FishCount and other totals will reflect update automatically to reflect filters."),
              fluidRow(
                box(title = "Filters", width = 12, collapsible = TRUE, solidHeader = TRUE,
                    column(6,
                           sliderInput('tagCPUEDatayear', 'Year', width='100%', min = min(tagCPUE$SetYear), max = max(tagCPUE$SetYear), value= c(max(tagCPUE$SetYear)-5,max(tagCPUE$SetYear) ), sep="", step = 1)),
                    column(6,   
                           selectInput('tagCPUEDataspecies', 'Species', width='100%',levels(factor(tagCPUE$CommonName)), multiple = TRUE))
                )),
              
              fluidRow(
                tabBox(title = "Tag Data",  width = 12,
                       tabPanel("CPUE by Species",
                                actionLink("tabButTagCPUE", "Table Description"),
                                dataTableOutput('tagCPUEBySpeciesData', width = "100%")
                       )
                )   
                )
                
              ),
      tabItem(tabName= "ftTrends",
             
              fluidRow(
                box(title = "Filters", width = 12, collapsible = TRUE, solidHeader = TRUE,
                    column(6,
                      uiOutput("FTTrendsYearSlider")
                    )
                    )),
              
              fluidRow(
                tabBox(title = "Fish Ticket Trends",  width = 12,
                       tabPanel("Calendar",
                                actionLink("tabButFTHeatMap", "Calendar Map Description"),
                                htmlOutput('ftHeatMap', width = "100%", height = "100%")
                       )
                )   
              )
              
      )
      )
    
  )
)