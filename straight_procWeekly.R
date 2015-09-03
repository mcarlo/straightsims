rm(list = ls())
load("straightStart.Rdata")

weekFileOrig <- read.csv("2015week01straight.csv", stringsAsFactors = F)
#weekFileOrig <- cbind(order = 1:16, weekFileOrig)
weekFile <- weekFileOrig[order(-weekFileOrig$WinProbability), ]
winprob <- weekFile$WinProbability[order(-weekFile$WinProbability)]
outcomeMatrix <- matrix(runif(16 * 1700) < winprob, nrow = 16)
# outcomeMatrix[, 1:10]

comparisonPicksScores <- crossprod(outcomeMatrix, comparisonPicks) + crossprod((1- outcomeMatrix), (1 - comparisonPicks))

fanprob <- weekFile$FanProb[order(-weekFile$WinProbability)]
fanMatrix <- matrix((fanMatrix < fanprob) * 1, nrow = 16)
fanScores <- crossprod(outcomeMatrix, fanMatrix) + crossprod((1- outcomeMatrix), (1 - fanMatrix))
fanSubset <- matrix(rep(0, 1700 * 250), nrow = 1700)
sampleFans <- matrix(sample(1:1700, 1700 * 250, replace = T), nrow = 1700)

for (i in 1:1700){
  fanSubset[i, ] <- fanScores[i, sampleFans[i, ]]
}
rm(fanScores)


save.image("2015wk01.RData")
###
rm(list = ls())

load("2015wk01.RData")

# suppressMessages(library(foreach))
# suppressMessages(suppressWarnings(library(data.table)))
poolsize <- seq(5, 50, by = 5)
outright <- rep(1, 10)
mostwins <- rep(1, 10)

calcTactics <- function(size){#size=20
  fanScoreSubset <- fanSubset[, 1:size]

  comparisonFirst <- comparisonPicksScores > apply(fanScoreSubset, 1, max)
  comparisonTiedorFirst <- comparisonPicksScores >= apply(fanScoreSubset, 1, max)

  fansFirst <- 1 * (fanScoreSubset == apply(fanScoreSubset, 1, max))
  fansTiedorFirstCount <- rowSums(fansFirst)
  fansTiedorFirstAvg <- mean(fansTiedorFirstCount)/size*17
  fansFirstCount <- rep(0, 1700)
  fansFirstCount[fansTiedorFirstCount == 1] <- 1
  fansFirstAvg <- mean(fansFirstCount)/size*17

  outright <- which(colSums(comparisonFirst) == max(colSums(comparisonFirst)))
  lenOut <- length(outright)
  outPoints <- t(comparisonPicks[, outright]) %*% weekFile$WinProbability +
    t((1 - comparisonPicks[, outright])) %*% (1 - weekFile$WinProbability)
  if (length(outright) > 1){
    maxOut <- outPoints[which(outPoints == max(outPoints))[1]]
    outright <- outright[which(outPoints == maxOut)[1]]
    outPoints <- maxOut
  }

  mostwins <- which(colSums(comparisonTiedorFirst/fansTiedorFirstCount) == max(colSums(comparisonTiedorFirst/fansTiedorFirstCount)))
  lenMost <- length(mostwins)
  mostPoints <- t(comparisonPicks[, mostwins]) %*% weekFile$WinProbability +
    t((1 - comparisonPicks[, mostwins])) %*% (1 - weekFile$WinProbability)
  if (length(mostwins) > 1){
    maxMost <- mostPoints[which(mostPoints == max(mostPoints))[1]]
    mostwins <- mostwins[which(mostPoints == maxMost)[1]]
    mostPoints <- maxMost
  }


  data <- list(outright, mostwins, outPoints = outPoints, mostPoints = mostPoints, numOutright = lenOut, numWins = lenMost, outPicks = comparisonPicks[, outright], mostPicks = comparisonPicks[, mostwins], outW = colSums(comparisonFirst)[outright]/100, mostW = colSums(comparisonTiedorFirst)[mostwins]/100, avgOut = fansFirstAvg, avgMost = fansTiedorFirstAvg)
  data
}

popList <- function(size){list(size, calcTactics(size))}

system.time(firstList <- popList(20))
playersBest <- rep(firstList, 20)

# suppressMessages(suppressWarnings(library(data.table)))

fanSizes <- seq(5, 100, by = 5)

compTactics <- function(){
  for(i in 2:20)  {#i = 2

    size <- fanSizes[i]
    genList <- popList(size)
    playersBest[[2*(i - 1) + 1]] <<- genList[[1]]
    playersBest[[2*i]] <<- genList[[2]]

  }
}

system.time(compTactics())


###
# rm(list = ls())
# setwd("D:/Documents/GitHub/wtpP")
# load("app2015wk01.RData")


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

save(weekFile, weekFileOrig, playersBest, file = "app2015wk01.RData")
