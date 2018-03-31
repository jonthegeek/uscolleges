#' Tidy US college scorecard data
#'
#' The most recent US college scorecard from the US Department of Education,
#' using the dev-friendly column names from the provided data dictionary.
#'
#' @format A tibble with 7593 observations of colleges in the United States, and
#'   622 variables. The variables are described in the
#'   \code{\link{uscolleges_data_dictionary}}.
#' @source \url{https://catalog.data.gov/dataset/college-scorecard}
"uscolleges"

#' Descriptions of the uscolleges data.
#'
#' A data dictionary describing the uscolleges data, derived from the dictionary
#' provided by the US Department of Education.
#'
#' @format A tibble with 622 observations of fields, and 4 variables:
#'   \describe{\item{field}{The field as it appears in uscolleges.}
#'   \item{API_field}{The field as it appeared in the source data and the
#'   college scorecard API.} \item{description}{The meaning of the field.}
#'   \item{category}{The category to which the field belongs. One of root,
#'   school, admissions, academics, student, cost, aid, completion, and
#'   repayment.}}
#' @source \url{https://collegescorecard.ed.gov/data/documentation/}
"uscolleges_data_dictionary"
