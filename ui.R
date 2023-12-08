#source("about.R")

source("sources.R")

ui <- fluidPage(
  
  # Заголовок приложения
  titlePanel("Журнал"),
  
  # Вкладки
  tabsetPanel(
    tabPanel("Загрузка оценок", 
             upload(),
             uiOutput("fileList")
    ),
    tabPanel("Создание/Редактирование журнала и сохранение",
             editing()
    ),
    tabPanel("Статистика (Таблица)", 
             #statTable()
             DT::dataTableOutput("table")
             # tableOutput("table")
    ),
    tabPanel("Статистика (График)", 
             statGraph()
    ),
    tabPanel("Помощь", 
             help_P()
    ),
    tabPanel("О программе", 
             sliderInput("scale", "Масштаб", min = 1, max = 10, value = 5),
             plotOutput("zoom_plot")
    )
  )
)