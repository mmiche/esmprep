# overallCounter
#
#
overallCounter <- function(idxAssigned, dateVec, RELEVANTINFO_ES = NULL) {
	
    if(length(idxAssigned)==1) {
    	
		diffAssigned <- 0
		cvOverall <- 1

	} else {
		
		diffAssigned <- c(0, diff(idxAssigned))
	
	    dateVecBool <- duplicated(dateVec)
	
	    # First questionnaire of person i always starts at 1.
	    cvOverall <- c(1)
	    counter <- 1
	    for(i in 2 : length(diffAssigned)) {
	
	        # If difference = 0 during one day (dateVecBool = TRUE), then
	        # the ES questionnaire is a repeated one. Therefore the counter
	        # must not be incremented.
	        if(diffAssigned[i] == 0 & dateVecBool[i] == TRUE) {
	            cvOverall <- c(cvOverall, counter)
	
	            # Else if the difference = 0 and a new day has begun, then the
	            # maximum number of questionnaires were missed by the person.
	            # Therefore increment by the maximum number of daily questionnaires.
	        } else if(diffAssigned[i] == 0 & dateVecBool[i] == FALSE) {
	            counter <- counter + RELEVANTINFO_ES[["MAXPROMPT"]]
	            cvOverall <- c(cvOverall, counter)
	        }
	
	        # For-loop for remaining possibilities of at least one questionnaire
	        # being missed by the person.
	        for(j in 1:(RELEVANTINFO_ES[["MAXPROMPT"]] - 1)) {
	            if(diffAssigned[i] == j | diffAssigned[i] == -(RELEVANTINFO_ES[["MAXPROMPT"]] - j)) {
	                counter <- counter + j
	                cvOverall <- c(cvOverall, counter)
	            }
	        }
	    }
	}
    return(cvOverall)
}
