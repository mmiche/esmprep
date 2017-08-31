# orderByIdAndTime
#
#' @importFrom lubridate ymd_hms
#
#
orderByIdAndTime <- function(esDf, RELEVANTVN_ES = NULL) {

    if(!is.data.frame(esDf)) {
        stop("Argument must be of type data.frame.")
    }

    idxRowOrder <- order(esDf[,"ID"], lubridate::ymd_hms(esDf[,RELEVANTVN_ES[["ES_START_DATETIME"]]]))
    esDfOrd <- esDf[idxRowOrder, ]
    return(esDfOrd)
}
