source("sources.R")
source("server.R")

# Run the application 
shinyApp(ui = ui, server = server)

# rm(list = ls(all.names = TRUE))
# gc()