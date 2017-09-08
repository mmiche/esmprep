#' dateTimeFormats2
#
#' @description dateTimeFormats displays the possible date-time options available (without examples).
#
#' @return No return values. Instead a vector is displayed with all the options for date-time objects.
#
#' @examples
#' # Run this function at any time you want to.
#' dateTimeFormats2()
#
#' @export
#
dateTimeFormats2 <- function() {
    dateTimeFormat <- c("ymd_HMS", "mdy_HMS", "dmy_HMS", "ymd_HM", "mdy_HM", "dmy_HM")
    return(dateTimeFormat)
}
