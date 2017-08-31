#' esmprep: A package for preparing raw data in research that uses the Experience-Sampling-Methodology (ESM).
#'
#' The 'esmprep' package helps to prepare a raw ESM dataset for statistical analysis. Preparation includes the handling of errors (mostly due to technological reasons) and the generating of new variables that are necessary and/or helpful in meeting the conditions when statistically analyzing ESM data. The functions in 'esmprep' are meant to hierarchically lead from bottom, i.e. the raw (separated) ESM dataset(s), to top, i.e. a single ESM dataset ready for statistical analysis.
#'
#' @section 'esmprep' functions:
#' The 'esmprep' functions have an hierarchical order, in which they should be run. See \strong{Examples} for the function's hiararchy.
#'
#' @docType package

#' @examples
#' \dontrun{
#' # -o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-
#' # N O T E.
#' # DEAR USER OF THE 'esmprep' PACKAGE,
#' # THE FOLLOWING CODE IS AN EXAMPLE OF ALL THE PACKAGES'S FUNCTIONS, WHICH ARE
#' # LARGELY INTERDEPENDENT AND WHICH ARE SUPPOSED TO RUN IN AN HIERARCHICAL ORDER.
#' # AFTER HAVING LOADED THE PACKAGE YOU CAN COPY PASTE THE ENTIRE CODE INTO YOUR
#' # CONSOLE OR INTO A SCRIPT AND THEN RUN IT.
#' # -o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-
#' # ---------------------------------------------------------------------------------
#' # Load the 'esmprep' package => library(esmprep)
#' # ---------------------------------------------------------------------------------
#' # FUNCTION  NAME: relevantREFVN
#' # --------------
#' # Don't run independently. Run function 1 of 28 in 'esmprep' functions' hierarchy.
#' # ------------------------
#' # With date and time as separate arguments
#' relRef <- relevantREFVN(ID="id", IMEI="imei", ST="st",
#' STARTDATE="start_date", STARTTIME="start_time",
#' ENDDATE="end_date", ENDTIME="end_time")
#' # # DON'T RUN, because the example data doesn't contain date-time objects.
#' # # With date-time objects instead of separate date and time
#' # relRef <- relevantREFVN(ID="id", IMEI="imei", ST="st",
#' # START_DATETIME="start_dateTime", END_DATETIME="end_dateTime")
#' # ---------------------------------------------------------------------------------
#' # FUNCTION  NAME: setREF
#' # --------------
#' # Don't run independently. Run function 2 of 28 in 'esmprep' functions' hierarchy.
#' # ------------------------
#' # 4 is the number of daily prompts.
#' # relRef is the result of function 'relevantREFVN'
#' # Relevant variables names of reference dataset.
#' RELEVANTVN_REF <- setREF(4, relRef)
#' # ---------------------------------------------------------------------------------
#' # FUNCTION  NAME: relevantESVN
#' # --------------
#' # Don't run independently. Run function 3 of 28 in 'esmprep' functions' hierarchy.
#' # ------------------------
#' # With date and time as separate arguments
#' relEs <- relevantESVN(svyName="survey_name", IMEI="IMEI",
#' STARTDATE="start_date", STARTTIME="start_time",
#' ENDDATE="end_date", ENDTIME="end_time")
#' # # DON'T RUN, because the example data doesn't contain date-time objects.
#' # # With date-time objects instead of separate date and time
#' # relEs <- relevantESVN(svyName="survey_name", IMEI="IMEI",
#' # START_DATETIME="start_dateTime", END_DATETIME="end_dateTime")
#' # ---------------------------------------------------------------------------------
#' # FUNCTION  NAME: setES
#' # --------------
#' # Don't run independently. Run function 4 of 28 in 'esmprep' functions' hierarchy.
#' # ------------------------
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
#'
#' # Extract relevant ESM general information
#' RELEVANTINFO_ES <- RELEVANT_ES[["RELEVANTINFO_ES"]]
#'
#' # Extract list of relevant variables names of raw ESM datasets.
#' RELEVANTVN_ES <- RELEVANT_ES[["RELEVANTVN_ES"]]
#' # ---------------------------------------------------------------------------------
#' # FUNCTION  NAME: esList
#' # --------------
#' # Don't run independently. Run function 5 of 28 in 'esmprep' functions' hierarchy.
#' # ------------------------
#' # 6 exemplary raw ESM (sub-)datasets.
#' esLs <- esList(list(morningControl, dayControl, eveningControl,
#' morningTest, dayTest, eveningTest), RELEVANTVN_ES)
#' # ---------------------------------------------------------------------------------
#' # FUNCTION  NAME: genKey
#' # --------------
#' # Don't run independently. Run function 6 of 28 in 'esmprep' functions' hierarchy.
#' # ------------------------
#' # esLs is the result of function 'esList'.
#' keyLs <- genKey(esLs)
#' # ---------------------------------------------------------------------------------
#' # FUNCTION  NAME: genDateTime
#' # --------------
#' # Don't run independently. Run function 7 of 28 in 'esmprep' functions' hierarchy.
#' # ------------------------
#' # Applying function to reference dataset (7a of 28)
#' referenceDfList <- genDateTime(referenceDf, "REF", RELEVANTINFO_ES, RELEVANTVN_ES,
#' RELEVANTVN_REF)
#'
#' # Extract reference dataset from output
#' referenceDfNew <- referenceDfList[["refOrEsDf"]]
#' names(referenceDfNew)
#'
#' # Extract extended list of relevant variables names of reference dataset
#' RELEVANTVN_REF <- referenceDfList[["extendedVNList"]]
#'
#' # Applying function to raw ESM dataset(s) (7b of 28)
#' # keyLs is the result of function 'genKey'.
#' keyList <- genDateTime(keyLs, "ES", RELEVANTINFO_ES, RELEVANTVN_ES,
#' RELEVANTVN_REF)
#'
#' # Extract list of raw ESM datasets from output
#' keyLsNew <- keyList[["refOrEsDf"]]
#'
#' # Extract extended list of relevant variables names of raw ESM datasets
#' RELEVANTVN_ES <- keyList[["extendedVNList"]]
#' # ---------------------------------------------------------------------------------
#' # FUNCTION  NAME: rmInvalid
#' # --------------
#' # Don't run independently. Run function 8 of 28 in 'esmprep' functions' hierarchy.
#' # ------------------------
#' # keyLsNew is the result of function 'genDateTime' (or of function 'splitDateTime').
#' rmInvLs <- rmInvalid(keyLsNew, RELEVANTVN_ES)
#' # Result of function 'rmInvalid' is a list with 4 elements:
#' names(rmInvLs)
#' # ---------------------------------------------------------------------------------
#' # FUNCTION  NAME: printRmInvalid
#' # --------------
#' # Don't run independently. Run function 9 of 28 in 'esmprep' functions' hierarchy.
#' # ------------------------
#' # rmInvLs is the result of function 'rmInvalid'. Display its result
#' # in the console both tablulated and in detail.
#' key_rmLs <- printRmInvalid(rmInvLs, smr="both", RELEVANTVN_ES)
#' # Display the list containing the KEY values of all questionnaires
#' # that have been removed.
#' key_rmLs
#' # Since there have been warning messages in 4 of the 6 datasets,
#' # the first ESM item (name: V1) was automatically converted to class
#' # character, although it is numeric. So we'll re-convert V1's class.
#' # Check V1 prior to conversion
#' str(rmInvLs[["dfValid"]][[2]][1:2])
#' rmInvLs[["dfValid"]] <- sapply(rmInvLs[["dfValid"]], function(x) {
#'      x[,"V1"] <- as.numeric(x[,"V1"])
#'      return(x) })
#' # Check V1 after conversion
#' str(rmInvLs[["dfValid"]][[2]][1:2])
#' # ----------------------------------------------------------------------------------
#' # FUNCTION  NAME: esItems
#' # --------------
#' # Don't run independently. Run function 10 of 28 in 'esmprep' functions' hierarchy.
#' # ------------------------
#' # Extract the item names of the raw ESM datasets. rmInvLs[["dfValid"]]
#' # is one of the results from function 'rmInvalid'
#' plausibItems <- esItems(dfList=rmInvLs[["dfValid"]], RELEVANTVN_ES)
#' # ----------------------------------------------------------------------------------
#' # FUNCTION  NAME: esPlausible
#' # --------------
#' # Don't run independently. Run function 11 of 28 in 'esmprep' functions' hierarchy.
#' # ------------------------
#' # Help checking the plausibility of items in the raw ESM datasets. rmInvLs[["dfValid"]]
#' # is one of the results from function 'rmInvalid'.
#' # plausibItems is the result of function 'esItems'.
#' plausibLs <- esPlausible(dfList=rmInvLs[["dfValid"]], itemVecList=plausibItems)
#' # Display the results (4 data frames) to the console
#' # plausibNames gives an overview of the item names across all ESM versions
#' plausibLs[["plausibNames"]]
#' # plausibClass gives an overview of the variable types of all items
#' plausibLs[["plausibClass"]]
#' # plausibRowNa shows for each ESM version the number of lines in the raw
#' # ESM datasets and how much percent of the data is missing (NAs).
#' plausibLs[["plausibRowNa"]]
#' # plausibMinMax shows for each numeric variable the minimum and maximum.
#' plausibLs[["plausibMinMax"]]
#' # ----------------------------------------------------------------------------------
#' # FUNCTION  NAME: esComplete
#' # --------------
#' # Don't run independently. Run function 12 of 28 in 'esmprep' functions' hierarchy.
#' # ------------------------
#' # Generate second argument of function 'esComplete'. It's strongly recommended
#' # to read the explantion of this 2nd argument in the 'esmprep' vignette, function
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
#' # ----------------------------------------------------------------------------------
#' # FUNCTION  NAME: esMerge
#' # --------------
#' # Don't run independently. Run function 13 of 28 in 'esmprep' functions' hierarchy.
#' # ------------------------
#' # Merge all raw ESM datasets. isCompleteLs is the result
#' # of function 'esComplete'.
#' esMerged <- esMerge(isCompleteLs, RELEVANTVN_ES)
#' # If preferred convert the 15 digit IMEI number from scientfic notation to text.
#' esMerged[,RELEVANTVN_ES[["ES_IMEI"]]] <- as.character(esMerged[,RELEVANTVN_ES[["ES_IMEI"]]])
#' # ----------------------------------------------------------------------------------
#' # FUNCTION  NAME: findChars
#' # --------------
#' # Don't run independently. Run function 14 of 28 in 'esmprep' functions' hierarchy.
#' # ------------------------
#' # esMerged is the result of function 'esMerge'
#' findTextIdx <- findChars(esMerged)
#' # Display structure of function output
#' str(findTextIdx)
#' # ----------------------------------------------------------------------------------
#' # FUNCTION  NAME: convertChars
#' # --------------
#' # Don't run independently. Run function 15 of 28 in 'esmprep' functions' hierarchy.
#' # ------------------------
#' # From result of function 'findChars' select the indices of the items
#' # in the ESM dataset that contain text answers of the participants.
#' findTextIdx1 <- findTextIdx[c(1,2,9,10)]
#' # Use findTextIdx1 to generate the 3rd argument of function 'convertChars'.
#' textColumns <- names(findTextIdx1)
#' # Generate data.frame specifying the conversion of single characters.
#' # Since R doesn't permit umlauts (non-ASCII characters) to be contained in datasets,
#' # which are attached to a package, this function cannot be presented the way it was
#' # intended, i.e. in the exemplary datasets there are no umlauts (non-ASCII characters), 
#' # therefore nothing REALLY gets converted. However, the function aims at converting
#' # troublesome characters, like umlauts, to less troublesome alternatives.
#' convertCharsDf <- data.frame(c("ä", "ü"), c("ae", "ue"))
#' # Apply function. esMerged is the result of function 'esMerge'.
#' esMerged1 <- convertChars(esMerged, textColumns, convertCharsDf)
#' # # As default upper and lower case are NOT ignored! If you want them
#' # # ignored, additionally pass TRUE to the argument ignoreCase, like this:
#' # convertChars(esMerged, textColumns, convertCharsDf, ignoreCase=TRUE)
#' # ----------------------------------------------------------------------------------
#' # FUNCTION  NAME: esAssign
#' # --------------
#' # Don't run independently. Run function 16 of 28 in 'esmprep' functions' hierarchy.
#' # ------------------------
#' # Assign questionnaires contained in the raw ESM dataset to all participants listed
#' # in the reference dataset. esMerged1 is the result of function 'convertChars',
#' # referenceDfNew is the result of function 'genDateTime' or of function
#' # 'splitDateTime'.
#' esAssigned <- esAssign(esDf = esMerged1, refDf = referenceDfNew, RELEVANTINFO_ES,
#' RELEVANTVN_ES, RELEVANTVN_REF)
#' # Assign questionnaires contained in the raw ESM dataset to participant P001 listed
#' # in the reference dataset.
#' # # DON'T RUN, unless you want to see the output solely for participant P001.
#' # esAssigned <- esAssign(esDf = esMerged1, refDf = referenceDfNew, RELEVANTINFO_ES,
#' # RELEVANTVN_ES, RELEVANTVN_REF, singlePerson="P001")
#' # More options can be passed to 'esAssign', see parameter description. Note that when
#' # setting the argument midnightPrompt to TRUE, esAssign takes a bit longer to do its job.
#' # Output: List with 4 data.frames.
#' names(esAssigned)
#' # ----------------------------------------------------------------------------------
#' # FUNCTION  NAME: missingEndDateTime
#' # --------------
#' # Don't run independently. Run function 17 of 28 in 'esmprep' functions' hierarchy.
#' # ------------------------
#' # esAssigned[["ES"]] is one of the results of function 'esAssign'.
#' noEndDf <- missingEndDateTime(esAssigned[["ES"]], RELEVANTVN_ES)
#' # ----------------------------------------------------------------------------------
#' # FUNCTION  NAME: relevantREFVN
#' # --------------
#' # Don't run independently. Run function 18 of 28 in 'esmprep' functions' hierarchy.
#' # ------------------------
#' # noEndDf is the result of function 'noEndDateTime'.
#' identDf <- esIdentical(noEndDf, RELEVANTVN_ES)
#' # ----------------------------------------------------------------------------------
#' # FUNCTION  NAME: suggestShift
#' # --------------
#' # Don't run independently. Run function 19 of 28 in 'esmprep' functions' hierarchy.
#' # ------------------------
#' # identDf is the result of function 'esIdentical'.
#' # 100 represents the number of minutes that at least must have passed
#' # between the scheduled start of an ESM questionnaire at its actual start
#' # in order for the questionnaire to be eligible for shifting (see function
#' # makeShift).
#' sugShift <- suggestShift(identDf, 100, RELEVANTINFO_ES, RELEVANTVN_ES)
#' # Display output element 'suggestShiftDf':
#' sugShift$suggestShiftDf
#' # Display output element 'printShiftDf':
#' sugShift$printShiftDf
#' # ----------------------------------------------------------------------------------
#' # FUNCTION  NAME: printSuggestedShift
#' # --------------
#' # Don't run independently. Run function 20 of 28 in 'esmprep' functions' hierarchy.
#' # ------------------------
#' # Display the result of function 'suggestShift' in the console.
#' printSuggestedShift(sugShift, RELEVANTVN_ES)
#' # ----------------------------------------------------------------------------------
#' # FUNCTION  NAME: makeShift
#' # --------------
#' # Don't run independently. Run function 21 of 28 in 'esmprep' functions' hierarchy.
#' # ------------------------
#' # sugShift is the result of function 'suggestShift'. referenceDfNew is the result
#' # of function 'genDateTime' or of function 'splitDateTime'.
#' # keyPromptDf is generated by using part of the output of function suggestShift,
#' # i.e. by selecting the columns NEW_PROMPT and SHIFTKEY from suggestShiftDf.
#' keyPromptDf <- sugShift$suggestShiftDf[,c("NEW_PROMPT", "SHIFTKEY")]
#' madeShift <- makeShift(sugShift, referenceDfNew, keyPromptDf, RELEVANTINFO_ES, RELEVANTVN_REF)
#' # Tip! Display the result of function 'makeShift' in the console
#' # in order to check whether the shifting was successful.
#' printSuggestedShift(madeShift, RELEVANTVN_ES)
#' # ----------------------------------------------------------------------------------
#' # FUNCTION  NAME: expectedPromptIndex
#' # --------------
#' # Don't run independently. Run function 22 of 28 in 'esmprep' functions' hierarchy.
#' # ------------------------
#' # Generate second argument of function 'expectedPromptIndex'. It's strongly
#' # recommended to read the explanation of this 2nd argument in the 'esmprep'
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
#' # simply use the result of function suggestShift as 1st argument.
#' # ----------------------------------------------------------------------------------
#' # FUNCTION  NAME: intolerable
#' # --------------
#' # Don't run independently. Run function 23 of 28 in 'esmprep' functions' hierarchy.
#' # ------------------------
#' # Generate second argument of function 'intolerable'
#' (intoleranceDf <- data.frame(
#' # Column 'prompt': Prompts that must NEVER be comined with expected categories.
#' prompt = c(2, 3, 4, 1, 1),
#' # Column 'expect': Expected categories that must NEVER be combined with the prompts.
#' expect = c(1, 1, 1, 2, 3)))
#' # Read: Prompts 2, 3, and 4 must never be combined with expected category 1.
#' # Read: Prompt 1 must never be combined with expected category 2.
#' # Read: Prompt 1 must never be combined with expected category 3.
#' # expectedDf is the result of function 'expectedPromptIndex'.
#' intolLs <- intolerable(expectedDf, intoleranceDf, RELEVANTINFO_ES)
#' # ----------------------------------------------------------------------------------
#' # FUNCTION  NAME: randomMultSelection
#' # --------------
#' # Don't run independently. Run function 24 of 28 in 'esmprep' functions' hierarchy.
#' # ------------------------
#' # intolLs[["cleanedDf"]] is the result of function 'intolerable'.
#' randSelLs <- randomMultSelection(intolLs[["cleanedDf"]])
#' # ----------------------------------------------------------------------------------
#' # FUNCTION  NAME: computeTimeLag
#' # --------------
#' # Don't run independently. Run function 25 of 28 in 'esmprep' functions' hierarchy.
#' # ------------------------
#' # randSelLs[["esRandSelIn"]] is the result of function 'randomMultSelection'.
#' lagDf <- computeTimeLag(randSelLs[["esRandSelIn"]], RELEVANTVN_ES)
#' # ----------------------------------------------------------------------------------
#' # FUNCTION  NAME: computeDuration
#' # --------------
#' # Don't run independently. Run function 26 of 28 in 'esmprep' functions' hierarchy.
#' # ------------------------
#' # lagDf is the result of function 'lagDf'.
#' durDf <- computeDuration(lagDf, RELEVANTVN_ES)
#' # ----------------------------------------------------------------------------------
#' # FUNCTION  NAME: computeTimeBetween
#' # --------------
#' # Don't run independently. Run function 27 of 28 in 'esmprep' functions' hierarchy.
#' # ------------------------
#' # durDf is the result of function 'computeDuration'.
#' tbsqDf <- computeTimeBetween(esDf = durDf, refDf = referenceDfNew, RELEVANTVN_ES,
#' RELEVANTVN_REF)
#' # ----------------------------------------------------------------------------------
#' # FUNCTION  NAME: esFinal
#' # --------------
#' # Don't run independently. Run function 28 of 28 in 'esmprep' functions' hierarchy.
#' # ------------------------
#' # tbsqDf is the result of function 'computeTimeBetween'.
#' esDfFin <- esFinal(tbsqDf, RELEVANTINFO_ES, RELEVANTVN_ES)}

#' @name esmprep
NULL
