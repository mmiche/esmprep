# splitDateTimeSingle
#
#' @importFrom lubridate parse_date_time
#
#
splitDateTimeSingle <- function(refOrEsDf=NULL, refOrEs = NULL, dateTimeFormat = "ymd_HMS", startOrEnd="START", RELEVANTVN_ES = NULL, RELEVANTVN_REF = NULL) {

    if(refOrEs == "REF") {
        dateTimeColumnName <- RELEVANTVN_REF[[paste0(refOrEs, "_", startOrEnd, "_DATETIME")]]
    } else {
        dateTimeColumnName <- RELEVANTVN_ES[[paste0(refOrEs, "_", startOrEnd, "_DATETIME")]]
    }

    if(is.na(match(dateTimeColumnName, names(refOrEsDf)))){
        stop(paste0("Column name ", dateTimeColumnName, " cannot be found in the data frame."))
    }

    # Convert the date-time object to format yyyy-mm-dd hh:mm:ss
    parseDateTime <- lubridate::parse_date_time(refOrEsDf[,dateTimeColumnName], orders = dateTimeFormat)

    # Extraction of date and time and appending both to the dataset
    # -------------------------------------------------------------
    # Extract the date ("yyyy-mm-dd")
    date <- as.Date(parseDateTime)
    generatedColumNameDate <- paste0(refOrEs, "_", startOrEnd, "_DATE")
    # Append the date
    refOrEsDf[,generatedColumNameDate] <- date

    # Extract the time ("hh:mm:ss")
    time <- format(as.POSIXct(parseDateTime), "%H:%M:%S")
    generatedColumNameTime <- paste0(refOrEs, "_", startOrEnd, "_TIME")
    # Append the time
    refOrEsDf[,generatedColumNameTime] <- time

    # Append to the list of relevant variable names
    if(refOrEs == "REF") {
        RELEVANTVN_REF[[generatedColumNameDate]] <- generatedColumNameDate
        RELEVANTVN_REF[[generatedColumNameTime]] <- generatedColumNameTime
        # assign("RELEVANTVN_REF", RELEVANTVN_REF, envir = .GlobalEnv)
        # ESMsingle = single raw ESM dataset, extList = extended list RELEVANTVN_REF
    		list(refOrEsDfSingle=refOrEsDf, extendedVariableNameList=RELEVANTVN_REF)
    } else {
        RELEVANTVN_ES[[generatedColumNameDate]] <- generatedColumNameDate
        RELEVANTVN_ES[[generatedColumNameTime]] <- generatedColumNameTime
        # assign("RELEVANTVN_ES", RELEVANTVN_ES, envir = .GlobalEnv)
        # ESMsingle = single raw ESM dataset, extList = extended list RELEVANTVN_ES
    		list(refOrEsDfSingle=refOrEsDf, extendedVariableNameList=RELEVANTVN_ES)
    }

    # # Return the dataset
    # return(refOrEsDf)
}
