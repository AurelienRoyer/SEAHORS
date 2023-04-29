\name{SEAHORS}
\alias{SEAHORS}

\title{SEAHORS}

\description{This package is a R shiny application dedicated to the intra-site spatial analysis of piece-plotted archaeological remains,making the two and three-dimensional spatial exploration of archaeological data as user-friendly as possible.}

\usage{
SEAHORS()
}

\details{This is a launcher function for the `SEAHORS` application.}

\value{Launch the `SEAHORS` Shiny application.}

\author{Aurelien Royer <aurelien.royer at u-bourgogne.fr>}

\seealso{
	\code{shiny}
	\code{plotly}
	\code{ggplot2}
}

\references{
Royer, A., Discamps, E., Plutniak, S., & Thomas, M. 2023. "SEAHORS: Spatial Exploration of ArcHaeological Objects in R Shiny". PCI Archaeology. DOI: 10.5281/zenodo.7674699.
}

\examples{
	if(interactive(SEAHORS()))
}
