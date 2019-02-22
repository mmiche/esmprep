#' esPlausible
#
#' @description esPlausible helps detecting implausibilities in the raw ESM datasets.
#
#' @param dfList a list. Each element of the list must be a data.frame. Each data.frame is a separate raw ESM dataset/an ESM questionnaire version. If there is just one ESM version the list therefore contains one data.frame.
#
#' @param itemVecList a list. Each list element must be a vector. Each vector element must contain all the variable names of the respective ESM questionnaire version. Use function \code{\link{esItems}} to generate \code{itemVecList}.
#
#' @details \code{esPlausible} makes no sense if there is only one ESM questionnaire version. However, if there is more than one version it makes sense. The list which is returned by \code{esPlausible} contains 4 elements:
#' \enumerate{
#' \item PlausibNames shows which item names occur in the different ESM questionnaire versions
#' \item plausibClass shows the class of each item in each of the different ESM questionnaire versions (R built-in class registration)
#' \item plausibRowNa shows the number of rows in each of the different ESM questionnaire versions and the percentage of existing data therein
#' \item plausibMinMax shows the minimum and the maximum value for all items containing numeric data.
#' }
#
#' @return A list of dataframes, each containing separate information regarding the plausibility of the ESM datasets. See \strong{Details} for more information.
#
#' @examples
#' # o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o
#' # Prerequisites in order to execute esPlausible. Start --------------
#' # Use example list delivered with the package
#' RELEVANTVN_ES <- RELEVANTVN_ESext
#' # keyLsNew is a list of datasets, also delivered with the package
#' rmInvLs <- rmInvalid(keyLsNew, RELEVANTVN_ES)
#' plausibItems <- esItems(dfList=rmInvLs[["dfValid"]], RELEVANTVN_ES)
#' # Prerequisites in order to execute esPlausible. End ----------------
#' # -------------------------------------------------------
#' # Run function 12 of 29; see esmprep functions' hierarchy.
#' # -------------------------------------------------------
#' # Help checking the plausibility of items in the raw ESM datasets. rmInvLs[["dfValid"]]
#' # is one of the results from function 'rmInvalid'.
#' # plausibItems is the result of function 'esItems'.
#' plausibLs <- esPlausible(dfList=rmInvLs[["dfValid"]], itemVecList=plausibItems)
#' # Display the results (4 data frames) to the console
#' # plausibNames gives an overview of the item names across all ESM versions
#' plausibLs[["plausibNames"]]
#' # plausibClass gives an overview of the variable types of all items
#' plausibLs[["plausibClass"]]
#' # plausibRowNa shows for each ESM version the number of lines in the raw
#' # ESM datasets and how much percent of the data is missing (NAs).
#' plausibLs[["plausibRowNa"]]
#' # plausibMinMax shows for each numeric variable the minimum and maximum.
#' plausibLs[["plausibMinMax"]]
#' # o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o=o
#
#' @seealso Exemplary code (fully executable) in the documentation of \code{\link{esmprep}} (function 12 of 29).
#
#' @export
#
esPlausible <- function(dfList, itemVecList) {

    dfCheck <- sapply(dfList, FUN = is.data.frame)

    # If at least one of the elements in dfList is not of type data.frame
    # stop the processing.
    if(any(dfCheck == FALSE)) {
        stop("Error in 1st argument 'dfList', which must be of type 'list'. All elements in the list must be of type 'data.frame'.")
    }

    if(class(itemVecList) != "list") {
        stop("Error in 2nd argument 'itemVecList', which must be of type 'list'. All elements in the list must be of type 'vector'.")
    }

    if(any(!is.character(unlist(itemVecList)))) {
        stop("Error in 2nd argument 'itemVecList'. All elements in each vector must be of type 'character'.")
    }

    namesAll0 <- c()
    for(i in 1:length(itemVecList)) {
        namesAll0 <- c(namesAll0, itemVecList[[i]])
    }
    namesAll <- unique(namesAll0)

    df_temp <- data.frame(namesAll)
    colNamesDf_temp <- c("names", "class", "naPercent", "min", "max", "nRows")

    # j <- 1
    for(j in 1:length(dfList)) {
    		# Match which variable in version j are among all versions variable names
        idxMatchNames <- match(itemVecList[[j]], namesAll)
        # Generate temporary variables containing missing values
        names_temp <- class_temp <- na_temp <- min_temp <- max_temp <- nRow_temp <- rep(NA, times = length(namesAll))
        # Assign the variable names from version j to the temporary variable
        # names_temp
        names_temp[idxMatchNames] <- itemVecList[[j]]
        # Assign the first 3 letters of the class (as registered by R) to the
        # variables of version j
        class_temp[idxMatchNames] <- substring(unlist(lapply(dfList[[j]][,itemVecList[[j]]], class)), 1, 3)
        
        for(k in 1:length(itemVecList[[j]])) {
        		# Generate the current (k_th) variable of version j
        		vn_temp <- itemVecList[[j]][k]
        		# Extract relevant values with summary function
            smry_k <- summary(dfList[[j]][, vn_temp])
            # If there are values returned by summary then
            # is.na(smry_k["Class"]) returns TRUE
            if(is.na(smry_k["Class"])) {
            	# Insert the most relevant values from summary to the
            	# temporary variables
                na_temp[idxMatchNames][k] <- as.numeric(smry_k["NA's"])
                min_temp[idxMatchNames][k] <- as.numeric(smry_k["Min."])
                max_temp[idxMatchNames][k] <- as.numeric(smry_k["Max."])
            }
        }
        nRow_temp[idxMatchNames] <- rep(nrow(dfList[[j]]), times = length(idxMatchNames))
        na_temp[idxMatchNames][which(is.na(na_temp[idxMatchNames]))] <- 0
        df_temp_j <- data.frame(names_temp, class_temp, na_temp, min_temp, max_temp, nRow_temp)
        colnames(df_temp_j) <- paste0(colNamesDf_temp, j)
        df_temp <- data.frame(df_temp, df_temp_j)
    }

    # -----------------------------------------------------------------
    # Extract information per variable and per ES questionnaire version
    # -----------------------------------------------------------------

    # 1 Extract names of variables
    # ----------------------------
    colNamesIdx <- which(substring(names(df_temp), 1, nchar(colNamesDf_temp[1])) == colNamesDf_temp[1])
    df_temp[,"namesCheck"] <- apply(df_temp[,c(1,colNamesIdx)], MARGIN = 1, function(x) all(x[2:(length(colNamesIdx+1))][!is.na(x[2:(length(colNamesIdx+1))])]==x[1]))

    # 2 Extract class of variables
    # ----------------------------
    classesIdx <- which(substring(names(df_temp), 1, nchar(colNamesDf_temp[2])) == colNamesDf_temp[2])

    classesNotNa <- apply(df_temp[,classesIdx], MARGIN = 1, function(x) which(!is.na(x[1:length(classesIdx)])))

    checkClass <- c()
    for(m in 1 : nrow(df_temp)) {
        if(length(classesNotNa[[m]])==1) {
            checkClass <- c(checkClass, TRUE)
        } else {
            consistantClass <- all(as.character(unlist(df_temp[m,classesIdx][classesNotNa[[m]][-1]]))==as.character(unlist(df_temp[m,classesIdx][classesNotNa[[m]][1]])))
            checkClass <- c(checkClass, consistantClass)
        }
    }
    df_temp[,"classCheck"] <- checkClass
    names(df_temp)

    # Extract number of missing values in variables
    # ---------------------------------------------
    nasIdx <- which(substring(names(df_temp), 1, nchar(colNamesDf_temp[3])) == colNamesDf_temp[3])

    # Extract minimum value in variables
    # ----------------------------------
    minimIdx <- which(substring(names(df_temp), 1, nchar(colNamesDf_temp[4])) == colNamesDf_temp[4])

    # Extract maximum value in variables
    # ----------------------------------
    maximIdx <- which(substring(names(df_temp), 1, nchar(colNamesDf_temp[5])) == colNamesDf_temp[5])

    # Extract number of values in questionnaire versions
    # --------------------------------------------------
    rowsIdx <- which(substring(names(df_temp), 1, nchar(colNamesDf_temp[6])) == colNamesDf_temp[6])

    # Compute number of missing values in percent
    # -------------------------------------------
    df_temp[,nasIdx] <- round(df_temp[,nasIdx]/df_temp[,rowsIdx]*100, digits = 1)

    df_tempOrder <- c(names(df_temp)[c(1,colNamesIdx)], "namesCheck", names(df_temp)[classesIdx], "classCheck", names(df_temp)[c(rowsIdx, nasIdx, minimIdx, maximIdx)])
    ncol(df_temp) == length(df_tempOrder)

    namesGrep <- grep(pattern="names", df_tempOrder)
    namesOrder <- df_tempOrder[namesGrep[-1]]

    classGrep <- grep(pattern="class", df_tempOrder)
    classOrder <- df_tempOrder[c(1,classGrep)]

    nRowsGrep <- grep(pattern="nRows", df_tempOrder)
    naPercentGrep <- grep(pattern="naPercent", df_tempOrder)
    nRowsNaPercent <- as.vector(rbind(nRowsGrep, naPercentGrep))
    rowNaOrder <- df_tempOrder[c(1, nRowsNaPercent)]

    minGrep <- grep(pattern="min", df_tempOrder)
    maxGrep <- grep(pattern="max", df_tempOrder)
    minMax <- as.vector(rbind(minGrep, maxGrep))
    minMaxOrder <- df_tempOrder[c(1, minMax)]

    list(plausibNames=df_temp[,namesOrder], plausibClass=df_temp[,classOrder], plausibRowNa=df_temp[,rowNaOrder], plausibMinMax=df_temp[,minMaxOrder])
}
