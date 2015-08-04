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

library(foreach)
createTwinPicks <- function(xMatrix){
  nCols <- dim(xMatrix)[2]
  outMat <- matrix(rep(1, 16 * nCols), ncol = nCols)
  foreach(j = 1:nCols, .combine = cbind) %do% {outMat[xMatrix[, j], j] <- 0}
  outMat
}

comparisonPicks <- matrix(rep(1, 16 * (39203 * 2)), nrow = 16)

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

comparisonPicks[, 39204:78406] <- -(comparisonPicks[, 1:39203] - 1)
fanMatrix <- matrix(runif(32000) , nrow = 16)
save.image("straightStart.RData")
