#' findChars
#
#' @description findChars picks all variables from the (merged) ESM dataset that are of the class character.
#
#' @param esDf a data.frame. A single ESM dataset. It must contain the 2 columns that hold the date-time object for when an ESM questionnaire was started and finished, respectively.
#
#' @details \code{findChars} prints to the console the structure of all variables in \code{esDf} that contain character values (i.e. text). Among these variables (the index of which is returned by the function) the user can select those that are suitable to apply the function \code{\link{convertChars}} to.
#
#' @return Indices (with corresponding variable names as attributes) of the columns of \code{esDf}, containing character strings. See \strong{Details} for more information and see \strong{Examples}.
#
#' @importFrom utils str
#
#' @examples
#' # o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o
#' # Prerequisites in order to execute findChars. Start ----------------
#' # Use example list delivered with the package
#' RELEVANTVN_ES <- RELEVANTVN_ESext
#' # isCompleteLs is a list of datasets, also delivered with the package
#' esMerged <- esMerge(isCompleteLs, RELEVANTVN_ES)
#' esMerged[,RELEVANTVN_ES[["ES_IMEI"]]] <- as.character(esMerged[,RELEVANTVN_ES[["ES_IMEI"]]])
#' # Prerequisites in order to execute findChars. End ------------------
#' # -------------------------------------------------------
#' # Run function 15 of 29; see esmprep functions' hierarchy.
#' # -------------------------------------------------------
#' # esMerged is the result of function 'esMerge'
#' findTextIdx <- findChars(esMerged)
#' # Display structure of function output
#' str(findTextIdx)
#' # o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o
#
#' @seealso Exemplary code (fully executable) in the documentation of \code{\link{esmprep}} (function 15 of 29).
#
#' @export
#
findChars <- function(esDf) {

    if(!is.data.frame(esDf)) {
        stop("Argument must be of class data.frame")
    }
    charClass <- which(sapply(esDf, FUN = is.character) == TRUE)

    print(str(esDf[,charClass]))

    return(charClass)
}
