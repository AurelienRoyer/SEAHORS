app_ui <- function(){
  shiny::addResourcePath("SEAHORS", system.file("R", package="SEAHORS"))
    

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

ui <- shinyUI(
  navbarPage(
  windowTitle = "SEAHORS",
  fluidPage(
    useShinyjs(),
    theme = shinytheme(theme = "journal"),
    sidebarLayout(
      sidebarPanel(span(img(src = "www/logo1.png", height = 110)),
                   tags$header(
                     tags$a(href = "https://github.com/AurelienRoyer/SEAHORS/",
                            "Spatial Exploration of ArcHaeological Objects in R Shiny")),
                   tags$hr(),
                   
                   tags$style(HTML(css)),
                   column(12,
               column(2,
        shinyWidgets::actionBttn(
          inputId = "save_load",
          label = "save",
          style = "stretch",
          color = "danger",
          size= "xs",
          icon = icon("fas fa-save",lib = "font-awesome")
        ),
               ),
        column(2,),
        column(2,
               shinyWidgets::actionBttn(
                 inputId = "save_load2",
                 label = "load",
                 style = "stretch",
                 color = "danger",
                 size= "xs",
                 icon = icon("fas fa-upload",lib = "font-awesome")
               ),)
        ),
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
                                     tags$br(),
                                     h5(style = "color: blue;","Only available with unique ID: "),        
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
                                    #fluidRow(column (7,checkboxInput("optioninfosfigplotly", "Show figure legend", TRUE))),
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
                                                                              "triangle"='triangle',
                                                                              "diamond"='diamond',
                                                                              "star"='star')),
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
                                    fluidRow(column (7,checkboxInput("optioninfosfigplotly", "Show figure legend", TRUE))),
                                    tags$br(),
                                    column(10,column(5,numericInput("height.size.b", label = h5("Figure height"), value = 800),),
                                           column(5,numericInput("width.size.b", label = h5("Figure width"), value = 1000),),
                                           tags$hr(),),
                                    tags$br(),
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
                                    column(10,
                                           column(4,numericInput("Xminor.breaks", "Position of X minor breaks",1, min = 0, max=40),),
                                           column(4,numericInput("Yminor.breaks", "Position of Y minor breaks",1, min = 0, max=40),),
                                           column(4,numericInput("Zminor.breaks", "Position of Z minor breaks",1, min = 0, max=40),),),
                                                                         column(10,
                                            checkboxInput("checkbox.auto.limits", label = "Automatic limits", value = TRUE),
                                            uiOutput("X.limx2"),
                                            uiOutput("Y.limx2"),
                                     ),
                                    
                                    column(12,br(),
                                           hr(),),
                                    uiOutput("themeforfigure"),
                   )# end of conditionalPanel
      ), #end sidebarpanel
      
      mainPanel(
        tabsetPanel(type = "tabs",id="mainpanel",
                    tabPanel("Overview", 
                             tags$div(
                               h2(" Welcome to the", em("SEAHORS"), "application",align="center", style = "font-family: 'Times', serif;
    font-weight: 500; font-size: 500; text-shadow: 3px 3px 3px #aaa; line-height: 1; 
     color: #404040;"),
                               tags$br(),
                               column(12, 
                                      column(3,),
                                      column(6,span(img(src = "www/logo2.png", height = 200)),),
                                      tags$br(),
                                      tags$br(),     
                               ),
                               column(12, br(),
                                      column(1,),
                                      column(9,
                                             br(),
                                             
                                             HTML(
                                               paste0(" <div style=width:100%;, align=left>
    <font size=3>
   <span style='text-transform:none'>
   
   <i>SEAHORS</i> (v. ", packageVersion("SEAHORS"), ") is an application dedicated to the intra-site spatial analysis of archaeological piece-plotted objects.</p>
   <p>It makes it possible to explore the spatial organisation of coordinate points taken on archaeological fields  and to visualise their distributions using interactive 3D and 2D plots.</p>
   <p> Its functionalities are presented in: </p>
   <p>
   <ul>
    <li>a <a href=https://nakala.fr/10.34847/nkl.3fdd6h8j target=_blank>video </a> tutorial</li>
    <li>and papers: 
<p> -Royer, A., E. Discamps, S. Plutniak, M. Thomas. (2023). 'SEAHORS: Spatial Exploration of ArcHaeological Objects in R Shiny'. <a href=https://archaeo.peercommunityin.org/articles/rec?id=320 target=_blank> <i>PCI Archaeology</i> </a>, DOI: <a href=https://doi.org/10.5281/zenodo.7674698 target=_blank>10.5281/zenodo.7674698</a>.</li> </p>
<p> -Royer, A., E. Discamps, S. Plutniak, M. Thomas. (2023). 'SEAHORS: Spatial Exploration of ArcHaeological Objects in R Shiny'. <a href=https://peercommunityjournal.org/articles/10.24072/pcjournal.289/ target=_blank> <i>Peer Community Journal</i> </a>, DOI: <a href=10.24072/pcjournal.289 target=_blank>10.24072/pcjournal.289</a>.</li>  </p>
</ul>
  </p>
   <p>This is an open and free software, 
   <ul>
      <li>it is available as an R package on the <a href=https://cran.r-project.org/package=SEAHORS target=_blank>CRAN</a>, and</li>
      <li> its source code is published on a <a href=https://github.com/AurelienRoyer/SEAHORS/ target=_blank>github repository</a>.</li>
    </ul>
    </p>
    <br>
    <p>Try <i>SEAHORS</i> now with the <a href=https://hal.science/hal-02190243 target=_blank>Cassenade</a> Paleolithic site dataset:</p>
    </span> 
    </font>" ))
    ), 
                               actionButton("button_example", 
                                            "Click to load the Cassenade dataset", style="height:50%"),
    br(), br(),
                               HTML("<p style = 'color:blue;'> <i>ENJOY IT !</i></color> </p> </div>"),
                                      ), #end of column
                             ) # end div()
                          #    column(12, column(2, HTML(
                          #      "  <div style=height:50%;, align=left> 
                          # <font size=2>
                          # <p>Try <i>SEAHORS</i> with the <a href=https://hal.science/hal-02190243 target=_blank>Cassenade</a> Paleolithic site dataset:</p>
                          # </font size>
                          # </div>"),#end html
                          #      actionButton("button_example","Click to load the Cassenade dataset",style="height:50%")),
                          #      tags$br(),
                               # tags$br(),),
                             
                    ), #end of tabPanel
                    tabPanel("Load data", 
                             tabsetPanel(type = "tabs",
                                         tabPanel(tags$h5("Import xyz data"), 
                                                  tags$br(),
                                                  tags$br(),
                                                  tags$hr(),
                                                  tags$h4(style = "color: red;","Loading file"), 
                                                  #fluidRow(
                                                  #   column(10,
                                                  #                 tags$h4(style = "color: red;","Options for loading file"), 
                                                  #                 checkboxInput("header", "Header", TRUE),
                                                  #                 checkboxInput("set.dec", "Check this option to automatically correct for the presence of comma in decimal numbers", TRUE),
                                                  #                 numericInput("digit.number", "To control the number of significant digit", 11, min = 1, step=1, max=30, width="50%"),
                                                  #                 
                                                  #                        tags$hr(),
                                                  # ),#endcolumn
                                                  #),#end of fluidrow  
                                                  fluidRow(column(9,
                                                                  fileInput("file1", "Choose File (.csv/.xls/.xlsx)",
                                                                            multiple = TRUE,
                                                                            accept = c("text/csv",
                                                                                       "text/comma-separated-values",
                                                                                       ".csv",
                                                                                       ".xlsx",".xls")),
                                                                  selectInput(inputId = "worksheet", label="Worksheet Name", choices =''),
                                                                  actionButton(inputId = "getData",label="Get Data"),
                                                                  actionButton('reset.BDD', 'Reset Input')
                                                  ),
                                                  column(3,
                                                         shinyWidgets::actionBttn(
                                                           inputId = "chr_setting",
                                                           label = "Options for loading file",
                                                           style = "unite",
                                                           color = "danger",
                                                           icon = icon("fas fa-cogs",lib = "font-awesome")
                                                         ),
                                                         tags$style("#bsmodal_param .modal-dialog{ width:1200px} 
                                                                .modal-backdrop {
                                                                                    display: none;
                                                                                    z-index: 1040 !important;
                                                                                }
                                                                                
                                                                                .modal-content {
                                                                                    margin: 2px auto;
                                                                                    z-index: 1100 !important;
                                                                                }
                                                                                
                                                                                "),
                                                         
                                                         bsModal(
                                                           id = "bsmodal_param",
                                                           title = tags$h4(style = "color: red;","Options for loading file"),
                                                           trigger = "chr_setting",size = "large",
                                                           
                                                           
                                                           checkboxInput("header", "Header", TRUE),
                                                           checkboxInput("set.dec", "Check this option to automatically correct for the presence of comma in decimal numbers", TRUE),
                                                         
                                                         
                                                           numericInput("digit.number", "To control the number of significant digit", 11, min = 1, step=1, max=30)
                                                     
                                                         ),)
                                                  
                                                  
                                                  ),
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
                                                  downloadButton("downloadData_redata", "Download")
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
                                                         br(),
                                                         downloadButton("downloadData_rawdata", "Download raw table"),
                                                         br(),br(),
                                                        DTOutput("table")
                                                    # column(10,)
                                                        ))
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
                                         tabPanel(tags$h5("archeoViz exports"), 
                                                  fluidRow(
                                                    column(10, 
                                                           br(),
                                                           HTML("Like <i>SEAHORS</i>, <a href=https://analytics.huma-num.fr/archeoviz/en target=_blank><i>archeoViz </i> </a>  is a web application to visualise spatial archaeological data. In addition, <i>archeoViz </i> allows to edit and communicate spatial datasets as <a href=https://analytics.huma-num.fr/archeoviz/home/ target=_blank>static web applications</a>.</p>
                                                                <p> Interoperability between archaeological software matters. So, here, you can:
                                                                 </p>"),
                                                           br(),
                                                           downloadLink("download.archeoviz", "* Export your data in archeoViz format (CSV)"),
                                                           br(),
                                                           br(),
                                                           uiOutput("run.archeoviz")
                                                    ))
                                         ),#end tabpanel
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
                               ),),
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
                                         tabPanel(tags$h5("Simple 2D plot"),
                                                  fluidRow(tags$br(),
                                                           htmlOutput("nb2.2"),
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
                                                    column(12,
                                                           column(2,numericInput("ratio.to.coord.simple", label = h5("Ratio figure"), value = 1),),
                                                           column(2),
                                                    ),
                                                  ),
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
                                                    column(7,
                                                           shinyWidgets::actionBttn(
                                                             inputId = "chr_settingbp",
                                                             label = "Bar plot display",
                                                             style = "unite",
                                                             color = "danger",
                                                             icon = icon("fas fa-chart-column",lib = "font-awesome")
                                                           ),
                                                           ),
                                                    radioButtons("var.ortho", "include ortho",
                                                                 choices = c(no = "no",
                                                                             yes = "yes"),
                                                                 selected = "no", inline=TRUE),  
                                                    tags$br(),
                                                    radioButtons("var.fit.table", "Include refits",
                                                                 choices = c(no = "no",
                                                                             yes = "yes"),
                                                                 selected = "no", inline=TRUE),
                                                    column(2),
                                                    column(6,downloadButton("downloadData2D", "Download as .HTML")), ),
                                                  
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
                                         
                                            
                             ), #end tabset panel
                    ), #end tabPanel
                    
                    tabPanel("2D slice",
                             tags$br(),
                             htmlOutput("nb3"),
                             column(12,
                                    column(6,radioButtons("var.2d.slice", "section",
                                                          choices = c(#xy = "xy",
                                                            #yx = "yx",
                                                            yz = "yz",
                                                            xz = "xz"),
                                                          selected = "yz", inline=TRUE),
                                           tags$br(),),
                                    column(2),
                                    column(3,checkboxInput("advanced.slice",label="Advanced plot", value=FALSE)),
                             ),
                             
                             column(12, numericInput("step2dslice", HTML("Thickness of slices <br> (lower this parameter to get more slices)"), 4, min = 0.1, max=10,step = 1, width="50%")),
                             column(12, uiOutput("range.2d.slice")),
                             
                             
                             fluidRow(
                               tags$br(),
                               tags$br(),
                               tags$br(),
                               tags$br(),
                               column(12,
                                      uiOutput("plot.2dslide")),
                               tags$br(),      
                             ),# end of fluidrow
                             hr(style = "border-top: 1px solid #000000;"), 
                             fluidRow(column(12,
                                             column(2, uiOutput("ratiotocoorsimple2"),),
                                            # column(12, downloadButton("downloadData2d.slice", "Download as .HTML")),
                                             tags$br(),
                                             column(12, uiOutput("download.slice.output")),
                             ),),#end of fluidrow
                             
                    ),#end tabPanel 2D slice
                    
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
                             fluidRow(
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
                                             column(5, downloadButton("downloadDatadensity", "Download as .pdf")),
                                             column(2,numericInput("ratio.to.coord", label = h5("Ratio figure"), value = 1),),
                             ),
                             tags$hr(),
                             column(12,
                                    column(6,radioButtons("var.ortho2", "Include ortho",
                                                          choices = c(no = "no",
                                                                      yes = "yes"),
                                                          selected = "no", inline=TRUE),),
                                    tags$hr(),
                                    
                             ),
                             
                             column(12,
                                    column(4, radioButtons("var.plotlyg.lines", "include density lines",
                                                           choices = c(no = "no",
                                                                       yes = "yes"),selected = "no"),),
                                    
                                    column(4,radioButtons("var.density.curves", "include density curves",
                                                          choices = c(no = "no",
                                                                      yes = "yes"),selected = "no"),),),
                             column(4, sliderInput("alpha.density", "Point transparency",  min = 0, max=1, value=1, width="50%"),),
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
                                                                                          ".csv")), ),
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
                                                  ),
                                                  br(),
                                                  hr(),
                                                #  br(),
                                                #  tags$h4("To save the settings as .csv"),
                                                #  fluidRow(
                                                #    column(7, downloadButton("export.settings", "Export settings as csv document")),
                                                #    br(),
                                                #    hr(),
                                                #    br(),),
                                                #  br(), 
                                                #  tags$h4("To load settings"),
                                                  fluidRow(
                                               #     column(7, fileInput("file.color.set", "Choose File to import settings (.csv)",
                                               #               multiple = TRUE,
                                               #               accept = c("text/csv",
                                                 #                        "text/comma-separated-values,text/plain",
                                                 #                        ".csv")),
                                                     
                                                  #  actionButton("go.load.settings", "load it"))
                                                    )
                                         ), #end tabpanel
                                         
                             ),#end tabsetpanel temp
                    ), # end of tabpanel
        ) #end tabset panel
      ) #end main panel
      ,fluid=FALSE) #sidebarLayout  
  )#endfluidPage
) #end navbarPage
) #end  shinyUI
}
