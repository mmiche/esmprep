# daylightSaving
#
#' @importFrom lubridate interval ymd %within%
#
#
daylightSaving <- function(STARTDATE, ENDDATE, dstDates = lubridate::ymd("0000-01-01")) {

    # Possible errors: start date and end date are assigned in the wrong order
    #				   or they are identical.
    if(lubridate::ymd(STARTDATE) > lubridate::ymd(ENDDATE)) {
        stop("End date can't be prior in time to start date. Please check!")
    } else if(lubridate::ymd(STARTDATE) == lubridate::ymd(ENDDATE)) {
        stop("Start date (1st argument) and end date (2nd argument) are identical. Please check!")
    }

    esPeriod_i <- lubridate::interval(lubridate::ymd(STARTDATE), lubridate::ymd(ENDDATE))
    # Which of the dst-dates are contained in the ES period
    crossDST <- lubridate::ymd(dstDates) %within% esPeriod_i
    
    if(any(crossDST)) {

        cat("Daylight saving time is contained in the ESM period.\n")

        esPeriod_iDates <- seq(as.Date(STARTDATE), as.Date(ENDDATE), by = 1)
        dstPost <- which(lubridate::ymd(esPeriod_iDates) >= dstDates[crossDST])
        # return the indices of the days of the ES period starting with the
        # daylight saving date until the end of the ES period as 1st argument.
        # Return the daylight saving date which was in the ES period.
        list(dstPost, dstDates[crossDST])
    } else {
        cat("Daylight saving time checked. It's not contained in the ESM period.\n")
        return(NA)
    }
}
