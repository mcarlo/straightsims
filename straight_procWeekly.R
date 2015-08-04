rm(list = ls())
load("straightStart.Rdata")

weekFile <- read.csv("2014week16.csv")
winprob <- weekFile$WinProbability[order(-weekFile$WinProbability)]
outcomeMatrix <- matrix(runif(32000) < winprob, nrow = 16)
# outcomeMatrix[, 1:10]

comparisonPicksScores <- crossprod(outcomeMatrix, comparisonPicks) + crossprod((1- outcomeMatrix), (1 - comparisonPicks))

fanprob <- weekFile$FanProb[order(-weekFile$WinProbability)]
fanMatrix <- matrix((fanMatrix < fanprob) * 1, nrow = 16)
fanScores <- crossprod(outcomeMatrix, fanMatrix) + crossprod((1- outcomeMatrix), (1 - fanMatrix))

poolsize <- 7
fanScoreSubset <- matrix(rep(0, 2000 * poolsize), nrow = 2000)
sampleFans <- matrix(sample(1:2000, 2000 * poolsize, replace = T), nrow = 2000)
for (i in 1:2000){
  fanScoreSubset[i, ] <- fanScores[i, sampleFans[i, ]]
}

countTies <- function(vec){
  sum(vec == max(vec))
}

comparisonFirst <- comparisonPicksScores > apply(fanScoreSubset, 1, max)
comparisonTiedorFirst <- comparisonPicksScores >= apply(fanScoreSubset, 1, max)

outright <- which(colSums(comparisonFirst) == max(colSums(comparisonFirst)))
mostwins <- which(colSums(comparisonTiedorFirst) == max(colSums(comparisonTiedorFirst)))

# comparisonPicks[, outright]
# comparisonPicks[, mostwins]

colSums(comparisonFirst)[outright] * 1.5 +
  0.5 * (colSums(comparisonTiedorFirst)[outright] -
           colSums(comparisonFirst)[outright])
colSums(comparisonFirst)[mostwins] * 1.5 +
  0.5 * (colSums(comparisonTiedorFirst)[mostwins] -
           colSums(comparisonFirst)[mostwins])

colSums(comparisonTiedorFirst)[mostwins]
colSums(comparisonTiedorFirst)[outright]

colSums(comparisonFirst)[outright]
colSums(comparisonFirst)[mostwins]

comparisonPicks[,outright]
comparisonPicks[,mostwins]


