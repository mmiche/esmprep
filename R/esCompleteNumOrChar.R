# esCompleteNumOrChar
#
#
esCompleteNumOrChar <- function(esVersion, realLastItem) {

    # If the variable name of the realLastItem is not of type character,
    # make it so.
    if(!is.character(realLastItem)) {
        realLastItem <- as.character(realLastItem)
    }

    # If: The last item is numeric.
    if(is.numeric(esVersion[,realLastItem])) {
        #
        idxIncomplete <- is.na(esVersion[,realLastItem])

        # Else: The last item must be a text answer, i.e. class character.
    } else {
        #
        if(is.character(esVersion[,realLastItem])) {
            emptySpacesRemoved <- gsub(" ", "", esVersion[,realLastItem])
        } else {
            emptySpacesRemoved <- gsub(" ", "", as.character(esVersion[,realLastItem]))
        }

        idxIncomplete <- emptySpacesRemoved==""
    }
    return(idxIncomplete)
}
