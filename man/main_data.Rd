% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/scripting.R
\name{main_data}
\alias{main_data}
\title{Main function for processing data}
\usage{
main_data(filename, codes, con, schema)
}
\arguments{
\item{filename}{path to excel file with timeseries structure metadata}

\item{codes}{output of \link[UMARfetchR]{main_structure} i.e. list of series codes}

\item{con}{connection to database}

\item{schema}{schema name}
}
\description{
Main function for processing data
}
