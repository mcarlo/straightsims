rm(list = ls())
library(combinat)
testM <- 1
x1 <- matrix(unlist(combn(1:16, m = testM)), nrow = testM) # 16

testM <- 2
x2 <- matrix(unlist(combn(1:16, m = testM)), nrow = testM) # 120

testM <- 3
x3 <- matrix(unlist(combn(1:16, m = testM)), nrow = testM) # 560

testM <- 4
x4 <- matrix(unlist(combn(1:16, m = testM)), nrow = testM) # 1820

# 1 + 16 + 120 + 560 + 1820 = 2517

testM <- 5
x5 <- matrix(unlist(combn(1:16, m = testM)), nrow = testM) # 4368

testM <- 6
x6 <- matrix(unlist(combn(1:16, m = testM)), nrow = testM) # 8008

testM <- 7
x7 <- matrix(unlist(combn(1:16, m = testM)), nrow = testM) # 11440

testM <- 8
x8 <- matrix(unlist(combn(1:16, m = testM)), nrow = testM) # 12870

testM <- 9
x9 <- matrix(unlist(combn(1:16, m = testM)), nrow = testM) # 16

testM <- 10
x10 <- matrix(unlist(combn(1:16, m = testM)), nrow = testM) # 800

testM <- 11
x11 <- matrix(unlist(combn(1:16, m = testM)), nrow = testM) # 560

testM <- 12
x12 <- matrix(unlist(combn(1:16, m = testM)), nrow = testM) # 1820

# 1 + 16 + 120 + 560 + 1820 = 2517

testM <- 13
x13 <- matrix(unlist(combn(1:16, m = testM)), nrow = testM) # 4368

testM <- 14
x14 <- matrix(unlist(combn(1:16, m = testM)), nrow = testM) # 8008

testM <- 15
x15 <- matrix(unlist(combn(1:16, m = testM)), nrow = testM) # 11440

testM <- 16
x16 <- matrix(unlist(combn(1:16, m = testM)), nrow = testM) # 12870

library(foreach)
createTwinPicks <- function(xMatrix){
  nCols <- dim(xMatrix)[2]
  outMat <- matrix(rep(1, 16 * nCols), ncol = nCols)
  foreach(j = 1:nCols, .combine = cbind) %do% {outMat[xMatrix[, j], j] <- 0}
  outMat
}

countTies <- function(vec){
  sum(vec == max(vec))
}

nCols <- dim(x1)[2] + dim(x2)[2] + dim(x3)[2] + dim(x4)[2] + dim(x5)[2] + dim(x6)[2] + 
  dim(x7)[2] + dim(x8)[2] + dim(x9)[2] + dim(x10)[2] + dim(x11)[2] + dim(x12)[2] + 
  dim(x13)[2] + dim(x14)[2] + dim(x15)[2] + dim(x16)[2]

comparisonPicks <- matrix(rep(1, 16 * (65536)), nrow = 16)

populateTwinPicks <- function(xMatrix){ #xMatrix <- x8
  nCols <- dim(xMatrix)[2]
  chooseN <- dim(xMatrix)[1]
  if(chooseN > 1) {
    startCol <- 2 + foreach(n = 1:(chooseN - 1), .combine = '+') %do% {choose(16, n)}
  } else {
    startCol <- 2
  }
  endCol <- startCol + choose(16, chooseN) - 1
  plugMatrix <- matrix(rep(1, 16 * nCols), nrow = 16)
  for(j in 1:nCols){
    plugMatrix[xMatrix[, j], j] <- 0
  }
  comparisonPicks[, startCol:endCol] <<- plugMatrix
}

populateTwinPicks(x1)
populateTwinPicks(x2)
populateTwinPicks(x3)
populateTwinPicks(x4)

populateTwinPicks(x5)
populateTwinPicks(x6)
populateTwinPicks(x7)
populateTwinPicks(x8)

populateTwinPicks(x9)
populateTwinPicks(x10)
populateTwinPicks(x11)
populateTwinPicks(x12)

populateTwinPicks(x13)
populateTwinPicks(x14)
populateTwinPicks(x15)
populateTwinPicks(x16)

fanMatrix <- matrix(runif(16 * 1700) , nrow = 16)
lsList = ls()

rm(list = lsList[-c(1, 4)])

save.image("straightStart.RData")
