% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/convertChars.R
\name{convertChars}
\alias{convertChars}
\title{convertChars}
\usage{
convertChars(esDf, charCols, convDf, ignoreCase = FALSE)
}
\arguments{
\item{esDf}{a data.frame. A single ESM dataset. It must contain the 2 columns that hold the date-time object for when an ESM questionnaire was started and finished, respectively.}

\item{charCols}{a vector of character strings. Each character string specifies a column name in the event sampling (raw) dataset which contains text in which specific characters shall be replaced by other characters, e.g. the dashed letter e by e.}

\item{convDf}{a data.frame. The data frame must contain exactly 2 columns, the first column specifies the characters that shall be replaced, the second column specifies the characters that are going to replace the ones in the first column.}

\item{ignoreCase}{logical. Enter TRUE if capitalization can be ignored in the course of replacement, else enter FALSE.}
}
\value{
\code{esDf} Each column which contains text (as specified by the user!) now contains the text with the specific characters being converted (as specified by the user!).
}
\description{
convertChars converts specified single characters within specified ESM variables that contain text.
}
\examples{
# o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o
# Prerequisites in order to execute convertChars. Start -------------
# Use example list delivered with the package
RELEVANTVN_ES <- RELEVANTVN_ESext
# isCompleteLs is a list of datasets, also delivered with the package
esMerged <- esMerge(isCompleteLs, RELEVANTVN_ES)
esMerged[,RELEVANTVN_ES[["ES_IMEI"]]] <- as.character(esMerged[,RELEVANTVN_ES[["ES_IMEI"]]])
findTextIdx <- findChars(esMerged)
# Prerequisites in order to execute convertChars. End ---------------
# -------------------------------------------------------
# Run function 16 of 29; see esmprep functions' hierarchy.
# -------------------------------------------------------
# From result of function 'findChars' select the indices of the items
# in the ESM dataset that contain text answers of the participants.
findTextIdx1 <- findTextIdx[c(1,2,9,10)]
# Use findTextIdx1 to generate the 3rd argument of function 'convertChars'.
textColumns <- names(findTextIdx1)
# Generate data.frame specifying the conversion of single characters.
convertCharsDf <- data.frame(c("ä", "ü"), c("ae", "ue"))
# Apply function. esMerged is the result of function 'esMerge'.
esMerged1 <- convertChars(esMerged, textColumns, convertCharsDf)
# # As default upper and lower case are NOT ignored! If you want them
# # ignored, additionally pass TRUE to the argument ignoreCase, like this:
# convertChars(esMerged, textColumns, convertCharsDf, ignoreCase=TRUE)
# o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o
}
\seealso{
Exemplary code (fully executable) in the documentation of \code{\link{esmprep}} (function 16 of 29).
}
