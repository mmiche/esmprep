# esmprep package
# ---------------
#
# -------------------------------------------------------------------------
# This is an examplary R script for the simulated ESM datasets of the
# esmprep package.
#
# The esmprep package consists of a hierarchy of currently 29 functions
# that lead up to a final ESM dataset, ready for statistical analysis.
# -------------------------------------------------------------------------
#
# -------------------------------------------------------------------------
# README start:
# -------------------------------------------------------------------------
# ESM category 1 'C1':
# -------------------
# 1. There is exactly 1 ESM version, meaning that participants were
#	 administered the very same questions during each single ESM day.
#	 E.g. a questionnaire in the morning did not differ whatsoever
#	 from a questionnaire at any other time of the day.
# 2. All ESM questionnaires during a day were prompted, i.e. some sort of
#	 signal at (a) certain scheduled time(s) during each day prompted the
#	 participant to fill out the questionnaire.
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# If 1 and 2 are true, use this R-script (esmprepScriptC1en.R) as template.
# -------------------------------------------------------------------------
# README end.
# -------------------------------------------------------------------------
#
# -------------------------------------------------------------------------
# Load package esmprep (package lubridate will be automatically loaded)
# --------------------------------------------------------------------
library(esmprep)
#
# # Help page of the package
# help(package=esmprep)
#
# # List all function names with their head (not with the body)
# lsf.str("package:esmprep")
#
# # Overall number of functions
# length(lsf.str("package:esmprep"))
#
# # List all objects in the package (31 functions and 7 exemplary datasets)
# cbind(ls("package:esmprep"))
#
# ------------------------------------------------------------------------------
# E X E M P L A R Y   E S M   D A T A   P R E P A R A T I O N    S  T  A  R  T
#
# If you mark all of the code and then execute it, at the end of the computing
# process you'll the time it took for this script to run through.
esmprepStart <- Sys.time()
#
# Reference dataset
# o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o
# Convert the 15 digit IMEI number from scientfic notation to text.
referenceDf$imei <- as.character(referenceDf$imei)
# Display the whole dataset in the console
referenceDf
# o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o
#
#
# 1 relevantREFVN
# o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o
# Run (function 1 of 28; see esmprep functions' hierarchy)
# --------------------------------------------------------
# With date and time as separate arguments
relRef <- relevantREFVN(ID="id", IMEI="imei", ST="st",
STARTDATE="start_date", STARTTIME="start_time",
ENDDATE="end_date", ENDTIME="end_time")
# o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o
#
# 2 setREF
# o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o
# Run (function 2 of 28; see esmprep functions' hierarchy)
# --------------------------------------------------------
# 4 is the number of daily prompts.
# relRef is the result of function 'relevantREFVN'
RELEVANTVN_REF <- setREF(4, relRef)
#
# Relevant variables names of reference dataset.
RELEVANTVN_REF
# o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o
#
# Run this function at any time.
dateTimeFormats()
# Run this function at any time.
dateTimeFormats2()
#
#
# 3 relevantESVN
# o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o
# Run (function 3 of 28; see esmprep functions' hierarchy)
# --------------------------------------------------------
# With date and time as separate arguments
relEs <- relevantESVN(svyName="survey_name", IMEI="IMEI",
STARTDATE="start_date", STARTTIME="start_time",
ENDDATE="end_date", ENDTIME="end_time")
# o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o
#
# 4 setES
# o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o
# Run (function 4 of 28; see esmprep functions' hierarchy)
# --------------------------------------------------------
# imeiNumbers is the vector containing all IMEI numbers used in
# the ESM study; use the respective entries in the referenceDf.
imeiNumbers <- referenceDf$imei
# surveyNames is the vector containing all ESM version names.
surveyNames <- c(
# Control group
   "dayControlGroup")
