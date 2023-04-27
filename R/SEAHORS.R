SEAHORS <- function(){
  shiny::addResourcePath('www', system.file('www', package = 'SEAHORS'))
  
  shinyApp(ui = app_ui, server = app_server)
}
