#source("about.R")
library(shinythemes)

source("sources.R")
ui <- fluidPage(   
  column(width = 1),
  column(width = 10,
    tags$img(height = 64, width = 64, src="logoS.png"),
    navbarPage(
      "Журнал",
      tabPanel("Загрузка оценок", 
               upload()#,
               #uiOutput("fileList")
      ),
      tabPanel("Создание/Редактирование журнала",
               editing()
      ),
      tabPanel("Статистика (Таблица)", 
               statTable()
               #DT::dataTableOutput("table")
               # tableOutput("table")
      ),
      tabPanel("Статистика (График)", 
               statGraph()
      ),
      tabPanel("Помощь", 
               help_P()
      ),
      tabPanel("О программе",
               about()
      )
    )
  ),
  column(width = 1), theme = shinytheme("flatly")
)