# 4 is the number of daily prompts
# relEs is the result of function 'relevantESVN'
RELEVANT_ES <- setES(4, imeiNumbers, surveyNames, relEs)
#
# Extract relevant ESM general information
RELEVANTINFO_ES <- RELEVANT_ES[["RELEVANTINFO_ES"]]
#
# Extract list of relevant variables names of raw ESM datasets.
RELEVANTVN_ES <- RELEVANT_ES[["RELEVANTVN_ES"]]
# o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o
#
#
# 5 esList
# o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o
# Run (function 5 of 28; see esmprep functions' hierarchy)
# --------------------------------------------------------
# Use day dataset (control group) of the 6 exemplary raw ESM (sub-)datasets.
esLs <- esList(list(dayControl), RELEVANTVN_ES)
#
# Initial set of column names (across all raw ESM datasets)
colNames5 <- unique(unlist(sapply(esLs, FUN = names)))
# o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o
#
#
# 6 genKey
# o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o
# Run (function 6 of 28; see esmprep functions' hierarchy)
# --------------------------------------------------------
# esLs is the result of function 'esList'.
keyLs <- genKey(esLs)
#
# Column names after applying function 'genKey'
colNames6 <- unique(unlist(sapply(keyLs, FUN = names)))
#
# New column names since prior function 'esList'
colNames6[!(colNames6 %in% colNames5)]
# o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o
#
# 7a genDateTime
# o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o
# Run (function 7 of 28; see esmprep functions' hierarchy)
# --------------------------------------------------------
# Applying function to reference dataset (7th a)
referenceDfList <- genDateTime(referenceDf, "REF", RELEVANTINFO_ES, RELEVANTVN_ES, RELEVANTVN_REF)
#
# Extract reference dataset from output
referenceDfNew <- referenceDfList[["refOrEsDf"]]
names(referenceDfNew)
#
# Extract extended list of relevant variables names of reference dataset
RELEVANTVN_REF <- referenceDfList[["extendedVNList"]]
# o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o
#
#
# 7b genDateTime
# o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o
# Applying function to raw ESM dataset(s) (7th b)
# keyLs is the result of function 'genKey'.
keyList <- genDateTime(keyLs, "ES", RELEVANTINFO_ES, RELEVANTVN_ES, RELEVANTVN_REF)
#
# Extract list of raw ESM datasets from output
keyLsNew <- keyList[["refOrEsDf"]]
#
# Extract extended list of relevant variables names of raw ESM datasets
RELEVANTVN_ES <- keyList[["extendedVNList"]]
#
# Column names after applying function 'genDateTime' with the ESM datasets.
colNames7 <- unique(unlist(sapply(keyLsNew, FUN = names)))
#
# New column names since prior function 'genDateTime'
colNames7[!(colNames7 %in% colNames6)]
# o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o
#
#
# 8 rmInvalid
# o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o
# Run (function 8 of 28; see esmprep functions' hierarchy)
# --------------------------------------------------------
# keyLsNew is the result of function 'genDateTime' (or of function 'splitDateTime').
rmInvLs <- rmInvalid(keyLsNew, RELEVANTVN_ES)
# Result of function 'rmInvalid' is a list with 4 elements:
names(rmInvLs)
#
# The raw ESM datasets are still separated within the list 'rmInvLs';
# each list element is named according to the ESM version it contains.
names(rmInvLs[["dfValid"]])
#
# Detailed overview of lines removed from the single raw ESM datasets:
rmInvLs[["listInvalid"]]
#
# The list element 'rmInvalidDfFinished' is relevant not for the user
# but for the function 'printRmInvalid' which is directly associated
# with the function 'rmInvalid'.
rmInvLs[["rmInvalidDfFinished"]]
#
length(rmInvLs[["noLinesRemovedAtAll"]])
rmInvLs[["noLinesRemovedAtAll"]]
# o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o
#
#
# 9 printRmInvalid
# o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o
# Run (function 9 of 28; see esmprep functions' hierarchy)
# --------------------------------------------------------
# rmInvLs is the result of function 'rmInvalid'. Display its result
# in the console both tablulated and in detail.
key_rmLs <- printRmInvalid(rmInvLs, smr="both", RELEVANTVN_ES)
# Display the list containing the KEY values of all questionnaires
# that have been removed.
key_rmLs
#
# Since there have been a warning message in the dataset, the first
# ESM item (name: V1) was automatically converted to class character,
# although it is numeric. So we'll re-convert V1's class.
# Check V1 prior to conversion
str(rmInvLs[["dfValid"]][[1]][1:2])
# Convert V1 from character to numeric
rmInvLs[["dfValid"]][[1]][,"V1"] <- as.numeric(rmInvLs[["dfValid"]][[1]][,"V1"])
#
#
# Check V1 after conversion
str(rmInvLs[["dfValid"]][[1]][1:2])
# o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o
#
# Plausibility check
# ------------------
# 10 esItems
# o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o
# Run (function 10 of 28; see esmprep functions' hierarchy)
# ---------------------------------------------------------
# Extract the item names of the raw ESM datasets. rmInvLs[["dfValid"]]
# is one of the results from function 'rmInvalid'
plausibItems <- esItems(dfList=rmInvLs[["dfValid"]], RELEVANTVN_ES)
# o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o
#
# 11 esPlausible
# o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o
# Run (function 11 of 28; see esmprep functions' hierarchy)
# ---------------------------------------------------------
# --->>> FUNCTION 'esPlausible' DOESN'T WORK FOR SINGLE ESM VERSION.
# Reason: None of the potential problems can occur, compared to the problems
#		  that can occur when multiple ESM versions are used!
#
# --->>> THEREFORE: SKIP FUNCTION 'esPlausible'.
#		 --------------------------------------
#
#
#
# o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o
#
#
# 12 esComplete
# o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o
# Run (function 12 of 28; see esmprep functions' hierarchy)
# ---------------------------------------------------------
# Generate second argument of function 'esComplete'. It's strongly recommended
# to read the explantion of this 2nd argument in the esmprep vignette, function
# 'esComplete'.
lastItemList <- list(
# In survey version "dayTestGroup" variable "V7" is the last item expected to contain data;
# unlike above, no conditions; NA as 2nd and 3rd element of the inner list are mandatory.
list("dayControlGroup", NA, NA, "V7"))
#
#
#
#
#
#
# --->>> EMPTY SPACE (compare R-script 'esmprepScriptC4')
#
#
#
#
#
#
#
# Apply function 'esComplete'. rmInvLs[["dfValid"]] is one of the results of function
# rmInvalid.
isCompleteLs <- esComplete(rmInvLs[["dfValid"]], lastItemList)
#
# Overview (table)
# -----------------
# Within raw ESM dataset 'dayControlGroup_1' there are 9 incomplete questionnaires
table(isCompleteLs[["dayControlGroup_1"]]["INCOMPLETE"])
#
#
#
#
# --->>> EMPTY SPACE (compare R-script 'esmprepScriptC4')
#
#
#
#
# Column names after applying function 'esComplete'.
colNames12 <- unique(unlist(sapply(isCompleteLs, FUN = names)))
#
# New column names since prior function 'esComplete'
colNames12[!(colNames12 %in% colNames7)]
# o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o
#
#
# 13 esMerge
# o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o
# Run (function 13 of 28; see esmprep functions' hierarchy)
# ---------------------------------------------------------
# --->>> FUNCTION 'esMerge' DOESN'T WORK FOR SINGLE ESM VERSION.
# Reason: Merging makes sense only if you have more than 1 dataset.
#
# --->>> THEREFORE: SKIP FUNCTION 'esMerge'.
#		 -----------------------------------
# o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o
#
#
# --->>> EMPTY SPACE (compare R-script 'esmprepScriptC4')
#
#
# 14 findChars
# o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o
# Run (function 14 of 28; see esmprep functions' hierarchy)
# ---------------------------------------------------------
# isCompleteLs is the result of function 'esComplete'. Pass argument as data.frame.
findTextIdx <- findChars(isCompleteLs[["dayControlGroup_1"]])
# Display structure of function output
str(findTextIdx)
# o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o
#
#
# 15 convertChars
# o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o
# Run (function 15 of 28; see esmprep functions' hierarchy)
# ---------------------------------------------------------
# From result of function 'findChars' select the indices of the items
# in the ESM dataset that contain text answers of the participants.
findTextIdx1 <- findTextIdx[c(1,2)]
# Use findTextIdx1 to generate the 3rd argument of function 'convertChars'.
textColumns <- names(findTextIdx1)
#
# Generate data.frame specifying the conversion of single characters.
# Convert Umlaute to unified use (e.g. ä as ae)
umlauteOnLow <- c("ä", "ö", "ü", "ß", "é", "è", "à")
umlauteOffLow <- c("ae", "oe", "ue", "ss", "e", "e", "a")
umlauteOffUp <- c("Ae", "Oe", "Ue", "E", "E", "A")
umlauteOn <- c(umlauteOnLow, toupper(umlauteOnLow[!umlauteOnLow=="ß"]))
umlauteOff <- c(umlauteOffLow, umlauteOffUp)
#
(convertCharsDf <- data.frame(umlauteOn, umlauteOff))
#
# Check prior to conversion:
isCompleteLs[["dayControlGroup_1"]][1:20,findTextIdx1]
#
# Apply function. esMerged is the result of function 'esMerge'.
esConverted <- convertChars(isCompleteLs[["dayControlGroup_1"]], textColumns, convertCharsDf)
#
# Check after conversion:
esConverted[1:20,findTextIdx1]
# o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o
#
#
# 16 esAssign
# o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o
# Run (function 16 of 28; see esmprep functions' hierarchy)
# ---------------------------------------------------------
#
# # Assign questionnaires contained in the raw ESM dataset to participant P001 listed
# # in the reference dataset.
# esAssigned <- esAssign(esDf = esMerged1, refDf = referenceDfNew, RELEVANTINFO_ES,
# RELEVANTVN_ES, RELEVANTVN_REF, singlePerson="P001")
#
# Assign questionnaires contained in the raw ESM dataset to all participants listed
# in the reference dataset. esMerged1 is the result of function 'convertChars',
# referenceDfNew is the result of function 'genDateTime' or of function
# 'splitDateTime'.
esAssigned <- esAssign(esDf = esConverted, refDf = referenceDfNew, RELEVANTINFO_ES,
RELEVANTVN_ES, RELEVANTVN_REF, promptTimeframe=30, dstDates = "2007-10-28")
#
# More options can be passed to 'esAssign', see parameter description.
# Output: List with 4 data.frames.
names(esAssigned)
#
# Column names of current raw ESM dataset
names(esAssigned$ES)
#
# Column names of optimal ESM sequence for all participants (if no questionnaires were
# missed).
names(esAssigned$ESopt)
#
# Excerpt of first 30 rows:
esAssigned$ESopt[1:30,]
#
# Preliminary completion rates (per prompt and overall)
esAssigned$ESrate
#
# Column names after applying function 'esAssign'.
colNames16 <- names(esAssigned$ES)
#
# New column names since prior function 'esAssign'
colNames16[!(colNames16 %in% colNames12)]
# o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o
#
#
# 17 missingEndDateTime
# o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o
# Run (function 17 of 28; see esmprep functions' hierarchy)
# ---------------------------------------------------------
# esAssigned[["ES"]] is one of the results of function 'esAssign'.
noEndDf <- missingEndDateTime(esAssigned[["ES"]], RELEVANTVN_ES)
# Display overview
table(noEndDf$NOENDDATE)
#
# Column names after applying function 'missingEndDateTime'.
colNames17 <- names(noEndDf)
#
# New column names since prior function 'missingEndDateTime'
colNames17[!(colNames17 %in% colNames16)]
# o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o
#
#
# Collect variables that don't specify ESM questionnaire items
(notItems <- as.character(unlist(RELEVANTVN_ES)))
#
# Ad hoc descriptive summary:
# --------------------------
# How many questionnaire versions are among the unfinished questionnaires?
unique(noEndDf[noEndDf$NOENDDATE==1, notItems[1]])
#
# How many phones with unfinished questionnaires on them?
unique(noEndDf[noEndDf$NOENDDATE==1, notItems[2]])
#
# How many different persons had at least one unfinished questionnaire?
unique(as.character(noEndDf[noEndDf$NOENDDATE==1, "ID"]))
#
#
# 18 esIdentical
# o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o
# Run (function 18 of 28; see esmprep functions' hierarchy)
# ---------------------------------------------------------
# noEndDf is the result of function 'noEndDateTime'.
identDf <- esIdentical(noEndDf, RELEVANTVN_ES)
#
# Column names after applying function 'esIdentical'.
colNames18 <- names(identDf)
#
# New column names since prior function 'esIdentical'
colNames18[!(colNames18 %in% colNames17)]
#
# Display excerpt of current raw ESM dataset with identical rows of data:
identDf[identDf$IDENT==1,c("ID", "KEY", notItems[-1], "ES_MULT", "ES_MULT2", "IDENT")]
# o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o
#
#
# 19 suggestShift
# o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o
# Run (function 19 of 28; see esmprep functions' hierarchy)
# ---------------------------------------------------------
# identDf is the result of function 'esIdentical'.
# 100 represents the number of minutes that at least must have passed
# between the scheduled start of an ESM questionnaire at its actual start
# in order for the questionnaire to be eligible for shifting (see function
# makeShift).
sugShift <- suggestShift(identDf, 100, RELEVANTINFO_ES, RELEVANTVN_ES)
# Display output element 'suggestShiftDf':
sugShift$suggestShiftDf
# Display output element 'printShiftDf':
sugShift$printShiftDf
#
# Column names after applying function 'esIdentical'.
colNames19 <- names(sugShift$esDf)
#
# New column names since prior function 'esIdentical'
colNames19[!(colNames19 %in% colNames18)]
# o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o
#
#
# 20 printSuggestedShift
# o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o
# Run (function 20 of 28; see esmprep functions' hierarchy)
# ---------------------------------------------------------
# Display the result of function 'suggestShift' in the console.
printSuggestedShift(sugShift, RELEVANTVN_ES)
# o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o
#
#
# 21 makeShift
# o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o
# Run (function 21 of 28; see esmprep functions' hierarchy)
# ---------------------------------------------------------
# sugShift is the result of function 'suggestShift'. referenceDfNew is the result
# of function 'genDateTime' or of function 'splitDateTime'.
# keyPromptDf is generated by using part of the output of function suggestShift,
# i.e. by selecting the columns NEW_PROMPT and SHIFTKEY from suggestShiftDf.
keyPromptDf <- sugShift$suggestShiftDf[,c("NEW_PROMPT", "SHIFTKEY")]
madeShift <- makeShift(sugShift, referenceDfNew, keyPromptDf, RELEVANTINFO_ES, RELEVANTVN_REF)
#
# Result of function makeShift is a list. List element no.1:
# --------------------------------------
madeShift$suggestedShiftDf
#
# Result of function makeShift is a list. List element no.2:
# --------------------------------------
madeShift$printShiftDf
#
# Column names after applying function 'makeShift'.
colNames21 <- names(madeShift$esDf)
#
# New column names since prior function 'makeShift'
colNames21[!(colNames21 %in% colNames19)]
#
# Tip! Display the result of function 'makeShift' in the console
# in order to check whether the shifting was successful.
printSuggestedShift(madeShift, RELEVANTVN_ES)
# o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o
#
#
# 22 expectedPromptIndex
# o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o
# Generate 2nd argument of function 'expectedPromptIndex'
# -------------------------------------------------------
# Run (function 22 of 28; see esmprep functions' hierarchy)
# ---------------------------------------------------------

