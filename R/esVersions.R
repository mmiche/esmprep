# esVersions
#
#
esVersions <- function(esDf, RELEVANTVN_ES=NULL) {

    esDfList <- list()
    svyNames <- unique(esDf[,RELEVANTVN_ES[["ES_SVY_NAME"]]])

    for(i in 1:length(svyNames)) {
        idx_i <- which(esDf[,RELEVANTVN_ES[["ES_SVY_NAME"]]]==svyNames[i])
        esDfList[[svyNames[i]]] <- esDf[idx_i,]
    }
    esDfList
}
