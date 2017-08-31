# is.integer0
#
#
is.integer0 <- function(values) {
    is.integer(values) && length(values) == 0L
}
