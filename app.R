#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

source("sources.R")

# Define UI for application that draws a histogram
# ui <- fluidPage(
# 
#     # Application title
#     titlePanel("Old Faithful Geyser Data"),
# 
#     # Sidebar with a slider input for number of bins
#     sidebarLayout(
#         sidebarPanel(
#             sliderInput("bins",
#                         "Number of bins:",
#                         min = 1,
#                         max = 50,
#                         value = 30)
#         ),
# 
#         # Show a plot of the generated distribution
#         mainPanel(
#            plotOutput("distPlot")
#         )
#     )
# )

ui <- fluidPage(
  
  # Заголовок приложения
  titlePanel("Управление оценками"),
  
  # Вкладки
  tabsetPanel(
    tabPanel("Загрузка оценок", 
             upload()
    ),
    tabPanel("Создание/Редактирование журнала и сохранение",
             editing()
    ),
    tabPanel("Статистика (Таблица)", 
             statTable()
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

# Define server logic required to draw a histogram
server <- function(input, output) {

    output$distPlot <- renderPlot({
        # generate bins based on input$bins from ui.R
        x    <- faithful[, 2]
        bins <- seq(min(x), max(x), length.out = input$bins + 1)

        # draw the histogram with the specified number of bins
        hist(x, breaks = bins, col = 'darkgray', border = 'white',
             xlab = 'Waiting time to next eruption (in mins)',
             main = 'Histogram of waiting times')
    })
}

# Run the application 
shinyApp(ui = ui, server = server)
