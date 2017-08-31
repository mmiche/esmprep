#' genKey
#
#' @description genKey generates a unique number for each ESM questionnaire.
#
#' @param dfList a list. Each element of the list must be a data.frame. Each data.frame is a separate raw ESM dataset/an ESM questionnaire version. If there is just one ESM version the list therefore contains one data.frame.
#
#' @details The unique number for each ESM questionnaire can be seen as an identifier prior to the assignment of the participants who filled out the questionnaires. Such an identifier is valuable in controlling a large amount of rows of data.
#
#' @return \code{esDf} with the additional column KEY, i.e. a unique integer for each data row.
#
#' @examples
#' # o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o
#' # Prerequisites in order to execute genKey. Start -------------------
#' relEs <- relevantESVN(svyName="survey_name", IMEI="IMEI",
#' STARTDATE="start_date", STARTTIME="start_time",
#' ENDDATE="end_date", ENDTIME="end_time")
#' imeiNumbers <- as.character(referenceDf$imei)
#' surveyNames <- c("morningTestGroup", "dayTestGroup", "eveningTestGroup",
#' "morningControlGroup", "dayControlGroup", "eveningControlGroup")
#' RELEVANT_ES <- setES(4, imeiNumbers, surveyNames, relEs)
#' RELEVANTVN_ES <- RELEVANT_ES[["RELEVANTVN_ES"]]
#' esLs <- esList(list(morningControl, dayControl, eveningControl,
#' morningTest, dayTest, eveningTest), RELEVANTVN_ES)
#' # Prerequisites in order to execute genKey. End ---------------------
#' # ------------------------------------------------------
#' # Run function 6 of 28; see esmprep functions' hierarchy.
#' # ------------------------------------------------------
#' # esLs is the result of function 'esList'.
#' keyLs <- genKey(esLs)
#' # o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o
#
#' @seealso Exemplary code (fully executable) in the documentation of \code{\link{esmprep}} (function 6 of 28).
#
#' @export
#
genKey <- function(dfList) {

    # Argument 'dfList' must be of class 'list', even when it contains only
    # one data.frame.
    dfCheck <- sapply(dfList, FUN = is.data.frame)

    # If at least one of the elements in dfList is not of class data.frame
    # stop the processing.
    if(any(dfCheck == FALSE)) {
        stop("Error in argument 'dfList'. It must be of class 'list'. All elements in the list must be of class 'data.frame'.")
    }

    nRows <- c()
    for(i in 1:length(dfList)) {
        nRows <- c(nRows, nrow(dfList[[i]]))
    }

    maxRows0 <- c(101, 1001, 10001, 100001, 1000001, 10000001, 100000001, 1000000001)
    nRowsSum <- sum(nRows)
    maxRows <- maxRows0[which(nRowsSum < maxRows0)[1]]

    # return data frame with number of lines in each raw data file and
    # a variable containing numbers, each assigned to one row of
    # raw data.
    keyVec <- maxRows:(maxRows+nRowsSum-1)

    start <- c(1, cumsum(nRows)[1:(length(nRows)-1)] + 1)
    stop <- cumsum(nRows)

    # Distribute keyVec across all datasets in the list
    for(j in 1:length(dfList)) {
        col_jWithoutKEY <- ncol(dfList[[j]])
        dfList[[j]][,"KEY"] <- keyVec[start[j]:stop[j]]
        col_jWithKEY <- ncol(dfList[[j]])
        # Set KEY as first column
        dfList[[j]] <- dfList[[j]][,c(col_jWithKEY, 1:col_jWithoutKEY)]
    }
    dfList
}
