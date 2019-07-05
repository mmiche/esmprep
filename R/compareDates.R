# compareDates
#
#' @importFrom lubridate ymd_hms
#
#
compareDates <- function(esDf, refDf, assignAll = FALSE, singlePerson = NA, RELEVANTVN_ES = NULL, RELEVANTVN_REF = NULL) {

    # Check whether maximum scheduled end-datetime is included in the raw ES dataset
    # -------------------------------------------------------------------------------
    if(assignAll==TRUE) {
        maxRawES <- max(lubridate::ymd_hms(paste(esDf[,RELEVANTVN_ES[["ES_START_DATE"]]], esDf[,RELEVANTVN_ES[["ES_START_TIME"]]])))
        maxrefDf <- max(lubridate::ymd_hms(paste(refDf[,RELEVANTVN_REF[["REF_END_DATE"]]], refDf[,RELEVANTVN_REF[["REF_END_TIME"]]])))
    } else {
        # compareDates for selected person i
        cd_i <- which(refDf[,RELEVANTVN_REF[["REF_ID"]]] == singlePerson)
        maxRawES <- max(lubridate::ymd_hms(paste(esDf[,RELEVANTVN_ES[["ES_START_DATE"]]], esDf[,RELEVANTVN_ES[["ES_START_TIME"]]])))
        maxrefDf <- max(lubridate::ymd_hms(paste(refDf[,RELEVANTVN_REF[["REF_END_DATE"]]], refDf[,RELEVANTVN_REF[["REF_END_TIME"]]]))[cd_i])
    }
	
	if(as.Date(maxrefDf) == as.Date(maxRawES)) {
		return("DatesEqual")
		# return(as.Date(maxrefDf) == as.Date(maxRawES))
		
	} else if(as.Date(maxrefDf) > as.Date(maxRawES)) {
		return("refDateGreater")
		# return(as.Date(maxrefDf) > as.Date(maxRawES))
		
	} else if(as.Date(maxrefDf) < as.Date(maxRawES)) {
		return("refDateLess")
		# return(as.Date(maxrefDf) < as.Date(maxRawES))
	
	} else {	
		
		stop("Subfunction 'compareDates' within function 'esAssign' needs input of type date-time, which it didn't receive. Something went wrong.")
	}
}
