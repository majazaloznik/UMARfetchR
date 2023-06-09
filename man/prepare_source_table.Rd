% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/prepare_structure.R
\name{prepare_source_table}
\alias{prepare_source_table}
\title{Prepare table to insert into `source` table
Helper function that manually prepares the new line for the source table.
This is only done once.}
\usage{
prepare_source_table(con)
}
\arguments{
\item{con}{connection to the database.}
}
\value{
a dataframe with the `name`, `name_long`, and `url`, columns.
for this table.
}
\description{
Prepare table to insert into `source` table
Helper function that manually prepares the new line for the source table.
This is only done once.
}
