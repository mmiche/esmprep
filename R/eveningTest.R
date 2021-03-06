#' Raw ESM dataset simulating a series of ESM questionnaires that were scheduled to be filled
#' out during the evening by participants of the test group.
#'
#' @format A data frame with 14 rows and 24 variables:
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
#'   \item V5_2. Arbitrary item, answer format numeric, ranging from 0 to 6.
#'   \item V7. Arbitrary item, answer format numeric, ranging from 0 to 1.
#'   \item V8. Arbitrary item, answer format text.
#'   \item V8_1. Arbitrary item, answer format numeric, ranging from 0 to 1.
#'   \item V8_3. Arbitrary item, answer format numeric, ranging from 1 to 4.
#'   \item V9. Arbitrary item, answer format numeric, ranging from 0 to 1.
#'   \item V9_1. Arbitrary item, answer format text.
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
# @name eveningControl
#
#' @usage eveningTest
#' @examples
#' # Display the whole dataset in the console
#' eveningTest
#
# @source R package esmprep.
"eveningTest"
