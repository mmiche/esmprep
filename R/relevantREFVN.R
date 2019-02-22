#' relevantREFVN
#
#' @description relevantREFVN creates a list of the relevant variable names (VN) of the reference (REF) dataset.
#
#' @param STARTDATE a character string that specifies the column name in the respective dataset holding the date of when the participant started ... see \strong{Details}.
#
#' @param STARTTIME a character string that specifies the column name in the respective dataset holding the time of when the participant started ... see \strong{Details}.
#
#' @param ENDDATE a character string that specifies the column name in the respective dataset holding the date of when the participant ended ... see \strong{Details}.
#
#' @param ENDTIME a character string that specifies the column name in the respective dataset holding the time of when the participant ended ... see \strong{Details}.
#
#' @param START_DATETIME a character string. If \code{STARTDATE} and \code{STARTTIME} are not in two separate columns but are combined as a date-time object in a single column pass that column's name and ignore the arguments \code{STARTDATE} and \code{STARTTIME}.
#
#' @param END_DATETIME a character string. If \code{ENDDATE} and \code{ENDTIME} are not in two separate columns but are combined as a date-time object in a single column pass that column's name and ignore the arguments \code{ENDDATE} and \code{ENDTIME}.
#
#' @param IMEI a character string. Column name that specifies the variable in the respective dataset holding the the IMEI number.
#
#' @param ID a character string that specifies the column name which holds the unique identification code for the participant.
#
#' @param ST a character string. It must be the first component of the column name in the reference dataset that specifies the prompts on the mobile device, e.g. ST for scheduled time. The column names must all be equal except for the last character, which must specify the respective number of the prompt, e.g. ST3 for the third prompt of the day. 
#
#' @details The relevant variable names (i.e. column names) must refer to the reference dataset. The date and time of both start and end refers to the ESM period for each participant, starting with the date and time he/she fills out the very first ESM questionnaire on his/her own and ending with the date and time he/she fills out the very last ESM questionnaire.
#
#' @return A list of the relevant variable/column names in the reference dataset. To be used as the last argument in the function \code{\link{setREF}}. The last element of the list is a logical value indicating whether the date and time are either separated (TRUE) or a single date-time object (FALSE). It is meaningful only for the subsequent function \code{\link{setREF}}.
#
#' @examples
#' # o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o
#' # ------------------------------------------------------
#' # Run function 1 of 29; see esmprep functions' hierarchy.
#' # ------------------------------------------------------
#' # With date and time as separate arguments
#' relRef <- relevantREFVN(ID="id", IMEI="imei", ST="st",
#' STARTDATE="start_date", STARTTIME="start_time",
#' ENDDATE="end_date", ENDTIME="end_time")
#' # With date-time objects instead of separate date and time
#' relRef <- relevantREFVN(ID="id", IMEI="imei", ST="st",
#' START_DATETIME="start_dateTime", END_DATETIME="end_dateTime")
#' # o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o
#
#' @seealso Exemplary code (fully executable) in the documentation of \code{\link{esmprep}} (function 1 of 29).
#
#' @export
#
relevantREFVN <- function(ID = NULL, IMEI = NULL, ST = NULL, STARTDATE = NULL, STARTTIME = NULL, ENDDATE = NULL, ENDTIME = NULL, START_DATETIME = NULL, END_DATETIME = NULL) {

    # ERROR handling start -----------------------------------------------------
    listCheck <- list(ID = ID, IMEI = IMEI, ST = ST, STARTDATE = STARTDATE,
                      STARTTIME = STARTTIME, ENDDATE = ENDDATE, ENDTIME = ENDTIME, START_DATETIME = START_DATETIME, END_DATETIME = END_DATETIME)

    # Check the class of each argument (They should all be of type character)
    checkChar <- as.vector(sapply(listCheck, FUN = is.character))

    # Check which arguments were not given (among the order of all expected arguments)
    isNull <- as.vector(sapply(listCheck, FUN = is.null))

    passedArgs <- ifelse(isNull, NA, as.character(listCheck))

    # All arguments that were passed (that were not NULL) to the function must be
    # of type character.
    if (any(checkChar[!isNull] == FALSE)) {
        idxNoChar <- which(checkChar[!isNull] == FALSE)
        stop(paste0("All arguments must be of type character. Check argument(s): ", names(listCheck)[!isNull][idxNoChar]))
        # Else if among the arguments of type character there is any empty character string: stop.
    } else if (any(nchar(gsub(" ", "", as.character(passedArgs[!isNull]))) == 0)) {
        idxEmptyChar <- which(nchar(gsub(" ", "", as.character(passedArgs[!isNull]))) == 0)
        stop(paste0("All arguments must be of type character consisting of at least one letter.  Check argument(s): ",
                    names(listCheck)[!isNull][idxEmptyChar]))
    }

    len_args1_2 <- length(which(isNull[1:2] == FALSE))
    # Argument 1-2 must be present. Error if one of them is missing.
    if (len_args1_2 < 2) {
        stop("Arguments 'ID' and 'IMEI' all must be present.")
    }
    
    len_args3 <- length(which(isNull[3] == FALSE))
    # Argument 3 must NOT be present. Warning if it is missing.
    if (isNull[3]) {
    	listCheck[["ST"]] <- "NO_PROMPT_TIMES_ARE_PRESENT"
        warning("Argument 'ST' is missing, meaning that in your ESM study participants NEVER were prompted to fill out a questionnaire. Instead they ALWAYS decided on their own whether to fill out a questionnaire? If participants were prompted at least once each ESM day, please pass the argument 'ST' to function 'relevantREFVN'.")
    }
    
    # Arguments 4 to 7 all must be present or all must be absent.
    # Present if date and time of ES-questionnaire is separated in 2 columns of the raw data.
    # Absent if date and time of ES-questionnaire is combined in 1 column.
    len_date_time <- length(which(isNull[4:7] == TRUE))
    if (len_date_time != 0 & len_date_time != 4) {
        stop("The arguments 'STARTDATE', 'STARTTIME', 'ENDDATE', and 'ENDTIME' are incomplete; either all or none of them must be present.")
    }

    # Arguments 8 and 9 all must be present or all must be absent.
    # Absent if date and time of ES-questionnaire is separated in 2 columns of the raw data.
    # Present if date and time of ES-questionnaire is combined in 1 column.
    len_dateTime <- length(which(isNull[8:9] == TRUE))
    if (len_dateTime == 1) {
        stop("The arguments 'START_DATETIME' and 'END_DATETIME' are incomplete; either both or none of them must be present.")
    }
    # ERROR handling end ----------------------------------------------------------

    # Set flag
    if (all(!isNull[4:7])) {
        # Set flag to true (denoting that date and time are in 2 separate columns)
        REF_flagSeparatedDateTimes <- TRUE
        # All separated dates and times are present, all date-time objects are absent.
        argNames <- names(listCheck)[1:7]
    } else if (all(!isNull[8:9])) {
        # Set flag to false (denoting that date and time are combined in 1 column)
        REF_flagSeparatedDateTimes <- FALSE
        # All date-time objects are present, all separated dates and times are absent.
        argNames <- names(listCheck)[c(1:3, 8:9)]
    }

    relREFinfoPassed <- as.character(unlist(listCheck))

    # list of relevant variable names in event sampling (ES)
    # ------------------------------------------------------
    if (REF_flagSeparatedDateTimes) {
        list(REF_ID = relREFinfoPassed[1],
             REF_IMEI = relREFinfoPassed[2],
             REF_ST = relREFinfoPassed[3],
             REF_START_DATE = relREFinfoPassed[4],
             REF_START_TIME = relREFinfoPassed[5],
             REF_END_DATE = relREFinfoPassed[6],
             REF_END_TIME = relREFinfoPassed[7],
             REF_DATETIMES_SEP = REF_flagSeparatedDateTimes)
    } else {
        list(REF_ID = relREFinfoPassed[1],
             REF_IMEI = relREFinfoPassed[2],
             REF_ST = relREFinfoPassed[3],
             REF_START_DATETIME = relREFinfoPassed[4],
             REF_END_DATETIME = relREFinfoPassed[5],
             REF_DATETIMES_SEP = REF_flagSeparatedDateTimes)
    }
}
