% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/parsing.R
\name{check_data_df}
\alias{check_data_df}
\title{Check data frame to be parsed}
\usage{
check_data_df(df, codes)
}
\arguments{
\item{df}{data with time series data}

\item{codes}{character vector of codes}
}
\value{
TRUE if it works
}
\description{
Uses the output of \link[UMARfetchR]{main_structure} to get the list
of legal series codes and also checks a bunch of other stuff.
}
