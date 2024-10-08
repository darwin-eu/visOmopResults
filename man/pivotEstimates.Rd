% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/pivotEstimates.R
\name{pivotEstimates}
\alias{pivotEstimates}
\title{Set estimates as columns}
\usage{
pivotEstimates(result, pivotEstimatesBy = "estimate_name", nameStyle = NULL)
}
\arguments{
\item{result}{A \verb{<summarised_result>}.}

\item{pivotEstimatesBy}{Names from which pivot wider the estimate values. If
NULL the table will not be pivotted.}

\item{nameStyle}{Name style (glue package specifications) to customise names
when pivotting estimates. If NULL standard tidyr::pivot_wider formatting will
be used.}
}
\value{
A tibble.
}
\description{
Pivot the estimates as new columns in result table.
}
\examples{
result <- mockSummarisedResult()
result |> pivotEstimates()

}
