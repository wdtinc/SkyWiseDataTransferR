% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/DataTransfer.R
\name{GetProducts}
\alias{GetProducts}
\title{GetProducts}
\usage{
GetProducts()
}
\value{
an R object resulting from the fromJSON call applied to the output from the api
}
\description{
Makes a call to the data transfer api to retrieve the products available for download
}
\examples{
\dontrun{products <- GetProducts()}
}
