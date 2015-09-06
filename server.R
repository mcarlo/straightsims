rm(list = ls())
#setwd("~/GitHub/straightsims")
load("app2015wk01.RData")
library(shiny); library(scales)


# Define a server for the Shiny app
shinyServer(function(input, output) { # input <- data.frame(players = 35)
  sizeIndex <- reactive({input$players/5 * 2})

  results <- reactive({playersBest[[sizeIndex()]]})

  output$most <- renderTable({cbind(Game = weekFile$Game, Pick = results()$mostTeams)}, include.rownames=F)
})
