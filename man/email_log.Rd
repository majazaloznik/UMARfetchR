% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/scripting.R
\name{email_log}
\alias{email_log}
\title{Send email with log}
\usage{
email_log(log, recipient, meta = FALSE)
}
\arguments{
\item{log}{path to log file}

\item{recipient}{email (not checked) address to be sent to as BCC.
I think single email is all that's allowed. Haven't tried more.}

\item{meta}{logical indicating if the script was the metadata one or the data one (default).
This affects the subject and text of the email.}
}
\value{
nothing, side effect is the email being sent.
}
\description{
Convenience wrapper for sending the log to a (bunch of) recipient(s). This fun is
based on the ddvR::email_log function, just fyi. Cannae be bothered writing tests for this.
}
