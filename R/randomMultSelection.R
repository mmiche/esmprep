#' randomMultSelection
#
#' @description randomMultSelection selects ESM questionnaires randomly as specified by the user.
#
#' @param esDf a data.frame. A single ESM dataset. It must contain the 2 columns that hold the date-time object for when an ESM questionnaire was started and finished, respectively.
#
#' @details If \code{randomMultSelection} has to be applied it should better be applied only once at the very end of the study. Otherwise the randomness of the selection no longer holds.
#
#' @return The user receives a list containing 2 datasets:
#' \enumerate{
#' \item esRandSelIn, i.e. the ESM dataset with the lines of data, of which some had to be randomly selected
#' \item esRandSelOut, i.e. the lines of data that had to be randomly removed.
#' }
#' See \strong{Details} for more information.
#
#' @examples
#' # o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o
#' # Prerequisites in order to execute randomMultSelection. Start ------
#' # RELEVANTINFO_ES is delivered with the package
#' intoleranceDf <- data.frame(prompt = c(2, 3, 4, 1, 1),
#' expect = c(1, 1, 1, 2, 3))
#' # expectedDf is a raw ESM dataset, delivered with the package.
#' intolLs <- intolerable(expectedDf, intoleranceDf, RELEVANTINFO_ES)
#' # Prerequisites in order to execute randomMultSelection. End --------
#' # -------------------------------------------------------
#' # Run function 25 of 29; see esmprep functions' hierarchy.
#' # -------------------------------------------------------
#' # intolLs[["cleanedDf"]] is the result of function 'intolerable'.
#' randSelLs <- randomMultSelection(intolLs[["cleanedDf"]])
#' # o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o
#
#' @seealso Exemplary code (fully executable) in the documentation of \code{\link{esmprep}} (function 25 of 29).
#
#' @export
#
randomMultSelection <- function(esDf) {

    dfCheck <- is.data.frame(esDf)

    # If argument 'esVersion' is not of class data.frame stop the processing.
    if(dfCheck == FALSE) {
        stop("First argument must be a data frame.")
    }

    esDf <- cumsumReset(esDf, "ES_MULT")

    idxMultRows <- rep(0, times = nrow(esDf))
    # Set up a new index variable
    idxMultRows1 <- which(esDf[,"ES_MULT2"] != 0)
    # Set 1 for ALL EMA questionnaires which are relevant in the random selection process
    idxMultRows [idxMultRows1] <- 1

    # Another variable that helps in the process of random selection.
    diffMult <- c(0, diff(esDf[idxMultRows == 1,"ES_MULT2"]))

    dfRand <- data.frame(esDf [idxMultRows == 1 , c("ID", "KEY", "ES_START_DATETIME", "ES_MULT", "ES_MULT2")], diffMult)

    # Find out the number of multiple questionnaires per scheduled time
    multStep <- c()
    for(i in 2 : nrow(dfRand)) {
        if(dfRand[i,"diffMult"] < 0) {
            multStep <- c(multStep, dfRand[i-1,"ES_MULT2"])
        }
        if(i == nrow(dfRand)) {
            multStep <- c(multStep, 2)
        }
    }

    # random selection entity, rows that will stay, rows that will be removed:
    randEnt <- rowStays <- rowsRemove <- c()
    for(i in 1 : length(multStep)) {
        # collect single entity from which one questionnaire will be selected
        # and from which the rest will be dropped.
        randEnt <- c(randEnt, rep(i, times = multStep[i]))
        # Register instance i by its KEY value
        pickFromRows <- dfRand[,"KEY"] [which(randEnt == i)]
        # Pick one questionnaire randomly (base-function 'sample()')
        pickRandom <- sample(1:multStep[i], 1)
        # Collect the row index of the full EMA dataset that denotes the
        # questionnaire that will stay.
        rowStays <- c(rowStays, pickFromRows[pickRandom])
        # Collect the row index of the full EMA dataset that denotes the
        # questionnaire(s) that will be dropped.
        rowsRemove <- c(rowsRemove, pickFromRows[-pickRandom])
    }

    # Rownames refer to the row index of the full EMA dataset before the removal takes place:
    idxRemoveMult <- match(rowsRemove, esDf[,"KEY"])
    # Indices of the EMA questionnaires that will be kept in the final EMA dataset:
    idxKeepMult <- match(rowStays, esDf[,"KEY"])

    esDfValid <- esDf[-idxRemoveMult,]
    esDfOut <- esDf[idxRemoveMult,]

    list(esRandSelIn=esDfValid, esRandSelOut=esDfOut)
}
