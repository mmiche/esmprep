#' relevantESVN
#
#' @description relevantESVN creates a list of the relevant variable names (VN) of (each of) the experience sampling (ES) dataset(s).
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
#' @param svyName a vector of character string(s). The column name in (each of) the ESM dataset(s) that specifies the particular survey version.\cr This is the only optional argument, i.e. if there exists no such column in the raw ESM dataset(s), keep the default value of NULL for this argument. If this default value is kept, the function \code{\link{esList}} will generate such a column and will fill it with 'ESMVERSION_ESMPREP' in each line of raw ESM data at the current state of the dataset(s).\cr \strong{NOTE}: It is not recommended to let \code{\link{esList}} generate this column, though. For reasons of clarity it is recommended that the user generates such a column for each raw ESM dataset(s) beforehand. The column name of (all) the raw ESM dataset(s) must be identical, however, the content of the new columns must uniquely specify their respective ESM dataset, e.g. "morningControlGroup" for the morning ESM version of the control group.
#
#' @param IMEI a character string. Column name that specifies the variable in the respective dataset holding the the IMEI number.
#
#' @details The relevant variable names (i.e. column names) must refer to the raw ESM dataset(s). The date and time of both start and end refers to the single ESM questionnaires, i.e. the date and time they actually were started on the phone and the date and time they were finished.
#
#' @return A list of the relevant variable/column names in the ESM dataset(s). To be used as the last argument in the function \code{\link{setES}}. The last element of the list is a logical value indicating whether the date and time are either separated (TRUE) or already a date-time object (FALSE). It is meaningful only for the subsequent function \code{\link{setES}}.
#
#' @examples
#' # o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o
#' # ------------------------------------------------------
#' # Run function 3 of 28; see esmprep functions' hierarchy.
#' # ------------------------------------------------------
#' # With date and time as separate arguments
#' relEs <- relevantESVN(svyName="survey_name", IMEI="IMEI",
#' STARTDATE="start_date", STARTTIME="start_time",
#' ENDDATE="end_date", ENDTIME="end_time")
#' # With date-time objects instead of separate date and time
#' relEs <- relevantESVN(svyName="survey_name", IMEI="IMEI",
#' START_DATETIME="start_dateTime", END_DATETIME="end_dateTime")
#' # o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o
#
#' @seealso Exemplary code (fully executable) in the documentation of \code{\link{esmprep}} (function 3 of 28).
#
#' @export
#
relevantESVN <- function(svyName=NULL, IMEI=NULL, STARTDATE=NULL, STARTTIME=NULL, ENDDATE=NULL, ENDTIME=NULL, START_DATETIME=NULL, END_DATETIME=NULL) {

    # ERROR handling start ---------------------------------------------------
    # List all arguments that were given
    listCheck <- list(svyName = svyName, IMEI = IMEI, STARTDATE = STARTDATE,
                      STARTTIME = STARTTIME, ENDDATE = ENDDATE, ENDTIME = ENDTIME,
                      START_DATETIME = START_DATETIME, END_DATETIME = END_DATETIME)

    # Check the class of each argument (They should all be of type character)
    checkChar <- as.vector(sapply(listCheck, FUN = is.character))

    # Check which arguments were not given (among the order of all expected arguments)
    isNull <- as.vector(sapply(listCheck, FUN = is.null))

    passedArgs <- ifelse(isNull, NA, as.character(listCheck))

    # All arguments that were passed (that were not NULL) to the function must be
    # of type character.
    if (any(checkChar[!isNull] == FALSE)) {
        idxNoChar <- which(checkChar[!isNull] == FALSE)
        stop(paste0("All arguments must be of type character. Check argument(s): ",
                    names(listCheck)[!isNull][idxNoChar]))

    # Else if any of the arguments of type character is an empty character: stop.
    } else if (any(nchar(gsub(" ", "", as.character(passedArgs[!isNull]))) == 0)) {
        idxEmptyChar <- which(nchar(gsub(" ", "", as.character(passedArgs[!isNull]))) == 0)
        stop(paste0("All arguments must be of type character consisting of at least one letter. Check argument(s): ", names(listCheck)[!isNull][idxEmptyChar]))
    }
    
    # Argument 1 can be present. Warning if it is missing.
    if (isNull[1]) {
    		listCheck[["svyName"]] <- "ES_SVY_NAME"
        message("Argument 'svyName' is the only optional argument. It has not been passed by the user. OK, go on.")
    }
    
    # Argument 2 must be present. Error if it is missing.
    if (isNull[2]) {
        stop("Arguments 'IMEI' both must be present.")
    }

    # Arguments 3 to 6 all must be present or they must all must be absent.
    # Present if date and time of ES-questionnaire is separated in 2 columns of the raw data.
    # Absent if date and time of ES-questionnaire is combined in 1 column.
    len_date_time <- length(which(isNull[3:6] == TRUE))
    if (len_date_time != 0 & len_date_time != 4) {
        stop("The arguments 'STARTDATE', 'STARTTIME', 'ENDDATE', and 'ENDTIME' are incomplete; either all or none of them must be present.")
    }

    # Arguments 7 and 8 all must be present or they must all must be absent.
    # Absent if date and time of ES-questionnaire is separated in 2 columns of the raw data.
    # Present if date and time of ES-questionnaire is combined in 1 column.
    len_dateTime <- length(which(isNull[7:8] == TRUE))
    if (len_dateTime == 1) {
        stop("The arguments 'START_DATETIME' and 'END_DATETIME' are incomplete; either both or none of them must be present.")
    }
    # ERROR handling end -------------------------------------------------------

    # Set flag
    if (all(!isNull[3:6])) {
        # Set flag to true (denoting that date and time are in 2 separate columns)
        ES_flagSeparatedDateTimes <- TRUE
        # All separated dates and times are present, all date-time objects are absent.
        argNames <- names(listCheck)[1:6]
    } else if (all(!isNull[7:8])) {
        # Set flag to false (denoting that date and time are combined in 1 column)
        ES_flagSeparatedDateTimes <- FALSE
        # All date-time objects are present, all separated dates and times are absent.
        argNames <- names(listCheck)[c(1:2, 7:8)]
    }

    relESinfoPassed <- as.character(unlist(listCheck))

    # list of relevant variable names in event sampling (ES)
    # ------------------------------------------------------
    if(ES_flagSeparatedDateTimes) {
        list(ES_SVY_NAME = relESinfoPassed[1],
             ES_IMEI = relESinfoPassed[2],
             ES_START_DATE = relESinfoPassed[3],
             ES_START_TIME = relESinfoPassed[4],
             ES_END_DATE = relESinfoPassed[5],
             ES_END_TIME = relESinfoPassed[6],
             ES_DATETIMES_SEP = ES_flagSeparatedDateTimes)
    } else {
        list(ES_SVY_NAME = relESinfoPassed[1],
             ES_IMEI = relESinfoPassed[2],
             ES_START_DATETIME = relESinfoPassed[3],
             ES_END_DATETIME = relESinfoPassed[4],
             ES_DATETIMES_SEP = ES_flagSeparatedDateTimes)
    }
}
