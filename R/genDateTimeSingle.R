# genDateTimeSingle
#
#' @importFrom lubridate parse_date_time
#
#
genDateTimeSingle <- function(refOrEsDf=NULL, refOrEs = NULL, dateFormat = "ymd", timeFormat = "HMS", startOrEnd = "START", RELEVANTVN_ES = NULL, RELEVANTVN_REF = NULL) {

    if(refOrEs == "REF") {
        # check whether column 2 can be coerced to type Date and column 3 to HMS!
        currentColumnNameDate <- paste0(refOrEs, "_", startOrEnd, "_DATE")
        if(is.na(match(RELEVANTVN_REF[[currentColumnNameDate]], names(refOrEsDf)))){
            stop(paste0("Column name ", RELEVANTVN_REF[[currentColumnNameDate]], " cannot be found in the data frame."))
        }
        # currentColumnNameDate <- eval(parse(text=paste0(refOrEs, "_", startOrEnd, "_DATE")))
        dateColumn <- refOrEsDf[,RELEVANTVN_REF[[currentColumnNameDate]] ]
        # Convert the date-time object to format yyyy-mm-dd hh:mm:ss
        parseDate <- lubridate::parse_date_time(dateColumn, orders = dateFormat)

        currentColumnNameTime <- paste0(refOrEs, "_", startOrEnd, "_TIME")
        if(is.na(match(RELEVANTVN_REF[[currentColumnNameTime]], names(refOrEsDf)))){
            stop(paste0("Column name ", RELEVANTVN_REF[[currentColumnNameTime]], " cannot be found in the data frame."))
        }
        timeColumn <- refOrEsDf[,RELEVANTVN_REF[[currentColumnNameTime]] ]

    } else {
        # check whether column 2 can be coerced to type Date and column 3 to HMS!
        currentColumnNameDate <- paste0(refOrEs, "_", startOrEnd, "_DATE")
        if(is.na(match(RELEVANTVN_ES[[currentColumnNameDate]], names(refOrEsDf)))){
            stop(paste0("Column name ", RELEVANTVN_ES[[currentColumnNameDate]], " cannot be found in the data frame."))
        }
        dateColumn <- refOrEsDf[,RELEVANTVN_ES[[currentColumnNameDate]] ]
        # Convert the date-time object to format yyyy-mm-dd hh:mm:ss
        parseDate <- lubridate::parse_date_time(dateColumn, orders = dateFormat)

        currentColumnNameTime <- paste0(refOrEs, "_", startOrEnd, "_TIME")
        if(is.na(match(RELEVANTVN_ES[[currentColumnNameTime]], names(refOrEsDf)))){
            stop(paste0("Column name ", RELEVANTVN_ES[[currentColumnNameTime]], " cannot be found in the data frame."))
        }
        timeColumn <- refOrEsDf[,RELEVANTVN_ES[[currentColumnNameTime]] ]
    }

    # Extractions
    # -----------
    # Extract the date ("yyyy-mm-dd")
    date <- as.Date(parseDate)
    if(timeFormat == "HMS") {
        # Extract the time ("hh:mm:ss")
        time <- format(as.POSIXct(strptime(timeColumn, "%T")), "%H:%M:%S")
    } else if(timeFormat == "HM") {
        # Extract the time ("hh:mm")
        time <- format(as.POSIXct(strptime(timeColumn, "%R")), "%H:%M")
    }

    # suppressWarnings for THIS part of the function:
    dateTime <- suppressWarnings(lubridate::parse_date_time(paste(date, time), orders = "ymd_HMS"))

    # Add newly generated date-time object to the input data frame:
    refOrEsDf[,paste0(refOrEs, "_", startOrEnd, "_DATETIME")] <- dateTime
    generatedcolumName <- paste0(refOrEs, "_", startOrEnd, "_DATETIME")

    # Append to the list of relevant variable names
    if(refOrEs == "REF") {
        RELEVANTVN_REF[[generatedcolumName]] <- generatedcolumName
        # assign("RELEVANTVN_REF", RELEVANTVN_REF, envir = .GlobalEnv)
        # Return the dataset and the list with appended element
        # ESMsingle = single raw ESM dataset, extList = extended list RELEVANTVN_REF
    		list(refOrEsDfSingle=refOrEsDf, extendedVariableNameList=RELEVANTVN_REF)
    } else {
        RELEVANTVN_ES[[generatedcolumName]] <- generatedcolumName
        # assign("RELEVANTVN_ES", RELEVANTVN_ES, envir = .GlobalEnv)
        # Return the dataset and the list with appended element
        # ESMsingle = single raw ESM dataset, extList = extended list RELEVANTVN_ES
    		list(refOrEsDfSingle=refOrEsDf, extendedVariableNameList=RELEVANTVN_ES)
    }

    
}
