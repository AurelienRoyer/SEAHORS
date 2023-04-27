\name{SEAHORS}
\alias{SEAHORS}

\title{SEAHORS}
\description{SEAHORS is a R shiny application dedicated to the intra-site spatial analysis of piece-plotted archaeological remains,making the two and three-dimensional spatial exploration of archaeological data as user-friendly as possible.}

\usage{
SEAHORS()
}

\details{
This is a launcher function for the `SEAHORS` application.
}
\value{
	Launch the `SEAHORS` Shiny application.
}
\author{Aurelien Royer <aurelien.royer at u-bourgogne.fr>}

\seealso{
	\code{shiny}
    \code{\link[shinythemes]{shinytheme}}
	\code{plotly}
    \code{\link[plotly]{layout}}
	\code{ggplot2}
    \code{\link[mgcv]{gam}}
    \code{\link[cxhull]{cxhull}}
    \code{\link[cxhull]{hullMesh}}
}
\references {
Royer, A., Discamps, E., Plutniak, S., & Thomas, M. (submitted). SEAHORS: Spatial Exploration of ArcHaeological Objects in R Shiny. Submitted to PCI Archaeology, 2023
Preprint: https://doi.org/10.5281/zenodo.7674699
}

\examples{
	\dontrun{
	SEAHORS()
	}
}
