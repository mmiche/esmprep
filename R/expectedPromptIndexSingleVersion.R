# expectedPromptIndexSingleVersion
#
#
expectedPromptIndexSingleVersion <- function(esVersion, expectedPromptIndex, expectedCategory) {

    PROMPTFALSE <- rep(0, times = nrow(esVersion))
    PROMPTFALSE[esVersion[,"PROMPT"]%in%expectedPromptIndex == FALSE] <- 1

    esVersion[,"PROMPTFALSE"] <- PROMPTFALSE
    esVersion[,"EXPCATEGORY"] <- expectedCategory

    return(esVersion)
}
