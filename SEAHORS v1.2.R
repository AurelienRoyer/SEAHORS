#############################################################################################
##### SEAHORS: Spatial Exploration of ArcHaeological Objects in R Shiny - V1.2 - 13 Apr 2023
#############################################################################################
#

##### package needed
if (!require('shiny')) install.packages('shiny'); library('shiny') #shiny
if (!require('shinythemes')) install.packages('shinythemes'); library('shinythemes') #journal
if (!require('shinyjs')) install.packages('shinyjs'); library('shinyjs') # toggle
if (!require('shinyWidgets')) install.packages('shinyWidgets'); library('shinyWidgets') #spectrumInput
if (!require('ggplot2')) install.packages('ggplot2'); library('ggplot2') #ggplot
if (!require('gridExtra')) install.packages('gridExtra'); library('gridExtra') #grid.arrange
if (!require('dplyr')) install.packages('dplyr'); library('dplyr') #%
if (!require('plotly')) install.packages('plotly'); library('plotly') #plotly
if (!require('DT')) install.packages('DT'); library('DT') #DT table
if (!require('readxl')) install.packages('readxl'); library('readxl') #read_xls
if (!require('raster')) install.packages('raster'); library('raster') #stack ; ggrb ; plotRGB 
if (!require('stringr')) install.packages('stringr'); library('stringr') #str_to_lower
if (!require('viridis')) install.packages('viridis'); library('viridis') #color for density
if (!require('htmlwidgets')) install.packages('htmlwidgets'); library('htmlwidgets') 
if (!require('rmarkdown')) install.packages('rmarkdown'); library('rmarkdown') ## for the report


