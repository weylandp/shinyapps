library(rpivotTable)
library(DT)
library(scales)
library(ggplot2)
library(shiny)
library(data.table)

function(input, output) {
  example1Data<-fread("example1.csv")
  example2Data<-fread("example2.csv")
  example3Data<-fread("example3.csv")
  example4Data<-fread("example4.csv")
  

  output$msppivotplot <- renderRpivotTable({
    example <- switch(input$exampleInput,
                      'Example 2' = example2Data,
                      'Example 3' = example3Data,
                      'Example 4' = example4Data,
                      example1Data)
   
    rpivotTable((example))
  })
  output$mspdatatable <- DT::renderDataTable({
    example <- switch(input$exampleInput,
                      'Example 2' = example2Data,
                      'Example 3' = example3Data,
                      'Example 4' = example4Data,
                      example1Data)
    datatable(example,  options = list (scrollX = '100%'))
    
  })
  output$mspplot <- renderPlot({
    example <- switch(input$exampleInput,
                      'Example 2' = example2Data,
                      'Example 3' = example3Data,
                      'Example 4' = example4Data,
                      example1Data)
    
    ggplot(data = example, aes(x=TaxonomicClass, y = Abundance)) +geom_bar(stat = "identity") + facet_grid(AbundanceType ~ .) + theme(axis.text.x = element_text(angle = 90, hjust = 0, vjust = .5))+ scale_y_continuous(labels = comma)
  
    })
}