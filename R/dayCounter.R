# dayCounter
#
#' @importFrom lubridate wday
#
#
dayCounter <- function(dateVec) {

    singleDates <- unique(dateVec)
    # nqd: number of questionnaires filled out each ES day
    nqd <- c()
    for(i in 1 : length(singleDates)) {
        nqd <- c(nqd, length(which(dateVec == singleDates[i])))
    }
    weekDay <- lubridate::wday(dateVec)
    esDay <- rep(1:length(singleDates), times = nqd)

    idxDupl <- which(duplicated(dateVec) == FALSE)

    return(data.frame(weekDay, esDay))
}
