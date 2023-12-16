source("sources.R")
source("server.R")

rm(list = ls(all.names = TRUE))
gc()

# Run the application 
shinyApp(ui = ui, server = server)
