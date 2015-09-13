rm(list = ls())
library(combinat)

sumChoose <- function(n){
  total <- 0
  for (i in 1:n) {
    total <- total + choose(n, i)
  }
  total
}

genFanCombos <- function(nGames){ #nGames = 13
  nCols <- sumChoose(nGames) + 1

  outMatrix <- matrix(rep(1, nGames * nCols), nrow = nGames) #outMatrix[, 1:13]
  endCol <- 0
  for (i in 1:nGames) { #i = 2
    startCol <- endCol + 1
    endCol <- choose(nGames, i) + startCol - 1
    innerCols <- choose(nGames, i)
    xMat <- matrix(unlist(combn(1:nGames, m = i)), nrow = i)
    plugMatrix <- matrix(rep(1, nGames * innerCols), nrow = nGames)
    for(j in 1:innerCols){
      plugMatrix[xMat[, j], j] <- 0
    }
    outMatrix[, startCol:endCol] <- plugMatrix
  }
  outMatrix
}

genFanMatrix <- function(nGames){
  matrix(runif(nGames * 1700) , nrow = nGames)
}

nGames <- 13
system.time(comparisonPicks13 <- genFanCombos(nGames))
fanMatrix13 <- genFanMatrix(nGames)

nGames <- 14
system.time(comparisonPicks14 <- genFanCombos(nGames))
fanMatrix14 <- genFanMatrix(nGames)

nGames <- 15
system.time(comparisonPicks15 <- genFanCombos(nGames))
fanMatrix15 <- genFanMatrix(nGames)

nGames <- 16
system.time(comparisonPicks16 <- genFanCombos(nGames))
fanMatrix16 <- genFanMatrix(nGames)

save(comparisonPicks13, fanMatrix13, comparisonPicks14, fanMatrix14,
     comparisonPicks15, fanMatrix15, comparisonPicks16, fanMatrix16, 
     file = "straightStartSpecific.RData")
