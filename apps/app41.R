fib <- function(n) ifelse(n<3, 1, fib(n-1)+fib(n-2))
output$nthValue    <- renderText({ fib(input$n) })
output$nthValueInv <- renderText({ 1 / fib(input$n) })