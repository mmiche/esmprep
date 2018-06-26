# findMin2
#
#' @importFrom lubridate ymd_hms as.duration days
#
#
findMin2 <- function(esTimesDf, RELEVANTVN_ES=NULL, RELEVANTINFO_ES=NULL) {
    # The following uses each ES questionnaire which has been started by a person:
    # Per person: Return the index for the scheduled time. Use the scheduled time which
    # is closest in seconds between actual ES start_time and each of the scheduled times.
	
    if(!is.data.frame(esTimesDf)) {
        stop("Argument must be of type data.frame.")
    }

    PROMPT <- c()		# '1': actual start time vs any of the 6 scheduled start times
    absStart1 <- c()	# Absolute actual minimum time difference in seconds.

    PROMPTEND <- c()		# '1': actual end time vs any of the 6 scheduled start times
    absEnd1 <- c()		# Absolute actual minimum time difference in seconds.

    # lag_ba0: dichotomous variable denoting whether actual start_time is before or
    # after the scheduled time. Digit 0 because after shifting, the variable 'lag_ba'
    # will have to be computed all over again.
    lag_ba0 <- c()		# '0': actual start time prior to scheduled time. '1': afterwards.
    
    # The date that had the least time difference to the actual start time.
    midnightDate <- c()

    # ADAPT to number of daily ES questionnaires
    # -------------------------------------------
    stTimes <- paste0("stTime", 1:RELEVANTINFO_ES[["MAXPROMPT"]])
	
    for (j in 1 : nrow(esTimesDf)) {
		
        start_j1 <- lubridate::as.duration(lubridate::ymd_hms(esTimesDf[j,RELEVANTVN_ES[["ES_START_DATETIME"]]]) - lubridate::ymd_hms(unlist(esTimesDf[j, stTimes])))
        absStart_j1 <- abs(start_j1)
        absStart_jSec1 <- as.numeric(absStart_j1)
        # Minimum time difference across all 6 scheduled times (AST: all scheduled times)
        minAST1 <- min(absStart_jSec1)
        # Note the overall minimum time difference between actual start time and all
        # scheduled times of the ES day (and the respective person)
        # # Very unlikely case: Actual start time is exactly (level: seconds) between
        # # 2 scheduled times. In such a case always choose the first of the 2
        # # scheduled times.
        minStart1 <- which(minAST1 == absStart_jSec1)[1]
        
        start_j2 <- lubridate::as.duration(lubridate::ymd_hms(esTimesDf[j,RELEVANTVN_ES[["ES_START_DATETIME"]]]) - (lubridate::ymd_hms(unlist(esTimesDf[j, stTimes])) - lubridate::days(1)))
        absStart_j2 <- abs(start_j2)
        absStart_jSec2 <- as.numeric(absStart_j2)
        # Minimum time difference across all 6 scheduled times (AST: all scheduled times)
        minAST2 <- min(absStart_jSec2)
        # Note the overall minimum time difference between actual start time and all
        # scheduled times of the ES day (and the respective person)
        # # Very unlikely case: Actual start time is exactly (level: seconds) between
        # # 2 scheduled times. In such a case always choose the first of the 2
        # # scheduled times.
        minStart2 <- which(minAST2 == absStart_jSec2)[1]
        
        start_j3 <- lubridate::as.duration(lubridate::ymd_hms(esTimesDf[j,RELEVANTVN_ES[["ES_START_DATETIME"]]]) - (lubridate::ymd_hms(unlist(esTimesDf[j, stTimes])) + lubridate::days(1)))
        absStart_j3 <- abs(start_j3)
        absStart_jSec3 <- as.numeric(absStart_j3)
        # Minimum time difference across all 6 scheduled times (AST: all scheduled times)
        minAST3 <- min(absStart_jSec3)
        # Note the overall minimum time difference between actual start time and all
        # scheduled times of the ES day (and the respective person)
        # # Very unlikely case: Actual start time is exactly (level: seconds) between
        # # 2 scheduled times. In such a case always choose the first of the 2
        # # scheduled times.
        minStart3 <- which(minAST3 == absStart_jSec3)[1]
        
        minAST <- which(c(minAST1, minAST2, minAST3) == min(c(minAST1, minAST2, minAST3)))
        
        	if(minAST == 1) {
        		# Scheduled start date and actual start date on the same day.
        		midnightDate <- c(midnightDate, 0)
	        # Append the index of the scheduled time (one out of indices 1-MAXPROMPT)
	        PROMPT <- c(PROMPT, minStart1)
	        absStart1 <- c(absStart1, as.numeric(absStart_jSec1[minStart1]))
	        start_j <- start_j1; minStart <- minStart1
        } else if(minAST == 2) {
        		# Scheduled start date prior to actual start date.
        	midnightDate <- c(midnightDate, -1)
	        # Append the index of the scheduled time (one out of indices 1-MAXPROMPT)
	        PROMPT <- c(PROMPT, minStart2)
	        absStart1 <- c(absStart1, as.numeric(absStart_jSec2[minStart2]))
	        start_j <- start_j2; minStart <- minStart2
        } else if(minAST == 3) {
        		# Scheduled start date subsequent to actual start date.
        	midnightDate <- c(midnightDate, 1)
        		# Append the index of the scheduled time (one out of indices 1-MAXPROMPT)
	        PROMPT <- c(PROMPT, minStart3)
	        absStart1 <- c(absStart1, as.numeric(absStart_jSec3[minStart3]))
	        start_j <- start_j3; minStart <- minStart3
        } else {
        		warning("Function findMin2 (not visible to the user) within function esAssign failed. Please report bug to the maintainer of the esmprep package (esmprep-at-gmail.com).")
        }

        # Intact date-time object consist of 19 characters: 'yyyy-mm-dd hh:mm:ss'.
        # If it is less than that the date-time object is defect.
        if (is.na(nchar(as.character(esTimesDf[j, RELEVANTVN_ES[["ES_END_DATETIME"]]]))) |
            nchar(as.character(esTimesDf[j, RELEVANTVN_ES[["ES_END_DATETIME"]]])) < 19) {

            PROMPTEND <- c(PROMPTEND, NA)
            absEnd1 <- c(absEnd1, NA)

        } else {
        		
	        if(minAST == 1) {
		        absEnd_i <- abs(lubridate::ymd_hms(esTimesDf[j, RELEVANTVN_ES[["ES_END_DATETIME"]]]) - lubridate::ymd_hms(unlist(esTimesDf[j, stTimes]) ))
	        } else if(minAST == 2) {
		        absEnd_i <- abs(lubridate::ymd_hms(esTimesDf[j, RELEVANTVN_ES[["ES_END_DATETIME"]]]) - (lubridate::ymd_hms(unlist(esTimesDf[j, stTimes])) - lubridate::days(1)) )
	        } else if(minAST == 3) {
	        	absEnd_i <- abs(lubridate::ymd_hms(esTimesDf[j, RELEVANTVN_ES[["ES_END_DATETIME"]]]) - (lubridate::ymd_hms(unlist(esTimesDf[j, stTimes])) + lubridate::days(1)) )
	        }
			
            absEnd_iSec <- as.numeric(lubridate::as.duration(absEnd_i))
            minEnd <- min(absEnd_iSec)

            minEnd1 <- which(minEnd == absEnd_iSec)[1]
            PROMPTEND <- c(PROMPTEND, minEnd1)
            absEnd1 <- c(absEnd1, as.numeric(absEnd_iSec[minEnd1]))
        }

        lag_ba0 <- c(lag_ba0, ifelse(as.numeric(start_j)[minStart] < 0, 0, 1))
    }
    return (data.frame(PROMPT, PROMPTEND, absStart1, absEnd1, lag_ba0, midnightDate))
}
