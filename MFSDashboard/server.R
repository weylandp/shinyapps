library(dplyr)
library(ggplot2)
library(googleVis)
library(data.table)
library(lubridate)
#ftData<-fread("C:/data/R Projects/ShinyApps/MFSDashboard/MFSDashboard/FTGrouped.csv")
function(input, output) {
  
  
 
  output$tagccpuemapPlot <- renderLeaflet({
    tagCPUE<-read.csv("Tag_vCPUE.csv")
    tagCPUE <- tagCPUE[tagCPUE$SetYear<=max(input$tagCPUEyear) & tagCPUE$SetYear>=min(input$tagCPUEyear),]
    if(!is.null(input$tagCPUEspecies)){
      tagCPUE$FishCount[!(tagCPUE$CommonName %in% input$tagCPUEspecies)]<-0 
      tagCPUE$MaleCount[!(tagCPUE$CommonName %in% input$tagCPUEspecies)]<-0
      tagCPUE$FemaleCount[!(tagCPUE$CommonName %in% input$tagCPUEspecies)]<-0
      tagCPUE$MortalityCount[!(tagCPUE$CommonName %in% input$tagCPUEspecies)]<-0
      tagCPUE$RecoveryCount[!(tagCPUE$CommonName %in% input$tagCPUEspecies)]<-0
      
    }
    tagCPUE <- tagCPUE %>%
                        group_by(SetID, SetDate, Latitude, Longitude) %>%
                        summarise(RodHours = mean(RodHours),
                                  FishCount = sum(FishCount))
    
    colfunc <- colorRampPalette(c("red","yellow","green"))
    cpuePal <- colorNumeric(palette = colfunc(20), domain = tagCPUE$FishCount/tagCPUE$RodHours)
    leaflet(tagCPUE) %>%
      addProviderTiles("Acetate.terrain") %>%
      addCircleMarkers( lng= tagCPUE$Longitude, lat= tagCPUE$Latitude, fillOpacity = .5 , color = ~cpuePal(FishCount/RodHours), radius = 1, popup = paste0("<strong>Date: </strong>",tagCPUE$SetDate, "<br><strong>Fish Count: </strong>", tagCPUE$FishCount, "<br><strong>CPUE: </strong>", tagCPUE$FishCount/tagCPUE$RodHours)) %>%
      addLegend(pal = cpuePal, title="CPUE Fish/Hour",values = (tagCPUE$FishCount/tagCPUE$RodHours))
    
  })
  output$tagCPUEBySpeciesData <- renderDataTable({
    tagCPUE<-read.csv("Tag_vCPUE.csv")
    tagCPUE <- tagCPUE[tagCPUE$SetYear<=max(input$tagCPUEDatayear) & tagCPUE$SetYear>=min(input$tagCPUEDatayear),]
    if(!is.null(input$tagCPUEDataspecies)){
      tagCPUE$FishCount[!(tagCPUE$CommonName %in% input$tagCPUEDataspecies)]<-0 
      tagCPUE$MaleCount[!(tagCPUE$CommonName %in% input$tagCPUEDataspecies)]<-0
      tagCPUE$FemaleCount[!(tagCPUE$CommonName %in% input$tagCPUEDataspecies)]<-0
      tagCPUE$MortalityCount[!(tagCPUE$CommonName %in% input$tagCPUEDataspecies)]<-0
      tagCPUE$RecoveryCount[!(tagCPUE$CommonName %in% input$tagCPUEDataspecies)]<-0
    }
    tagCPUE <- tagCPUE %>%
      group_by(SetID,
               SetDate,
               SetYear,
               SetMonth,
               SetSeason,
               VesselName,
               ProjectName,
               Latitude,
               Longitude,
               PunchCardArea
) %>%
      summarise(RodHours = mean(RodHours),
                FishCount = sum(FishCount),
                MaleCount = sum(MaleCount),
                FemaleCount = sum(FemaleCount),
                MortalityCount = sum(MortalityCount),
                RecoveryCount = sum(RecoveryCount)
      )
    datatable(tagCPUE,  options = list (scrollX = '100%'))
  })
output$tagccpuePlot <- renderPlot({
  tagCPUE<-read.csv("Tag_vCPUE.csv")
  tagCPUE <- tagCPUE[tagCPUE$SetYear<=max(input$tagCPUEPlotyear) & tagCPUE$SetYear>=min(input$tagCPUEPlotyear),]
  if(!is.null(input$tagCPUEPlotspecies)){
    tagCPUE$FishCount[!(tagCPUE$CommonName %in% input$tagCPUEPlotspecies)]<-0 
    tagCPUE$MaleCount[!(tagCPUE$CommonName %in% input$tagCPUEPlotspecies)]<-0
    tagCPUE$FemaleCount[!(tagCPUE$CommonName %in% input$tagCPUEPlotspecies)]<-0
    tagCPUE$MortalityCount[!(tagCPUE$CommonName %in% input$tagCPUEPlotspecies)]<-0
    tagCPUE$RecoveryCount[!(tagCPUE$CommonName %in% input$tagCPUEPlotspecies)]<-0
  }
  tagCPUE <- tagCPUE %>%
    group_by(SetID,
             SetDate,
             SetYear,
             SetMonth,
             SetSeason,
             VesselName,
             ProjectName,
             Latitude,
             Longitude,
             PunchCardArea
    ) %>%
    summarise(RodHours = mean(RodHours),
              FishCount = sum(FishCount),
              MaleCount = sum(MaleCount),
              FemaleCount = sum(FemaleCount),
              MortalityCount = sum(MortalityCount),
              RecoveryCount = sum(RecoveryCount)
    )
  if(input$cpuePlotFacetType=="PCA"){
    tagCPUE <- tagCPUE %>%
      group_by(SetYear,
               PunchCardArea
      ) %>%
      summarise(RodHours = sum(RodHours),
                FishCount = sum(FishCount),
                MaleCount = sum(MaleCount),
                FemaleCount = sum(FemaleCount),
                MortalityCount = sum(MortalityCount),
                RecoveryCount = sum(RecoveryCount)
      )
  }
  ggplot(data = tagCPUE, aes(x = SetYear, y = FishCount/RodHours)) + geom_bar(stat="identity") + facet_grid(PunchCardArea ~ .) + scale_x_continuous(breaks=tagCPUE$SetYear) + theme(axis.text.x = element_text(angle = 90, hjust = 0, vjust = .5))
  
 
})
output$FTTrendsYearSlider <- renderUI({
  sliderInput("FTTrendsyear", 'Year', width='100%', min = 1970, max = 2015, value= c(2005,2015), sep="", step = 1)
})




}
