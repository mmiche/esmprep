#' esComplete
#
#' @description esComplete checks whether each ESM questionnaire is complete as specified by the user.
#
#' @param dfList a list. Each element of the list must be a data.frame. Each data.frame is a separate raw ESM dataset/an ESM questionnaire version. If there is just one ESM version the list therefore contains one data.frame.
#
#' @param lastItemList a list. Each list element too must be a list. Each of these inner lists must contain exactly 4 elements:
#' \enumerate{
#' \item First, a character string specifying the ESM questionnaire version
#' \item Second, a character string specifying the penultimate item of its respective ESM questionnaire version (i.e. the column name of the raw ESM dataset)
#' \item Third, a vector of at least one numeric value, specifying the condition upon which the last item is expected to contain a value, so that the questionnaire can be considered complete, and
#' \item Fourth, a character string specifying the last item of its respective ESM questionnaire version (i.e. the column name of the raw ESM dataset).
#' }
#' If there is no condition that determines which is the last item expected to contain a value, then the second and the third argument will have to be set to NA. See \strong{Details} for more information.
#
#' @details If due to some technical error an ESM questionnaire does not contain an end date and/or end time it might be a complete questionnaire nonetheless. Completion can be defined as the last item of the questionnaire containing valid data. In addition it is possible that the value in the penultimate item sets a condition upon which the questionnaire's completion is achieved either if the penultimate item contains a specific value (e.g. 0), which might signal that the questionnaire ends right there. However, if the penultimate item contains a value greater than 0, this might signal that the questionnaire's last item is expected to contain valid data.
#
#' @return \code{dfList} with additional column INCOMPLETE denoting an ESM questionnaire to be complete (= 0) or incomplete (= 1). If within the 2nd argument \code{lastItemList} at least one of the ESM questionnaire versions are passed more than once, then the additional columns will be named INCOMPLETE_i, where i specifies the number of how often an ESM version has been passed (see \strong{Examples}).
#
#' @examples
#' # o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o
#' # Prerequisites in order to execute esComplete. Start ---------------
#' # Use example list delivered with the package
#' RELEVANTVN_ES <- RELEVANTVN_ESext
#' # keyLsNew is a list of datasets, also delivered with the package
#' rmInvLs <- rmInvalid(keyLsNew, RELEVANTVN_ES)
#' plausibItems <- esItems(dfList=rmInvLs[["dfValid"]], RELEVANTVN_ES)
#' # Prerequisites in order to execute esComplete. End -----------------
#' # -------------------------------------------------------
#' # Run function 12 of 28; see esmprep functions' hierarchy.
#' # -------------------------------------------------------
#' # Generate second argument of function 'esComplete'. It's strongly recommended
#' # to read the explantion of this 2nd argument in the esmprep vignette, function
#' # 'esComplete'.
#' lastItemList <- list(
#' # If in survey version "morningTestGroup" variable "V6" contains the value 0,
#' # then variable "V6_1" is the last item expected to contain data, else "V6" is the last item
#' # expected to contain data.
#' list("morningTestGroup", "V6", 0, "V6_1"),
#' # In survey version "dayTestGroup" variable "V7" is the last item expected to contain data;
#' # unlike above, no conditions; NA as 2nd and 3rd element of the inner list are mandatory.
#' list("dayTestGroup", NA, NA, "V7"),
#' # Information of all further ESM versions are passed accordingly:
#' list("eveningTestGroup", "V9", 1, "V9_1"),
#' list("morningControlGroup", "V6", 0, "V6_1"),
#' list("dayControlGroup", NA, NA, "V7"),
#' # The last ESM version has 2 conditions, therefore it is passed 2 times:
#' # If V8_1 contains a value between 1 and 5, then V8_3 is the last item expected to
#' # contain data.
#' list("eveningControlGroup", "V8_1", 1:5, "V8_3"),
#' # If V8_1 contains the value 0, then V8_2 is the last item expected to contain data.
#' list("eveningControlGroup", "V8_1", 0, "V8_2"))
#' # Apply function 'esComplete'. rmInvLs[["dfValid"]] is one of the results of function
#' # rmInvalid.
#' isCompleteLs <- esComplete(rmInvLs[["dfValid"]], lastItemList)
#' # o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o
#
#' @seealso Exemplary code (fully executable) in the documentation of \code{\link{esmprep}} (function 12 of 28).
#
#' @export
#
esComplete <- function(dfList, lastItemList) {

    dfCheck <- sapply(dfList, FUN = is.data.frame)

    # If argument 'esVersion' is not of type data.frame stop the processing.
    if(any(dfCheck == FALSE)) {
        stop("Error in first argument 'dfList': All elements in the list must be of type 'data.frame'.")
    }

    listCheck <- sapply(lastItemList, FUN = is.list) & !sapply(lastItemList, FUN = is.data.frame)
    if(any(listCheck == FALSE)) {
        stop("Error in second argument 'lastItemList'. Make sure each list element is again a list, containing exactly 4 entries (for detailed information enter ?esComplete).")
    }

    svyNamesFromDfList <- names(dfList)
    if(any(is.null(svyNamesFromDfList))){
        stop("The argument 'dfList' contains at least one data.frame without a name. Prior to this function apply functions 'listES' and 'removeInvalidDf' (in this order).")
    }

    svyNamesFromLastItemList <- c()
    for(m in 1:length(lastItemList)) {
        svyNamesFromLastItemList <- c(svyNamesFromLastItemList, sapply(lastItemList[[m]][1], FUN = as.character))
    }

    # Make the order of lastItemList and dfList correspond to one another:
    # -------------------------------------------------------------------
    idxOrderComplete <- match(svyNamesFromLastItemList, svyNamesFromDfList)

    if(any(is.na(idxOrderComplete))) {
        isNA <- which(is.na(idxOrderComplete))
        cat("Prior to this function apply function 'rmInvalid'.\n")
        stop(paste0(svyNamesFromLastItemList[isNA], " can't be found in the list that contains the raw event sampling data frames."))
    }

    # If a questionnaire name in the argument 'lastItemList' occurs more
    # than once:
    if(any(duplicated(idxOrderComplete))) {
        idxDupl <- which(duplicated(idxOrderComplete))
        maxOccurrence <- 1
        for(o in idxDupl) {
            # Of the questionnaire names in the argument 'lastItemList'
            # that occur more than once (see if-clause), how often do
            # they occur?
            maxOccurrence_n <- length(which(idxOrderComplete == idxOrderComplete[o]))
            maxOccurrence <- ifelse(maxOccurrence_n > maxOccurrence, maxOccurrence_n, maxOccurrence)
        }
    }

    checkStructureOfLastItemList <- list()
    for(n in 1:length(lastItemList)) {

        checkClass <- sapply(lastItemList[[n]], FUN = class)
        checkNA <- sapply(lastItemList[[n]], FUN = is.na)

        # Do the column names appear in the dataset?
        # First extract the column names.
        colNames <- sapply(lastItemList[[n]][c(2,4)], FUN = as.character)
        # # Then identify the dataset (its index) they are supposed to be in.
        # idxDfList <- which(names(dfList) == lastItemList[[n]][1])[1]
        # Check their existence. If any NA is found then at least one of
        # column names do not occur in the respective dataset.
        colNameDontExist <-
            any(is.na(match(colNames[!is.na(colNames)],
                            names(dfList[[idxOrderComplete[n]]]))))

        if(colNameDontExist) {
            stop("At least one of the column names in the 2nd argument can't be found in their respective data frame.")
        } else {
            checkStructureOfLastItemList[[n]] <- TRUE
        }

        if(length(which(is.na(colNames))) == 0) {
            if(!is.numeric( unlist(dfList[[idxOrderComplete[n]]][colNames[1]]))) {
                stop("If there is a condition in the questionnaire that must be met in order to determine which item is the last one to contain data, the condition must be numeric, i.e. at least one value (of type integer), according to which the last item is expected to contain data.")
            } else {
                checkStructureOfLastItemList[[n]] <-
                    c(checkStructureOfLastItemList[[n]], TRUE)
            }
        }
    }

    if(any(sapply(checkStructureOfLastItemList,  function(x) any(x == FALSE)))) {
        stop("Error in argument 'lastItemList'. It must be a list of lists, each inner list containing exactly 4 entries (for more detailed information enter ?esComplete).")
    }

    lastItemList_elemNo3_list <- sapply(lastItemList, function(x) x[[3]])
    lastItemList_elemNo3 <-
        unlist(lastItemList_elemNo3_list)[!is.na(unlist(lastItemList_elemNo3_list))]
    true_lastItemList_elemNo3 <- lastItemList_elemNo3 < 0 |
        lastItemList_elemNo3%%1 != 0
    if(any(true_lastItemList_elemNo3)) {
        stop(paste0("Error in argument 'lastItemList': Only integers > 0 are permitted as values upon which it depends which item of the event sampling questionnaire is the last one expected to contain data. You entered: ", lastItemList_elemNo3[true_lastItemList_elemNo3], ".\n\n"))
    }

    svyNamesFromLastItemList <- c()
    svyNameOccurrence <- c()
    for(i in 1:length(lastItemList)) {
        svyName_i <- unlist(lastItemList[[i]][1])
        svyNamesFromLastItemList <- c(svyNamesFromLastItemList, svyName_i)
        svyNameOccurrence <- c(svyNameOccurrence, length(which(svyNamesFromLastItemList%in%svyName_i)))
    }
    maxOccurrence <- max(svyNameOccurrence)

    # The j-loop must iterate according to the length of lastItemList,
    # not according to the number of questionnaire versions.
    dfListCompleteQuestionnaires <- list()
    # List must be generated sequentially, starting at 1.
    counter <- 1
	
    for(k in idxOrderComplete) {

        esVersion_k <- esCompleteSingleVersion(
            # Current data file
            dfList[[k]],

            # Current survey name (type character)
            unlist(lastItemList[[counter]][1]),
            
            # Value(s) in conditional item that makes the last item expected to contain a value.
            unlist(lastItemList[[counter]][2]),

            # Variable name of last item of current data file (type character)
            unlist(lastItemList[[counter]][3]),

            # Variable name of conditional item of current data file (type character or NA)
            unlist(lastItemList[[counter]][4]))

        if(maxOccurrence > 1) {
            idxIncomplete <- which(names(esVersion_k) == "INCOMPLETE")
            colnames(esVersion_k)[idxIncomplete] <- paste0("INCOMPLETE_", svyNameOccurrence[counter])
            outListName <- paste0(as.character(svyNamesFromLastItemList[counter]), "_", svyNameOccurrence[counter])
            dfListCompleteQuestionnaires[[outListName]] <- esVersion_k
            counter <- counter + 1
        } else {
            outListName <- as.character(svyNamesFromLastItemList[counter])
            dfListCompleteQuestionnaires[[outListName]] <- esVersion_k
            counter <- counter + 1
        }

    }

    # RETURN list containing data frames
    # ----------------------------------
    dfListCompleteQuestionnaires
}
