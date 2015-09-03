rm(list = ls())
library(shiny); library(scales)
setwd("~/GitHub/straightsims")
load("app2015wk01.RData")

# Define a server for the Shiny app
shinyServer(function(input, output) { # input <- data.frame(players = 35)
  sizeIndex <- reactive({input$players/5 * 2})

  results <- reactive({playersBest[[sizeIndex()]]})

  outrightPicks <- reactive({results()$outPicks})

  outright <- reactive({
    vec <- weekFile$Victor
    vec[outrightPicks() == 0] <- weekFile$Underdog[outrightPicks() == 0]
    vec
  })

  output$outrightWins <- reactive({results()$outW})

  output$avgOut <- reactive({results()$avgOut})

  output$avgMost <- reactive({results()$avgMost})

  output$outrightPoints <- reactive({results()$outPoints})

  mostPicks <- reactive({results()$mostPicks})

  mostWins <- reactive({
    vec <- weekFile$Victor
    vec[mostPicks() == 0] <- weekFile$Underdog[mostPicks() == 0]
    vec
  })

  output$mostWins <- reactive({results()$mostW})

  output$mostPoints <- reactive({results()$mostPoints})

  output$outright <- renderTable({cbind(Game = weekFile$Game[order(weekFile$Order)], Victor = outright()[order(weekFile$Order)])}, include.rownames=F)
  output$most <- renderTable({cbind(Game = weekFile$Game[order(weekFile$Order)], Victor = mostWins()[order(weekFile$Order)])}, include.rownames=F)

  output$week <- renderTable({data.frame(Game = weekFile$Game, Victor = weekFile$Victor)})
})
