rm(list = ls())
#setwd("D:/Documents/GitHub/straightsims")
load("straightStartSpecific.Rdata")

weekFile <- read.csv("~/WEEK02_2015.csv", stringsAsFactors = F) #read.csv("D:/WTP/WEEK01_2015.csv", stringsAsFactors = F)
weekFile <- weekFile[order(weekFile$YahooOrder), ]
winprob <- weekFile$WinProbability

nGames <- length(winprob)

set.seed(nGames)
outcomeMatrix <- matrix(runif(nGames * 1700) < winprob, ncol = 1700)
# outcomeMatrix[, 1:10]

comparisonPicks <- comparisonPicks16
fanMatrix <- fanMatrix16
if (nGames == 14) {
  comparisonPicks <- comparisonPicks14
  fanMatrix <- fanMatrix14
} else if (nGames == 13) {
  comparisonPicks <- comparisonPicks13
  fanMatrix <- fanMatrix13
} else if (nGames == 15) {
  comparisonPicks <- comparisonPicks15
  fanMatrix <- fanMatrix15
}
rm(comparisonPicks13, comparisonPicks14, comparisonPicks15, comparisonPicks16,
   fanMatrix13, fanMatrix14, fanMatrix15, fanMatrix16)

comparisonPicksScores <- crossprod(outcomeMatrix, comparisonPicks) + crossprod((1- outcomeMatrix), (1 - comparisonPicks))

fanprob <- weekFile$StraightFans
fanMatrix <- matrix((fanMatrix < fanprob) * 1, nrow = nGames)
fanScores <- crossprod(outcomeMatrix, fanMatrix) + crossprod((1- outcomeMatrix), (1 - fanMatrix))
fanSubset <- matrix(rep(0, 1700 * 250), nrow = 1700)
sampleFans <- matrix(sample(1:1700, 1700 * 250, replace = T), nrow = 1700)

for (i in 1:1700){
  fanSubset[i, ] <- fanScores[i, sampleFans[i, ]]
}
rm(fanScores)
calcTactics <- function(size){#size=40
  fanScoreSubset <- fanSubset[, 1:size]

  comparisonFirst <- comparisonPicksScores > apply(fanScoreSubset, 1, max)
  comparisonTiedorFirst <- comparisonPicksScores >= apply(fanScoreSubset, 1, max)

  fansFirst <- 1 * (fanScoreSubset == apply(fanScoreSubset, 1, max))
  fansTiedorFirstCount <- rowSums(fansFirst)
  fansTiedorFirstAvg <- sum(fansTiedorFirstCount)/(100 * size)
  fansFirstCount <- rep(0, 1700)
  fansFirstCount[fansTiedorFirstCount == 1] <- 1
  fansFirstAvg <- sum(fansFirstCount)/(100 * size)

  outright <- which(colSums(comparisonFirst) == max(colSums(comparisonFirst)))
  lenOut <- length(outright)
  outPoints <- t(comparisonPicks[, outright]) %*% weekFile$WinProbability +
    t((1 - comparisonPicks[, outright])) %*% (1 - weekFile$WinProbability)
  if (length(outright) > 1){
    maxOut <- outPoints[which(outPoints == max(outPoints))[1]]
    outright <- outright[which(outPoints == maxOut)[1]]
    outPoints <- maxOut
  }
  outPicksPoints <- sum(comparisonFirst[, outright]/fansTiedorFirstCount)
  outPicks = comparisonPicks[, outright]
  outTeams = weekFile$Victor
  outTeams[outPicks == 0] <- weekFile$Underdog[outPicks==0]

  mostwins <- which(colSums(comparisonTiedorFirst/fansTiedorFirstCount) == max(colSums(comparisonTiedorFirst/fansTiedorFirstCount)))
  lenMost <- length(mostwins)
  mostPoints <- t(comparisonPicks[, mostwins]) %*% weekFile$WinProbability +
    t((1 - comparisonPicks[, mostwins])) %*% (1 - weekFile$WinProbability)
  if (length(mostwins) > 1){
    maxMost <- mostPoints[which(mostPoints == max(mostPoints))[1]]
    mostwins <- mostwins[which(mostPoints == maxMost)[1]]
    mostPoints <- maxMost
  }
  mostPicksPoints <- sum(comparisonTiedorFirst[, mostwins]/fansTiedorFirstCount)
  mostPicks = comparisonPicks[, mostwins]
  mostTeams = weekFile$Victor
  mostTeams[mostPicks == 0] <- weekFile$Underdog[mostPicks==0]


  data <- list(outright, mostwins, outPoints = outPoints, mostPoints = mostPoints, numOutright = lenOut, numWins = lenMost, outPicks = outPicks, mostPicks = mostPicks, outW = colSums(comparisonFirst)[outright]/100, mostW = colSums(comparisonTiedorFirst)[mostwins]/100, outTeams = outTeams, mostTeams = mostTeams, avgOut = fansFirstAvg, avgMost = fansTiedorFirstAvg, outPicksPoints = outPicksPoints, mostPicksPoints = mostPicksPoints)
  data
}

