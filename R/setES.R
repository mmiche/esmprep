#' setES
#
#' @description setES sets the relevant variable names concerning the ESM dataset(s).
#
#' @param MAXPROMPT a numeric value. The number of prompts per day.
#
#' @param IMEI_NUMBERS a vector of character strings. Each element of the vector specifies an IMEI number of at least one of the phone that have been used in the ESM study.
#
#' @param SVYNAMES a vector of character strings. Each element of the vector specifies one ESM version, which must exist as a separate column in the raw ESM dataset(s). If in function \code{\link{relevantESVN}} the default value NULL has been kept for the argument svyName, also keep the default value NULL for this argument! Keeping the default value NULL is not recommended, though. See \strong{NOTE} in the description of the argument 'svyName' of function \code{\link{relevantESVN}}.
#
#' @param ESVN a list. Each element of the list must specify one of the relevant column names of the raw ESM dataset(s); i.e. the ESM survey version, the IMEI number, the start date, the start time, the end date, and the end time. Use function \code{\link{relevantESVN}} to generate \code{ESVN}.
#
#' @details The one list is named RELEVANTINFO_ES. It contains 3 elements.
#' \enumerate{
#' \item MAXPROMPT: the number of daily prompts on the mobile device
#' \item IMEI_NUMBERS: all the IMEI numbers that are used in the study
#' \item SVYNAMES: the names of all ESM questionnaire versions used in the study.
#' }
#' The other list is named RELEVANTVN_ES, it contains either 4 or 6 elements, depending on whether the start date and the start time already exist as a date-time object (same for end date and end time). In the latter case the list elements' names are:
#' \enumerate{
#' \item ES_SVY_NAME: the column name in the ESM dataset(s) holding the name of the ESM questionnaire version
#' \item ES_IMEI: the column name in the ESM dataset(s) holding the IMEI number
#' \item ES_START_DATE: the date of when an ESM questionnaire was started
#' \item ES_START_TIME: the time of when an ESM questionnaire was started
#' \item ES_END_DATE: the date of when an ESM questionnaire was finished
#' \item ES_END_TIME: the time of when an ESM questionnaire was finished
#' }
#' If the start date and start time (same for end date and end time) are combined to a date-time object, the 3rd list element will be ES_STARTDATETIME and the 4th element will be ES_ENDDATETIME
#' The last element will always be ES_DATETIMES_SEP: TRUE if date and time are separated, FALSE if they are a single date-time object.
#
#' @return 2 separate lists. Each element of the lists is named according to the variable's content. See \strong{Details} for more information.
#
#' @importFrom stats var
#
#' @examples
#' # o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o
#' # Prerequisites in order to execute setES. Start --------------------
#' relEs <- relevantESVN(svyName="survey_name", IMEI="IMEI",
#' STARTDATE="start_date", STARTTIME="start_time",
#' ENDDATE="end_date", ENDTIME="end_time")
#' # Prerequisites in order to execute setES. End ----------------------
#' # ------------------------------------------------------
#' # Run function 4 of 29; see esmprep functions' hierarchy.
#' # ------------------------------------------------------
#' # imeiNumbers is the vector containing all IMEI numbers used in
#' # the ESM study; use the respective entries in the referenceDf.
#' imeiNumbers <- as.character(referenceDf$imei)
#' # surveyNames is the vector containing all ESM version names.
#' surveyNames <- c(
#' # Test group
#'    "morningTestGroup", "dayTestGroup", "eveningTestGroup",
#' # Control group
#'    "morningControlGroup", "dayControlGroup", "eveningControlGroup")
#' # 4 is the number of daily prompts
#' # relEs is the result of function 'relevantESVN'
#' RELEVANT_ES <- setES(4, imeiNumbers, surveyNames, relEs)
#' # Extract relevant ESM general information
#' RELEVANTINFO_ES <- RELEVANT_ES[["RELEVANTINFO_ES"]]
#' # Extract list of relevant variables names of raw ESM datasets.
#' RELEVANTVN_ES <- RELEVANT_ES[["RELEVANTVN_ES"]]
#' 
#' # With date-time objects instead of separate date and time
#' relEs <- relevantESVN(svyName="survey_name", IMEI="IMEI",
#' START_DATETIME="start_dateTime", END_DATETIME="end_dateTime")
#' RELEVANT_ES <- setES(4, imeiNumbers, surveyNames, relEs)
#' # Extract relevant ESM general information
#' RELEVANTINFO_ES <- RELEVANT_ES[["RELEVANTINFO_ES"]]
#' # Extract list of relevant variables names of raw ESM datasets.
#' RELEVANTVN_ES <- RELEVANT_ES[["RELEVANTVN_ES"]]
#' # o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o
#
#' @seealso Exemplary code (fully executable) in the documentation of \code{\link{esmprep}} (function 4 of 29).
#
#' @export
#
setES <- function(MAXPROMPT=NULL, IMEI_NUMBERS=NULL, SVYNAMES=NULL, ESVN=NULL) {

    # ERROR handling start ---------------------------------------------------
    # 1st argument 'MAXPROMPT'
    # MAXPROMPT is obligatory and it must be of type numeric.
    if(is.null(MAXPROMPT) | !is.numeric(MAXPROMPT)) {
        stop("Argument 'MAXPROMPT' is obligatory. It must be of type numeric.")
    }

    # MAXPROMPT must not be a real number but a positive integer.
    if(MAXPROMPT%%1 != 0L | MAXPROMPT <= 0) {
        stop("Argument 'MAXPROMPT' must be a positive integer.")
    }

    # Convert 'MAXPROMPT' to be of type integer.
    MAXPROMPT <- as.integer(MAXPROMPT)

    # 2nd argument 'IMEI_NUMBERS', each must be of type character.
    if(!is.vector(IMEI_NUMBERS) | !is.character(IMEI_NUMBERS)) {
        stop("Argument 'IMEI_NUMBERS' must be a vector containing elements of type 'character'.")
    }

    # 3rd argument 'SVYNAMES' gets handled below.

    # 4th argument 'ESVN', produced by the function 'relevantESVN'.
    if(is.null(ESVN)) {
        stop("Argument 'ESVN' is missing. It must be produced by the function 'relevantESVN'.")
    } else if (class(ESVN) != "list" |
               is.integer0(ESVN[["ES_DATETIMES_SEP"]]) |
               !is.logical(ESVN[["ES_DATETIMES_SEP"]])) {
        stop("Argument 'ESVN' must be produced by the function 'relevantESVN'.")
    }

    # Check whether the length of each element in the list is equal to the length
    # of all other elements in the list.
    checkIMEI_NUMBERS_len <- c()
    for(i in 1:length(IMEI_NUMBERS)) {checkIMEI_NUMBERS_len <- c(checkIMEI_NUMBERS_len, nchar(IMEI_NUMBERS[i]))}
    if(!is.vector(IMEI_NUMBERS) | var(checkIMEI_NUMBERS_len) != 0) {
        stop('All IMEI numbers must contain an equal amount of single characters, e.g. "3" and "47" differ by 1 single character.')
    }
    # ERROR handling end -----------------------------------------------------

    RELEVANTINFO_ES <- list()
    RELEVANTINFO_ES[["MAXPROMPT"]] <- MAXPROMPT
    RELEVANTINFO_ES[["IMEI_NUMBERS"]] <- IMEI_NUMBERS
	
	# SVYNAMES is the only optional argument, therefore it may be NULL.  
    if(!is.null(SVYNAMES)) {
    		# 3rd argument 'SVYNAMES'
    		# It must be of type character.
    		if(!is.character(SVYNAMES)) {
        		stop("Argument 'SVYNAMES' must be of type 'character'.")
    		}
	
	RELEVANTINFO_ES[["SVYNAMES"]] <- SVYNAMES
    	} else {
    		RELEVANTINFO_ES[["SVYNAMES"]] <- "NO_SURVEY_NAMES_PASSED_BY_USER"
    }
    

    RELEVANTVN_ES <- list()

    # Relevant variable names
    # -----------------------
    # 1 = ES_SVY_NAME (no ES_ at the beginning because survey_name only occurs in the ES raw dataset)
    RELEVANTVN_ES[["ES_SVY_NAME"]] <- ESVN[[1]]
    # 2 = ES_IMEI
    RELEVANTVN_ES[["ES_IMEI"]] <- ESVN[[2]]

    if(ESVN[["ES_DATETIMES_SEP"]]) {
        # 3 = ES_START_DATE
        RELEVANTVN_ES[["ES_START_DATE"]] <- ESVN[[3]]
        # 4 = ES_START_TIME
        RELEVANTVN_ES[["ES_START_TIME"]] <- ESVN[[4]]
        # 5 = ES_END_DATE
        RELEVANTVN_ES[["ES_END_DATE"]] <- ESVN[[5]]
        # 6 = ES_END_TIME
        RELEVANTVN_ES[["ES_END_TIME"]] <- ESVN[[6]]

        cat("For the event sampling dataset(s) next apply the function 'genKey' and then function 'genDateTime'.")

    } else {
        # 3 = ES_START_DATE_TIME
        RELEVANTVN_ES[["ES_START_DATETIME"]] <- ESVN[[3]]
        # 4 = ES_START_TIME
        RELEVANTVN_ES[["ES_END_DATETIME"]] <- ESVN[[4]]

        cat("For the event sampling dataset(s) next apply the function 'genKey' and then function 'splitDateTime'.")
    }
    list(RELEVANTVN_ES = RELEVANTVN_ES, RELEVANTINFO_ES = RELEVANTINFO_ES)
}
