# cumsumReset
#
#
cumsumReset <- function(esDf, multVN) {

    mult <- 0
    x <- esDf[,multVN]

    # If x contains NA they are converted to 0.
    if(any(is.na(x))) {
        x[is.na(x)] <- 0
    }

    vec <- c()
    for(i in 1 : length(x)) {
        if(x[i] == 0) {
            mult <- 0
            vec <- c(vec, mult)
        } else {
            vec <- c(vec, mult + 1)
            mult <- mult + 1
        }
    }
    # 'vec' contains values >= 0.
    # If there are no multiple elements in x then vec contains only 0s.
    if(all(vec == 0)) {
        cat("All values in the argument are equal to one another.\n")

    } else {
        # In 'vec' for all values equal to 1, SHIFT their POSITION backwards by 1.
        idx <- which(vec == 1) - 1
        # Register all positions in 'vec' when their value is equal to 0
        idx0 <- which(vec != 0)
        # Add 1 to each value registered in idx and idx0
        vec[c(idx, idx0)] <- vec[c(idx, idx0)] + 1
    }
    esDf[,"ES_MULT2"] <- vec

    return(esDf)
}
