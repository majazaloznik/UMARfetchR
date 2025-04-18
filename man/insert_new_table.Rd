% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/db_writing.R
\name{insert_new_table}
\alias{insert_new_table}
\title{Insert new table}
\usage{
insert_new_table(df, con, schema = "platform", keep_vintage = FALSE)
}
\arguments{
\item{df}{dataframe table_code and table_name columns.}

\item{con}{connection to the database.}

\item{schema}{db schema, defaults to platfrom}

\item{keep_vintage}{boolean to indicate if vintages are kept}
}
\value{
nothing
}
\description{
Used to insert the new tables into the database. The input
dataframe must have passed through \link[UMARfetchR]{compute_table_codes} so that
the table_codes and table_names are aligned.
}
