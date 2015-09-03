rm(list = ls())
library(shiny); library(scales)
setwd("D:/Documents/GitHub/wtpP")
load("app2015wk01.RData")

# Define a server for the Shiny app
shinyServer(function(input, output) { # input <- data.frame(players = 20)
  sizeIndex <- reactive({input$players/5 * 2})
  
  results <- reactive({playersBest[[sizeIndex()]]})
  
  outrightPicks <- reactive({results()$outPicks})
  
  outright <- reactive({
    vec <- weekFile$Victor
    vec[outrightPicks() == 0] <- weekFile$Underdog[outrightPicks() == 0]
    vec
  })
  
  output$outrightWins <- reactive({results()$outW})
                                  
  output$outrightPoints <- reactive({results()$outPoints})

  mostPicks <- reactive({results()$mostPicks})
  
  mostWins <- reactive({
    vec <- weekFile$Victor
    vec[mostPicks() == 0] <- weekFile$Underdog[mostPicks() == 0]
    vec
  })
  
  output$mostWins <- reactive({results()$mostW})
  
  output$mostPoints <- reactive({results()$mostPoints})
  
  output$outright <- renderTable({cbind(Game = weekFile$Game[order(weekFile$order)], Victor = outright()[order(weekFile$order)])}, include.rownames=F)
  output$most <- renderTable({cbind(Game = weekFile$Game[order(weekFile$order)], Victor = mostWins()[order(weekFile$order)])}, include.rownames=F)
  
  output$week <- renderTable({data.frame(Game = weekFile$Game, Victor = weekFile$Victor)})
})
