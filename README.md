SEAHORS
================

# [<img src="https://raw.githubusercontent.com/AurelienRoyer/SEAHORS/main/www/logo1.png" height="60em" align="center"/>](https://github.com/AurelienRoyer/SEAHORS) Spatial Exploration of ArcHaeological Objects in R Shiny

[![DOI](https://zenodo.org/badge/581203118.svg)](https://zenodo.org/badge/latestdoi/581203118)

SEAHORS is a R Shiny free open-source application, that allows easy and
quick exploration of the spatial distribution of archaeological objects.
The main goal of this application is to make the two and
three-dimensional spatial exploration of archaeological data as
user-friendly as possible, in order to give opportunities to researchers
not familiar with GIS and R to undertake such approaches.

SEAHORS has an easily accessible interface and uses text and Excel files
(.csv and .xls respectively). The application includes functions to
merge several databases, for example when spatial data and analysis data
are stored in separate files.

SEAHORS can generate five types of plots: 3D, 2D and density plots, as
well as plots for which it is possible to cut off the site into slices
and to modify the angle of projection to explore spatial organisation
without constraint of the grid orientation. SEAHORS has visualization
tools with several sorting and formatting keys (colours) applicable to
coordinates and all possible analysis variables (i.e. levels, splits,
analytical attributes).

## Installation

  - Install R (<https://www.r-project.org/>) and optionally Rstudio
    Desktop (<https://posit.co/download/rstudio-desktop/>) to have a
    more comfortable R environment.
  - Open the script in R or Rstudio.
  - To execute the R shiny script in R, you must highlight the code
    (“Select all” or CTRL + A) and click on “Run all” or press CTRL +
    18. 
  - To execute the R shiny script in R studio, you can either highlight
    the code (“Select all” or CTRL + A) and click on “Run selected
    lines” or CTRL + Enter, or simply click on the “Run App” button
    (at the top of the editor window).

The application will be launched automatically and the necessary R
package will be installed automatically the first time.

The first launch may therefore take some time.

## Demonstration and tutorial

The application overview is detailled the paper (Royer et al. preprint,
see Reference).

A tutorial video of SEAHORS is available [in
English](https://nakala.fr/10.34847/nkl.3fdd6h8j) and [in
French](https://nakala.fr/10.34847/nkl.65bf1h72).

A web application of SEAHORS v1 is deployed on the Shinyapps.io server:
<https://aurelienroyer.shinyapps.io/Seahors/>

## Data accessibility of Cassenade as example

  - Spatial data: <https://nakala.fr/10.34847/nkl.e30aie2u>
  - Refit: <https://nakala.fr/10.34847/nkl.fe27j10z>
  - Orthophoto: <https://nakala.fr/10.34847/nkl.7ea78e6u>

## Reference

Royer, A., Discamps, E., Plutniak, S., & Thomas, M. (submitted).
SEAHORS: Spatial Exploration of ArcHaeological Objects in R Shiny.
Submitted to [PCI
Archaeology](https://archaeo.peercommunityin.org/PCIArchaeology), 2023

Preprint: <https://doi.org/10.5281/zenodo.7674699>

## Update

### v1.5 April 2023

Add ggplot 2D tab :“Simple 2D plot” with pdf download and numeric imput
to modify the projection ratio.

Add a button “advanced plot” at ggplot 2D slide to activated plotly or
ggplot figure. Add a ratio imput when the button is unchecked.

Add “Figure options” sidebar conditional panel : to modify the labels
axis, the size of the labels and the tick mark, the space between major
tick mark and minor grid (without tick marks), and the theme of ggplot
figure (“Simple 2D plot” and “Density Plot”).

Add a button to directly load the dataset example of Cassenade. Button
is on the overview panel.

Correction DensityPlot and modification of point size and transparency.

Correction color for simple 2D plot

Correction color for refit projection
