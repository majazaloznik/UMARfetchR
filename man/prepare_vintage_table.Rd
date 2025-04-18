% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/prepare_data.R
\name{prepare_vintage_table}
\alias{prepare_vintage_table}
\title{Get new vintages ids}
\usage{
prepare_vintage_table(data, con, schema = "platform")
}
\arguments{
\item{data}{- checked data from Excel sheet.}

\item{con}{connection to the database.}

\item{schema}{schema name}
}
\value{
data frame with `series_code`, `series_id` and `published` columns
}
\description{
Helper function preparing vintages to be imported. First checks which
series have new data and keeps only those, adding their series_ids
and published times to prep for import into the vintage table
}
