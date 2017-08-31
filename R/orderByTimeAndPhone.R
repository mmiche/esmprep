# orderByTimeAndPhone
#
#' @importFrom lubridate ymd_hms
#
#
orderByTimeAndPhone <- function(esDf, RELEVANTVN_ES = NULL) {

    if(!is.data.frame(esDf)) {
        stop("Argument must be of type data.frame.")
    }

    # Extract columns that are relevent to register persons
    esDf[,RELEVANTVN_ES[["ES_SVY_NAME"]]] <- as.character(esDf[,RELEVANTVN_ES[["ES_SVY_NAME"]]])
    esDf[,RELEVANTVN_ES[["ES_IMEI"]]] <- format(esDf[,RELEVANTVN_ES[["ES_IMEI"]]], digits = 16)

    idxRowOrder <- order(lubridate::ymd_hms(esDf[,RELEVANTVN_ES[["ES_START_DATETIME"]]]), esDf[,RELEVANTVN_ES[["ES_IMEI"]]])

    esDfOrd <- esDf[idxRowOrder, ]
    return(esDfOrd)
}
