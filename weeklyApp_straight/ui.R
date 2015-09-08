library(shiny)
library(googleVis)

# Define the overall UI
shinyUI(fluidPage(
  includeCSS("styles.css"),
  fluidRow(
    column(3, p("")),
    column(9,
           h3("Tactical picks for 2015"), #style = "color: #06018f;"),
           h6("Appropriate for straight-up pick'em pools with a weekly payout"),
           sliderInput("players", "   Number of Players in Pool:", min = 5,
                       max = 100, step = 5, value = 35),
            h4("Winningest Picks, Week 1"),
            htmlOutput(outputId="mostWins")
           ,
                        tags$head(tags$style(type="text/css", 
                                             ".myTableHeadrow {color:#FFFFFF; background-color:#FF0000;} 
                                             .myTablerow {background-color:#D9D9D9;}"))
            )
    ),
  fluidRow(column(3, p("")),

           column(9, "Updated 9/8/16 4:30p PDT")),
    tags$head(includeScript("google-analytics.js"))
)

)