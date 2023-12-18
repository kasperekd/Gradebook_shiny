library(ggplot2)
# library(tidyverse)
library(fmsb)
source("statTable.R")

statGraph = function()
{
  rt <- list(
    selectInput("classSelect", "Выбор класса", choices = NULL),
    tags$hr(),
    fluidRow(
        column(6, uiOutput("plotContainer")),  
        column(6, uiOutput("plotContainerSubj"))   
    )
  )
  return(rt)
}

statGraph_server = function(input, output, session)
{
  observeEvent(input$selectButton, {
    class_stats <- calculateClassStats(dataT())
    subject_stats <- calculateSubjectStats(dataT())
    
    # class_plots <- classPlotsMean(class_stats)
    #mean subj
    subject_plotMean <- ggplot(subject_stats, aes(x = subject, y = `Средняя оценка`, fill = subject)) +
      geom_bar(stat = "identity") +
      labs(title = "Средняя оценка по предметам",
           x = "Предмет", y = "Средняя оценка") +
      theme_minimal()+
      ylim(0, 5)
    #median subj
    subject_plotMedian <- ggplot(subject_stats, aes(x = subject, y = `Медианная оценка`, fill = subject)) +
      geom_bar(stat = "identity") +
      labs(title = "Медианная оценка по предметам",
           x = "Предмет", y = "Медиана") +
      theme_minimal()+
      ylim(0, 5)
    #percent subj
    subject_PlotPercent <- subjectPlotPercent(subject_stats)
    
    output$subjectPlotMean <- renderPlot({
      subject_plotMean
    })
    output$subjectPlotMedian <- renderPlot({
      subject_plotMedian
    })
    output$subjectPlotPercent <- renderPlot({
      subject_PlotPercent
    })
    output$plotContainerSubj <- renderUI({
      fluidRow(
        plotOutput("subjectPlotMean"),
        plotOutput("subjectPlotMedian"),
        plotOutput("subjectPlotPercent")
      )
    })
    
    output$plotContainer <- renderUI({
      fluidRow(
        plotOutput("classPlotMean"),
        plotOutput("classPlotMedian"),
        plotOutput("classPlotPercent")
      )
    })
    
    updateSelectInput(session, "classSelect", choices = unique(class_stats$class))
  })
  
  observe({
    req(input$classSelect)
    class_stats <- calculateClassStats(dataT())
    # class_plots <- classPlotsMean(class_stats)
    # class_plotsMedian <- classPlotsMedian(class_stats)
    subject_stats <- calculateSubjectStats(dataT())
    
    selected_class <- input$classSelect
    class_data <- subset(class_stats, class == selected_class) 
    #mean class
    class_plotMean <- ggplot(class_data, aes(x = Предмет, y = `Среднее`, fill = Предмет)) +
      geom_bar(stat = "identity") +
      labs(title = paste("Средние оценки класса:", selected_class), 
           x = "Предмет", y = "Среднее") +
      theme_minimal()+
      ylim(0, 5)
    #median class
    class_plotMedian <- ggplot(class_data, aes(x = Предмет, y = `Медиана`, fill = Предмет)) +
      geom_bar(stat = "identity") +
      labs(title = "Медианная оценка", 
           x = "Предмет", y = "Медиана") +
      theme_minimal()+
      ylim(0, 5)
    
    class_plotPercent <- classPlotPercent(class_data)
    
    output$classPlotMean <- renderPlot({
      class_plotMean
    })
    output$classPlotMedian <- renderPlot({
      class_plotMedian
    })
    output$classPlotPercent <- renderPlot({
      class_plotPercent
    })
    
  })
}
subjectPlotPercent <- function(subject_stats) {
  subject_plot <- ggplot(subject_stats, aes(x = subject)) +
    geom_col(aes(y = `%1`, fill = "1"), position = "dodge", width = 0.9) +
    geom_col(aes(y = `%2`, fill = "2"), position = "dodge", width = 0.7) +
    geom_col(aes(y = `%3`, fill = "3"), position = "dodge", width = 0.5) +
    geom_col(aes(y = `%4`, fill = "4"), position = "dodge", width = 0.3) +
    geom_col(aes(y = `%5`, fill = "5"), position = "dodge", width = 0.1) +
    ylab("%") +
    xlab("Предмет") +
    ggtitle("Процент распределения оценок по предметам") +
    scale_fill_manual(values = c("red", "orange", "yellow", "green", "blue"),
                      name = "Оценка",
                      labels = c("1", "2", "3", "4", "5")) +
    theme_minimal()
  return(subject_plot)
}
classPlotPercent <- function(subject_stats) {
  subject_plot <- ggplot(subject_stats, aes(x = `Предмет`)) +
    geom_col(aes(y = `%1`, fill = "1"), position = "dodge", width = 0.9) +
    geom_col(aes(y = `%2`, fill = "2"), position = "dodge", width = 0.7) +
    geom_col(aes(y = `%3`, fill = "3"), position = "dodge", width = 0.5) +
    geom_col(aes(y = `%4`, fill = "4"), position = "dodge", width = 0.3) +
    geom_col(aes(y = `%5`, fill = "5"), position = "dodge", width = 0.1) +
    ylab("%") +
    xlab("Предмет") +
    ggtitle("Процент распределения оценок") +
    scale_fill_manual(values = c("red", "orange", "yellow", "green", "blue"),
                      name = "Оценка",
                      labels = c("1", "2", "3", "4", "5")) +
    theme_minimal()
  return(subject_plot)
}