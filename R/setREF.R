#' setREF
#
#' @description setREF sets the relevant variable names concerning the reference dataset.
#
#' @param MAXPROMPT a numeric value. The number of prompts per day.
#
#' @param REFVN a list. Each element of the list must specify one of the relevant column names of the reference dataset; i.e. the identification number (e.g. ID), the IMEI number, the character substring that all columns have in common which specify the prompt time, the start date, the start time, the end date, and the end time. Use function \code{\link{relevantREFVN}} to generate \code{REFVN}.
#
#' @details The list is named "RELEVANTVN_REF". It contains either 5 or 7 elements, depending on whether the start date and the start time already exist as a date-time object (same for end date and end time). In the latter case the list elements' names are:
#' \enumerate{
#' \item REF_ID: the column name in the reference dataset holding the name of the unique participant identification code.
#' \item REF_IMEI: the column name in the reference dataset holding the IMEI number.
#' \item REF_ST: the column name in the reference dataset holding the scheduled times (st)/prompts, except for the numeric end of the column name.
#' \item REF_START_DATETIME: the date-time object of when the very first ESM questionnaire was scheduled/prompted.
#' \item REF_END_DATETIME: the date-time object of when the very last ESM questionnaire was scheduled/prompted.
#' }
#' If the start date and start time (same for end date and end time) are separated, the list elements will be
#' \enumerate{
#' \item REF_ID: the column name in the reference dataset holding the name of the unique participant identification code.
#' \item REF_IMEI: the column name in the reference dataset holding the IMEI number.
#' \item REF_ST: the column name in the reference dataset holding the scheduled times (st)/prompts, except for the numeric end of the column name.
#' \item REF_START_DATE: the date of when the very first ESM questionnaire was scheduled/prompted.
#' \item REF_START_TIME: the time of when the very first ESM questionnaire was scheduled/prompted.
#' \item REF_END_DATE the date of when the very last ESM questionnaire was scheduled/prompted.
#' \item REF_END_TIME the time of when the very last ESM questionnaire was scheduled/prompted.
#' }
#' The last element of the output list will always be "REF_DATETIMES_SEP": TRUE if date and time are separated, FALSE if they are a single date-time object.
#
#' @return A list. Each element of the list is named according to the variable's content. See \strong{Details} for more information.
#
#' @examples
#' # o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o
#' # Prerequisites in order to execute setREF. Start  ------------------
#' relRef <- relevantREFVN(ID="id", IMEI="imei", ST="st",
#' STARTDATE="start_date", STARTTIME="start_time",
#' ENDDATE="end_date", ENDTIME="end_time")
#' # Prerequisites in order to execute setREF. End ---------------------
#' # ------------------------------------------------------
#' # Run function 2 of 28; see esmprep functions' hierarchy.
#' # ------------------------------------------------------
#' # 4 is the number of daily prompts.
#' # relRef is the result of function 'relevantREFVN'
#' # Relevant variables names of reference dataset.
#' (RELEVANTVN_REF <- setREF(4, relRef))
#' # With date-time objects instead of separate date and time
#' relRef <- relevantREFVN(ID="id", IMEI="imei", ST="st",
#' START_DATETIME="start_dateTime", END_DATETIME="end_dateTime")
#' (RELEVANTVN_REF <- setREF(4, relRef))
#' # o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o
#
#' @seealso Exemplary code (fully executable) in the documentation of \code{\link{esmprep}} (function 2 of 28).
#
#' @export
#
setREF <- function(MAXPROMPT = NULL, REFVN = NULL) {

    # ERROR handling start --------------------------------------------------------
    # 1st argument 'MAXPROMPT'
    
    if(is.null(MAXPROMPT)) {
    		warning("Argument 'MAXPROMPT' is missing, meaning that in your ESM study participants NEVER were prompted to fill out a questionnaire. Instead they ALWAYS decided on their own whether to fill out a questionnaire? If participants were prompted at least once each ESM day, please pass the argument 'MAXPROMPT' to function 'setREF'.")
    } else {
    		
    		# If at least one prompt per day, then MAXPROMPT is obligatory.
    		
    		# MAXPROMPT is obligatory and it must be of type numeric.
	    if (is.null(MAXPROMPT) | !is.numeric(MAXPROMPT)) {
	        stop("Argument 'MAXPROMPT' is obligatory. It must be of type numeric.")
	    }
	
	    # MAXPROMPT must not be a real number but a positive integer.
	    if (MAXPROMPT%%1 != 0L | MAXPROMPT <= 0) {
	        stop("Argument 'MAXPROMPT' must be a positive integer.")
	    }
	
	    # Convert 'MAXPROMPT' to be of type integer.
	    MAXPROMPT <- as.integer(MAXPROMPT)
    		
    }
    
    # 4th argument 'REFVN', produced by the function 'relevantREFERENCEvariables'.
    if (is.null(REFVN)) {
        stop("Argument 'REFVN' is missing. It must be produced by the function 'relevantREFERENCEvariables'.")

    } else if (class(REFVN) != "list" |
               is.integer0(REFVN[["REF_DATETIMES_SEP"]]) |
               !is.logical(REFVN[["REF_DATETIMES_SEP"]])) {
        stop("Argument 'REFVN' must be produced by the function 'relevantREFERENCEvariables'.")
    }
    # ERROR handling end --------------------------------------------------------

    RELEVANTVN_REF <- list()
    # Relevant variable names
    # -----------------------
    if (REFVN[["REF_DATETIMES_SEP"]]) {
        # 1 = Variable denoting the ID in the reference dataset
        RELEVANTVN_REF[["REF_ID"]] <- REFVN[[1]]
        # 2 = REF_IMEI
        RELEVANTVN_REF[["REF_IMEI"]] <- REFVN[[2]]
        # 3 = REF_START_DATE
        RELEVANTVN_REF[["REF_START_DATE"]] <- REFVN[[4]]
        # 4 = REF_START_TIME
        RELEVANTVN_REF[["REF_START_TIME"]] <- REFVN[[5]]
        # 5 = REF_END_DATE
        RELEVANTVN_REF[["REF_END_DATE"]] <- REFVN[[6]]
        # 6 = REF_END_TIME
        RELEVANTVN_REF[["REF_END_TIME"]] <- REFVN[[7]]
		
		if(is.null(MAXPROMPT)) {
			RELEVANTVN_REF[["REF_ST"]] <- "NO_PROMPT_TIMES_ARE_PRESENT"
		} else {
			# APPEND all st_i's as one unit to the list
        		RELEVANTVN_REF[["REF_ST"]] <- paste0(REFVN[["REF_ST"]], 1:MAXPROMPT)
		}

        cat("For the reference dataset next apply the function 'genDateTime'.")

    } else {
        # 1 = Variable denoting the ID in the reference dataset
        RELEVANTVN_REF[["REF_ID"]] <- REFVN[[1]]
        # 2 = REF_IMEI
        RELEVANTVN_REF[["REF_IMEI"]] <- REFVN[[2]]
        # 3 = REF_START_DATETIME
        RELEVANTVN_REF[["REF_START_DATETIME"]] <- REFVN[[4]]
        # 4 = REF_END_DATETIME
        RELEVANTVN_REF[["REF_END_DATETIME"]] <- REFVN[[5]]

        if(is.null(MAXPROMPT)) {
			RELEVANTVN_REF[["REF_ST"]] <- "NO_PROMPT_TIMES_ARE_PRESENT"
		} else {
			# APPEND all st_i's as one unit to the list
        	RELEVANTVN_REF[["REF_ST"]] <- paste0(REFVN[["REF_ST"]], 1:MAXPROMPT)
		}

        cat("For the reference dataset next apply the function 'splitDateTime'.")
    }
    
    RELEVANTVN_REF
}
