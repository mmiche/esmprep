# SETUPLISTCheck
#
#
SETUPLISTCheck <- function(RELEVANTINFO_ES=NULL, RELEVANTVN_ES=NULL, RELEVANTVN_REF=NULL) {
	
	# Check argument RELEVANTINFO_ES
	# ------------------------------
	if(!is.null(RELEVANTINFO_ES)) {
		# expected list names and expected order of list names.
		expectedListNamesINFO_ES <- c("MAXPROMPT", "IMEI_NUMBERS", "SVYNAMES")
		if(any( (names(RELEVANTINFO_ES) %in% expectedListNamesINFO_ES) == FALSE)) {
			stop(paste0("Error in function argument 'RELEVANTINFO_ES'. At least one name of the list is unexpected. Order of the names is important! Use function setES to generate 'RELEVANTINFO_ES'!\nExpected names are: ", paste(expectedListNamesINFO_ES, collapse=", "), ".\nReceived names are: ", paste(names(RELEVANTINFO_ES), collapse=", "), "."))
		}
	}
	
	# Check argument RELEVANTVN_ES
	# ----------------------------
	if(!is.null(RELEVANTVN_ES)) {
		# expected list names and expected order of list names.
		expectedListNamesVN_ES_Full <- c("ES_SVY_NAME", "ES_IMEI", "ES_START_DATE", "ES_START_TIME", "ES_END_DATE", "ES_END_TIME", "ES_START_DATETIME", "ES_END_DATETIME")
		
		if(length(RELEVANTVN_ES) == 4) {
			
			if(any( (names(RELEVANTVN_ES) %in% expectedListNamesVN_ES_Full[c(1,2,7,8)]) == FALSE)) {
				stop(paste0("Error in function argument 'RELEVANTVN_ES'. At least one name of the list is unexpected. Order of the names is important! Use function setES to generate 'RELEVANTVN_ES'!\nExpected names are: ", paste(expectedListNamesVN_ES_Full[c(1,2,7,8)], collapse=", "), ".\nReceived names are: ", paste(names(RELEVANTVN_ES), collapse=", "), "."))
			}
			
		} else if(length(RELEVANTVN_ES) == 6) {
			
			if(any( (names(RELEVANTVN_ES) %in% expectedListNamesVN_ES_Full[1:6]) == FALSE)) {
				stop(paste0("Error in function argument 'RELEVANTVN_ES'. At least one name of the list is unexpected. Order of the names is important! Use function setES to generate 'RELEVANTVN_ES'!\nExpected names are: ", paste(expectedListNamesVN_ES_Full[1:6], collapse=", "), ".\nReceived names are: ", paste(names(RELEVANTVN_ES), collapse=", "), "."))
			}
			
		} else if(length(RELEVANTVN_ES) == 8) {
			
			if(any( (names(RELEVANTVN_ES) %in% expectedListNamesVN_ES_Full) == FALSE)) {
				stop(paste0("Error in function argument 'RELEVANTVN_ES'. At least one name of the list is unexpected. Order of the names is important! Use function setES to generate 'RELEVANTVN_ES'!\nExpected names are: ", paste(expectedListNamesVN_ES_Full, collapse=", "), ".\nReceived names are: ", paste(names(RELEVANTVN_ES), collapse=", "), "."))
			}
			
		}
	}
	
	# Check argument RELEVANTVN_REF
	# -----------------------------
	if(!is.null(RELEVANTVN_REF)) {
		# expected list names and expected order of list names.
		expectedListNamesVN_REF_Full <- c("REF_ID", "REF_IMEI", "REF_START_DATE", "REF_START_TIME", "REF_END_DATE", "REF_END_TIME", "REF_ST", "REF_START_DATETIME", "REF_END_DATETIME")
		
		if(length(RELEVANTVN_REF) == 5) {
			
			if(any( (names(RELEVANTVN_REF) %in% expectedListNamesVN_REF_Full[c(1,2,8:9,7)]) == FALSE)) {
				stop(paste0("Error in function argument 'RELEVANTVN_REF'. At least one name of the list is unexpected. Order of the names is important! Use function setREF to generate 'RELEVANTVN_REF'!\nExpected names are: ", paste(expectedListNamesVN_REF_Full[c(1,2,8:9,7)], collapse=", "), ".\nReceived names are: ", paste(names(RELEVANTVN_REF), collapse=", "), "."))
			}
			
		} else if(length(RELEVANTVN_REF) == 7) {
			
			if(any( (names(RELEVANTVN_REF) %in% expectedListNamesVN_REF_Full[1:7]) == FALSE)) {
				stop(paste0("Error in function argument 'RELEVANTVN_REF'. At least one name of the list is unexpected. Order of the names is important! Use function setREF to generate 'RELEVANTVN_REF'!\nExpected names are: ", paste(expectedListNamesVN_REF_Full[1:7], collapse=", "), ".\nReceived names are: ", paste(names(RELEVANTVN_REF), collapse=", "), "."))
			}
			
		} else if(length(RELEVANTVN_REF) == 9) {
			
			if(any( (names(RELEVANTVN_REF) %in% expectedListNamesVN_REF_Full) == FALSE)) {
				stop(paste0("Error in function argument 'RELEVANTVN_REF'. At least one name of the list is unexpected. Order of the names is important! Use function setREF to generate 'RELEVANTVN_REF'!\nExpected names are: ", paste(expectedListNamesVN_REF_Full, collapse=", "), ".\nReceived names are: ", paste(names(RELEVANTVN_REF), collapse=", "), "."))
			}
		}
	}
}
