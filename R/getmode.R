# getmode
#
#
getmode <- function(values) {
    uniqValues <- unique(values)
    uniqValues[which.max(tabulate(match(values, uniqValues)))]
}
