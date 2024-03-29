% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/scripting.R
\name{update_data}
\alias{update_data}
\title{Wrapper function for complete data pipeline}
\usage{
update_data(metadata_filename, data_filename, con, schema, path = "logs/")
}
\arguments{
\item{metadata_filename}{metadata file}

\item{data_filename}{data file}

\item{con}{connection to database}

\item{schema}{name of database schema}

\item{path}{folder to store the log file to}
}
\value{
Nothing, just side effects :). Writes to the database and the excel file and emails logs.
}
\description{
This wrapper function runs the whole data pipeline by running \link[UMARfetchR]{main_data}
one which imports any new data, while logging everything to the sink and emailing the
logs to the listed recipients.
}