# o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o
#
#
# 23 intolerable
# o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o
# Run (function 23 of 28; see esmprep functions' hierarchy)
# ---------------------------------------------------------

# o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o
#
#
# 24 randomMultSelection
# o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o
# Run (function 24 of 28; see esmprep functions' hierarchy)
# ---------------------------------------------------------
# intolLs[["cleanedDf"]] is the result of function 'intolerable'.
randSelLs <- randomMultSelection(madeShift$esDf)
#
# Output of function 'randomMultSelection'
names(randSelLs)
#
# No new column names since prior function 'randomMultSelection'
# o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o
#
#
# 25 computeTimeLag
# o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o
# Run (function 25 of 28; see esmprep functions' hierarchy)
# ---------------------------------------------------------
# randSelLs[["esRandSelIn"]] is the result of function 'randomMultSelection'.
lagDf <- computeTimeLag(randSelLs[["esRandSelIn"]], RELEVANTVN_ES)
#
# Column names after applying function 'computeTimeLag'.
colNames25 <- names(lagDf)
#
# New column names since prior function 'computeTimeLag'
colNames25[!(colNames25 %in% colNames21)]
# o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o
#
#
# 26 computeDuration
# o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o
# Run (function 26 of 28; see esmprep functions' hierarchy)
# ---------------------------------------------------------
# lagDf is the result of function 'lagDf'.
durDf <- computeDuration(lagDf, RELEVANTVN_ES)
#
# Column names after applying function 'computeTimeLag'.
colNames26 <- names(durDf)
#
# New column names since prior function 'computeTimeLag'
colNames26[!(colNames26 %in% colNames25)]
# o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o
#
#
# 27 computeTimeBetween
# o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o
# Run (function 27 of 28; see esmprep functions' hierarchy)
# ---------------------------------------------------------
# durDf is the result of function 'computeDuration'.
tbsqDf <- computeTimeBetween(esDf = durDf, refDf = referenceDfNew, RELEVANTVN_ES, RELEVANTVN_REF)
#
# Column names after applying function 'computeTimeBetween'.
colNames27 <- names(tbsqDf)
#
# New column names since prior function 'computeTimeBetween'
colNames27[!(colNames27 %in% colNames26)]
# o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o
#
#
# 28
# o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o
# Run (function 28 of 28; see esmprep functions' hierarchy)
# ---------------------------------------------------------
# tbsqDf is the result of function 'computeTimeBetween'.
esDfFin <- esFinal(tbsqDf, RELEVANTINFO_ES, RELEVANTVN_ES)
#
# Column names after applying function 'computeTimeBetween'.
colNames28 <- names(esDfFin)
#
# New column names since prior function 'computeTimeBetween'
colNames28[!(colNames28 %in% colNames27)]
#
# rows and columns prior to applying function 'esFinal'
dim(tbsqDf)
#
# Rows and columns after applying function 'esFinal'
dim(esDfFin)
# o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o-o
#
esmprepEnd <- Sys.time()
#
# Time which it took for all functions to run through the exemplary data:
difftime(esmprepEnd, esmprepStart, units="secs")
#
# E X E M P L A R Y   E S M   D A T A   P R E P A R A T I O N    E  N  D
# ------------------------------------------------------------------------------