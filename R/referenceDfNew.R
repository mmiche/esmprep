#' Dataset 'referenceDf' in modified form
#'
#' \strong{Note}: The dataset \code{referenceDfNew} is the result of the function \code{\link{genDateTime}}, when the dataset \code{\link{referenceDf}} is one of the function arguments.
#'
#' @docType data
# @keywords datasets
# @name referenceDfNew
#
#' @usage referenceDfNew
#' @examples
#' # Convert the 15 digit IMEI number from scientfic notation to text.
#' referenceDfNew$imei <- as.character(referenceDfNew$imei)
#' # Display the whole dataset in the console
#' referenceDfNew
#
# @source R package esmprep.
"referenceDfNew"