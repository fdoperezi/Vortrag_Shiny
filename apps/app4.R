output$distPlotIso <- renderPlot({
  
  if (input$plotButton == 0) {
    return 
  } else {
    dist <- rnorm(isolate(input$obsIso))
    
    dist <- as.data.frame(dist)
    g <- ggplot(dist, aes(x=dist)) + geom_histogram(aes(y=..density..), fill="black", colour="white", ) + 
      xlab("") + ylab("") + ggtitle(isolate(input$TitleIso)) + geom_rangeframe()
    if (isolate(input$densityIso)) {
      g <- g + geom_density(colour="steelblue", size=1.25, alpha=0.5)
    }
    print(g)
  }
})