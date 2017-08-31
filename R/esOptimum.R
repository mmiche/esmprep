# esOptimum
#
#
esOptimum <- function(optID, refDf, refId, STARTDATE, STARTTIME, ENDDATE, ENDTIME, MAXPROMPT, refSts) {

    idx_temp <- match(optID, refDf[,refId])

    if(is.na(idx_temp)) {
        stop("Argument 'optID' is not included in reference dataset. Please check.")
    }

    if(as.Date(refDf[idx_temp,STARTDATE]) > as.Date(refDf[idx_temp,ENDDATE])) {
        stop("End date can't be prior to the start date. Please check.")
    } else if(as.Date(refDf[idx_temp,STARTDATE]) == as.Date(refDf[idx_temp,ENDDATE])) {
        stop("End date is equal to the start date. This function requires 2 different dates.")
    }

    # ES commitment for each individual ----------------------------------------
    # ----------------------------------
    # Optimum number of questionnaires for person i
    esDateStartStop <- c(refDf[idx_temp,STARTDATE], refDf[idx_temp,ENDDATE])
    esTimeStartStop <- c(refDf[idx_temp,STARTTIME], refDf[idx_temp,ENDTIME])

    # ---------------------------------------------------------------------------
    # ADAPT to number of daily ES questionnaires in 'x[1:maxNumber]'
    # -------------------------------------------
    stStartOpt <- which(refDf [idx_temp , refSts] == esTimeStartStop[1])
    stEndOpt <- which(refDf [idx_temp , refSts] == esTimeStartStop[2])

    esOpt_esTimePeriod <- seq(as.Date(esDateStartStop[1]), as.Date(esDateStartStop[2]), by = 1)
    # Number of days of event sampling
    len_esOpt_esTimePeriod <- length(esOpt_esTimePeriod)

    # Dealing with 1st ES day ---------------------
    esOpt_timesFirst <- stStartOpt:MAXPROMPT
    esOpt_multDatesFirst <- rep(esDateStartStop[1], times = length(esOpt_timesFirst))
    # ----------------------------------------------

    # Dealing with last ES day ---------------------
    esOpt_timesLast <- 1:stEndOpt
    esOpt_multDatesLast <- rep(esDateStartStop[2], times = length(esOpt_timesLast))
    # ----------------------------------------------

    if(len_esOpt_esTimePeriod > 3) {
        # Dealing with ES days between 1st and last ES day ---
        esOpt_timesFull <- rep(1:MAXPROMPT, times = len_esOpt_esTimePeriod-2)
        esOpt_multDatesFull <- rep(esOpt_esTimePeriod[-c(1,len_esOpt_esTimePeriod)], each = MAXPROMPT)
        # -------------------------------------------------------

        # Concatenate first ES day, ES days in between, and last ES day
        esOptDates <- c(as.Date(esOpt_multDatesFirst), as.Date(esOpt_multDatesFull), as.Date(esOpt_multDatesLast))
        esOptTimesIdx <- c(esOpt_timesFirst, esOpt_timesFull, esOpt_timesLast)
        esOptTimes <- as.character(refDf [idx_temp , refSts]) [esOptTimesIdx]
        # ---------------------------------------------------------------------------

    } else if(len_esOpt_esTimePeriod == 2){

        # Concatenate first ES day, ES days in between, and last ES day
        esOptDates <- c(as.Date(esOpt_multDatesFirst), as.Date(esOpt_multDatesLast))
        esOptTimesIdx <- c(esOpt_timesFirst, esOpt_timesLast)
        esOptTimes <- as.character(refDf [idx_temp , refSts]) [esOptTimesIdx]
        # ---------------------------------------------------------------------------
    } else {
        stop("Event sampling period must be apart at least 1 day, i.e. 2 different dates.")
    }

    esOpt_cvOverall <- 1:length(esOptTimes)
    esOpt_id <- rep(optID, times = length(esOptTimes))

    esOptDf_temp <- data.frame(ID = esOpt_id, CV_ES = esOpt_cvOverall, STARTDATE = esOptDates, PROMPT = esOptTimesIdx, STARTTIME = esOptTimes)

    return(esOptDf_temp)
}
