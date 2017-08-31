# esCompleteSingleVersion
#
#
esCompleteSingleVersion <- function(esVersion, svyName, conditionalLastItem=NA, conditionalValue_s=NA, lastItem) {

    # If both 'conditionalLastItem' and 'conditionalValue_s' are null, checkConditional
    # returns TRUE, else FALSE.
    checkConditional <- length(which(is.na(c(conditionalLastItem, conditionalValue_s))))
	
    if(is.null(conditionalLastItem) & is.null(conditionalValue_s)) {
        conditionalLastItem <- conditionalValue <- NA
    } else if(checkConditional==1){
        stop("Argument 'conditionalLastItem' and 'conditionalValue' either must both be given or must both be omitted (default assignment is NULL).")
    }

    incom <- rep(0, times=nrow(esVersion))

    # If the last item is unconditional
    if(is.na(conditionalLastItem)) {

        # esCompleteNumOrChar returns a boolean vector. FALSE = realLastItem contains
        # a value, TRUE = realLastItem is missing.
        idxIncomplete <- esCompleteNumOrChar(esVersion=esVersion, realLastItem=lastItem)
        if(!is.integer0(idxIncomplete)) {
            # Among those without an end date apply the index 'idxIncomplete'.
            incom[idxIncomplete] <- 1
        }

    # Else the last item is conditional.
    } else {

        # The conditional item MUST be numeric. Anything else would be insane.

        # If the conditional item is missing the last item will have to be missing too.
        # Conclusion: The questionnaire is incomplete.
        idxIncomplete1 <- is.na(esVersion[,conditionalLastItem])

        incom[idxIncomplete1] <- 1

        # Conditional value: Value that signals whether or not the last item must contain
        # a value. If conditional item = conditional value (e.g. 0) then the last item
        # is missing rightfully, else the last item should contain a value. If it doesn't
        # the questionnaire will be incomplete.

        # esCompleteNumOrChar returns a boolean vector. FALSE = realLastItem contains
        # a value, TRUE = realLastItem is missing.
        idxIncomplete2 <- esCompleteNumOrChar(esVersion=esVersion, realLastItem=lastItem)

        if(length(which(incom==0))>0) {

            # At this point incom=0 means that these items have an existing value in the item
            # upon which it depends whether in the last item a value is expected to exist.
            subsetIncom0 <- incom == 0 & esVersion[,conditionalLastItem] %in% conditionalValue_s

            idxIncomplete1_sub <- idxIncomplete1[subsetIncom0]
            idxIncomplete2_sub <- idxIncomplete2[subsetIncom0]
            idxIncomplete <- ifelse(idxIncomplete1_sub==FALSE & idxIncomplete2_sub==TRUE, TRUE, FALSE)
            incom[subsetIncom0][idxIncomplete] <- 1

        } else {
            warning(paste0("In questionnaire version ", svyName, " both the penultimate and the last item contain no values at all."))
        }

    }
    esVersion[,"INCOMPLETE"] <- incom

    return(esVersion)
}