##### script R shiny
options(shiny.reactlog = TRUE)
css <- "
.radio-inline {
  padding: 0 3px;
  text-align: center;
  margin-left: 0 !important;
  line-height: 30px;

}
.radio-inline input {
  top: 20px;
  left: 50%;
  margin-left: -6px !important;
  line-height: 30px;
}"
ui <- navbarPage(
  windowTitle = "SEAHORS",
  fluidPage(
    useShinyjs(),
    theme = shinytheme(theme = "journal"),
    sidebarLayout(
      sidebarPanel(span(img(src = "logo1.png", height = 110)),
                   tags$header(
                     tags$a(href = "https://github.com/AurelienRoyer/SEAHORS/",
                            "Spatial Exploration of ArcHaeological Objects in R Shiny")),
                   tags$hr(),
                   
                   tags$style(HTML(css)),

                   radioButtons(
                                "bt2", h4("QUICK SIDEBAR"),
                                choices = c("Data" = 1,
                                            "Point size" = 2,
                                            "Point color" = 3,
                                            "Point shape" = 4,
                                            "Fig. options"=5),
                                selected = "1", inline=TRUE), style = "font-size:90%",

                   tags$hr(),
                   conditionalPanel(condition="input.bt2==1",
                                    h4(style = "color: red;","Subsetting dataset"),
                                    tags$br(),
                                    uiOutput("Date"),
                                    uiOutput("xlimits"),
                                    uiOutput("ylimits"),
                                    uiOutput("zlimits"),
                                    uiOutput("liste.sector"),
                                    uiOutput("liste.UAS"),
                                    fluidRow(conditionalPanel("output.fileUploaded", 
                                                              column(5,
                                                                     actionButton("all_UAS_entry", label = "ALL"),),
                                                              column(2,
                                                                     actionButton("reset_UAS_entry", label = "reset"),)
                                    )),#end fluidrow
                                    uiOutput("liste.Nature"),
                                    fluidRow(conditionalPanel("output.fileUploaded", 
                                                              column(5,
                                                                     actionButton("all_artifact_entry", label = "ALL"),),
                                                              column(2,
                                                                     actionButton("reset_artifact_entry", label = "reset"),))
                                    ), #end fluidrow
                                    
                                    uiOutput("liste.passe"),
                                    width=4, 
                   ), # end of conditionalPanel
                   conditionalPanel(condition="input.bt2==2",
                                    h4(style = "color: red;","Modifying point size according to a variable"),
                                    tags$br(),
                                    fluidRow(column (6,numericInput("minsize", "Minimal point size", 0.25, min = 0.1, max=10, width="50%")),
                                             column (6,numericInput("point.size", "Default point size", 2, min = 1, max=20, width="50%"), ),  ),
                                    uiOutput("sectionXx2"),
                                    uiOutput("sectionXy2"),
                                    uiOutput("sectionXz2"),
                                    uiOutput("var.gris.2D"),
                                    uiOutput("var.gris.2D.1"),
                   ), # end of conditionalPanel
                   conditionalPanel(condition="input.bt2==3",
                                    h4(style = "color: red;","Modifying point color according to a variable"),
                                    tags$h5(style = "color: blue;","you can import color ramp from panel 'additional settings'"),
                                    
                                    tags$br(),
                                    fluidRow(column (7,checkboxInput("optioninfosfigplotly", "Show figure legend", TRUE))),
                                    tags$br(),
                                    uiOutput("liste.Colors"),
                                    tags$hr(),
                                    column(7,div(style = "height:2px"),
                                           h4("Select colors"),
                                           uiOutput("colors2")),
                                    tags$br(),
                                    tags$br(),
                   ), # end of conditionalPanel
                   conditionalPanel(condition="input.bt2==4",
                                    h4(style = "color: red;","Modifying point shape"),
                                    tags$br(),
                                    column(9,
                                           column(6,selectInput("shape", "main shape",
                                                                choices= list("circle"='circle',
                                                                              "square"= 'square',
                                                                              "triangle"='triangle-up',
                                                                              "diamond"='diamond' )),
                                           ),
                                           
                                           column(6, style = "margin-top: 25px;", actionButton("do.shape1", "Set main shape ")),
                                    ),
                                    column(10,
                                           
                                           column(7, uiOutput("shape2"),),
                                           column(6,  style = "margin-top: 3px;",uiOutput("shape2.var1"),),
                                           column(6,  style = "margin-top: 3px;",uiOutput("shape2.var2"),),
                                           br(),
                                           column(6, actionButton("do.shape2", "Set secondary shape")),
                                           
                                           tagAppendAttributes(textOutput("text.shape"), style="white-space:pre-wrap;"),
                                    )
                                    
                   ),# end of conditionalPanel
                   conditionalPanel(condition="input.bt2==5",
                                    h4(style = "color: red;","Figure options"),
                                    tags$br(),
                                    br(),
                                    column(10,
                                           column(4,numericInput("fontsizeaxis", "Axis font size",12, min = 1, max=40),),
                                           column(4,numericInput("fontsizetick", "tick font size",12, min = 1, max=40),),),
                                    column(10,
                                           column(4,textInput("Name.X", label="Legends name of X",value = "X"),),
                                           column(4,textInput("Name.Y", label="Legends name of Y",value = "Y"),),
                                            column(4,textInput("Name.Z", label="Legends name of Z",value = "Z"),),),
                                    column(10,
                                           column(4,numericInput("Xtickmarks", "Position of X tick marks",1, min = 0, max=40),),
                                                  column(4,numericInput("Ytickmarks", "Position of Y tick marks",1, min = 0, max=40),),
                                    column(4,numericInput("Ztickmarks", "Position of Z tick marks",1, min = 0, max=40),),),
                                    br(),
                                    uiOutput("themeforfigure"),
                   )# end of conditionalPanel
      ), #end sidebarpanel
      
      mainPanel(
        tabsetPanel(type = "tabs",
                    tabPanel("Overview", 
                             tags$div(
                               h2(" Welcome to the", em("SEAHORS"), "application",align="center", style = "font-family: 'Times', serif;
    font-weight: 500; font-size: 500; text-shadow: 3px 3px 3px #aaa; line-height: 1; 
     color: #404040;"),
                               tags$br(),
                               column(12, 
                                      column(3,),
                                      column(6,span(img(src = "logo2.png", height = 200)),),
                                      tags$br(),
                                      tags$br(),     
                               ),
                               column(12, br(),
                                      column(1,),
                                      column(9,
                                             br(),
                                             
                                             HTML(
                                               " <div style=width:100%;, align=left>
    <font size=3>
   <span style='text-transform:none'>
   
   <i>SEAHORS</i> is dedicated to the intra-site spatial analysis of archaeological piece-plotted</p>
   
   <p> v1.2</p>
   <p>This shiny R script makes possible to explore the spatial organisation of coordinate points taken on archaeological fields 
  and to visualise their distributions using interactive 3D and 2D plots </p>
   <br>
   <p> An overview of the possibility was published by: </p>
   <p> Royer, A., Discamps, E., Plutniak, S., & Thomas, M. (submitted) - SEAHORS: Spatial Exploration of ArcHaeological Objects in R Shiny. </p>
   <p> Submitted to PCIArchaeology, 2023 
   <a href=https://archaeo.peercommunityin.org/PCIArchaeology target=_blank>https://archaeo.peercommunityin.org/PCIArchaeology/</a></p>
   <p> Preprint: https://doi.org/10.5281/zenodo.7674699 </p>
   <p>A video explaining the features is also available <a href=https://nakala.fr/10.34847/nkl.3fdd6h8j target=_blank>here</a></p>
  <br>
   <p>The source code is openly published on the dedicated <a href=https://github.com/AurelienRoyer/SEAHORS/ target=_blank>github repository</a>
   <p style = 'color:blue;'> <i>ENJOY IT !</i></color> </p> 
   
   </span> 
   
      </font size>           </div>" )
                                      ), ), #end of column
                             ) # end div()
                             
                    ), #end of tabPanel
                    tabPanel("Load data", 
                             tabsetPanel(type = "tabs",
                                         tabPanel(tags$h5("Import xyz data"), 
                                                  tags$br(),
                                                  tags$br(),
                                                  tags$hr(),
                                                  fluidRow(column(10,
                                                                  tags$h4(style = "color: red;","Options for loading file"), 
                                                                  checkboxInput("header", "Header", TRUE),
                                                                  checkboxInput("set.dec", "Check this option to automatically correct for the presence of comma in decimal numbers", TRUE),
                                                                  tags$hr(),
                                                  ),#endcolumn
                                                  ),#end of fluidrow  
                                                  fluidRow(column(12,
                                                                  fileInput("file1", "Choose File (.csv/.xls/.xlsx)",
                                                                            multiple = TRUE,
                                                                            accept = c("text/csv",
                                                                                       "text/comma-separated-values",
                                                                                       ".csv",
                                                                                       ".xlsx",".xls")),
                                                                  selectInput(inputId = "worksheet", label="Worksheet Name", choices =''),
                                                                  actionButton(inputId = "getData",label="Get Data"),
                                                                  actionButton('reset.BDD', 'Reset Input')
                                                  )),
                                                  fluidRow(
                                                    tags$br(),
                                                    htmlOutput("nb6"),
                                                    column (7, 
                                                            tags$hr(),
                                                            tags$h4(style = "color: red;","Basic data"), 
                                                            tags$br(),
                                                            
                                                            fluidRow(column(6,uiOutput("set.x"),), 
                                                                     column(2,checkboxInput("checkbox.invX", label = "Inversion of x", value = F),),),
                                                            fluidRow(column(6,uiOutput("set.y"),), 
                                                                     column(2,checkboxInput("checkbox.invY", label = "Inversion of y", value = F),),),
                                                            fluidRow(column(6,uiOutput("set.z"),), 
                                                                     column(2,checkboxInput("checkbox.invZ", label = "Inversion of z", value = F),),),
                                                            uiOutput("set.ID"),
                                                            tags$hr(),
                                                            tags$br(),
                                                            tags$br(),
                                                            tags$h4(style = "color: red;","Variable for quick sidebar selection"), 
                                                            tags$br(),
                                                            uiOutput("set.date"),
                                                            uiOutput("set.sector"), 
                                                            uiOutput("set.levels"),  
                                                            uiOutput("set.nature"),
                                                            uiOutput("set.passe"),
                                                    ), #endcolumn
                                                  ),#end of fluidrow   
                                                  tags$hr(),
                                                  tableOutput("contents")
                                         ), #end of tabPanel
                                         tabPanel(tags$h5("Merge additional data"), 
                                                  tags$br(),
                                                  tags$h5(style = "color: blue;","This allows you to merge additional data with the XYZ data, using a Unique object ID (recorded in a column in both datasets). First, load the additional data below:"),
                                                  tags$br(),
                                                  fileInput("file.extradata", "Choose File (.csv/.xls/.xlsx)",
                                                            multiple = TRUE,
                                                            accept = c("text/csv",
                                                                       "text/comma-separated-values",
                                                                       ".csv",
                                                                       ".xlsx",".xls")),
                                                  tags$h5(style = "color: blue;","Choose the column with the same Unique object ID, then press Merge "),
                                                  uiOutput("set.columnID"),
                                                  tags$br(),
                                                  actionButton("goButton.set.columnID", "Merge"),
                                                  tags$br(),
                                                  tags$br(),
                                                  tags$hr(),
                                                  tags$h5(style = "color: red;","Report on the merging"),
                                                  tags$h5(style = "color: blue;","IDs that are NOT unique in the XYZ dataset"),
                                                  verbatimTextOutput("notunique"),
                                                  tags$h5(style = "color: blue;","IDs that are NOT unique in the additional dataset"),
                                                  verbatimTextOutput("notunique2"),
                                                  tags$h5(style = "color: blue;","Objects present in the XYZ dataset that have no correspondence in the additional dataset"),
                                                  verbatimTextOutput("suppl.no.include"),
                                                  tags$h5(style = "color: blue;","Objects present in the additional dataset that have no correspondence in the XYZ dataset"),
                                                  verbatimTextOutput("ID.no.suppl.data"),
                                                  tags$br(),
                                         ),#end tabpanel
                                         tabPanel(tags$h5("Import orthophoto "), 
                                                  tags$br(),
                                                  tags$h5(style = "color: red;","Orthophoto file must be in .tiff format"), 
                                                  tags$br(),
                                                  fluidRow(
                                                    fileInput("file2", "For x/y section",
                                                              multiple = F,
                                                              accept = c(".tif",".tiff")), 
                                                    uiOutput("liste.ortho.file2"),
                                                    fileInput("file5", "For y/x section",
                                                              multiple = F,
                                                              accept = c(".tif",".tiff")),
                                                    uiOutput("liste.ortho.file5"),
                                                    fileInput("file3", "For x/z section",
                                                              multiple = F,
                                                              accept = c(".tif",".tiff")),
                                                    uiOutput("liste.ortho.file3"),
                                                    fileInput("file4", "For y/z section",
                                                              multiple = F,
                                                              accept = c(".tif",".tiff")),
                                                    uiOutput("liste.ortho.file4"),
                                                  )#end fluidrow
                                         ),#end tabpanel
                                         tabPanel(tags$h5("Import refit data"), 
                                                  tags$br(),
                                                  tags$br(),
                                                  tags$h5(style = "color: red;", "This allows you to import refit data, either directly from the XYZ dataset, or from another file using a Unique object ID (recorded in a column in both datasets). Recommended format for the refit data: a dataframe with two columns, one with the unique object ID and one with a unique number for each refit group"),
                                                  fileInput("file.fit", "Choose File (.csv/.xls/.xlsx)",
                                                            multiple = TRUE,
                                                            accept = c("text/csv",
                                                                       "text/comma-separated-values",
                                                                       ".csv",
                                                                       ".xlsx",".xls")),  
                                                  tags$h5(style = "color: blue;","Choose the column with the Unique object ID, then press Import refit data"),
                                                  column(12,
                                                         column(8, uiOutput("set.columnID.for.fit"),),
                                                         tags$br(),
                                                         column(8, uiOutput("set.REM"),),
                                                         column(12,checkboxInput("Refit.data.from.XYZ.file", label = "Check this box if the refit data is included in the XYZ dataset", value = F),),
                                                         tags$br(),
                                                  ), # end of column
                                                  actionButton("goButton.set.columnID.for.fit", "Import refit data"),
                                                  tags$br(),
                                                  tags$br(),
                                                  tags$h5(style = "color: blue;","Table of refits"),
                                                  verbatimTextOutput("Fit.table.output"),
                                                  downloadButton("downloadData_redata", "Download"),
                                         ),#end tabpanel
                                         tabPanel(tags$h5("Concatenate two columns"), 
                                                  tags$br(),
                                                  column(12,textInput("Merge.groupe", "Choose the name of the new column",value = "new.concatenate.col"),),
                                                  tags$br(),
                                                  column(8, uiOutput("set.col1"),),
                                                  tags$br(),
                                                  column(8,radioButtons("separatormerge", "separator between the two names",
                                                                        choices = c("." = ".",
                                                                                    "_" = "_",
                                                                                    "-" = "-",
                                                                                    "," =",",
                                                                                    "nospace"= ""),
                                                                        selected = "_", inline=TRUE),),
                                                  tags$br(),
                                                  tags$br(),
                                                  column(8, uiOutput("set.col2"),),
                                                  tags$br(),
                                                  column(8,actionButton("Merge2", "Concatenate the two columns"),),
                                         ),
                             ),#end tabSETPanel
                    ),#end tabpanel
                    
                    tabPanel("Table", 
                             tabsetPanel(type = "tabs",
                                         tabPanel(tags$h5("Raw table"), 
                                                  fluidRow(
                                                    column(10,
                                                           DTOutput("table"))),
                                                  column(11, downloadButton("downloadData_rawdata", "Download")),
                                         ),#end tabpanel
                                         tabPanel(tags$h5("Pivot table"),
                                                  fluidRow(
                                                    uiOutput("liste.summary"),
                                                    column(5,
                                                           h4("Remains class "),
                                                           tableOutput("summary")),
                                                    column(11, downloadButton("downloadData_pivotdata", "Download")),
                                                  ) #end fluidrow
                                         ), #end tabpanel
                             ), #end tabset panel
                    ), #end tabPanel
                    
                    tabPanel("3D plot",
                             fluidRow(
                               tags$br(),
                               htmlOutput("nb"),
                               tags$br(),
                               tags$br(),
                               column(12,
                                      uiOutput("plot3Dbox"),),
                               tags$br(),
                               tags$hr(),
                               tags$br(),
                               tags$hr(),),
                             fluidRow(
                               hr(style = "border-top: 1px solid #000000;"), 
                               column(12,
                                      column (8,fluidRow( column (4,numericInput("ratiox", "X ratio", 1, min = 1,  max=10, width="50%")),
                                                          column (4,numericInput("ratioy", "Y ratio", 1, min = 1,  max=10, width="50%")),
                                                          column (4,numericInput("ratioz", "Z ratio", 1, min = 1,  max=10, width="50%")),),
                                      ),
                                      column(4,numericInput("height.size.a", label = h5("Figure height"), value = 800),),),),
                             tags$br(),
                             tags$br(),
                             tags$br(),
                             
                             column(8, downloadButton("downloadData3D", "Download as .HTML")),
                             tags$hr(),
                             tags$br(),
                             uiOutput("var.fit.3D"),
                    ), #end tabPanel 
                    tabPanel("2D plot", 
                             
                             tabsetPanel(type = "tabs",
                                         tabPanel(tags$h5("Advanced 2D plot"),
                                                  
                                                  fluidRow(tags$br(),
                                                           htmlOutput("nb2"),
                                                           tags$br(),
                                                           column(1,  actionButton("run_button", "Display/refresh", icon = icon("play")),),
                                                           tags$br(),
                                                           tags$br(),
                                                           tags$br(),
                                                           column(12,      
                                                                  radioButtons("var1", "section",
                                                                               choices = c(xy = "xy",
                                                                                           yx = "yx",
                                                                                           yz = "yz",
                                                                                           xz = "xz"),
                                                                               selected = "xy", inline=TRUE),
                                                                  tags$br(),),
                                                           
                                                           column(12,
                                                                  uiOutput("plot2Dbox"),),
                                                           tags$br(),),
                                                  fluidRow(
                                                    tags$br(),
                                                    tags$br(),
                                                    hr(style = "border-top: 1px solid #000000;"), 
                                                    column(12,
                                                           column(6,downloadButton("downloadData2D", "Download as .HTML")),
                                                           column(3,numericInput("height.size.b", label = h5("Figure height"), value = 800),),
                                                           column(3,numericInput("width.size.b", label = h5("Figure width"), value = 1000),),),),
                                                  radioButtons("var.ortho", "include ortho",
                                                               choices = c(no = "no",
                                                                           yes = "yes"),
                                                               selected = "no", inline=TRUE),  
                                                  tags$br(),
                                                  radioButtons("var.fit.table", "Include refits",
                                                               choices = c(no = "no",
                                                                           yes = "yes"),
                                                               selected = "no", inline=TRUE),
                                                  hr(style = "border-top: 0.5px solid #000000;"), 
                                                  fluidRow(column(8,
                                                                  tags$br(),
                                                                  tags$h4(style = "color: red;","How to record a new variable in SEAHORS:"),
                                                                  tags$h5(style = "color: blue;","Step1: go to the RECORD NEW GROUP subpanel in the ADDITIONAL SETTINGS panel"),
                                                                  tags$h5(style = "color: blue;","Step2: choose a name for your new group variable and create it"),
                                                                  tags$h5(style = "color: blue;","Step3: go back to 2D PLOT panel, and use the box or lasso tool to select points"),
                                                                  tags$h5(style = "color: blue;","Step4: click on the button below to record group information for the selected points"),
                                                  ),
                                                  column(12,actionButton('Change2','Change Group Assignment'),),
                                                  tags$br(),
                                                  column(8,
                                                         tags$br(),
                                                         tags$br(), 
                                                  ),
                                                  ),#end fluidrow
                                                  fluidRow(
                                                    column(9,
                                                           verbatimTextOutput("brushed"))
                                                  ) #end fluidrow
                                         ), #end sub-tabpanel
                                         
                                         tabPanel(tags$h5("Simple 2D plot"),
                                                  fluidRow(tags$br(),
                                                           htmlOutput("nb2.2"),
                                                           tags$br(),
                                                           #column(1,  actionButton("run_button2", "Display/refresh", icon = icon("play")),),
                                                           tags$br(),
                                                           tags$br(),
                                                           tags$br(),
                                                           column(12,      
                                                                  radioButtons("var1.simple", "section",
                                                                               choices = c(xy = "xy",
                                                                                           yx = "yx",
                                                                                           yz = "yz",
                                                                                           xz = "xz"),
                                                                               selected = "xy", inline=TRUE),
                                                                  tags$br(),),
                                                           
                                                           column(12,
                                                                  uiOutput("plot2Dbox.simple"),),
                                                           tags$br(),),
                                                  fluidRow(
                                                    tags$br(),
                                                    tags$br(),
                                                    hr(style = "border-top: 1px solid #000000;"), 
                                                    ### a finir dessous 
                                                    column(12,
                                                           column(2,numericInput("ratio.to.coord.simple", label = h5("Ratio figure"), value = 1),),
                                                           column(2),
                                                           column(3,numericInput("height.size.b.simple", label = h5("Figure height"), value = 800),),
                                                           column(3,numericInput("width.size.b.simple", label = h5("Figure width"), value = 1000),),),),
                                                  column(12,
                                                         column(2,radioButtons("var.ortho.simple", "include ortho",
                                                                               choices = c(no = "no",
                                                                                           yes = "yes"),
                                                                               selected = "no", inline=TRUE),  ),
                                                         column(2, radioButtons("var.fit.table.simple", "Include refits",
                                                                                choices = c(no = "no",
                                                                                            yes = "yes"),
                                                                                selected = "no", inline=TRUE),),
                                                         column(2),
                                                         column(6,downloadButton("downloadData2D.simple", "Download as .pdf")), 
                                                         hr(style = "border-top: 0.5px solid #000000;"), ),
                                                  tags$br(),
                                                  
                                                  
                                         ),#end tabpanel    
                             ), #end tabset panel
                    ), #end tabPanel
                    
                    tabPanel("2D slice",
                             fluidRow(tags$br(),
                                      htmlOutput("nb3"),
                                      tags$br(),
                                      tags$br(),
                                      column(12,
                                             radioButtons("var.2d.slice", "section",
                                                          choices = c(#xy = "xy",
                                                            #yx = "yx",
                                                            yz = "yz",
                                                            xz = "xz"),
                                                          selected = "yz", inline=TRUE),
                                             tags$br(),),
                                      
                                      column(12, numericInput("step2dslice", HTML("Thickness of slices <br> (lower this parameter to get more slices)"), 4, min = 0.1, max=10,step = 1, width="50%")),
                                      column(12, uiOutput("range.2d.slice")),
                                      tags$br(),
                                      tags$br(),
                                      column(12,
                                             uiOutput("plot.2dslide")),
                                      tags$br(),      
                             ),# end of fluidrow
                             hr(style = "border-top: 1px solid #000000;"), 
                             fluidRow(column(12,
                                             column(12, downloadButton("downloadData2d.slice", "Download as .HTML")),
                                             column(5,
                                                    numericInput("height.size.c", label = h5("Figure height"), value = 400),),
                                             column(5,
                                                    numericInput("width.size.c", label = h5("Figure width"), value = 600),),
                                             #column(8,
                                             #      numericInput("point.size5", "Default point size", 2, min = 1, max=20, width="50%"),),
                             ),),#end of fluidrow
                    ), #end tabPanel
                    tabPanel("Rotated 2D plot",
                             tags$br(),
                             htmlOutput("nb4"),
                             tags$br(),
                             fluidRow(column(8,sliderInput('pi2','Angle of rotation:',1,min=-180,max=180,step=1, value=0),),
                                      column(12,
                                             uiOutput("plot2Drota"),
                                             radioButtons("var.section2D", "section",
                                                          choices = c(xz = "xz",
                                                                      yz = "yz"),
                                                          selected = "xz", inline=TRUE),
                                             uiOutput("plot2Drota2"),),
                                      tags$br(),
                                      tags$br(),),
                             hr(style = "border-top: 1px solid #000000;"), 
                             fluidRow(column(12,
                                             column(5,
                                                    numericInput("height.size.d", label = h5("Figure height"), value = 800),),
                                             column(5,
                                                    numericInput("width.size.d", label = h5("Figure width"), value = 1000),),
                             ),
                             tags$br(),
                             column(12,actionButton("transferxyz", "Replace XYZ data with the newly computed rotated XYZ coordinates"),),
                             ),#end of fluidrow
                             tags$br(),
                             tags$br(),
                             fluidRow(
                               column(12, downloadButton("downloadData_rotateddata", "Download rotated coordinates in .csv")),
                               tags$br(),
                               tags$br(),
                               tags$br(),
                               column(12,
                                      column(7,uiOutput("sectionXx3"),),
                                      column(7,uiOutput("sectionXy3"),),
                               ),#end of column
                             ), #end of fluidrow
                    ), #end tabPanel 
                    
                    tabPanel("Density plot", 
                             fluidRow(tags$br(),
                                      htmlOutput("nb5"),
                                      
                                      tags$br(),
                                      column(12,
                                             uiOutput("plotdens"),),
                                      tags$br(),
                             ),#end of fluidrow
                             tags$br(),
                             hr(style = "border-top: 1px solid #000000;"), 
                             fluidRow(column(12,
                                             column(4,radioButtons("var3", "section",
                                                                   choices = c(xy = "xy",
                                                                               yx = "yx",
                                                                               yz = "yz",
                                                                               xz = "xz"), inline=TRUE),),
                                             column(8, downloadButton("downloadDatadensity", "Download as .pdf")),),
                                      column(12,  
                                             column(4,
                                                    numericInput("height.size.e", label = h5("Figure height"), value = 800),),
                                             column(4,
                                                    numericInput("width.size.e", label = h5("Figure width"), value = 1000),),
                                             column(2,checkboxInput("ratio.to.coord", label = "Aspect ratio = 1", value = F),),
                                      ),
                                      column(12,
                                             radioButtons("var.ortho2", "Include ortho",
                                                          choices = c(no = "no",
                                                                      yes = "yes"),
                                                          selected = "no", inline=TRUE),
                                             tags$hr(),
                                             column(4, numericInput("alpha.density", "Transparency", 1, min = 0, max=1, width="50%"),),
                                             column(4, numericInput("point.size3", "Point size", 1, min = 1, max=20, width="50%"),),
                                      ),
                                      tags$hr(),
                                      column(12,
                                             tags$hr(),
                                             column(4, radioButtons("var.plotlyg.lines", "include density lines",
                                                                    choices = c(no = "no",
                                                                                yes = "yes"),selected = "no"),),
                                             
                                             column(4,radioButtons("var.density.curves", "include density curves",
                                                                   choices = c(no = "no",
                                                                               yes = "yes"),selected = "no"),),),
                                      tags$br(),
                                      tags$br(),
                                      tags$hr(),
                                      column(12,
                                             tags$h5(style = "color: blue;","Density calculated by mass::ke2D package, using Kernel density"),),
                             ) #end fluidrow
                    ), #end tabPanel
                    
                    tabPanel("Additional settings",
                             tabsetPanel(type = "tabs",
                                         tabPanel(tags$h5("Color ramps"),
                                                  br(),
                                                  column(6,
                                                         column(6, downloadButton("save.col", "Save color ramp")),
                                                         br(),
                                                         br(),
                                                         br(),
                                                         br(),
                                                         column(6,   fileInput("file.color", "Choose File to import color ramp (.csv)",
                                                                               multiple = TRUE,
                                                                               accept = c("text/csv",
                                                                                          "text/comma-separated-values,text/plain",
                                                                                          ".csv")),  ),
                                                  )#end of column
                                         ),
                                         tabPanel(tags$h5("Refit customization"),
                                                  br(),
                                                  br(),
                                                  uiOutput("liste.Colors.refit"),
                                                  column(4, div(style = "height:2px"),
                                                         h4("Select a color for refit groups"),
                                                         uiOutput("colorsrefits")),
                                                  column(6, downloadButton("save.col.fit", "Save color ramp")),
                                                  br(),
                                                  br(),
                                                  br(),
                                                  br(),
                                                  column(6,   fileInput("file.color.fit", "Choose File to import color ramp (.csv)",
                                                                        multiple = TRUE,
                                                                        accept = c("text/csv",
                                                                                   "text/comma-separated-values,text/plain",
                                                                                   ".csv")),  ),
                                                  
                                                  column (6,numericInput("w2", "thickness of lines",2, min = 1, max=10, width="50%")),
                                                  br(),
                                                  column (12,tags$hr(),),
                                                  uiOutput("liste.var.refit"),
                                                  br(),
                                                  uiOutput("liste.varrefit"),
                                                  
                                         ), #end of tabPanel

                                         tabPanel(tags$h5("Slider parameters"),
                                                  br(),
                                                  
                                                  tags$hr(),
                                                  fluidRow(column (7,numericInput("stepXsize", "Steps used for the X slider in the quick sidebar", 0.1, min = 0.1, step=0.1, max=100, width="50%")),
                                                           column (7,numericInput("stepYsize", "Steps used for the Y slider in the quick sidebar", 0.1, min = 0.1, step=0.1, max=100, width="50%")),
                                                           column (7,numericInput("stepZsize", "Steps used for the Z slider in the quick sidebar", 0.1, min = 0.1, step=0.1, max=100, width="50%")),
                                                  ),
                                                  tags$hr(),
                                         ),
                                         tabPanel(tags$h5("Information shown while hovering points"),
                                                  br(),
                                                  uiOutput("liste.infos"),
                                                  br(),
                                                  actionButton("listeinfos.go", "Update"),
                                         ),
                                         tabPanel(tags$h5("Record new group"), 
                                                  br(),
                                                  br(),
                                                  column (12,tags$h3("Record new group"),
                                                          br(),
                                                          textInput("text.new.group", label="Name of the new group variable",value = "new.group"),
                                                          uiOutput("liste.newgroup"),
                                                          actionButton("go.ng", "Create"),
                                                          br(),
                                                          br(),),
                                                  column (12,
                                                          hr(style = "border-top: 1px solid #000000;"), 
                                                          br(),
                                                          tags$h3("Rename new group modality"),
                                                          uiOutput("liste.newgroup2"),
                                                          uiOutput("liste.newgroup4"),
                                                          textInput("text.new.group2", label=h5("New name of the modality"),value = "new.modality"),
                                                          actionButton("go.ng2", "Modify"),),
                                                  
                                         ), #end tabpanel
                                         tabPanel(tags$h5("Export settings"), 
                                                  br(),
                                                  radioButtons("docpdfhtml", "Export format",
                                                               choices = c(html = "html"),
                                                               
                                                               selected = "html", inline=TRUE),
                                                  br(),
                                                  fluidRow(
                                                    column(6, downloadButton("export.Rmarkdown", "Export settings as Rmarkdown document")),
                                                  )
                                         ), #end tabpanel
                                         
                             ),#end tabsetpanel temp
                    ), # end of tabpanel
        ) #end tabset panel
      ) #end main panel
      ,fluid=FALSE) #sidebarLayout  
  )#endfluidPage
) #end navbarPage

server <- function(input, output, session) {
  
  ##### necessary settings----
  options(shiny.maxRequestSize=150*1024^2) ## limits 150 MO to import
  font.size <- "8pt"
  vv<-NULL ## for plotly_selected
  minsize<-reactiveVal(0.25) ##for min point
  size.scale<-reactiveVal(3) ##for point
  stepX<-reactiveVal(0.1) ## step size sliders
  stepY<-reactiveVal(0.1) ## step size sliders
  stepZ<-reactiveVal(0.1) ## step size sliders
  transpar<-reactiveVal(1) ## alpha for density plot
  data.fit<-reactiveVal() ##for import fit data
  data.fit2<-reactiveVal() ##for import fit data
  data.fit3<-reactiveVal() ##for import fit data
  rotated.new.dataxy<-reactiveVal() ## to include new xyzdata from rotation
  shape_all<-reactiveVal("circle") ##for import fit data
  session_store <- reactiveValues()  ## for save  plot
  setXX<-reactiveVal(NULL) ##input$setx
  setYY<-reactiveVal(NULL) ##input$sety
  setZZ<-reactiveVal(NULL) ##input$setz
  height.size<-reactiveVal(800) ## default size of figure
  width.size<-reactiveVal(1000) ## default size of figure
  data.fit.3D<-reactiveVal() ## for refit data for 3D plot
  listinfosmarqueur<-reactiveVal(NULL) ## for listinfos to be null at the beginning. 
  colorofrefit<-reactiveVal("red")## color base for refit
  legendplotlyfig<-reactiveVal(TRUE) ##for legends.
  inputcolor<-reactiveVal("null")
  fileisupload<-reactiveVal(NULL)
  save.col.react.fit<-reactiveVal()
  mypaletteofcolors.fit<-reactiveVal()
  nnrow.df.df<-reactiveVal(0) ##nrow df$df
  ratiox<-reactiveVal(1) ## aspectratio X
  ratioy<-reactiveVal(1) ## aspectratio y
  ratioz<-reactiveVal(1) ## aspectratio z
  ratio.simple<-reactiveVal(1)
  font_size<-reactiveVal(12)
  font_tick<-reactiveVal(12)
  nameX<-reactiveVal("X")
  nameY<-reactiveVal("Y")
  nameZ<-reactiveVal("Z")
  Xtickmarks.size<-reactiveVal()
  Ytickmarks.size<-reactiveVal()
  Ztickmarks.size<-reactiveVal()
  
  #####
  
  
  ##### Import data----
  
  observe({
    req(!is.null(input$file1))
    extension <- tools::file_ext(input$file1$name)
    switch(extension,
           csv = {updateSelectInput(session, "worksheet", choices = input$file1$name)},
           xls =   {    selectionWorksheet <-excel_sheets(path = input$file1$datapath)
           updateSelectInput(session, "worksheet", choices = selectionWorksheet)},
           xlsx =  {      selectionWorksheet <-excel_sheets(path = input$file1$datapath)
           updateSelectInput(session, "worksheet", choices = selectionWorksheet)})
  })
  
  df<-reactiveValues( #creation df 
    df=NULL) # end reactivevalues 
  
  observeEvent(input$getData, {
    req(!is.null(input$file1))
    extension <- tools::file_ext(input$file1$name)
    df$df2 <- switch(extension,
                     csv =  {    
                       sep2 <- if( ";" %in% strsplit(readLines(input$file1$datapath, n=1)[1], split="")[[1]] ){";"
                       } else if( "," %in% strsplit(readLines(input$file1$datapath, n=1)[1], split="")[[1]] ){","
                       } else if ( "\t" %in% strsplit(readLines(input$file1$datapath, n=1)[1], split="")[[1]] ){"\t"
                       } else {";"}
                       utils::read.csv(input$file1$datapath,
                                       header = input$header,
                                       sep = sep2, stringsAsFactors = F,  fileEncoding="latin1",
                                       dec=".")},
                     xls = readxl::read_xls(input$file1$datapath, sheet=input$worksheet),
                     xlsx = readxl::read_xlsx(input$file1$datapath, sheet=input$worksheet))
    fileisupload(1)
  })# end observe of df$df
  
  observeEvent(!is.null(fileisupload()), { ## add two necessary columns for the rest of manipulations, correct issues with comma and majuscule
    req(!is.null(fileisupload()))
    null<-"0"
    shapeX<-shape_all()
    df$df<-df$df2[,!sapply(df$df2, function(x) is.logical(x))] ##remove column without data
    if (input$set.dec == TRUE){
      df$df[] <- apply(df$df,2,function (x) str_replace_all(x,",","."))
    } else{}
    if(!is.null(df$df[sapply(df$df, function(x) !is.numeric(x))])) {
      df$df[sapply(df$df, function(x) !is.numeric(x))] <- mutate_all(df$df[sapply(df$df, function(x) !is.numeric(x))], .funs=str_to_lower)}
    text<-""
    df$df<-cbind(shapeX,text,null,df$df) 
    nnrow.df.df(nrow(df$df))
    listinfosmarqueur(1)
  }) #end observe 
  
  # reset data
  observeEvent(input$reset.BDD, { 
    fileisupload(NULL)
    shinyjs::refresh()
    shinyjs::reset('file1')
    df$df <- NULL
    df$df2 <- NULL
  }, priority = 1000)
  
  #### others options ----
  observeEvent(input$Colors,{
    inputcolor(input$Colors)
  })
  
  observeEvent(input$minsize, {
    minsize(input$minsize)
  })
  observeEvent(input$alpha.density, {
    transpar(input$alpha.density)
  })
  observeEvent(input$point.size,{
    size.scale(input$point.size)
  })
  
  icon_svg_path = "M10,6.536c-2.263,0-4.099,1.836-4.099,4.098S7.737,14.732,10,14.732s4.099-1.836,4.099-4.098S12.263,6.536,10,6.536M10,13.871c-1.784,0-3.235-1.453-3.235-3.237S8.216,7.399,10,7.399c1.784,0,3.235,1.452,3.235,3.235S11.784,13.871,10,13.871M17.118,5.672l-3.237,0.014L12.52,3.697c-0.082-0.105-0.209-0.168-0.343-0.168H7.824c-0.134,0-0.261,0.062-0.343,0.168L6.12,5.686H2.882c-0.951,0-1.726,0.748-1.726,1.699v7.362c0,0.951,0.774,1.725,1.726,1.725h14.236c0.951,0,1.726-0.773,1.726-1.725V7.195C18.844,6.244,18.069,5.672,17.118,5.672 M17.98,14.746c0,0.477-0.386,0.861-0.862,0.861H2.882c-0.477,0-0.863-0.385-0.863-0.861V7.384c0-0.477,0.386-0.85,0.863-0.85l3.451,0.014c0.134,0,0.261-0.062,0.343-0.168l1.361-1.989h3.926l1.361,1.989c0.082,0.105,0.209,0.168,0.343,0.168l3.451-0.014c0.477,0,0.862,0.184,0.862,0.661V14.746z"
  
  ### button for png dl
  dl_button <- list(
    name = "Download as .png",
    icon = list(
      path = icon_svg_path,
      transform = "scale(0.84) translate(-1, 0)"
    ),
    click = htmlwidgets::JS('function(gd) {Plotly.downloadImage(gd, {format: "png"}
                          ) }') )
  
  #### other option figures
  observeEvent(input$fontsizeaxis, {
    font_size(input$fontsizeaxis)
  }) 
  observeEvent(input$fontsizetick, {
    font_tick(input$fontsizetick)
  }) 
  
  observeEvent(input$Xtickmarks, {
    Xtickmarks.size(input$Xtickmarks)
  }) 
  observeEvent(input$Ytickmarks, {
    Ytickmarks.size(input$Ytickmarks)
  }) 
  observeEvent(input$Ztickmarks, {
    Ztickmarks.size(input$Ztickmarks)
  }) 
  
  ##### option size of figure ----
  
  observeEvent(input$height.size.a, {
    height.size(input$height.size.a)
  })
  #
  observeEvent(input$height.size.b, {
    height.size(input$height.size.b)
  })
  observeEvent(input$width.size.b, {
    width.size(input$width.size.b)
  })
  #
  observeEvent(input$height.size.b.simple, {
    height.size(input$height.size.b.simple)
  })
  observeEvent(input$width.size.b.simple, {
    width.size(input$width.size.b.simple)
  })
  #
  observeEvent(input$height.size.c, {
    height.size(input$height.size.c)
  })
  observeEvent(input$width.size.c, {
    width.size(input$width.size.c)
  }) 
  #
  observeEvent(input$height.size.d, {
    height.size(input$height.size.d)
  })
  observeEvent(input$width.size.d, {
    width.size(input$width.size.d)
  })  
  #
  observeEvent(input$height.size.e, {
    height.size(input$height.size.e)
  })
  observeEvent(input$width.size.e, {
    width.size(input$width.size.e)
  })   
  
  observeEvent(input$ratiox, {
    ratiox(input$ratiox)
  })   
  observeEvent(input$ratioy, {
    ratioy(input$ratioy)
  })  
  observeEvent(input$ratioz, {
    ratioz(input$ratioz)
  })  
  observeEvent(input$ratio.to.coord.simple, {
    ratio.simple(input$ratio.to.coord.simple)
  })  
  
  output$themeforfigure=renderUI({
    req(!is.null(fileisupload()))
    themes <- ls("package:ggplot2", pattern = "^theme_")
    themes <- themes[themes != "theme_get" &
                       themes != "theme_set" &
                       themes != "theme_replace" &
                       themes != "theme_test" &
                       themes != "theme_update"]
    themes <- paste0(themes, "()")
    selectInput("themeforfigure.list", h4("Theme for 'Simple 2Dplot'"),
                choices = themes,
                selected = themes[5])
  })
  
  
  themeforfigure.choice<-reactiveVal(c("theme_classic()"))
  observeEvent(input$themeforfigure.list,{
    themeforfigure.choice(c(input$themeforfigure.list))
    
  })
  
  ##### function used in the script ----
  #function for density
  get_density <- function(x, y, ...) {
    dens <- MASS::kde2d(x, y, ...)
    ix <- findInterval(x, dens$x)
    iy <- findInterval(y, dens$y)
    ii <- cbind(ix, iy)
    return(dens$z[ii])
  }
  #function for newgroup
  dataModal <- function() {
    if (!is.null(vv) && !is.null(values$newgroup)) { 
      modalDialog(
        selectInput("select.new.group", label = h3("Select the new group"), 
                    choices = values$newgroup, 
                    selected = values$newgroup[1]),
        textInput("NewGroup", "Choose the name of assignement",value = "new.variable"),
        footer = tagList(
          modalButton("Cancel"),
          actionButton("Change", "OK")
        )
      )
    }
  }
  
  #function for refit
  seq2 <- function(from, to, by=1){
    if (to>=from){
      return(seq(from, to, by))
    }else{
      return(NULL)
    }
  }
  
  #function for orthopho import from Rstoolbox
  .toRaster <- function(x) {
    if (inherits(x, "SpatRaster")) {
      return(stack(x))
    } else {
      return(x)
    }
  }
  
  .numBand <- function(raster, ...){
    bands <- list(...)
    lapply(bands, function(band) if(is.character(band)) which(names(raster) == band) else band ) 
  }
  ggRGB<-function(img, r = 3, g = 2, b = 1, scale, maxpixels = 5e+05, 
                  stretch = "none", ext = NULL, limits = NULL, clipValues = "limits", 
                  quantiles = c(0.02, 0.98), ggObj = TRUE, ggLayer = FALSE, 
                  alpha = 1, coord_equal = TRUE, geom_raster = FALSE, nullValue = 0) 
  {
    img <- .toRaster(img)
    verbose <- getOption("RStoolbox.verbose")
    annotation <- !geom_raster
    rgb <- unlist(.numBand(raster = img, r, g, b))
    nComps <- length(rgb)
    if (inherits(img, "RasterLayer")) 
      img <- brick(img)
    rr <- sampleRegular(img[[rgb]], maxpixels, ext = ext, asRaster = TRUE)
    RGB <- getValues(rr)
    if (!is.matrix(RGB)) 
      RGB <- as.matrix(RGB)
    if (!is.null(limits)) {
      if (!is.matrix(limits)) {
        limits <- matrix(limits, ncol = 2, nrow = nComps, 
                         byrow = TRUE)
      }
      if (!is.matrix(clipValues)) {
        if (!anyNA(clipValues) && clipValues[1] == "limits") {
          clipValues <- limits
        }
        else {
          clipValues <- matrix(clipValues, ncol = 2, nrow = nComps, 
                               byrow = TRUE)
        }
      }
      for (i in 1:nComps) {
        if (verbose) {
          message("Number of pixels clipped in ", 
                  c("red", "green", "blue")[i], 
                  " band:\n", "below limit: ", sum(RGB[, 
                                                       i] < limits[i, 1], na.rm = TRUE), " | above limit: ", 
                  sum(RGB[, i] > limits[i, 2], na.rm = TRUE))
        }
        RGB[RGB[, i] < limits[i, 1], i] <- clipValues[i, 
                                                      1]
        RGB[RGB[, i] > limits[i, 2], i] <- clipValues[i, 
                                                      2]
      }
    }
    rangeRGB <- range(RGB, na.rm = TRUE)
    if (missing("scale")) {
      scale <- rangeRGB[2]
    }
    if (rangeRGB[1] < 0) {
      RGB <- RGB - rangeRGB[1]
      scale <- scale - rangeRGB[1]
      rangeRGB <- rangeRGB - rangeRGB[1]
    }
    if (scale < rangeRGB[2]) {
      warning("Scale < max value. Resetting scale to max.", 
              call. = FALSE)
      scale <- rangeRGB[2]
    }
    RGB <- na.omit(RGB)
    if (stretch != "none") {
      stretch <- tolower(stretch)
      for (i in seq_along(rgb)) {
        RGB[, i] <- .stretch(RGB[, i], method = stretch, 
                             quantiles = quantiles, band = i)
      }
      scale <- 1
    }
    naind <- as.vector(attr(RGB, "na.action"))
    nullbands <- sapply(list(r, g, b), is.null)
    if (any(nullbands)) {
      RGBm <- matrix(nullValue, ncol = 3, nrow = NROW(RGB))
      RGBm[, !nullbands] <- RGB
      RGB <- RGBm
    }
    if (!is.null(naind)) {
      z <- rep(NA, times = ncell(rr))
      z[-naind] <- rgb(RGB[, 1], RGB[, 2], RGB[, 3], max = scale, 
                       alpha = alpha * scale)
    }
    else {
      z <- rgb(RGB[, 1], RGB[, 2], RGB[, 3], max = scale, alpha = alpha * 
                 scale)
    }
    df_raster <- data.frame(coordinates(rr), fill = z, stringsAsFactors = FALSE)
    x <- y <- fill <- NULL
    if (ggObj) {
      exe <- as.vector(extent(rr))
      df <- data.frame(x = exe[1:2], y = exe[3:4])
      if (annotation) {
        dz <- matrix(z, nrow = nrow(rr), ncol = ncol(rr), 
                     byrow = TRUE)
        p <- annotation_raster(raster = dz, xmin = exe[1], 
                               xmax = exe[2], ymin = exe[3], ymax = exe[4], 
                               interpolate = FALSE)
        if (!ggLayer) {
          p <- ggplot() + p + geom_blank(data = df, aes(x = x, 
                                                        y = y))
        }
      }
      else {
        p <- geom_raster(data = df_raster, aes(x = x, y = y, 
                                               fill = fill), alpha = alpha)
        if (!ggLayer) {
          p <- ggplot() + p + scale_fill_identity()
        }
      }
      if (coord_equal & !ggLayer) 
        p <- p + coord_equal()
      return(p)
    }
    else {
      return(df_raster)
    }
  }
  ##function for 2D slice
  plotUI <- function(id) {
    ns <- NS(id)
    plotlyOutput(ns("plot"), height = height.size())
    
  }
  
  plotServer <- function(id,df.sub.a, Xvar, Yvar,liste.valeur.slice) {
    
    moduleServer(
      id,
      function(input, output, session) {
        t2 <- list(
          family = "Arial",
          size = 14,
          color = "red")
        output$plot <- renderPlotly({
          df.sub2<-df.sub()
          set.antivar.2d.slice<-c(setXX(),setYY())[c(setXX(),setYY())!=set.var.2d.slice()]
          set.antivar.2d.name<-c(nameX(),nameY())[c(setXX(),setYY())!=set.var.2d.slice()]
          Xtickmarks.size<-c(Xtickmarks.size(),Ytickmarks.size())[c(setXX(),setYY())!=set.var.2d.slice()]
          yymax = df.sub2[,setZZ()] %>% ceiling() %>% max(na.rm = TRUE)
          yymin=df.sub2[,setZZ()] %>% floor() %>% min(na.rm = TRUE)
          
          xymax = df.sub2[,set.antivar.2d.slice] %>% ceiling() %>% max(na.rm = TRUE)
          xymin=df.sub2[,set.antivar.2d.slice] %>% floor() %>% min(na.rm = TRUE)
          
          df.sub.a<-as.data.frame(df.sub.a)
          min.size2<-minsize()
          size.scale <- size.scale()
          myvaluesx<-unlist(myvaluesx())
          if (is.null(unlist(myvaluesx))) {
            myvaluesx <-c("blue","red","green")
          }
          shapeX<-df.sub.a$shapeX
          shape.level<-levels(as.factor(shapeX))
          
          p<- plot_ly(x=~df.sub.a[,Xvar], y = ~df.sub.a[,Yvar],
                      type="scatter",
                      color = ~df.sub.a$layer2,
                      colors = myvaluesx,
                      size  = ~df.sub.a$point.size2,
                      sizes = c(min.size2,size.scale),
                      mode   = 'markers',
                      fill = ~'',
                      symbol = ~df.sub.a$shapeX, 
                      symbols = shape.level,
                      text=df.sub.a$text,                                   
                      hovertemplate = paste('<b>X</b>: %{x:.4}',
                                            '<br><b>Y</b>: %{y}',
                                            '<b>%{text}</b>'),
                      height = height.size(),
                      width = width.size())
          p<-p %>% layout(showlegend = legendplotlyfig(),
                          title = list(text=liste.valeur.slice,font=t2,x =0.1),
                          scene = list(aspectratio=list(x=1,y=1,z=1)),
                          xaxis = list(title=paste(set.antivar.2d.name), range=c(xymin,xymax),
                                       dtick = Xtickmarks.size, 
                                       tick0 = floor(min(df.sub.a[,Xvar])), 
                                       tickmode = "linear",
                                       titlefont = list(size = font_size()), tickfont = list(size = font_tick())),
                          yaxis=list(title=paste(nameZ()), range=c(yymin,yymax),
                                     dtick = Ztickmarks.size(), 
                                     tick0 = floor(min(df.sub.a[,Yvar])), 
                                     tickmode = "linear",
                                     titlefont = list(size = font_size()), tickfont = list(size = font_tick())),
                          dragmode = "select")%>%
            event_register("plotly_selecting")
          p <-p %>%
            config(displaylogo = FALSE,
                   modeBarButtonsToAdd = list(dl_button),
                   toImageButtonOptions = list(
                     format = "svg")
            )
          
        })
      }
    )
  }
  
  #function for color
  color.function<-function (levelofcolor,name,selected_rainbow,loadingfile){  
    uvalues <-levels(as.factor(levelofcolor))
    n <- length(uvalues)
    choices <- as.list(uvalues)
    myorder  <- as.list(1:n)
    
    if (!is.null (loadingfile)) {
      mycolors <-unlist(loadingfile)
      selected_rainbow<-1
    } else {
      mycolors <- list("darkgreen", "blue","purple", "green","pink","orange","grey","aquamarine","chartreuse", 
                       "mintcream","salmon","brown","lightblue","lightslateblue","gold")}
    colors <- paste0("background:",mycolors,";")
    colors <- paste0(colors,"color:black;")
    colors <- paste0(colors,"font-family: Arial;")
    colors <- paste0(colors,"font-weight: bold;")
    selected2 <-mycolors
    
    nk <- length(mycolors)  ## to repeat colors when there are more bars than the number of colors
    tagList(
      div(br()),
      div(
        lapply(1:n, function(i){
          k <- i %% nk
          if (k==0) k=nk
          if (selected_rainbow == "1") {
            selected2 <-mycolors[i]  }
          spectrumInput(
            inputId = paste0(name,i),
            label = paste0(uvalues[i], ": " ),
            choices = list(mycolors,
                           as.list(rainbow(10)),
                           as.list(heat.colors(10)),
                           as.list(terrain.colors(10)),
                           as.list(cm.colors(10)),
                           as.list(topo.colors(10)
                           )
            ),
            selected = selected2,
            options = list(`toggle-palette-more-text` = "Show more")
          )
          
        }),
        
      )
    )
  } # end of color.function
  
  
  ##### output loading slide ----
  
  liste.x<-reactiveVal(c("X.rotated","x","X","null","SPATIAL..X"))
  observeEvent(input$setx,{
    liste.x(c(input$setx))
  })
  liste.y<-reactiveVal(c("Y.rotated","y","Y","null","SPATIAL..Y"))
  observeEvent(input$sety,{
    liste.y(c(input$sety))
  })
  liste.z<-reactiveVal(c("z","Z","null","SPATIAL..Z"))
  observeEvent(input$setz,{
    liste.z(c(input$setz))
  })
  liste.date<-reactiveVal(c("Years","periods","SPATIAL..Year"))
  observeEvent(input$setdate,{
    liste.date(c(input$setdate))
  })
  liste.nature2<-reactiveVal(c("Nature","Type","null"))
  observeEvent(input$setnature,{
    liste.nature2(c(input$setnature))
  })
  liste.levels<-reactiveVal(c("UAS","Levels","null","SPATIAL..USfield"))
  observeEvent(input$setlevels,{
    liste.levels(c(input$setlevels))
  })
  liste.passe2<-reactiveVal(c("Passe","null"))
  observeEvent(input$setpasse,{
    liste.passe2(c(input$setpasse))
  })
  liste.ID<-reactiveVal(c("ID","Point","null","fieldID"))
  observeEvent(input$setID,{
    liste.ID(c(input$setID))
  })
  liste.sector2<-reactiveVal(c("null","context","localisation","square","Sector","SPATIAL..Square_field"))
  observeEvent(input$setsector,{
    liste.sector2(c(input$setsector))
  })
  
  output$set.x=renderUI({
    req(!is.null(fileisupload()))
    selectInput("setx", h4("x (Default name: x)"),
                choices = names(df$df)[c(3:ncol(df$df))],
                selected = liste.x())
  })
  output$set.y=renderUI({
    req(!is.null(fileisupload()))
    selectInput("sety", h4("y (Default name: y)"),
                choices = names(df$df)[c(3:ncol(df$df))],
                selected = liste.y())
  })
  output$set.z=renderUI({
    req(!is.null(fileisupload()))
    selectInput("setz", h4("z (Default name: z)"),
                choices = names(df$df)[c(3:ncol(df$df))],
                selected = liste.z())
  }) 
  
  observeEvent(input$setx,{
    df$df[,input$setx]<-df$df[,input$setx]%>% as.numeric()
    setXX(input$setx)
    nameX(input$setx)
  })
  
  observeEvent(input$sety,{
    df$df[,input$sety]<-df$df[,input$sety]%>% as.numeric()
    setYY(input$sety)
    nameY(input$sety)
  })
  
  observeEvent(input$setz,{ 
    df$df[,input$setz]<-df$df[,input$setz]%>% as.numeric()
    setZZ(input$setz)
    nameZ(input$setz)
  })
  
  output$set.nature=renderUI({
    req(!is.null(fileisupload()))
    selectInput("setnature", h4("Type (Default name: Type)"),
                choices = names(df$df)[c(3:ncol(df$df))],
                selected = liste.nature2())
  }) 
  
  output$set.levels=renderUI({
    req(!is.null(fileisupload()))
    selectInput("setlevels", h4("Levels (Default name: Levels)"),
                choices = names(df$df)[c(3:ncol(df$df))],
                selected = liste.levels())
  }) 
  
  output$set.date=renderUI({
    req(!is.null(fileisupload()))
    selectInput("setdate", h4("years : format years (Default name: Years)"),
                choices = names(df$df)[c(3:ncol(df$df))],
                selected = liste.date()) 
  }) 
  
  
  output$set.passe=renderUI({
    req(!is.null(fileisupload()))
    selectInput("setpasse", h4("others (No default name)"),
                choices = names(df$df)[c(3:ncol(df$df))],
                selected = liste.passe2())
  }) 
  
  
  output$set.ID=renderUI({
    req(!is.null(fileisupload()))
    selectInput("setID", h4("Unique object ID (Default name: ID)"),
                choices = names(df$df)[c(3:ncol(df$df))],
                selected = liste.ID())
  })   
  
  output$set.sector=renderUI({
    req(!is.null(fileisupload()))
    selectInput("setsector", h4("Context/square/sector (Default name: Context, Square, Sector)"),
                choices = names(df$df)[c(3:ncol(df$df))],
                selected = liste.sector2())
  }) 
  
  observeEvent(input$checkbox.invX, {
    req(input$setx)
    df$df[,input$setx]<-df$df[,input$setx]*-1
  })
  
  observeEvent(input$checkbox.invY, {
    req(input$sety)
    df$df[,input$sety]<-df$df[,input$sety]*-1
  })
  observeEvent(input$checkbox.invZ, {
    req(input$setz)
    df$df[,input$setz]<-df$df[,input$setz]*-1
  })
  
  observeEvent(input$Name.X, {
    req(input$setx)
    nameX(input$Name.X)
  })
  observeEvent(input$Name.Y, {
    req(input$sety)
    nameY(input$Name.Y)
  })
  observeEvent(input$Name.Z, {
    req(input$setz)
    nameZ(input$Name.Z)
  })
  
  #### verification
  observeEvent(ignoreInit = TRUE, c(setXX(),setYY(),setZZ(),input$setID), {
    if( sum(is.na(as.numeric(df$df[,input$setx])))>0 || sum(is.na(as.numeric(df$df[,input$sety])))>0 || sum(is.na(as.numeric(df$df[,input$setz])))>0 || (dim(df$df[duplicated(df$df[,input$setID]),])[1]>0 & input$setID != "null")) {
      
      showModal(modalDialog(
        title = "Issues with loaded data",
        if( sum(is.na(as.numeric(df$df[,input$setx])))>0) {
          HTML(paste(sum(is.na(as.numeric(df$df[,input$setx]))), " X value(s) was/were not included as not numerical <br>"))},
        if( sum(is.na(as.numeric(df$df[,input$sety])))>0) {
          HTML(paste(sum(is.na(as.numeric(df$df[,input$sety]))), " Y value(s) was/were not included as not numerical<br>"))},
        if( sum(is.na(as.numeric(df$df[,input$setz])))>0) {
          HTML(paste(sum(is.na(as.numeric(df$df[,input$setz]))), " Z value(s) was/were not included as not numerical<br>"))},
        if(input$setID != "null" & dim(df$df[duplicated(df$df[,input$setID]),])[1]>0) { 
          HTML(paste(dim(df$df[duplicated(df$df[,input$setID]),])[1], " object ID(s) is/are not unique !<br> "))
        }
      ))
    } 
  })
  
  ##### import extradata ----
  ID.no.suppl.data.txt<-reactiveVal("no data")
  notunique.txt<-reactiveVal("no data")
  notunique2.txt<-reactiveVal("no data")
  suppl.no.include.txt<-reactiveVal("no data")
  
  observe({
    req(input$file.extradata)
    extension <- tools::file_ext(input$file.extradata$name)
    df$file.extradata <- switch(extension,
                                csv = {    
                                  sep2 <- if( ";" %in% strsplit(readLines(input$file1$datapath, n=1)[1], split="")[[1]] ){";"
                                  } else if( "," %in% strsplit(readLines(input$file1$datapath, n=1)[1], split="")[[1]] ){","
                                  } else if ( "\t" %in% strsplit(readLines(input$file1$datapath, n=1)[1], split="")[[1]] ){"\t"
                                  } else {";"}
                                  utils::read.csv(input$file.extradata$datapath,
                                                  header = input$header,
                                                  sep = sep2, stringsAsFactors = F, 
                                                  dec=".")},
                                xls = readxl::read_xls(input$file.extradata$datapath),
                                xlsx = readxl::read_xlsx(input$file.extradata$datapath))
  }) #end observe 
  output$set.columnID=renderUI({
    req(input$file.extradata)
    req(input$setID)
    selectInput("setcolumnID", h4("Select the unique objects ID)"),
                choices = names(df$file.extradata),
                selected = c(paste(input$setID)))
  }) 
  observeEvent(input$setcolumnID, { ## add two necessary columns for the rest of manipulations
    df$file.extradata2<-df$file.extradata[,!sapply(df$file.extradata, function(x) is.logical(x))] ##remove column whitout data
    df$file.extradata2[sapply(df$file.extradata2, function(x) !is.numeric(x))] <- mutate_all(df$file.extradata2[sapply(df$file.extradata2, function(x) !is.numeric(x))], .funs=str_to_lower)
    temp.data<-df$df[duplicated(df$df[,input$setID]) | duplicated(df$df[,input$setID], fromLast = T),]
    if (nrow(temp.data) >0 ) {notunique.txt(temp.data)
    } else {notunique.txt("All IDs are unique")}
    temp.data2<-df$file.extradata2[duplicated(df$file.extradata2[,input$setcolumnID]) | duplicated(df$file.extradata2[,input$setcolumnID], fromLast = T),]
    if (nrow(temp.data2) >0 ) {notunique2.txt(temp.data2)
    } else {notunique2.txt("All IDs are unique")}
  }) #end observe 
  
  observeEvent(input$goButton.set.columnID, {
    req(input$setcolumnID)
    if(input$setID == "null"){ 
      showModal(modalDialog(
        title = "Issues with merging data", 
        HTML(paste("No unique ID has been defined in the XYZ dataset"))
      ))
      
      return()
    }
    if(dim(df$df[duplicated(df$df[,input$setID]),])[1]>0){ 
      showModal(modalDialog(
        title = "Issues with merging data", 
        HTML(paste("Object IDs from the XYZ dataset are not unique. <br>
                 Import refit data required absolutely a unique ID per object"))
      ))
      
      return()
    }
    names(df$file.extradata2)[match(paste(input$setcolumnID),names(df$file.extradata2))]<-paste(input$setID)
    if(dim(df$file.extradata2[duplicated(df$file.extradata2[,input$setID]),])[1]>0){ 
      showModal(modalDialog(
        title = "Issues with merging data", 
        HTML(paste("Object IDs from the imported dataset are not unique. <br>
                 Import refit data required absolutely a unique ID per object"))
      ))
      
      return()
    }
    
    same.column.to.remove<-intersect(colnames(df$df),colnames(df$file.extradata2)) # remove column with same name
    same.column.to.remove<-same.column.to.remove[same.column.to.remove!=input$setID]
    df$file.extradata3<-df$file.extradata2[!names(df$file.extradata2)%in% c(same.column.to.remove)]
    df$file.extradata3[,input$setID]<-as.character(df$file.extradata3[,input$setID]) ## same format to avoid pb
    df$df[,input$setID]<-as.character(df$df[,input$setID]) ## same format to avoid pb
    
    temp.data2<-setdiff(df$df[,input$setID],df$file.extradata3[,input$setID])
    if(length(temp.data2)==0){ 
      ID.no.suppl.data.txt("perfect")} else {suppl.no.include.txt(temp.data2)}
    
    temp.data<-setdiff(df$file.extradata3[,input$setID],df$df[,input$setID])
    if(length(temp.data)==0){ 
      suppl.no.include.txt("perfect")} else {ID.no.suppl.data.txt(temp.data)}
    
    df$df<-full_join(df$file.extradata3,df$df)%>% 
      relocate(c("shapeX","text","null"))
  })
  
  ## table to show import extradata ----
  output$notunique<- renderPrint({notunique.txt()})
  output$notunique2<- renderPrint({notunique2.txt()})
  output$suppl.no.include<- renderPrint({suppl.no.include.txt()})
  output$ID.no.suppl.data<- renderPrint({ID.no.suppl.data.txt()})
  
  ##### import refit data ----
  observe({
    req(input$file.fit)
    extension <- tools::file_ext(input$file.fit$name)
    df$file.fit <- switch(extension,
                          csv = {    
                            sep2 <- if( ";" %in% strsplit(readLines(input$file1$datapath, n=1)[1], split="")[[1]] ){";"
                            } else if( "," %in% strsplit(readLines(input$file1$datapath, n=1)[1], split="")[[1]] ){","
                            } else if ( "\t" %in% strsplit(readLines(input$file1$datapath, n=1)[1], split="")[[1]] ){"\t"
                            } else {";"}
                            utils::read.csv(input$file.fit$datapath,
                                            header = input$header,
                                            sep = sep2, stringsAsFactors = F, 
                                            dec=".")},
                          xls = readxl::read_xls(input$file.fit$datapath),
                          xlsx = readxl::read_xlsx(input$file.fit$datapath))
    
  }) #end observe 
  output$set.columnID.for.fit=renderUI({
    req(input$setID)
    selectInput("setcolumnID.for.fit", h4("Select the column recording the unique object ID)"),
                choices = names(df$file.fit),
                selected = c(paste(input$setID)))
  }) 
  
  output$set.REM=renderUI({ 
    selectInput("setREM", h4("Select the column recording the unique ID of refit groups"),
                choices= names(df$file.fit)[!names(df$file.fit) %in% input$setcolumnID.for.fit],
                #choices = names(df$file.fit),
                selected = c("refit","null"))
  }) 
  
  observeEvent(input$Refit.data.from.XYZ.file, {
    updateSelectInput(session,"setcolumnID.for.fit",choices=if(input$Refit.data.from.XYZ.file == FALSE){names(df$file.fit)}else{names(df$df)},selected=input$setID )
    updateSelectInput(session,"setREM",choices=if(input$Refit.data.from.XYZ.file == FALSE){names(df$file.fit)}else{names(df$df)},selected="refit" )
  })
  
  observeEvent(input$goButton.set.columnID.for.fit, {
    req(input$setcolumnID.for.fit) 
    req((input$setREM)!="")
    if(input$setID == "null"){ 
      showModal(modalDialog(
        title = "Issues with merging data", 
        HTML(paste("No unique ID has been defined in the XYZ dataset"))
      ))
      return()
    }
    if(dim(df$df[duplicated(df$df[,input$setID]),])[1]>0){ 
      showModal(modalDialog(
        title = "Issues with merging data", 
        HTML(paste("Object IDs from the XYZ dataset are not unique. <br>
                 Import refit data required absolutely a unique ID per object"))
      ))
      return()  }
    
    if(input$Refit.data.from.XYZ.file == FALSE){
      df$file.fit3<-df$file.fit
      df$file.fit3<-df$file.fit3[,!sapply(df$file.fit3, function(x) is.logical(x))] ##remove column whitout data
      df$file.fit3[sapply(df$file.fit3, function(x) !is.numeric(x))] <- mutate_all(df$file.fit3[sapply(df$file.fit3, function(x) !is.numeric(x))], .funs=str_to_lower)
      df$file.fit3<-as.data.frame(df$file.fit3)
      names(df$file.fit3)[match(paste(input$setcolumnID.for.fit),names(df$file.fit3))]<-paste(input$setID)
      same.column.to.remove<-intersect(colnames(df$df),colnames(df$file.fit3))
      same.column.to.remove<-same.column.to.remove[same.column.to.remove!=input$setID]
      df$file.fit2<-df$file.fit3[!names(df$file.fit3)%in% c(same.column.to.remove)]
    } else {
      df$file.fit2<-df$df[!is.na(df$df[input$setREM]),]
      df$file.fit2<-df$file.fit2[!df$file.fit2[input$setREM]=="" & !df$file.fit2[input$setREM]=="NA",]
    }
    df$file.fit2[,input$setID]<-as.character(df$file.fit2[,input$setID]) ## same format to avoid pb
    df$df[,input$setID]<-as.character(df$df[,input$setID])                ## same format to avoid pb
    data.fit(df$file.fit2)
    
  }) 
  
  observeEvent(data.fit(), {
    req(input$setREM)
    data.REM<-left_join(data.fit(),df$df)
    if(is.na(data.REM$shapeX)[1]==TRUE){ ##test to go next step
      showModal(modalDialog(
        title = "Issues with merging data", 
        HTML(paste("No refit data have been merged. <br> Unique IDs should not match together"))
      ))
      return()
    }
    
    fac <- as.factor(data.REM[,input$setREM]) 
    idx_lev <- which(nchar(levels(fac))>0)
    eff <- table(fac)[idx_lev]
    Lcombi <- lapply(lapply(eff, function(a){1:a} ), function(v){if (length(v)>1){combn(v, 2)}else{matrix(nrow=2, ncol=0)}})
    Lidx <- lapply(names(eff), function(a,f){which(f==a)}, fac)
    LcombiRow <- mapply( function(M, v){matrix(v[M], nrow(M), ncol(M))}, Lcombi, Lidx, SIMPLIFY = FALSE)
    m1 <- data.REM[unlist(lapply(LcombiRow, function(M){M[1,]})),]
    m2 <- data.REM[unlist(lapply(LcombiRow, function(M){M[2,]})),]
    table.fit2 <- rbind(m1, m2)
    colnames(m2)<-paste0(colnames(m2),".2")
    colnames(m2)[which(names(m2) == paste0(input$setx,".2"))] <- "xend"
    colnames(m2)[which(names(m2) == paste0(input$sety,".2"))] <- "yend"
    colnames(m2)[which(names(m2) == paste0(input$setz,".2"))] <- "zend"
    m2<-m2 %>% relocate(shapeX.2, text.2,null.2)
    
    table.fit <- cbind(m1, m2[,4:ncol(m2)])
    
    idx <- c(rbind(1:nrow(m1), 1:nrow(m2)+nrow(m1)))
    table.fit2 <- table.fit2[idx,]
    tt <- sapply(LcombiRow,ncol)*2
    v1 <- rep(names(tt), tt)
    v2 <- rep(unlist(lapply(sapply(LcombiRow,ncol), seq2, from=1)), each=2)
    table.fit2 <- cbind(table.fit2, paste0(v1, ".", v2))
    colnames(table.fit2)[which(names(table.fit2) == 'paste0(v1, ".", v2)')] <- "fit.2"
    table.fit2<-table.fit2 %>% relocate(shapeX, text,null)
    table.fit<-table.fit %>% relocate(shapeX, text,null)
    data.fit2(table.fit)
    data.fit.3D(table.fit2)
    data.fit3(table.fit)
    
    data.refit.choose(names(table.fit2)) ## for color of refit
    showModal(modalDialog(
      title = "Refit data", 
      HTML(paste("Refit data have been merged."))
    ))
  })
  
  #### merge two columns ----
  
  output$set.col1=renderUI({
    req(!is.null(fileisupload()))
    selectInput("setcol1", h4("Choose a first column"),
                choices = names(df$df)[c(3:ncol(df$df))],
                selected = "")
  })   
  output$set.col2=renderUI({
    req(!is.null(fileisupload()))
    selectInput("setcol2", h4("Choose a second column"),
                choices = names(df$df)[c(3:ncol(df$df))],
                selected = "")
  })  
  
  observeEvent(input$Merge2, {
    new.group<-paste0(df$df[,input$setcol1],input$separatormerge,df$df[,input$setcol2])
    df$df<-cbind(df$df,new.group)
    colnames(df$df)[ncol(df$df)]<-c(input$Merge.groupe)
    showModal(modalDialog(
      HTML(paste("Data have been merged. <br>
               The first value obtained is",df$df[,input$Merge.groupe][1] ))
    ))
  })
  
  ## table to show refit ----
  output$Fit.table.output<- renderPrint({
    if (is.null(data.fit3())) { "no refit"} else {
      data.fit3()[,4:ncol(data.fit3())]}
  })
  
  
  ##### ortho slide import ----
  observe({                                  ### ortho xy
    req(input$file2)
    df$ortho.2<-stack(input$file2$datapath) 
  })
  output$liste.ortho.file2=renderUI({
    req(input$file2)
    renderPlot({                                                    
      s2<-stack(input$file2$datapath)
      plotRGB(s2,maxpixels=50000)
    })
  })
  output$liste.ortho.file3=renderUI({
    req(input$file3)
    renderPlot({
      s3<-stack(input$file3$datapath)
      plotRGB(s3,maxpixels=50000)
    })
  })
  output$liste.ortho.file4=renderUI({
    req(input$file4)
    renderPlot({
      s4<-stack(input$file4$datapath)
      plotRGB(s4,maxpixels=50000)
    })
  })
  output$liste.ortho.file5=renderUI({
    req(input$file5)
    renderPlot({
      s5<-stack(input$file5$datapath)
      plotRGB(s5,maxpixels=50000)
    })
  })
  
  ##### output sidebar ----
  output$liste.Colors=renderUI({
    req(!is.null(fileisupload()))
    selectInput("Colors", h4("Variable to be colored"),
                choices = names(df$df)[c(3:ncol(df$df))],
                selected = c("UAS","null",names(df$df)[1]))
  })
  
  output$liste.Nature=renderUI({
    req(input$setnature)
    checkboxGroupInput("Nature", h4("Type"),
                       choices = levels(as.factor(df$df[,input$setnature])),selected = factor(df$df[,input$setnature]))
  })
  output$liste.passe=renderUI({
    req(input$setpasse)
    checkboxGroupInput("Passe", h4(paste(input$setpasse)),
                       choices = levels(as.factor(df$df[,input$setpasse])),selected = levels(as.factor(df$df[,input$setpasse])))
  })
  output$liste.sector=renderUI({
    req(input$setsector)
    checkboxGroupInput("localisation", h4("Context"),
                       choices = levels(as.factor(df$df[,input$setsector])),selected = factor(df$df[,input$setsector]))
  })
  output$liste.UAS=renderUI({
    req(input$setlevels)
    checkboxGroupInput("UAS", h4("Levels"),
                       choices = levels(as.factor(df$df[,input$setlevels])),selected = factor(df$df[,input$setlevels]))
  })
  textnbobject<-reactiveVal(NULL)
  observe({
    if (!is.null(nrow(df$df))){
      req(!is.null(df.sub()))
      textnbobject(paste("Number of objects plotted:",nrow(df.sub()),"for a total of", nnrow.df.df(), "rows present in the dataset"))
    }
  })
  
  output$nb=renderUI({
    HTML(paste(textnbobject()))
  })
  output$nb2=renderUI({
    HTML(paste(textnbobject()))
  })
  output$nb2.2=renderUI({
    HTML(paste(textnbobject()))
  })
  output$nb3=renderUI({
    HTML(paste(textnbobject()))
  })
  output$nb4=renderUI({
    HTML(paste(textnbobject()))
  })
  output$nb5=renderUI({
    HTML(paste(textnbobject()))
  })
  
  output$nb6=renderUI({
    req(!is.null(fileisupload()))
    req(!is.null(df.sub()))
    HTML(paste("Number of rows imported:",sum(nrow(df$df)-(max(sum(is.na(as.numeric(df$df[,input$setx]))),sum(is.na(as.numeric(df$df[,input$sety]))),sum(is.na(as.numeric(df$df[,input$setz])))))),"for a total of", nrow(df$df), "rows present in the dataset"))
  })
  
  output$ylimits=renderUI({
    req(!is.null(fileisupload()))
    req(input$sety)
    ymax= df$df[,input$sety] %>% as.numeric() %>%ceiling() %>% max(na.rm = TRUE)
    ymin=df$df[,input$sety] %>% as.numeric() %>% floor() %>% min(na.rm = TRUE)
    sliderInput('yslider','y limits',min=ymin,max=ymax,value=c(ymin,ymax),step=stepY())
  })
  output$xlimits=renderUI({
    req(!is.null(fileisupload()))
    req(input$setx)
    xmax = df$df[,input$setx] %>% ceiling() %>% max(na.rm = TRUE)
    xmin=df$df[,input$setx] %>% floor() %>% min(na.rm = TRUE)
    sliderInput('xslider','x limits',min=xmin,max=xmax,value=c(xmin,xmax),step=stepX())
  })
  output$zlimits=renderUI({
    req(!is.null(fileisupload()))
    req(input$setz)
    zmax = df$df[,input$setz] %>% ceiling() %>% max(na.rm = TRUE)
    zmin=df$df[,input$setz] %>% floor() %>% min(na.rm = TRUE)
    sliderInput('zslider','z limits',min=zmin,max=zmax,value=c(zmin,zmax),step=stepZ())
  })
  output$Date=renderUI({
    req(!is.null(fileisupload()))
    req(input$setdate)
    dmin=min(as.numeric(df$df[,input$setdate]), na.rm=T)
    dmax=max(as.numeric(df$df[,input$setdate]), na.rm=T)
    if((dmax!="inf")==TRUE){
      sliderInput('Date2','Year(s) :',min=dmin,max=dmax,value=c(dmin,dmax),step=1,sep='')
    } else {}
  })
  
  
  ##### output additional Setting slide ----
  
  observeEvent(input$stepXsize, {
    stepX(input$stepXsize)
  })
  observeEvent(input$stepYsize, {
    stepY(input$stepYsize)
  })
  observeEvent(input$stepZsize, {
    stepZ(input$stepZsize)
  })
  output$liste.infos=renderUI({
    req(!is.null(fileisupload()))
    checkboxGroupInput("listeinfos", h4("Choose the variable information to be shown while hovering points on plots"),
                       choices = names(df$df)[c(4:ncol(df$df))], selected = NULL)
  })
  
  output$shape2=renderUI({
    req(!is.null(fileisupload()))
    req(input$shape)
    s2<-list("circle","square","triangle-up","diamond")
    s2<-s2[s2!=input$shape]
    selectInput("setshape2", h4("Secondary shape"),
                choices = s2)
  }) 
  output$shape2.var1=renderUI({ 
    req(!is.null(fileisupload()))
    selectInput("setshape2.1", h5("Select variable for secondary shape"),
                choices = names(df$df)[c(3:ncol(df$df))])
  })
  output$shape2.var2=renderUI({ 
    req(!is.null(fileisupload()))
    df$Sh2<-df$df
    selectInput("setshape2.2", h5("Select variable modality for secondary shape"),
                choices = levels(as.factor(df$Sh2[,input$setshape2.1])),selected = factor(df$Sh2[,input$shape2.var1]))
  })
  
  tt<-reactiveVal()
  observeEvent(input$do.shape2, {
    tt2<-paste(input$setshape2,input$setshape2.1," ", input$setshape2.2, " ") 
    tt3<-paste(tt2, tt(), sep="\n") 
    tt(tt3)
    
  })
  observeEvent(input$do.shape1, {
    tt3<-NULL
    tt(tt3)
  })
  
  output$text.shape <- renderText({
    paste(tt())}
  )
  
  observeEvent(input$do.shape1, {
    df$df$shapeX<-input$shape
  })
  
  observeEvent(input$do.shape2, {
    df$df$shapeX[df$df[,input$setshape2.1] %in% input$setshape2.2]<-input$setshape2
  })
  
  observeEvent(input$optioninfosfigplotly, {
    legendplotlyfig(input$optioninfosfigplotly)
  })
  
  
  ####liste infos  ----
  observeEvent(req(!is.null(listinfosmarqueur())),{
    df$df$text<-""}
  )
  
  observeEvent(input$listeinfos.go, {
    req(input$setz)
    req(input$setID)
    selected = c()
    for (s in 1:length(input$listeinfos)) {
      selected = c(selected, input$listeinfos[s])
    }
    if (is.null(selected)) {
      selected = character(0)
    }
    
    df$df$text<-paste("<br><b>Z</b>:", df$df[,input$setz],"<br><b>ID</b>:", df$df[,input$setID])
    if (length(input$listeinfos)>0){
      for (ii in 1:length(input$listeinfos)){
        text5<-paste("<br>",input$listeinfos[ii],": ",df$df[,input$listeinfos[ii]], sep="")
        df$df$text<-paste(df$df$text,text5)
      }
    }
    updateCheckboxGroupInput(session, "listeinfos", selected = selected)
    listinfosmarqueur(NULL)
  })
  
  ##### colors ----
  save.col.react<-reactiveVal()
  mypaletteofcolors<-reactiveVal()
  
  observeEvent(df$file.color,{ 
    mypaletteofcolors(df$file.color[2])
  })
  
  basiccolor= reactive({
    req(!is.null(fileisupload()))
    name<-"colorvar"
    color.function(df$df[[inputcolor()]],name,1,mypaletteofcolors())
  }) 
  
  save.col2<-observeEvent(myvaluesx(),{ 
    if (length(unlist(myvaluesx()))>1) {
      color<-levels(as.factor(df$df[,inputcolor()]))
      names_of_the_variable<-unlist(myvaluesx())
      length(color)<-max(c(length(color),length(names_of_the_variable))) ## to avoid problem of different row
      length(names_of_the_variable)<-max(c(length(color),length(names_of_the_variable)))
      save.col.react(cbind.data.frame(color,names_of_the_variable))
    }
  })
  
  observe({
    req(input$file.color)
    extension <- tools::file_ext(input$file.color$name)
    df$file.color <- switch(extension,
                            csv = {    
                              sep2 <- if( ";" %in% strsplit(readLines(input$file1$datapath, n=1)[1], split="")[[1]] ){";"
                              } else if( "," %in% strsplit(readLines(input$file1$datapath, n=1)[1], split="")[[1]] ){","
                              } else if ( "\t" %in% strsplit(readLines(input$file1$datapath, n=1)[1], split="")[[1]] ){"\t"
                              } else {";"}
                              utils::read.csv(input$file.color$datapath,
                                              header = input$header,
                                              sep = sep2, stringsAsFactors = F, 
                                              dec=".")},
                            xls = readxl::read_xls(input$file.color$datapath),
                            xlsx = readxl::read_xlsx(input$file.color$datapath))
    
  })
  
  myvaluesx<-reactive({
    req(!is.null(fileisupload()))
    myvaluesx <-NULL
    n <- length(unique(df$df[,inputcolor()]))
    val <- list()
    myvaluesx <- lapply(1:n, function(i) {
      if (i==1) val <- list(input[[paste0("colorvar",i)]])
      else val <- list(val,input[[paste0("colorvar",i)]])
      
    })
  }) # end of myvaluexS
  
  output$colors2 <- renderUI({
    basiccolor()
  })
  
  
  #color for refits ----
  data.refit.choose<-reactiveVal(NULL)
  inputcolor.refit<-reactiveVal("null")
  
  output$liste.Colors.refit=renderUI({
    req(!is.null(fileisupload()))
    req(!is.null(data.refit.choose()))
    selectInput("Colors.rerefit", h4("Refit variable to be colored"),
                choices = data.refit.choose()[c(3:length(data.refit.choose()))],
                selected = data.refit.choose()[1])
    
  })
  
  observeEvent(input$Colors.rerefit,{
    inputcolor.refit(input$Colors.rerefit)
  })
  
  observeEvent(df$file.color.fit,{ 
    mypaletteofcolors.fit(df$file.color.fit[2])
    
  })
  
  basiccolorforfit=reactive({
    if (is.null(inputcolor.refit())) return(NULL)
    data.fit.3D<-data.fit.3D()
    name<-"colorvar.refit"
    color.function(data.fit.3D[[inputcolor.refit()]],name,0,mypaletteofcolors.fit()) 
    
  })
  
  output$colorsrefits <- renderUI({
    basiccolorforfit()
  })
  
  colorvalues<-reactive({
    req(!is.null(data.fit()))
    colorvalues<-NULL
    n <- length(unique(data.fit.3D()[,input$setID]))
    val <- list()
    colorvalues<- lapply(1:n, function(i) {
      if (i==1) val <- list(input[[paste0("colorvar.refit",i)]])
      else val <- list(val,input[[paste0("colorvar.refit",i)]])
      
    })
  }) # end of Colorvalues
  
  observeEvent(colorvalues(),{ 
    if (length(unlist(colorvalues()))>1) {
      color<-levels(as.factor(data.fit.3D()[[inputcolor.refit()]]))
      names_of_the_variable<-unlist(colorvalues())
      length(color)<-max(c(length(color),length(names_of_the_variable))) ## to avoid problem of different row
      length(names_of_the_variable)<-max(c(length(color),length(names_of_the_variable)))
      save.col.react.fit(cbind.data.frame(color,names_of_the_variable))
    }
    
  })
  
  observe({
    req(input$file.color.fit)
    extension <- tools::file_ext(input$file.color.fit$name)
    df$file.color.fit <- switch(extension,
                                csv = {    
                                  sep2 <- if( ";" %in% strsplit(readLines(input$file1$datapath, n=1)[1], split="")[[1]] ){";"
                                  } else if( "," %in% strsplit(readLines(input$file1$datapath, n=1)[1], split="")[[1]] ){","
                                  } else if ( "\t" %in% strsplit(readLines(input$file1$datapath, n=1)[1], split="")[[1]] ){"\t"
                                  } else {";"}
                                  utils::read.csv(input$file.color.fit$datapath,
                                                  header = input$header,
                                                  sep = sep2, stringsAsFactors = F, 
                                                  dec=".")},
                                xls = readxl::read_xls(input$file.color.fit$datapath),
                                xlsx = readxl::read_xlsx(input$file.color.fit$datapath))
  })
  
  ### variable subset refits ----
  react.var.rerefit<-reactiveVal("null")
  react.listevarrefit<-reactiveVal("0")
  
  output$liste.var.refit=renderUI({
    req(!is.null(fileisupload()))
    req(!is.null(data.refit.choose()))
    selectInput("var.rerefit", h4("Subsetting refit"),
                choices = data.refit.choose()[c(3:length(data.refit.choose()))],
                selected = data.refit.choose()[1])
  })
  
  output$liste.varrefit=renderUI({
    req(!is.null(fileisupload()))
    req(!is.null(data.refit.choose()))
    checkboxGroupInput("listevarrefit", h4("Select the refit modalities to be shown"),
                       choices = levels(as.factor(data.fit.3D()[,input$var.rerefit])), selected = factor(data.fit.3D()[,input$var.rerefit]))
  })
  
  observeEvent(input$var.rerefit,{
    react.var.rerefit(input$var.rerefit)
  })
  observeEvent(input$listevarrefit,{
    react.listevarrefit(input$listevarrefit)
  })
  
  
  ##### ouput 2D and 3D slide ----
  output$sectionXy2=renderUI({
    req(!is.null(fileisupload()))
    req(input$yslider)
    y2min=min(input$yslider)
    y2max=max(input$yslider)
    sliderInput('ssectionXy2','y (point size): min/max',min=y2min,max=y2max,value=c(y2min,y2max),step=stepY())
  })
  output$sectionXx2=renderUI({
    req(!is.null(fileisupload()))
    req(input$xslider)
    x2min=input$xslider[1]
    x2max=input$xslider[2]
    sliderInput('ssectionXx2','x (point size): min/max',min=x2min,max=x2max,value=c(x2min,x2max),step=stepX())
  })
  output$sectionXz2=renderUI({
    req(!is.null(fileisupload()))
    req(input$zslider)
    z2min=min(input$zslider)
    z2max=max(input$zslider)
    sliderInput('ssectionXz2','z (point size): min/max',min=z2min,max=z2max,value=c(z2min,z2max),step=stepZ())
  }) 
  
  output$var.gris.2D=renderUI({ 
    req(!is.null(fileisupload()))
    selectInput("set.var.gris.2D", h4("Select the variable for point that are going to be wide"),
                choices = names(df$df)[c(3:ncol(df$df))])
  }) 
  output$var.gris.2D.1=renderUI({ 
    req(!is.null(fileisupload()))
    checkboxGroupInput("set.var.gris.2D.1", h4("Levels of variable"),
                       choices = levels(as.factor(df$df[,input$set.var.gris.2D])),selected = factor(df$df[,input$set.var.gris.2D]))
  }) 
  
  output$sectionXx3=renderUI({
    req(!is.null(fileisupload()))
    req(input$pi2)
    xmin=0
    xmax=input$xslider[2]-input$xslider[1]
    sliderInput('ssectionXx3','x: min/max',min=xmin,max=xmax,value=c(xmin,xmax),step=0.05)
  })
  output$sectionXy3=renderUI({
    req(!is.null(fileisupload()))
    req(input$pi2)
    ymin=0
    ymax=input$yslider[2]-input$yslider[1]
    sliderInput('ssectionXy3','y: min/max',min=ymin,max=ymax,value=c(ymin,ymax),step=0.05)
  })
  
  output$var.fit.3D=renderUI({
    req(!is.null(data.fit.3D()))
    radioButtons("var.fit.3D", "Include refits",
                 choices = c(no = "no",
                             yes = "yes"),
                 selected = "no", inline=TRUE)
  })
  
  var.sub2<-reactiveVal()
  min.point.sliderx<-reactiveVal()
  min.point.slidery<-reactiveVal()
  min.point.sliderz<-reactiveVal()
  set.var.gris<-reactiveVal()
  
  observeEvent(input$set.var.gris.2D.1, {
    var.sub2(input$set.var.gris.2D.1)
  }) 
  
  observeEvent(input$ssectionXx2,{
    min.point.sliderx(input$ssectionXx2)
  })
  observeEvent(input$ssectionXy2,{
    min.point.slidery(input$ssectionXy2)
  })
  observeEvent(input$ssectionXz2,{
    min.point.sliderz(input$ssectionXz2)
  })
  
  observeEvent(input$set.var.gris.2D, {
    set.var.gris(input$set.var.gris.2D)
  }) 
  
  
  ##### new group slide ----
  output$liste.newgroup=renderUI({
    req(!is.null(fileisupload()))
    selectInput("listenewgroup", h4("Copy data from another variable (select NULL for a default value of zero)"),
                choices = names(df$df)[c(3:ncol(df$df))],
                selected = c("null"))
  })
  values <- reactiveValues(newgroup = NULL)
  create.newgroup <- observeEvent(input$go.ng, {
    new.group<-df$df[,input$listenewgroup]
    req(!isTruthy(input$text.new.group == values$newgroup)) ## block if two same names exist because problems later
    values$newgroup <- c(values$newgroup, input$text.new.group)
    df$df<-cbind(df$df,new.group)
    colnames(df$df)[ncol(df$df)]<-c(input$text.new.group)
    
  })
  
  output$brushed<- renderPrint({
    g1 <- df$df
    d <- event_data('plotly_selected')
    if (is.null(d)) return()
    if (length(d)==0) {
      vv <<- NULL
      return()
    }
    dd <- cbind(d[[3]],d[[4]])
    switch(input$var1,
           xy={var<-setXX()
           var2<-setYY()       },
           yz={   var<-setYY() 
           var2<-setZZ()     },
           xz={   var<-setXX()
           var2<-setZZ()    },
           yx={   var<-setYY() 
           var2<-setXX() })
    
    WW<-which(g1[[var]] %in% dd[,1] & g1[[var2]] %in% dd[,2]) 
    vv<-df$df[WW,3:ncol(df$df)]
    vv <<- vv
    vv
  })  
  
  observeEvent(input$Change2, {
    showModal(dataModal())
  })
  observeEvent(input$Change, {
    req(!is.null(input$Change))
    df$df[which(row.names(df$df) %in% row.names(vv)),][input$text.new.group] <<-
      input$NewGroup
    removeModal()
  }) # end of Observe Event
  
  #rename
  output$liste.newgroup2=renderUI({
    req(!is.null(fileisupload()))
    selectInput("liste.newgroup.rename", label = h5("Select the new group"), 
                choices = values$newgroup, 
                selected = values$newgroup[1])
  })
  output$liste.newgroup4=renderUI({
    req(!is.null(fileisupload()))
    req(!is.null(values$newgroup))
    req(input$liste.newgroup.rename != "")
    selectInput("liste.newgroup3", label = h5("Select the variable"), 
                choices = factor(df$df[,input$liste.newgroup.rename]))
  })
  observeEvent(input$go.ng2, { 
    req(!is.null(input$liste.newgroup3))
    df$df[,input$liste.newgroup.rename][df$df[,input$liste.newgroup.rename]==input$liste.newgroup3]<-input$text.new.group2
  })
  
  
  ##### simplification to checkboxgroupinput----
  observeEvent(input$all_artifact_entry, {
    req(input$setnature)
    updateCheckboxGroupInput(session, "Nature", 
                             selected = levels(as.factor(df$df[,input$setnature]))) })
  observeEvent(input$reset_artifact_entry, {
    updateCheckboxGroupInput(session, "Nature", 
                             selected = FALSE)})
  observeEvent(input$all_UAS_entry, {
    req(input$setlevels)
    updateCheckboxGroupInput(session, "UAS", 
                             selected = levels(as.factor(df$df[,input$setlevels])))})
  observeEvent(input$reset_UAS_entry, {
    updateCheckboxGroupInput(session, "UAS", 
                             selected = FALSE)})
  
  ##### creation df.sub----
  df.sub <- reactive({ # that would be used to create plot
    req(!is.null(fileisupload()))  
    req(!is.null(input$xslider))
    req(inputcolor())
    df.sub<-df$df
    plotcol<-df.sub[,inputcolor()]
    df.sub$layer2 <- factor(plotcol)
    df.sub$point.size <- size.scale()
    df.sub$point.size2<-size.scale()
    
    df.sub<-df.sub %>% relocate(layer2, point.size,point.size2)
    if (input$setdate!="null"){
      df.sub[,input$setdate] <-as.numeric(df.sub[,input$setdate])
      df.sub[,input$setdate][is.na(df.sub[,input$setdate])]<-0
      if (!is.null(input$Date2)) {
        df.sub<-df.sub %>%
          filter(df.sub[,input$setdate] >= input$Date2[1], df.sub[,input$setdate] <= input$Date2[2])}}
    
    if (input$setsector!="null"){
      df.sub <- df.sub[df.sub[,input$setsector] %in% input$localisation, ]}
    if (input$setlevels!="null"){
      df.sub <- df.sub[df.sub[,input$setlevels] %in% input$UAS, ]}
    if (input$setnature!="null"){
      df.sub <- df.sub[df.sub[,input$setnature] %in% input$Nature, ]}
    if (input$setpasse!="null"){
      df.sub <- df.sub[df.sub[,input$setpasse]%in% input$Passe, ]}
    df.sub<-df.sub %>% 
      filter(.data[[input$setx]] >= input$xslider[1], .data[[input$setx]] <= input$xslider[2]) %>% 
      filter(.data[[input$sety]] >= input$yslider[1], .data[[input$sety]] <= input$yslider[2]) %>% 
      filter(.data[[input$setz]] >= input$zslider[1], .data[[input$setz]] <= input$zslider[2])
    df.sub
  })    # end of df.sub reactive
  
  
  ##### creation df.sub.minpoint----
  df.sub.minpoint <- reactive({ 
    df.sub.minpoint<-df.sub()
    if(!is.null(set.var.gris())) {
      df.sub.minpoint<-df.sub.minpoint  %>%
        filter((.data[[set.var.gris()]] %in% var.sub2()))}
    if(!is.null(min.point.sliderx())) {
      df.sub.minpoint<-df.sub.minpoint  %>%
        filter(.data[[input$setx]] >= min(min.point.sliderx()), .data[[input$setx]] <= max(min.point.sliderx())) %>%
        filter(.data[[input$sety]] >= min(min.point.slidery()), .data[[input$sety]] <= max(min.point.slidery())) %>%
        filter(.data[[input$setz]] >= min(min.point.sliderz()), .data[[input$setz]] <= max(min.point.sliderz()))
    }
    if (nrow(df.sub.minpoint)>0){
      df.sub.minpoint$point.size2<-size.scale()
    } 
    df.sub.minpoint
    
  }) # end of df.sub reactive 
  
  ### function for rotated 2DPlot ----
  rotated.table<-reactive({
    isTruthy(df.sub())
    points_start<-df.sub()
    M <- cbind.data.frame(points_start[,input$setx],points_start[,input$sety])
    alpha <- input$pi2 # in degree
    M <- as.matrix(M)
    # centrage
    centroid <- colMeans(M)
    Mc <- M - matrix(centroid, nrow=nrow(M), ncol=2, byrow = TRUE)
    # matrix of rotation
    alpha <- alpha/180*pi
    R <- matrix(c(cos(alpha), sin(alpha), -sin(alpha), cos(alpha)), 2, 2)
    # rotation
    Mr <- Mc%*%R
    # translation to come back at the center
    Mr <- Mr + matrix(centroid, nrow=nrow(M), ncol=2, byrow = TRUE)
    
    # normalisation of data
    inidataxmax<- points_start[,input$setx]%>%as.numeric()%>%ceiling()%>% max()
    inidataxmin<- points_start[,input$setx]%>%as.numeric()%>%floor()%>% min()
    inidataymax<- points_start[,input$sety]%>%as.numeric()%>%ceiling()%>% max()
    inidataymin<- points_start[,input$sety]%>%as.numeric()%>%floor()%>% min()
    points_start$x2<-((Mr[,1]-min(Mr[,1]))/(max(Mr[,1])-min(Mr[,1])))*(abs(inidataxmax-inidataxmin))
    points_start$y2<-((Mr[,2]-min(Mr[,2]))/(max(Mr[,2])-min(Mr[,2])))*(abs(inidataymax-inidataymin))
    rotated.table<-points_start
    
  }) 
  
  ##### output.contents ----  
  output$contents <- renderTable({
    req(!is.null(fileisupload()))
    isTruthy(df.sub())
    df.5<-df.sub()[1:10,]
    df.6<-cbind.data.frame(df.5[,input$setx],df.5[,input$sety],df.5[,input$setz],df.5[,input$setID],
                           df.5[,input$setdate],df.5[,input$setsector],df.5[,input$setlevels],df.5[,input$setnature],
                           df.5[,input$setpasse])
    colnames(df.6)<-c(input$setx,input$sety,input$setz,input$setID,
                      input$setdate,input$setsector,input$setlevels,
                      input$setnature,input$setpasse)
    return(df.6[1:5,1:9])
  })
  
  
  #### 3D plot ----
  output$plot3Dbox <- renderUI({
    plotlyOutput("plot3d", height = height.size())
  })
  
  output$plot3d <- renderPlotly({ 
    df.sub <- df.sub()
    df.sub3 <-df.sub.minpoint()
    min.size2<-minsize()
    myvaluesx<-unlist(myvaluesx())
    
    if (is.null(unlist(myvaluesx))) {
      myvaluesx <-c("blue","red","green")
    }
    
    size.scale <- size.scale()
    if (nrow(df.sub3)>0){
      df.sub$point.size[!((df.sub[,input$setx] %in% df.sub3[,input$setx]) & (df.sub[,input$sety] %in% df.sub3[,input$sety]) & (df.sub[,input$setz] %in% df.sub3[,input$setz]))]<-min.size2
    } 
    shapeX<-df.sub$shapeX
    shape.level<-levels(as.factor(shapeX))
    text2<-df.sub$text
    p <- plot_ly(df.sub,height = height.size(),width = height.size())
    p <-add_trace(p, x = ~df.sub[,input$setx], y = ~df.sub[,input$sety], z = ~df.sub[,input$setz], 
                  type="scatter3d",
                  color = ~layer2,
                  colors=myvaluesx,
                  size  = ~point.size,
                  sizes = c(min.size2,size.scale),
                  mode   = 'markers',
                  symbol = ~shapeX,
                  symbols =shape.level,
                  text = text2,
                  hovertemplate = paste('<b>X</b>: %{x:.4}',
                                        '<br><b>Y</b>: %{y}',
                                        '<b>%{text}</b>')
    ) # end plotly
    
    if (!is.null(data.fit.3D()) && input$var.fit.3D == "yes"){
      colorvalues<-unlist(colorvalues())
      data.fit.3D<-data.fit.3D()
      data.fit.3D<-data.fit.3D %>% filter((.data[[input$setID]] %in% df.sub[,input$setID]))
      data.fit.3D$color.fit<-colorvalues[match(data.fit.3D[[inputcolor.refit()]],levels(as.factor(data.fit.3D[[inputcolor.refit()]])))] # set up the list of color 
      data.fit.3D<-data.fit.3D[data.fit.3D[,react.var.rerefit()] %in% react.listevarrefit(),]
      
      p<-add_trace(p,x = ~data.fit.3D[,setXX()], y = ~data.fit.3D[,setYY()], z = ~data.fit.3D[,setZZ()], split = ~data.fit.3D[,input$setREM],
                   line = list(color=~data.fit.3D$color.fit),
                   type = "scatter3d", mode = "lines", showlegend = legendplotlyfig(), inherit = F)
    }
    
    p <- p %>% layout(
      showlegend = legendplotlyfig(),
      scene = list(
        xaxis = list(title = nameX(),
                     dtick = Xtickmarks.size(), 
                     tick0 = floor(min(df.sub[,input$setx])), 
                     tickmode = "linear",
                     titlefont = list(size = font_size()), tickfont = list(size = font_tick())),
        
        yaxis = list(title = nameY(),
                     dtick = Ytickmarks.size(), 
                     tick0 = floor(min(df.sub[,input$sety])), 
                     tickmode = "linear",
                     titlefont = list(size = font_size()), tickfont = list(size = font_tick())),
        zaxis = list(title = nameZ(),
                     dtick = Ztickmarks.size(), 
                     tick0 = floor(min(df.sub[,input$setz])), 
                     tickmode = "linear",
                     titlefont = list(size = font_size()), tickfont = list(size = font_tick())),

        camera = list(projection = list(type = 'orthographic')),
        aspectmode = "manual",
        aspectratio=list(x=ratiox(),y=ratioy(),z=ratioz())),
      autosize=FALSE
    )
    
    p <-p %>%
      config(displaylogo = FALSE,
             modeBarButtonsToAdd = list(dl_button),
             toImageButtonOptions = list(
               format = "svg")
      )
    session_store$plt <- p
    p
  })
  
  
  #### 2D plot ---- 
  ##advanced plot
  output$plot2Dbox <- renderUI({
    plotlyOutput("sectionYplot", height = height.size())
  })
  
  output$sectionYplot <- renderPlotly({
    plot2D.react()
    session_store$plt2D<- plot2D.react()
  })
  plot2D.react<-reactive({ 
    input$run_button
    min.size2<-minsize()
    orthofile<-NULL
    if (input$var.ortho == "yes" ){
      orthofile <- switch(input$var1,
                          xy = if(!is.null(input$file2)) {stack(input$file2$datapath)},
                          yx = if(!is.null(input$file5)) {stack(input$file5$datapath)},
                          xz = if(!is.null(input$file3)) {stack(input$file3$datapath)},
                          yz = if(!is.null(input$file4)) {stack(input$file4$datapath)})
    }
    
    height.size2<-height.size()
    width.size2 <- width.size()
    isolate ({
      df.sub2<-df.sub() 
      df.sub3<-df.sub.minpoint()
      myvaluesx<-unlist(myvaluesx())
      if (is.null(unlist(myvaluesx))) {
        myvaluesx <-c("blue","red","green")
      }
      size.scale <- size.scale()
      
      if (nrow(df.sub3)>0){
        df.sub2$point.size2[!((df.sub2[,input$setx] %in% df.sub3[,input$setx]) & (df.sub2[,input$sety] %in% df.sub3[,input$sety]) & (df.sub2[,input$setz] %in% df.sub3[,input$setz]))]<-min.size2
        
      }
      switch(input$var1,
             xy={var<-setXX()
             var2<-setYY()       
             axis.var.name<-nameX()
             axis.var2.name<-nameY()
             Xtickmarks.size<-Xtickmarks.size()
             Ytickmarks.size<-Ytickmarks.size()
             },
             yz={   var<-setYY() 
             var2<-setZZ()     
             axis.var.name<-nameY()
             axis.var2.name<-nameZ()
             Xtickmarks.size<-Ytickmarks.size()
             Ytickmarks.size<-Ztickmarks.size()},
             xz={   var<-setXX()
             var2<-setZZ()   
             axis.var.name<-nameX()
             axis.var2.name<-nameZ()
             Xtickmarks.size<-Xtickmarks.size()
             Ytickmarks.size<-Ztickmarks.size()
             },
             yx={   var<-setYY() 
             var2<-setXX() 
             axis.var.name<-nameY()
             axis.var2.name<-nameX()
             Xtickmarks.size<-Ytickmarks.size()
             Ytickmarks.size<-Xtickmarks.size()}
      )
      
      shapeX<-df.sub2$shapeX
      shape.level<-levels(as.factor(shapeX))
      
      if (is.null(orthofile)){
        p<- plot_ly(height = height.size(),
                    width = width.size())
        p<- add_trace(p, x = ~df.sub2[[var]], y = ~df.sub2[[var2]],
                      type="scatter",
                      color = ~df.sub2$layer2,
                      colors = myvaluesx,
                      size  = ~df.sub2$point.size2,
                      sizes = c(min.size2,size.scale),
                      mode   = 'markers',
                      fill = ~'',
                      symbol = ~df.sub2$shapeX, 
                      symbols = shape.level,
                      text=df.sub2$text,                                   
                      hovertemplate = paste('<b>X</b>: %{x:.4}',
                                            '<br><b>Y</b>: %{y}',
                                            '<b>%{text}</b>'))
        
        if (input$var.fit.table == "yes" & !is.null(data.fit.3D())){
          colorvalues<-unlist(colorvalues())
          
          data.fit.3D<-data.fit.3D() %>% filter((.data[[input$setID]] %in% df.sub2[,input$setID]))
          data.fit.3D$color.fit<-colorvalues[match(data.fit.3D[[inputcolor.refit()]],levels(as.factor(data.fit.3D[[inputcolor.refit()]])))] # set up the list of color 
          
          if (length(levels(as.factor(data.fit.3D$color.fit)))>1){
            for (i in 1:length (levels(as.factor(data.fit.3D[,input$setREM])))) {
              data.fit.3D.2<-data.fit.3D[data.fit.3D[,input$setREM]==levels(as.factor(data.fit.3D[,input$setREM]))[i],]
              if (length(levels(as.factor(data.fit.3D.2[["color.fit"]])))>1){
                data.fit.3D$color.fit[((data.fit.3D[,input$setx] %in% data.fit.3D.2[,input$setx]) & (data.fit.3D[,input$sety] %in% data.fit.3D.2[,input$sety]) & (data.fit.3D[,input$setz] %in% data.fit.3D.2[,input$setz]))]<-c("#000000") # Black color for refit variable mixing 
              }}} #end of if
          
          data.fit.3D<-data.fit.3D[data.fit.3D[,react.var.rerefit()] %in% react.listevarrefit(),]
          
          
          p<-add_trace(p,x = ~data.fit.3D[[var]], y = ~data.fit.3D[[var2]], split = ~data.fit.3D[,input$setREM],   
                       line = list(color=~data.fit.3D$color.fit,width=input$w2),
                       type = "scatter", mode = "lines", showlegend = legendplotlyfig(), inherit = F)
          
        } # end of refit 
        
        p <-  p %>% layout(showlegend = legendplotlyfig(),
                           scene = list( aspectmode = "manual",
                                          aspectratio=list(x=ratiox(),y=ratioy()),
                                           autosize=FALSE),
                           xaxis = list(title = paste(axis.var.name),
                                        dtick = Xtickmarks.size, 
                                        tick0 = floor(min(df.sub2[[var]])), 
                                        tickmode = "linear",titlefont = list(size = font_size()), tickfont = list(size = font_tick())),
                           
                           yaxis = list(title = paste(axis.var2.name),
                                        dtick = Ytickmarks.size, 
                                        tick0 = floor(min(df.sub2[[var2]])), 
                                        tickmode = "linear",
                                        titlefont = list(size = font_size()), tickfont = list(size = font_tick())),

                           dragmode = "select")%>%
          event_register("plotly_selecting")
        
      } else {
        p <-ggplot()+
          ggRGB(img = orthofile,
                r = 1,
                g = 2,
                b = 3,
                maxpixels =500000,
                ggLayer = T)+
          geom_point(data = df.sub2,
                     aes(x = .data[[var]],
                         y = .data[[var2]],
                         fill=layer2,
                         size=as.factor(point.size2),
                         shape=shapeX,
                         text= paste(paste(var,":"), .data[[var]], paste(var2,":"), .data[[var2]], paste(df.sub2$text))
                     ))
        
        if (input$var.fit.table == "yes" & !is.null(data.fit.3D())){
          colorvalues<-unlist(colorvalues())
          data.fit.3D<-data.fit3() %>% filter((.data[[input$setID]] %in% df.sub2[,input$setID]))
          data.fit.3D$color.fit<-colorvalues[match(data.fit.3D[[inputcolor.refit()]],levels(as.factor(data.fit.3D[[inputcolor.refit()]])))] # set up the list of color 
          if (is.null(colorvalues)) {
            data.fit.3D$color.fit <-c("black")
          }
          data.fit.3D<-data.fit.3D[data.fit.3D[,react.var.rerefit()] %in% react.listevarrefit(),]
          
          switch(input$var1,
                 xy={
                   varend<-"xend"
                   var2end<- "yend"
                 },
                 yz={
                   varend<-"yend"
                   var2end<- "zend"
                 },
                 xz={
                   varend<-"xend"
                   var2end<- "zend"
                 },
                 yx={
                   varend<-"yend"
                   var2end<- "xend"
                 })
          
          p<-p+geom_segment(data=data.fit.3D, aes(x = .data[[var]], y = .data[[var2]], xend=.data[[varend]],
                                                  yend=.data[[var2end]]), color=data.fit.3D$color.fit,linewidth=input$w2, inherit.aes = F)
        }
        
        p<-p+scale_fill_manual(values=unlist(myvaluesx))+
          scale_shape_manual(values=shape.level)+
          scale_size_manual(values=c(size.scale,min.size2))+
          xlab(paste(axis.var.name))+ylab(paste(axis.var2.name))+
         # theme(legend.title = element_blank())+
          match.fun(stringr::str_sub(themeforfigure.choice(), 1, -3))()+ theme(legend.position='none')+
          theme(axis.title.x = element_text(size=font_size()),
                axis.title.y = element_text(size=font_size()),
                axis.text.x = element_text(size=font_tick()),
                axis.text.y = element_text(size=font_tick()),
                legend.title = element_blank())+
          theme(legend.position='none')
        p<-p+scale_x_continuous(breaks=seq(floor(min(df.sub2[[var]])),max(df.sub2[[var]]),Xtickmarks.size))+
          scale_y_continuous(breaks=seq(floor(min(df.sub2[[var2]])),max(df.sub2[[var2]]),Ytickmarks.size))
      }
      p <-p %>%
        config(displaylogo = FALSE,
               modeBarButtonsToAdd = list(dl_button),
               toImageButtonOptions = list(
                 format = "svg")
        )
      
    }) #end isolate
    
  }) #plot2D.react
  
  ## simple 2D plot
  output$plot2Dbox.simple <- renderUI({
    plotOutput("sectionYplot.simple", height = height.size(), width = width.size())
  })
  
  output$sectionYplot.simple <- renderPlot({
    plot(plot2D.simple.react())
    session_store$plt2D.simple<- plot2D.simple.react()
  })
  plot2D.simple.react<-reactive({ 
    #input$run_button2
    
    min.size2<-minsize()
    orthofile<-NULL
    if (input$var.ortho.simple == "yes" ){
      orthofile <- switch(input$var1.simple,
                          xy = if(!is.null(input$file2)) {stack(input$file2$datapath)},
                          yx = if(!is.null(input$file5)) {stack(input$file5$datapath)},
                          xz = if(!is.null(input$file3)) {stack(input$file3$datapath)},
                          yz = if(!is.null(input$file4)) {stack(input$file4$datapath)})
    }
    
    #isolate ({
    df.sub2<-df.sub() 
    df.sub3<-df.sub.minpoint()
    myvaluesx<-unlist(myvaluesx())
    if (is.null(unlist(myvaluesx))) {
      myvaluesx <-c("blue","red","green")
    }
    size.scale <- size.scale()
    
    if (nrow(df.sub3)>0){
      df.sub2$point.size2[!((df.sub2[,input$setx] %in% df.sub3[,input$setx]) & (df.sub2[,input$sety] %in% df.sub3[,input$sety]) & (df.sub2[,input$setz] %in% df.sub3[,input$setz]))]<-min.size2
      
    }
    switch(input$var1.simple,
           xy={var<-setXX()
           var2<-setYY()       
           axis.var.name<-nameX()
           axis.var2.name<-nameY()
           Xtickmarks.size<-Xtickmarks.size()
           Ytickmarks.size<-Ytickmarks.size()
           },
           yz={   var<-setYY() 
           var2<-setZZ()     
           axis.var.name<-nameY()
           axis.var2.name<-nameZ()
           Xtickmarks.size<-Ytickmarks.size()
           Ytickmarks.size<-Ztickmarks.size()},
           xz={   var<-setXX()
           var2<-setZZ()   
           axis.var.name<-nameX()
           axis.var2.name<-nameZ()
           Xtickmarks.size<-Xtickmarks.size()
           Ytickmarks.size<-Ztickmarks.size()
           },
           yx={   var<-setYY() 
           var2<-setXX() 
           axis.var.name<-nameY()
           axis.var2.name<-nameX()
           Xtickmarks.size<-Ytickmarks.size()
           Ytickmarks.size<-Xtickmarks.size()}
    )
    
    shapeX<-df.sub2$shapeX
    shape.level<-levels(as.factor(shapeX))
    point.size3<-as.factor(df.sub2$point.size2)
    
    p <-ggplot()
    if (!is.null(orthofile)){
      
      p<-p+ ggRGB(img = orthofile,
                  r = 1,
                  g = 2,
                  b = 3,
                  maxpixels =500000,
                  ggLayer = T)
    }   
    
    p<-p+geom_point(data = df.sub2,
                    aes(x = .data[[var]],
                        y = .data[[var2]],
                        col=factor(layer2),
                        size=point.size3,
                        shape=shapeX
                    ))    +
      coord_fixed(ratio.simple())
    
    if (input$var.fit.table.simple == "yes" & !is.null(data.fit.3D())){
      colorvalues<-unlist(colorvalues())
      data.fit.3D<-data.fit3() %>% filter((.data[[input$setID]] %in% df.sub2[,input$setID]))
      data.fit.3D$color.fit<-colorvalues[match(data.fit.3D[[inputcolor.refit()]],levels(as.factor(data.fit.3D[[inputcolor.refit()]])))] # set up the list of color 
      if (is.null(colorvalues)) {
        data.fit.3D$color.fit <-c("black")
      }
      data.fit.3D<-data.fit.3D[data.fit.3D[,react.var.rerefit()] %in% react.listevarrefit(),]
      
      switch(input$var1.simple,
             xy={
               varend<-"xend"
               var2end<- "yend"
             },
             yz={
               varend<-"yend"
               var2end<- "zend"
             },
             xz={
               varend<-"xend"
               var2end<- "zend"
             },
             yx={
               varend<-"yend"
               var2end<- "xend"
             })
      
      p<-p+geom_segment(data=data.fit.3D, aes(x = .data[[var]], y = .data[[var2]], xend=.data[[varend]],
                                              yend=.data[[var2end]]), color=data.fit.3D$color.fit,linewidth=input$w2, inherit.aes = F)
    }
    p<-p+scale_color_manual(values=myvaluesx)+
      scale_shape_manual(values=shape.level)+
      scale_size_manual(values=c(size.scale,min.size2))+
      xlab(paste(axis.var.name))+ylab(paste(axis.var2.name))+
      match.fun(stringr::str_sub(themeforfigure.choice(), 1, -3))()+
      theme(axis.title.x = element_text(size=font_size()),
            axis.title.y = element_text(size=font_size()),
            axis.text.x = element_text(size=font_tick()),
            axis.text.y = element_text(size=font_tick()),
            legend.title = element_blank())+
      theme(legend.position='none')

    p<-p+scale_x_continuous(breaks=seq(floor(min(df.sub2[[var]])),max(df.sub2[[var]]),Xtickmarks.size))+
      scale_y_continuous(breaks=seq(floor(min(df.sub2[[var2]])),max(df.sub2[[var2]]),Ytickmarks.size))
    p   
    #  }) #end isolate
    
  }) #end plot2D.react 
  
  
  ##### 2D slice ---- 
  set.var.2d.slice<-reactiveVal()
  output$range.2d.slice=renderUI({
    req(!is.null(fileisupload()))
    req(input$var.2d.slice)
    set.var.2d.slice<- switch(input$var.2d.slice,
                              xz = setYY(),
                              yz = setXX())
    set.var.2d.slice(set.var.2d.slice)
    xymax = df$df[,set.var.2d.slice] %>% ceiling() %>% max(na.rm = TRUE)
    xymin=df$df[,set.var.2d.slice] %>% floor() %>% min(na.rm = TRUE)
    sliderInput('range2dslice','Range of slices',min=xymin,max=xymax,value=c(xymin,xymax),step=input$step2dslice)
  })
  
  ratio.slice<-reactiveVal(1)
  observeEvent(c(input$range2dslice, input$step2dslice), {
    req(!is.null(input$range2dslice))
    ratio.slice<-(max(input$range2dslice)-min(input$range2dslice))/input$step2dslice 
    ratio.slice<-ceiling(ratio.slice)
    if (ratio.slice<1) {
      ratio.slice<-1
    }
    
    ratio.slice(ratio.slice)
    df.sub.list<-vector("list", ratio.slice)
    min.size2<-minsize()
    df.sub2<-df.sub()
    set.var.2d.slice<-set.var.2d.slice()
    set.antivar.2d.slice<-c(setXX(),setYY())[c(setXX(),setYY())!=set.var.2d.slice()]
    
    df.sub3<-df.sub.minpoint() 
    if (nrow(df.sub3)>0){
      df.sub2$point.size2[!((df.sub2[,input$setx] %in% df.sub3[,input$setx]) & (df.sub2[,input$sety] %in% df.sub3[,input$sety]) & (df.sub2[,input$setz] %in% df.sub3[,input$setz]))]<-min.size2
    }
    
    liste.valeur.slice<-vector(length=ratio.slice)
    for (j in 1:ratio.slice){
      k<-j-1
      val<-min(input$range2dslice)+k*input$step2dslice
      val2<-val+input$step2dslice
      if(val2>max(input$range2dslice)){ 
        val2<-max(input$range2dslice)
      }
      liste.valeur.slice[j]<-paste("2D slice from ",val," to ",val2, " in ",set.var.2d.slice()," axis")
      df.sub.list[[j]]<- filter (df.sub2, .data[[set.var.2d.slice]]>= val, .data[[set.var.2d.slice]]<=val2)
    }
    plotServerList <- lapply(
      1:ratio.slice,
      function(i) {
        plotServer(paste0("plot", i),df.sub.list[i],set.antivar.2d.slice,setZZ(),liste.valeur.slice[i])
      }
    )
    
  })
  
  output$plot.2dslide <- renderUI({
    
    ns <- session$ns
    tagList(
      lapply(1:ratio.slice(),
             function(i) {
               plotUI(paste0("plot", i))
             }
      )
    )
  })
  
  ##### output sectiondensityplot slide ----  
  output$plotdens <- renderUI({
    plotOutput("sectiondensityplot", height = height.size(), width = width.size())
  })
  
  output$sectiondensityplot <- renderPlot({
    df.sub4<-df.sub()
    
    min.size2<-minsize()
    size.scale <- size.scale()
    
    df.sub3<-df.sub.minpoint()
    if (nrow(df.sub3)>0){
      df.sub4$point.size2[!((df.sub4[,input$setx] %in% df.sub3[,input$setx]) & (df.sub4[,input$sety] %in% df.sub3[,input$sety]) & (df.sub4[,input$setz] %in% df.sub3[,input$setz]))]<-min.size2
      
    }
    
    myvaluesx<-unlist(myvaluesx())
    if (is.null(unlist(myvaluesx))) {
      myvaluesx <-c("red","blue","green")
    }
    orthofile<-NULL
    if (input$var.ortho2 == "yes" ){
      orthofile <- switch(input$var3,
                          xy = if(!is.null(input$file2)) {stack(input$file2$datapath)},
                          yx = if(!is.null(input$file5)) {stack(input$file5$datapath)},
                          xz = if(!is.null(input$file3)) {stack(input$file3$datapath)},
                          yz = if(!is.null(input$file4)) {stack(input$file4$datapath)}) }
    
    switch(input$var3,
           xy={
             df.sub4$var<-df.sub4[,input$setx]
             df.sub4$var2<- df.sub4[,input$sety]
             nameaxis<-c(nameX(),nameY()) 
             Xtickmarks.size<-Xtickmarks.size()
             Ytickmarks.size<-Ytickmarks.size()
             },
           yz={
             df.sub4$var<-df.sub4[,input$sety]
             df.sub4$var2<- df.sub4[,input$setz]
             nameaxis<-c(nameY(),nameZ()) 
             Xtickmarks.size<-Ytickmarks.size()
             Ytickmarks.size<-Ztickmarks.size()},
           xz={
             df.sub4$var<-df.sub4[,input$setx]
             df.sub4$var2<- df.sub4[,input$setz]
             nameaxis<-c(nameX(),nameZ())
             Xtickmarks.size<-Xtickmarks.size()
             Ytickmarks.size<-Ztickmarks.size()},
           yx={
             df.sub4$var<-df.sub4[,input$sety]
             df.sub4$var2<- df.sub4[,input$setx]
             nameaxis<-c(nameY(),nameX())
             Xtickmarks.size<-Ytickmarks.size()
             Ytickmarks.size<-Xtickmarks.size()}
           
    )
    
    df.sub4$density <- get_density(df.sub4$var, df.sub4$var2, n = 100)
    
    
    
    # Density curve of x left panel 
    ydensity <- ggplot(df.sub4, aes(var, fill=factor(.data[[inputcolor()]]))) + 
      geom_density(alpha=.5) + 
      scale_fill_manual( values = myvaluesx)+
      match.fun(stringr::str_sub(themeforfigure.choice(), 1, -3))()+
      theme(legend.position = "none")
    
    # Density curve of y right panel 
    zdensity <- ggplot(df.sub4, aes(var2, fill=factor(.data[[inputcolor()]]))) + 
      geom_density(alpha=.5) + 
      scale_fill_manual( values = myvaluesx)+match.fun(stringr::str_sub(themeforfigure.choice(), 1, -3))()+
      theme(legend.position = "none")+coord_flip()
    blankPlot <- ggplot()+geom_blank(aes(1,1))+
      theme(plot.background = element_blank(), 
            panel.grid.major = element_blank(),
            panel.grid.minor = element_blank(), 
            panel.border = element_blank(),
            panel.background = element_blank(),
            axis.title.x = element_blank(),
            axis.title.y = element_blank(),
            axis.text.x = element_blank(), 
            axis.text.y = element_blank(),
            axis.ticks = element_blank()
      )
    
    if (is.null(orthofile)){
      p<-ggplot(df.sub4,aes(var, var2, color = density)) + 
        #geom_point(aes(var, var2, color = density), alpha=transpar(), size=input$point.size3)+
        geom_point(aes(var, var2, color = density), alpha=transpar(), size=df.sub4$point.size2)+ 
        scale_size_manual(values=c(size.scale,min.size2))+
        labs(x = nameaxis[1],y = nameaxis[2])+
        match.fun(stringr::str_sub(themeforfigure.choice(), 1, -3))()+
        theme(axis.title.x = element_text(size=font_size()),
              axis.title.y = element_text(size=font_size()),
              axis.text.x = element_text(size=font_tick()),
              axis.text.y = element_text(size=font_tick()))+
        {if (input$ratio.to.coord)coord_fixed()}
      
    } else { p <-ggplot()+ ggRGB(img = orthofile,
                                 r = 1,
                                 g = 2,
                                 b = 3,
                                 maxpixels =500000,
                                 ggLayer = T) +
      geom_point(df.sub4,mapping=aes(var, var2, color = density),alpha=transpar(), size=input$point.size3)+
      labs(x = nameaxis[1],y = nameaxis[2])
    }
    
    if (input$var.plotlyg.lines== "yes") {
      p<-p+geom_density_2d(mapping=aes(var, var2, color = ..level..),data=df.sub4)}
    
    p<-p+scale_color_viridis()+
      guides(fill = guide_legend(title = "Level"))+
      theme(axis.title.x = element_text(size=font_size()),
            axis.title.y = element_text(size=font_size()),
            axis.text.x = element_text(size=font_tick()),
            axis.text.y = element_text(size=font_tick()),)
    p<-p+scale_x_continuous(breaks=seq(floor(min(df.sub4$var)),max(df.sub4$var),Xtickmarks.size))+
      scale_y_continuous(breaks=seq(floor(min(df.sub4$var2)),max(df.sub4$var2),Ytickmarks.size))
    
    if (input$var.density.curves== "yes") {   
      
      p<-grid.arrange(ydensity, blankPlot, p, zdensity, 
                      ncol=2, nrow=2, widths=c(4, 1.4), heights=c(1.4, 4))
      
    } else {
      p} 
    session_store$plotdensity <- p
    
    p
  }) #end output$sectiondensityplot  
  
  observeEvent(input$transferxyz,{
    
    if (dim(df$df[duplicated(df$df[,input$setID]),])[1]>0) { 
      showModal(modalDialog(
        title = "This option is not possible without an unique ID !", 
        HTML(paste(dim(df$df[duplicated(df$df[,input$setID]),])[1], " object ID(s) is/are not unique ... <br> "))
      ))
      return()
    } 
    
    rotated.new.dataxy<-rotated.new.dataxy()
    names(rotated.new.dataxy)<-c(paste(input$setID),"X.rotated","Y.rotated")
    if(isTRUE("X.rotated" %in% names(df$df))==TRUE) {
      df$df<-df$df[,!colnames(df$df) %in% c("rotated")]
    }
    df$df<-full_join(df$df,rotated.new.dataxy)
    updateSelectInput(session,"setx",
                      choices=names(df$df["X.rotated"]),
                      select = names(df$df["X.rotated"]))
    updateSelectInput(session,"sety",
                      choices=names(df$df["Y.rotated"]),
                      select = names(df$df["Y.rotated"]))
  })
  
  ###output rotated 2D plot ----
  output$plot2Drota<- renderUI({
    plotlyOutput("plot2d2", height = height.size())
  })
  output$plot2Drota2<- renderUI({
    plotlyOutput("plot2d3", height = height.size())
  })
  
  output$plot2d2 <- renderPlotly({
    req(input$pi2)
    req(input$ssectionXy3)
    myvaluesx<-unlist(myvaluesx())
    if (is.null(unlist(myvaluesx))) {
      myvaluesx <-c("blue","red","green")
    }
    size.scale <- size.scale()
    min.size2<-minsize()
    df.sub5<-rotated.table()
    df.sub5<-as.data.frame(df.sub5)%>%
      filter(.data[["x2"]]>= min(input$ssectionXx3), .data[["x2"]]<= max(input$ssectionXx3)) %>%
      filter(.data[["y2"]]>= min(input$ssectionXy3), .data[["y2"]]<= max(input$ssectionXy3))
    # 
    shapeX<-df.sub5$shapeX
    shape.level<-levels(as.factor(shapeX))
    df.sub5$point.size2<-size.scale()
    temp.rot<-data.frame(df.sub5[,input$setID],df.sub5["x2"],df.sub5["y2"])
    colnames(temp.rot)<-c("ID","X.rotated","Y.rotated")
    rotated.new.dataxy(temp.rot)
    
    p<- plot_ly(df.sub5, x = ~x2, y = ~y2,
                type="scatter",
                color = ~layer2,
                colors = myvaluesx,
                size  = ~point.size2,
                sizes = c(min.size2,size.scale),
                mode   = 'markers',
                fill = ~'',
                symbol = ~shapeX,
                symbols = shape.level,
                text=df.sub5$text,
                hovertemplate = paste('<b>X</b>: %{x:.4}',
                                      '<br><b>Y</b>: %{y}',
                                      '<b>%{text}</b>'),
                height=height.size(),
                width=width.size()
    )
    
    p <- p %>% layout(showlegend = legendplotlyfig(),
                      scene = list(aspectratio=list(x=ratiox(),y=ratioy(),z=ratioz())),
                      xaxis = list(title=paste0(nameX()," modified"),
                                   dtick = Xtickmarks.size(), 
                                   tick0 = floor(min(df.sub5[["x2"]])), 
                                   tickmode = "linear",
                                   titlefont = list(size = font_size()), tickfont = list(size = font_tick())),
                      yaxis=list(title=paste(nameY()," modified"),
                                 dtick = Ytickmarks.size(), 
                                 tick0 = floor(min(df.sub5[["y2"]])), 
                                 tickmode = "linear",
                                 titlefont = list(size = font_size()), tickfont = list(size = font_tick())),
                      dragmode = "select")%>%
      event_register("plotly_selecting") 
    p <-p %>%
      config(displaylogo = FALSE,
             modeBarButtonsToAdd = list(dl_button),
             toImageButtonOptions = list(
               format = "svg")
      )
    session_store$plotrota <- p
    p
  })
  
  output$plot2d3 <- renderPlotly({ 
    req(input$pi2)
    req(input$ssectionXy3)
    myvaluesx<-unlist(myvaluesx())
    if (is.null(unlist(myvaluesx))) {
      myvaluesx <-c("blue","red","green")
    }
    size.scale <- size.scale()
    min.size2<-minsize()
    df.sub5<-rotated.table()
    df.sub5<-df.sub5%>%
      filter(.data[["x2"]]>= min(input$ssectionXx3), .data[["x2"]]<= max(input$ssectionXx3)) %>%
      filter(.data[["y2"]]>= min(input$ssectionXy3), .data[["y2"]]<= max(input$ssectionXy3))
    df.sub5<-as.data.frame(df.sub5)
    df.sub5$var2<- df.sub5[,input$setz]
    
    switch(input$var.section2D,
           xz={var<-"x2"
           var3<-paste0(nameX()," modified")},
           yz={   var<-"y2"
           var3<-paste0(nameY()," modified") })
    shapeX<-df.sub5$shapeX
    shape.level<-levels(as.factor(shapeX))
    df.sub5$point.size2<-size.scale()
    
    p<- plot_ly(df.sub5, x = ~df.sub5[[var]], y = ~df.sub5[,input$setz],
                type="scatter",
                color = ~layer2,
                colors = myvaluesx,
                size  = ~point.size2,
                sizes = c(min.size2,size.scale),
                mode   = 'markers',
                fill = ~'',
                symbol = ~shapeX,
                symbols = shape.level,
                text=df.sub5$text,
                hovertemplate = paste('<b>X</b>: %{x:.4}',
                                      '<br><b>Y</b>: %{y}',
                                      '<b>%{text}</b>'),
                height=height.size(),
                width=width.size()
    )
    p <-p %>% layout(showlegend = legendplotlyfig(),
                     scene = list(aspectratio=list(x=ratiox(),y=ratioy(),z=ratioz())),
                     xaxis = list(title=paste0(var3),
                                  dtick = Xtickmarks.size(), 
                                  tick0 = floor(min(df.sub5[[var]])), 
                                  tickmode = "linear",
                                  titlefont = list(size = font_size()), tickfont = list(size = font_tick())),
                     yaxis=list(title=paste(nameZ()),
                                dtick = Ytickmarks.size(), 
                                tick0 = floor(min(df.sub5[,input$setz])), 
                                tickmode = "linear",
                                titlefont = list(size = font_size()), tickfont = list(size = font_tick())),
                     dragmode = "select")%>%
      event_register("plotly_selecting")
    p <-p %>%
      config(displaylogo = FALSE,
             modeBarButtonsToAdd = list(dl_button),
             toImageButtonOptions = list(
               format = "svg"))
    
  })
  
  ##### download button ---- 
  #3D plot
  output$downloadData3D <- downloadHandler(
    filename = function() {
      paste("plot3D - ",paste(input$file1$name)," - ", Sys.Date(), ".html", sep="")
    },
    content = function(file) {
      htmlwidgets::saveWidget(as_widget(session_store$plt), file, selfcontained = TRUE)
    }
  )
  options(shiny.usecairo=T)
  ##2d plot
  output$downloadData2D <- downloadHandler(
    filename = function() {
      paste("plot2D - ",paste(input$file1$name)," - ", Sys.Date(), ".html", sep="")
    },
    content = function(file) {
      htmlwidgets::saveWidget(as_widget(session_store$plt2D), file, selfcontained = TRUE)
    }
  )
  output$downloadData2D.simple <- downloadHandler(
    filename = function(){paste("plot2D - ",paste(input$file1$name)," - ", Sys.Date(), '.pdf', sep = '')},
    content = function(file){
      ggsave(session_store$plt2D.simple,filename=file, device = "pdf")
    },
  )
  
  ##2d plot slice
  output$downloadData2d.slice <- downloadHandler(
    filename = function() {
      paste("plot2D.slice - ",paste(input$file1$name)," - ", Sys.Date(), ".html", sep="")
    },
    content = function(file) {
      htmlwidgets::saveWidget(as_widget(session_store$plotslice), file, selfcontained = TRUE)
    }
  )
  
  ##2d plot density  
  output$downloadDatadensity <- downloadHandler(
    filename = function(){paste("plotDensity - ",paste(input$file1$name)," - ", Sys.Date(), '.pdf', sep = '')},
    content = function(file){
      ggsave(session_store$plotdensity,filename=file, device = "pdf")
    },
  )
  
  # refit table
  output$downloadData_redata<- downloadHandler(
    filename = function() {
      paste0(Sys.Date(),"_refit_table.csv",sep="")
    },
    content = function(file) {
      write.table(data.fit3()[,4:ncol(data.fit3())], file, row.names = FALSE, sep=";",dec=".") 
    }
  )
  # raw table
  output$downloadData_rawdata<- downloadHandler(
    filename = function() {
      paste0(Sys.Date(),paste(input$file1$name),".csv",sep="")
    },
    content = function(file) {
      write.table(df$df[,3:ncol(df$df)], file, row.names = FALSE, sep=";",dec=".")
    }
  )
  # pivot table
  output$downloadData_pivotdata<- downloadHandler( 
    filename = function() {
      paste0(Sys.Date(),"pivot.table",".csv")
    },
    content = function(file) {
      write.table(Pivotdatatable(), file, row.names = FALSE, sep=";",dec=".")
    }
  )
  # save color
  output$save.col<- downloadHandler( 
    filename = function() {
      paste0(Sys.Date(),"save.col",".csv")
    },
    content = function(file) {
      write.table(save.col.react(), file, row.names = FALSE, sep=";",dec=".")
    }
  )
  output$save.col.fit<- downloadHandler( 
    filename = function() {
      paste0(Sys.Date(),"save.col.refit",".csv")
    },
    content = function(file) {
      write.table(save.col.react.fit(), file, row.names = FALSE, sep=";",dec=".")
    }
  )
  
  
  #rotated table
  output$downloadData_rotateddata<- downloadHandler( 
    filename = function() {
      paste0(Sys.Date(),"rotated coordinates",".csv")
    },
    content = function(file) {
      write.table(rotated.new.dataxy(), file, row.names = FALSE, sep=";",dec=".")
    }
  )
  
  ##### output summary slide ----
  output$liste.summary=renderUI({
    req(!is.null(fileisupload()))
    checkboxGroupInput("listesum", h4("Variables for summary table"),
                       choices = names(df$df)[c(3:ncol(df$df))])
  })
  
  Pivotdatatable<-reactive({req(input$listesum)
    df.sub<-df.sub()
    liste.sum<-c(input$listesum) # creation d'une liste
    table_matos<-df.sub %>% group_by(across(liste.sum)) %>% summarize(Freq=n())
    colnames(table_matos)<-c(unlist(liste.sum),"n")
    table_matos})
  
  output$summary <- renderTable({
    Pivotdatatable()
  })
  
  ##### output Table  ----
  output$table <-  DT::renderDataTable(
    DT::datatable(
      df.sub()[,-c(1:6)], extensions = 'Buttons', options = list(
        lengthMenu = list(c(5, 15,50,100, -1), c('5', '15','50','100', 'All')),
        pageLength = 15,
        initComplete = htmlwidgets::JS(
          "function(settings, json) {",
          paste0("$(this.api().table().container()).css({'font-size': '", font.size, "'});"),
          "}")
      ))  
  )#end renderDataTable
  
  #### rmarkdown report template ----
  
  w.report<-function(){ 
    writeLines(con = "report.Rmd", text = "---
title: 'Welcome to *SEAHORS*  report'
output: html_document
date : '`r format(Sys.time())`'
params:
  data: NA
  dataraw: NA
  file: NA
  path: NA
  plot2: NA
  plot3: NA
  plotrota: NA
  plotdens: NA
  nat: NA
  pas: NA
  loca: NA
  UAS: NA
  tobj: NA
  xsli: NA
  ysli: NA
  zsli: NA
  dat: NA
  linfos: NA
  col: NA
  setx: NA
  sety: NA
  setz: NA
  setid: NA
  setsect: NA
  setnat: NA
  setlvl: NA
  setdate: NA
  setpasse: NA
  fileextra: NA
  filerem: NA
  setrem: NA
  tabrefit: NA

---


```{r setup, include= FALSE}
library(DT)
```

```{r, echo=FALSE}
if (file.exists(paste0(getwd(),'/logo1.png'))){
htmltools::img(src = knitr::image_uri(file.path(getwd(), 'logo1.png')), 
               alt = 'logo', 
               style = 'position:absolute; top:0; right:0; padding:10px; height:150px ;')
}

```


```{r, echo=FALSE, include=FALSE}
file<-params$file
path<-params$path
data2<-params$data
 nat<- params$nat
  pas<-params$pas
 loca <-params$loca
 UAS <-params$UAS
 tobj <-params$tobj
  xsli<-params$xsli
 ysli <-params$ysli
  zsli<-params$zsli
 dat <-params$dat
  linfos<-params$linfos
  col<-params$col
  setx<-params$setx
  sety<-params$sety
  setz<-params$setz
  setid<-params$setid
 setsect<-params$setsect
 setnat <-params$setnat
  setlvl<-params$setlvl
 setdate <-params$setdate
  setpasse<-params$setpasse
  fileextra<-params$fileextra
 filerem <-params$filerem
  setrem<-params$setrem
 tabrefit <-params$tabrefit
data2raw<-params$dataraw

```
---

 This report was produced using the file **`r file[1]`** <br> 



### Setting informations


X axis: **`r setx`** <br> 
- sliders Xlimits between **`r xsli[1]` ** and **`r xsli[2]` ** <br> 
Y axis: **`r sety`** <br> 
- sliders Ylimits between **`r ysli[1]` ** and **`r ysli[2]` ** <br> 
Z axis: **`r setz`** <br> 
-sliders Zlimits between **`r zsli[1]` ** and **`r zsli[2]` ** <br> 

Year(s): **`r setdate `** <br> 
- sliders between **`r dat[1] `** and **`r dat[2] `**<br> 

Unique object IDs: **`r setid `**<br> 
```{r , echo=FALSE, message=FALSE, out.width='50%'}

if (setid != 'null'){
if(dim(data2raw[duplicated(data2raw[,setid]),])[1]>0) { 
 paste('Object IDs were not unique') } else {
 paste('All objects have unique IDs')
 }}


```


Context: **`r setsect `** <br> 
-with  **`r loca`** parameters selected  <br> 
Levels: **`r setlvl `** <br> 
-with **`r UAS `** parameters selected <br> 
Type: **`r setnat `** <br> 
-with **`r nat `** parameters selected <br> 
Others: **`r setpasse `** <br> 
-with **`r pas `** parameters selected<br> 

**`r tobj `** 

### Coloried variable : 
```{r , echo=FALSE, message=FALSE, out.width='100%'}

col

```


### The data : 
```{r , echo=FALSE, message=FALSE, out.width='100%'}
data2

```

### The refit data : 
```{r , echo=FALSE, message=FALSE, out.width='100%'}
 if (!is.null(tabrefit)) {
 tabrefit} else {
paste('no refit table has been added')
  }



```

### The plot(s) : 

```{r plotlyout, echo=FALSE, message=FALSE, out.width='100%'}
if (!is.null(params$plot2)) {params$plot2}
if (!is.null(params$plot3)) {params$plot3}
if (!is.null(params$plotdens)) {params$plotdens}
if (!is.null(params$plotdens)) {params$plotrota}

```")
  }


#### Rmarkdown report export ----
output$export.Rmarkdown<- downloadHandler( 
  filename = function() {
    paste0(Sys.Date(),"_report_Rmarkdown",".", input$docpdfhtml)
  },
  content = function(file) {    
    if (!is.null(data.fit3())){
      data.fit4<-data.fit3()[,4:ncol(data.fit3())]
    } else {
      data.fit4<-NULL}
    params2 <- list(data = df.sub()[,7:ncol(df.sub())],
                    dataraw = df$df[,4:ncol(df$df)],
                    file = input$file1$name,
                    path= input$file1$datapath,
                    plot3= session_store$plt,
                    plot2= session_store$plt2D,
                    plotrota=session_store$plotrota,
                    plotdens=session_store$plotdensity,
                    nat=input$Nature,
                    pas=input$Passe,
                    loca=input$localisation,
                    UAS=input$UAS,
                    tobj=textnbobject(),
                    xsli=input$xslider,
                    ysli=input$yslider,
                    zsli=input$zslider,
                    dat=input$Date2,
                    linfos=listinfosmarqueur(),
                    col=save.col.react(),
                    setx=input$setx,
                    sety=input$sety,
                    setz=input$setz,
                    setid=input$setID,
                    setsect=input$setsector,
                    setnat=input$setnature,
                    setlvl=input$setlevels,
                    setdate=input$setdate,
                    setpasse= input$setpasse,
                    fileextra=input$file.extradata$name,
                    filerem=input$file.fit$name,
                    setrem=input$setREM,
                    tabrefit=data.fit4
    )
    w.report()
    tmp_dir <- tempdir()
    tmp_pic2 <- file.path(tmp_dir,"logo1.png")
    file.copy("www/logo1.png", tmp_pic2, overwrite = TRUE)
    tempReport <- tempfile(fileext = ".Rmd") # make sure to avoid conflicts with other shiny sessions if more params are used
    file.copy("report.Rmd", tempReport, overwrite = TRUE)
    rmarkdown::render(tempReport, output_format = paste0(input$docpdfhtml,"_document"), output_file = file, output_options = list(self_contained = TRUE),
                      params = params2
    )
  }
)

} # end server

shinyApp(ui, server)