popList <- function(size){list(size, calcTactics(size))}
system.time(firstList <- popList(25))

compTactics <- function(inputList, reps){
  fanSizes <- seq(5, 5 * reps, by = 5)
  outputList <- rep(inputList, reps)
  for(i in 1:reps)  {#i = 2

    size <- fanSizes[i]
    genList <- popList(size)
    outputList[[2*(i - 1) + 1]] <- genList[[1]]
    outputList[[2*i]] <- genList[[2]]

  }
  outputList
}

save(weekFile, firstList, compTactics, popList, calcTactics, fanSubset, comparisonPicks, comparisonPicksScores, file = "2015wk02.RData")
###
# rm(list = ls())
# setwd("D:/Documents/GitHub/straightsims")
#
# load("2015wk02.RData")

# system.time(compTactics(firstList, 5))
maxReps <- 20
playersBest <- rep(firstList, maxReps)

system.time(playersBest <- compTactics(firstList, maxReps))

# setwd("weeklyApp_straight")

save(weekFile, playersBest, file = "weeklyApp_straight/app2015wk02.RData")

###


# for (i in 1:19){#i = 4
#   thisList <- playersBest[[2*i]]
#   nextList <- playersBest[[2*i + 2]]
#   if(is.null(try(dim(thisList$outPicks)[2]))) {next}
#
#   thisMatch <- match(data.frame(thisList$outPicks), data.frame(nextList$outPicks))
#   numMatchesThis <- sum(1 * !is.na(thisMatch))
#   if (numMatchesThis == 0){
#     thisList$outPicks <- thisList$outPicks[, 1]
#     next
#   } else {
#     nextMatch <- thisMatch[!is.na(thisMatch)]
#     thisList$outPicks <- thisList$outPicks[, which(!is.na(thisMatch))[1]]
#     nextList$outPicks <- thisList$outPicks
#   }
#   playersBest[[2 * i]] <- thisList
#   playersBest[[2 * i + 2]] <- nextList
#
#   print(i)
#   print(thisList$outPicks)
#   print(nextList$outPicks)
#   print(thisMatch)
#   print(nextMatch)
# }


# for (i in 1:19){#i = 4
#   thisList <- playersBest[[2*i]]
#   nextList <- playersBest[[2*i + 2]]
# if(is.null(try(dim(thisList$mostPicks)[2]))) {next}
#
#   thisMatch <- match(data.frame(thisList$mostPicks), data.frame(nextList$mostPicks))
#   numMatchesThis <- sum(1 * !is.na(thisMatch))
#   if (numMatchesThis == 0){
#     thisList$mostPicks <- thisList$mostPicks[, 1]
#     next
#   } else {
#     nextMatch <- thisMatch[!is.na(thisMatch)]
#     thisList$mostPicks <- thisList$mostPicks[, which(!is.na(thisMatch))[1]]
#     nextList$mostPicks <- thisList$mostPicks
#   }
#   playersBest[[2 * i]] <- thisList
#   playersBest[[2 * i + 2]] <- nextList
#
#   print(i)
#   print(thisList$mostPicks)
#   print(nextList$mostPicks)
#   print(thisMatch)
#   print(nextMatch)
# }

