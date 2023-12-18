source("sources.R")
source("server.R")

# rsconnect::setAccountInfo(name='vgkkpy-kasperekd',
#                           token='0E0B8B797652EAC34409EA0F0093CE14',
#                           secret='awYIut0Uo4jyEJs0Ek0g+MWuUFCWULuEVGHt4UIs')

rm(list = ls(all.names = TRUE))
gc()

# Run the application 
shinyApp(ui = ui, server = server)
