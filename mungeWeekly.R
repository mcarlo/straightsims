rm(list = ls())
setwd("D:/Documents/GitHub/straightsims")

load("2015wk01.RData")

# system.time(compTactics(firstList, 5))
playersBest <- rep(firstList, 20)
system.time(playersBest <- compTactics(firstList, 20))

save(weekFile, playersBest, file = "app2015wk01.RData")

###
rm(list = ls())
load("app2015wk01.RDaata")


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

