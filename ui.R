#source("about.R")

source("sources.R")

ui <- fluidPage(
  titlePanel("Журнал"),
  tabsetPanel(
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
)