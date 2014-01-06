output$distPlot <- renderPlot({
  
  # generate an rnorm distribution and plot it
  dist <- rnorm(input$obs)
  if (!is.null(dist)) {
    dist <- as.data.frame(dist)
    g <- ggplot(dist, aes(x=dist)) + geom_histogram(aes(y=..density..), fill="black", colour="white", ) + 
      xlab("") + ylab("") + ggtitle(input$Title) + geom_rangeframe()
    if (input$density) {
      g <- g + geom_density(colour="steelblue", size=1.25, alpha=0.5)
    }
    print(g)
  }
  
})
