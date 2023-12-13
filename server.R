source("libs.R")
source("sources.R")

source("ui.R")
server <- function(input, output, session) 
{
  upload_server(input, output, session)
  editing_server(input, output, session)
  #statTable_server(input, output, session)
  
  
  # output$table <- renderTable({
  #   req(input$file1)
  #   df <- read.csv(input$file1$datapath, sep = ';',fileEncoding = "UTF-8")
  #   df
  # })
  
  
  about_server(input, output)
}