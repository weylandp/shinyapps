function(input, output) {
  
  
 
  output$tagccpuemapPlot <- renderLeaflet({
    tagCPUE<-read.csv("Tag_vCPUE.csv")
    tagCPUE <- tagCPUE[tagCPUE$SetYear<=max(input$tagCPUEyear) & tagCPUE$SetYear>=min(input$tagCPUEyear),]
    if(!is.null(input$tagCPUEspecies)){
      tagCPUE <- tagCPUE[tagCPUE$CommonName %in% input$tagCPUEspecies,]
    }
    
    cpuePal <- colorBin("RdYlGn", sqrt(tagCPUE$FishCount/tagCPUE$RodHours), n=5)
    
    leaflet(tagCPUE) %>%
      addProviderTiles("Acetate.terrain") %>%
      addCircleMarkers( lng= tagCPUE$Longitude, lat= tagCPUE$Latitude, fillOpacity = .5 , color = ~cpuePal(FishCount/RodHours), radius = 1, popup = paste0("<strong>Date: </strong>",tagCPUE$SetDate, "<br><strong>Fish Count: </strong>", tagCPUE$FishCount, "<br><strong>CPUE: </strong>", tagCPUE$FishCount/tagCPUE$RodHours)) 
    
  })
  
  
}