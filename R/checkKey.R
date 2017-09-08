# checkKey
#
#
checkKey <- function(dfList) {
    sapply(dfList, function(x) names(x)[1]=="KEY" & all(is.numeric(x[,1])))
}

