# checkKey2
#
#
checkKey2 <- function(dfList) {
    sapply(dfList, function(x) match("KEY", names(x)))
}
