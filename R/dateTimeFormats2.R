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
    dateTimeFormat <- c("ymd_hms", "mdy_hms", "dmy_hms", "ymd_hm", "mdy_hm", "dmy_hm")
    return(dateTimeFormat)
}
