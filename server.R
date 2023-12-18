source("libs.R")
source("sources.R")

source("ui.R")
server <- function(input, output, session) 
{
  upload_server(input, output, session)
  editing_server(input, output, session)

  statTable_server(input, output, session)
  statGraph_server(input, output, session)
  
  help_P_server(input, output)
  about_server(input, output)
}