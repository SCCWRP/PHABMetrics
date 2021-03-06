% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/chkinp.R
\name{chkinp}
\alias{chkinp}
\title{Check input data for PHABMetrics}
\usage{
chkinp(data, purge = FALSE, msgs = FALSE)
}
\arguments{
\item{data}{Input data}

\item{purge}{If true, a data frame will be returned
with problematic rows removed, see details.}

\item{msgs}{logical, if \code{FALSE} a purged or non-purged data frame, if \code{TRUE} a
two-element list with the data frame and concatenated list of messages, see the return value}
}
\value{
An error message is returned if the input data are not correctly formatted.

If \code{msgs = FALSE} (default), a data frame is returned that is either the same 
as the input if all checks have passed or a purged (\code{purge = TRUE}) or non-purged 
\code{purge = FALSE}) with or without offending rows removed.  If \code{msgs = TRUE}, a two-element list is returned, where 
the first element \code{data} is the data frame that would be returned if \code{msgs = FALSE}
and the second element is \code{msgs} with a concatenated character string of messages
indicating if all checks have passed and if not, which issues were encountered.  In the 
latter case, row numbers in the messages indicate which observations in the input data 
had issues.
}
\description{
Check input data for PHABMetrics
}
\details{
This function checks the following, relevant for the specified class of metrics:
\describe{
\item{}{\code{\link{algae}}: There are no conflicting values for every unique combination of \code{id}, \code{LocationCode}, \code{AnalyteName}, and \code{VariableResult} combination should have only one entry in \code{VariableResult} where \code{AnalyteName} is equal to \code{"Microalgae Thickness"}, \code{"Macrophyte Cover"}, \code{"Macroalgae Cover, Attached"}, or \code{"Macroalgae Cover, Unattached"}. This check is done for \code{algae()} metrics.}
\item{}{\code{\link{channelsinuosity}}: There are no conflicting values for every unique combination of \code{id}, \code{LocationCode}, \code{AnalyteName}, and \code{Result} combination should have only one entry in \code{Result} where \code{AnalyteName} is equal to \code{"Slope"}, \code{"Length, Segment"}, \code{"Elevation Difference"}, \code{"Bearing"}, \code{"Proportion"}, or \code{"Length, Reach"}.}
}
}
\examples{
dat <- phabformat(sampdat)

# get messages
datmsg <- chkinp(dat, msgs = TRUE)
datmsg$msgs

# get messages and purge
datprg <- chkinp(dat, msgs = TRUE, purge = TRUE)
dim(datprg$data)

}
