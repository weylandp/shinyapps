library(dplyr)
function(input, output) {
  
  
 
  output$tagccpuemapPlot <- renderLeaflet({
    tagCPUE<-read.csv("Tag_vCPUE.csv")
    tagCPUE <- tagCPUE[tagCPUE$SetYear<=max(input$tagCPUEyear) & tagCPUE$SetYear>=min(input$tagCPUEyear),]
    if(!is.null(input$tagCPUEspecies)){
      tagCPUE <- tagCPUE[tagCPUE$CommonName %in% input$tagCPUEspecies | tagCPUE$CommonName == "", ,]
    }
    tagCPUE <- tagCPUE %>%
                        group_by(SetID, SetDate, Latitude, Longitude) %>%
                        summarise(RodHours = mean(RodHours),
                                  FishCount = sum(FishCount))
    cpuePal <- colorBin("RdYlGn", sqrt(tagCPUE$FishCount/tagCPUE$RodHours), n=9)
    
    leaflet(tagCPUE) %>%
      addProviderTiles("Acetate.terrain") %>%
      addCircleMarkers( lng= tagCPUE$Longitude, lat= tagCPUE$Latitude, fillOpacity = .5 , color = ~cpuePal(sqrt(FishCount/RodHours)), radius = 1, popup = paste0("<strong>Date: </strong>",tagCPUE$SetDate, "<br><strong>Fish Count: </strong>", tagCPUE$FishCount, "<br><strong>CPUE: </strong>", tagCPUE$FishCount/tagCPUE$RodHours)) %>%
      addLegend(pal = cpuePal, values = (tagCPUE$FishCount/tagCPUE$RodHours))
    
  })
  output$tagCPUEBySpeciesData <- renderDataTable({
    tagCPUE<-read.csv("Tag_vCPUE.csv")
    tagCPUE <- tagCPUE[tagCPUE$SetYear<=max(input$tagCPUEDatayear) & tagCPUE$SetYear>=min(input$tagCPUEDatayear),]
    if(!is.null(input$tagCPUEDataspecies)){
      tagCPUE <- tagCPUE[tagCPUE$CommonName %in% input$tagCPUEDataspecies | tagCPUE$CommonName == "", ,]
    }
    datatable(tagCPUE,  options = list (scrollX = '100%'))
  })
  
}