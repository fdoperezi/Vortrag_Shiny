# Reactive expression to compose a data frame containing all of the values
sliderValues <- reactive({
  # Compose data frame
  data.frame(
    Name = c("Integer", 
             "Decimal",
             "Range",
             "selectInput",
             "numericInput",
             "Radio Button"),
    Value = as.character(c(input$integer, 
                           input$decimal,
                           paste(input$range, collapse=' '),
                           input$dataset,
                           input$obsN,
                           input$rb)), 
    stringsAsFactors=FALSE)
}) 

# Show the values using an HTML table
output$values <- renderTable({
  sliderValues()
})