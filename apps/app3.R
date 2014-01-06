output$distPlot1 <- renderPlot({
  
  # generate an rnorm distribution and plot it
  dist <- rnorm(input$obs1)

  if (!is.null(dist)) {
    dist <- as.data.frame(dist)
    g <- ggplot(dist, aes(x=dist)) + geom_histogram(aes(y=..density..), fill="black", colour="white", ) + 
      xlab("") + ylab("") + ggtitle(isolate(input$Title1)) + geom_rangeframe()
    if (input$density1) {
      g <- g + geom_density(colour="steelblue", size=1.25, alpha=0.5)
    }
    print(g)
  }
  
})