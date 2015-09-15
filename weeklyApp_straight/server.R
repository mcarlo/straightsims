#rm(list = ls())
#setwd("D:/Documents/GitHub/straightsims/weeklyApp_straight") #setwd("~/GitHub/straightsims")
load("app2015wk02.RData")
library(shiny); library(scales)
require(googleVis)

# Define a server for the Shiny app
shinyServer(function(input, output) { # input <- data.frame(players = 35)
  sizeIndex <- reactive({input$players/5 * 2})

  results <- reactive({playersBest[[sizeIndex()]]})

  # most <- renderTable({cbind(Game = weekFile$Game, Pick = results()$mostTeams)}, include.rownames=F)

  output$mostWins <- renderGvis({
    most <- as.data.frame(cbind(Game = weekFile$Game, Pick = results()$mostTeams))
    most.W <- gvisTable(most, #include.rownames=F,
                      options=list(page='enable', #height=500, width = 300,
                                   showRowNumber = F, pageSize = 16,
                                   cssClassNames = "{headerRow: 'myTableHeadrow',
                                   tableRow: 'myTablerow'}",
                                   alternatingRowStyle = TRUE, page = 'disable'),
                      chartid = "mytable")
    most.W
  })
#     tbl2 <- gvisTable(most(), options=list(page='enable', height=300, cssClassNames = "{headerRow: 'myTableHeadrow', tableRow: 'myTablerow'}", alternatingRowStyle = FALSE), chartid = "mytable")
#     tbl2
#     })
#   output$weekFile <- renderGvis({
#     tbl2 <- gvisTable(weekFile, options=list(page='enable', height=300, cssClassNames = "{headerRow: 'myTableHeadrow', tableRow: 'myTablerow'}", alternatingRowStyle = FALSE), chartid = "mytable")
#     tbl2
  # })
})
