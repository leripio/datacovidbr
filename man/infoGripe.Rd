% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/infoGripe.R
\name{infoGripe}
\alias{infoGripe}
\title{Data from http://info.gripe.fiocruz.br/}
\usage{
infoGripe()
}
\value{
A \code{list} with elements \code{casos} e \code{obitos}, containing \code{tibbles}
with the distribution of cases and deaths, respectively, by week and
age.
}
\description{
Extracts the data used in http://info.gripe.fiocruz.br/.
A description of the dataset is available at the link in the references.
}
\references{
https://gitlab.procc.fiocruz.br/mave/repo/-/tree/master/Dados/InfoGripe
}
