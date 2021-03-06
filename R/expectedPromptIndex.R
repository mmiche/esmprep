#' expectedPromptIndex
#
#' @description expectedPromptIndex 
#
#' @param esDf a data.frame. A single ESM dataset. It must contain the 2 columns that hold the date-time object for when an ESM questionnaire was started and finished, respectively.
#
#' @param expectedPromptIndexList a list. Each list element must also be a list. Each of these inner lists must contain exactly 3 elements: first a character string specifying the ESM questionnaire version; second a vector of at least one integer specifying the daily prompt(s) that the first argument‘s version correspond(s) to, and third an integer specifying the time of day that the first argument‘s version corresponds to.
#
#' @param RELEVANTVN_ES a list. This list is generated by function \code{\link{setES}} and it is extended once either by function \code{\link{genDateTime}} or by function \code{\link{splitDateTime}}.
#
#' @param RELEVANTINFO_ES a list. This list is generated by function \code{\link{setES}}.
#
#' @details The return values directly correspond to the elements within the second argument: If there are prompt indices (as computed within the function 'esAssign') diverge from the expected prompt indices the variable PROMPTFALSE's value is 1, else 0. The variable EXPCATEGORY corresponds to category, with which the user expects the respective prompt(s) to be combined with.
#
#' @return \code{esDf} with the additional columns PROMPTFALSE and EXPCATEGORY. See \strong{Details} for more information.
#
#' @examples
#' # o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o
#' # Prerequisites in order to execute makeShift. Start ----------------
#' # Use example list delivered with the package
#' RELEVANTINFO_ES <- RELEVANTINFO_ES
#' # Use example list delivered with the package
#' RELEVANTVN_ES <- RELEVANTVN_ESext
#' # Use example list delivered with the package
#' RELEVANTVN_REF <- RELEVANTVN_REFext
#' # esAssigned is a list of datasets, delivered with the package. It is
#' # the result of the assignment of the ESM questionnaires to ALL 8
#' # participants in the reference dataset.
#' noEndDf <- missingEndDateTime(esAssigned[["ES"]], RELEVANTVN_ES)
#' identDf <- esIdentical(noEndDf, RELEVANTVN_ES)
#' sugShift <- suggestShift(identDf, 100, RELEVANTINFO_ES, RELEVANTVN_ES)
#' keyPromptDf <- sugShift$suggestShiftDf[,c("NEW_PROMPT", "SHIFTKEY")]
#' madeShift <- makeShift(sugShift, referenceDfNew, keyPromptDf, RELEVANTINFO_ES, RELEVANTVN_REF)
#' # Prerequisites in order to execute makeShift. End -------------------
#' # -------------------------------------------------------
#' # Run function 23 of 29; see esmprep functions' hierarchy.
#' # -------------------------------------------------------
#' # Generate second argument of function 'expectedPromptIndex'. It's strongly
#' # recommended to read the explanation of this 2nd argument in the esmprep
#' # vignette, function 'expectedPromptIndex'.
#' expIdxList <- list(
#' # I - the user - expect in the ESM version morningTestGroup that
#' # prompt no.1 is always linked to the value 1.
#' list("morningTestGroup", 1, 1),
#' # I - the user - expect in the ESM version dayTestGroup that
#' # prompt no. 2 and no.3 are always linked to the value 2.
#' list("dayTestGroup", c(2, 3), 2),
#' # Information of all further ESM versions are passed accordingly:
#' list("eveningTestGroup", 4, 3),
#' list("morningControlGroup", 1, 1),
#' list("dayControlGroup", c(2,3), 2),
#' list("eveningControlGroup", 4, 3))
#' # madeShiftDf$esDf is part of the output of function 'makeShift', if at
#' # least one questionnaire was shifted to a neighboring prompt index.
#' expectedDf <- expectedPromptIndex(madeShift$esDf, expIdxList, RELEVANTINFO_ES,
#' RELEVANTVN_ES)
#' # If no questionnaire is suggested for shifting (see function suggestShift)
#' # use the result of function suggestShift as 1st argument, like this:
#' # expectedDf <- expectedPromptIndex(sugShift$esDf, expIdxList, RELEVANTINFO_ES,
#' # RELEVANTVN_ES)
#' # o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o
#
#' @seealso Exemplary code (fully executable) in the documentation of \code{\link{esmprep}} (function 23 of 29).
#
#' @export
#
expectedPromptIndex <- function(esDf, expectedPromptIndexList, RELEVANTINFO_ES=NULL, RELEVANTVN_ES=NULL) {

    # Split up esDf into its components with function 'esVersions'
    esDfList <- esVersions(esDf, RELEVANTVN_ES=RELEVANTVN_ES)

    if(class(expectedPromptIndexList) != "list") {
        stop("The argument 'expectedPromptIndexList' must be a list.")
    }

    if(!all(sapply(expectedPromptIndexList, FUN = class) == "list")) {
        stop("Each element of the argument 'expectedPromptIndexList' must again be a list (containing 3 elements).")
    }

    if(!all(sapply(expectedPromptIndexList, FUN = length) == 3)) {
        stop("Each element of the argument 'expectedPromptIndexList' must again be a list, containing 3 elements.")
    }
    
    
    # Error handling function for all set-up lists generated by setES and setREF.
    # Both lists RELEVANTVN_ES and RELEVANTVN_REF get extended either by function
    # genDateTime or by function splitDateTime!
    SETUPLISTCheck(RELEVANTINFO_ES=RELEVANTINFO_ES,
    			   RELEVANTVN_ES=RELEVANTVN_ES,
    			   RELEVANTVN_REF=NULL)
    

    # Check class of each element of each list within 'expectedPromptIndexList'
    innerClass <- as.data.frame(sapply(expectedPromptIndexList, function(x) sapply(x, FUN = class)))

    # First element in inner list of 'expectedPromptIndexList' must be of
    # type character
    if(!all(innerClass[1,] == "character")) {
        stop("1st argument in each inner list of 'expectedPromptIndexList' must be of type character. It must denote a single event sampling survey version.")
    }

    if(!all(innerClass[2:3,] == "numeric" | innerClass[2:3,] == "integer")) {
        stop("2nd and 3rd argument in each inner list of 'expectedPromptIndexList' must be either of type numeric or of type integer. The 2nd argument must denote the expected index or indices of the scheduled start time(s). The 3rd argument must denote the time of day with which the 2nd argument is concordant.")
    }

    # However, the variable for the expected start time index can be checked. It
    # must be between 1 and MAXPROMPT.
    stStartArgs <- unlist(sapply(expectedPromptIndexList, function(x) x[2]))
    # If any of trueIdx is FALSE, then the start index is beyond the range of
    # possible start indices.
    trueIdx <- stStartArgs >= 1 & stStartArgs <= RELEVANTINFO_ES[["MAXPROMPT"]] & stStartArgs%%1 == 0
    if(!all(trueIdx)) {
        stop(paste0("The 2nd argument within each inner list must denote the index or indices of the scheduled start time(s). At least one of the indices is beyond the possible range of indices, which is between 1 and ", RELEVANTINFO_ES[["MAXPROMPT"]], ". You entered: ", c(stStartArgs[!trueIdx]), ".\n\n"))
    }

    # Extract sequentially:
    svyNamesFromExpectedStartTimeIndexList <- svyNameOccurrence <- c()
    for(i in 1:length(expectedPromptIndexList)) {
        svyName_i <- unlist(expectedPromptIndexList[[i]][1])
        svyNamesFromExpectedStartTimeIndexList <- c(svyNamesFromExpectedStartTimeIndexList, svyName_i)
        svyNameOccurrence <- c(svyNameOccurrence, length(which(svyNamesFromExpectedStartTimeIndexList%in%svyName_i)))
    }

    maxOccurrence <- max(svyNameOccurrence)

    if(maxOccurrence > 1) {
        stop("Each event sampling questionnaire version must not occur more than once in the argument 'expectedPromptIndexList'.")
    }

    svyNamesFromEsDfList <- c()
    for(j in 1:length(esDfList)) {
        svyNamesFromEsDfList <- c(svyNamesFromEsDfList, getmode(esDfList[[j]][,RELEVANTVN_ES[["ES_SVY_NAME"]]]))
    }

    # Make the order of expectedPromptIndexList and esDfList correspond to one another:
    # -------------------------------------------------------------------
    idxOrderComplete <- match(svyNamesFromExpectedStartTimeIndexList, svyNamesFromEsDfList)

    # The j-loop must iterate according to the length of lastItemList,
    # not according to the number of questionnaire versions.
    esDfListStreamOut <- list()
    # List must be generated sequentially, starting at 1.
    counter <- 1

    for(k in idxOrderComplete) {

        esVersion_k <- expectedPromptIndexSingleVersion(
            # Current subdata file
            esDfList[[k]],
            # # Current survey name (type character)
            # unlist(lastItemList[[counter]][1]),
            # Expected start time index or indices
            expectedPromptIndexList[[counter]][[2]],
            # Expected daytime index
            expectedPromptIndexList[[counter]][[3]])

        esDfListStreamOut[[names(esDfList)[k]]] <- esVersion_k
        counter <- counter + 1
    }

    # RETURN list containing data frames
    # ----------------------------------
    names(esDfListStreamOut)

    # Put the componentes back together
    esDfStreamOutMerged <- esMerge(esDfListStreamOut, RELEVANTVN_ES=RELEVANTVN_ES)

    # Order according to time and phone
    esDfStreamOutOrdered <- orderByIdAndTime(esDfStreamOutMerged, RELEVANTVN_ES=RELEVANTVN_ES)

    return(esDfStreamOutOrdered)
}
