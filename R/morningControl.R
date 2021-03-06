#' Raw ESM dataset simulating a series of ESM questionnaires that were scheduled to be filled
#' out during the morning by participants of the control group.
#'
#' @format A data frame with 14 rows and 20 variables:
#' \itemize{
#'   \item V1. Arbitrary item, answer format numeric, ranging from 0 to 3.
#'   \item V1_1. Arbitrary item, answer format numeric, ranging from 0 to 1.
#'   \item V1_2. Arbitrary item, answer format text.
#'   \item V2. Arbitrary item, answer format numeric, ranging from 0 to 100.
#'   \item V2_1. Arbitrary item, answer format numeric, ranging from 0 to 100.
#'   \item V3. Arbitrary item, answer format numeric, ranging from 0 to 100.
#'   \item V3_1. Arbitrary item, answer format text.
#'   \item V4. Arbitrary item, answer format numeric, ranging from 0 to 1.
#'   \item V4_1. Arbitrary item, answer format numeric, ranging from 0 to 4.
#'   \item V5. Arbitrary item, answer format numeric, ranging from 0 to 6.
#'   \item V5_1. Arbitrary item, answer format numeric, ranging from 0 to 6.
#'   \item V6. Arbitrary item, answer format numeric, ranging from 0 to 1.
#'   \item V6_1. Arbitrary item, answer format numeric, ranging from 1 to 4.
#'   \item V7. Arbitrary item, answer format numeric, ranging from 0 to 1.
#'   \item survey_name. Name of the ESM version.
#'   \item IMEI. IMEI number of the mobile device, used by the participant.
#'   \item start_date. Date of when a single ESM questionnaire was started.
#'   \item start_time. Time of when a single ESM questionnaire was started.
#'   \item end_date. Date of when a single ESM questionnaire was ended.
#'   \item end_time. Time of when a single ESM questionnaire was ended.
#' }
#'
#' @docType data
# @keywords datasets
# @name morningControl
#
#' @usage morningControl
#' @examples
#' # Display the whole dataset in the console
#' morningControl
#
# @source R package esmprep.
"morningControl"
