# rmInvalidLines
#
#' @importFrom lubridate ymd_hms
#
#
rmInvalidLines <- function(df, RELEVANTVN_ES = NULL) {

    # Start date/start time is assumed to be generally missing when a technical error occurs.
    idxNA <- which(is.na(lubridate::ymd_hms(df[,RELEVANTVN_ES[["ES_START_DATETIME"]]])))
    if(length(idxNA) > 0) {
        dfNew <- df[-idxNA,]
        list(dfNew=dfNew, removedLines=df[idxNA,])
    } else {
        list(dfNew=df, removedLines=NA)
    }
}
