library(shiny)

# Define the overall UI
shinyUI(fluidPage(
  fluidRow(
     column(4,
           h1("WinThatPool")
           )
#      ,
#      column(5,
#             p("Tactical picks for 2015, Week 1 (Straight picks, no confidence points)")
#      )
    ),
    fluidRow(
      column(4, p(""))
#       ,
#       column(4,
#              sliderInput("players", "   Number of Players in Pool:", min = 5,
#                          max = 100, step = 5, value = 25))
      ),
    # tags$head(includeScript("google-analytics.js")),

    fluidRow(
      column(4,
             h4("Most simulated outright wins"),
             h5("These picks are more aggressive. If you care about season-long points, don't use these.")),
      column(4,
             p("Tactical picks for 2015, Week 1"),
p("Straight picks, (no confidence points)")
      ),
      column(4,
             h4("Most simulated wins and ties"),
             h5("These picks are less aggressive. If you care about season-long points, use these instead."))
             ),
    fluidRow(
      column(4,
             tableOutput(outputId="outright")),
      column(4,
             sliderInput("players", "   Number of Players in Pool:", min = 5,
                         max = 100, step = 5, value = 25)),
      column(4,
             tableOutput(outputId="most"))

    ),
  fluidRow(
    column(3, p("")),
    column(6,
           h2("'Tactical picks' means these are not predictions. They reflect WinThatPool's recommendation for winning a weekly prize based only on this week's outcome. Do not use these picks if you hope to win a season-long prize."),
           p("Notice that as you play with the slider controlling the number of other players in your pool, the higher the number of players, the greater the number of upsets in the winningest picks. Of course the number of players in your pool doesn't affect the outcome of games, but it does affect your chance of amassing the most points."),
           p(""),
           p("WinThatPool simulated pool results equivalent to 100 complete NFL seasons using this week's win probabilities for each game and this week's model of other pool entries.
             The first set listed above won the most times. The second set listed above won or tied the most times."),
           h6("Outright Wins " ,textOutput("outrightWins")),

           h6("Average Wins " ,textOutput("avgOut")),

           h6("Wins or ties " ,textOutput("mostWins")),

           h6("Average Wins or ties " ,textOutput("avgMost"))

    )

  )
    )
)