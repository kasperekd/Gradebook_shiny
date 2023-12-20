source("sources.R")
source("server.R")

# rm(list = ls(all.names = TRUE))
# gc()

shinyApp(ui = ui, server = server)
