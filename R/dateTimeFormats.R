#' dateTimeFormats
#
#' @description dateTimeFormats displays the possible date-time options available (with examples).
#
#' @return No return values. Instead a matrix is displayed with all the options for date-time objects, with examples.
#
#' @examples
#' # Run this function at any time you want to.
#' dateTimeFormats()
#
#' @export
#
dateTimeFormats <- function() {
    dateTimeFormat <- c("ymd_hms", "mdy_hms", "dmy_hms", "ymd_hm", "mdy_hm", "dmy_hm")
    examplaryInput <- c("2017-02-06 07:11:23", "02-06-17 07:11:23", "06-02-17 07:11:23",
                        "17-02-06 07:11", "02-06-2017 07:11", "06-02-2017 07:11")
    output <- c(rep("2017-06-02 07:11:23 UTC", 3), rep("2017-06-02 07:11:00 UTC", 3))
    print(data.frame(dateTimeFormat, examplaryInput, output))
}
