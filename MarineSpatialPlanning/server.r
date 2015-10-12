library(rpivotTable)
library(DT)
library(scales)
library(ggplot2)
library(shiny)
library(data.table)

function(input, output) {
  example2Data<-fread("HotExample2.csv")
  

  output$msppivotplot <- renderRpivotTable({
    example <- switch(input$exampleInput,
                      'Hot Example' = example2Data
                      )
    rpivotTable(data=example, rows=c("TaxonomicClass","Occurrencename"), cols="Abundance")
   
    
  })
  output$mspplot <- renderPlot({
    example <- switch(input$exampleInput,
                      'Hot Example' = example2Data
                      )
    
    ggplot(data = example, aes(x=TaxonomicClass)) +geom_bar()  + theme(axis.text.x = element_text(angle = 90, hjust = 0, vjust = .5))+ scale_y_continuous(labels = comma) +ggtitle("Taxonomic Frequency") + labs(y="Count", x="Taxonomic Class")
  
    })
}