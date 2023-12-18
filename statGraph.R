library(ggplot2)
source("statTable.R")

statGraph = function()
{
  rt <- list(
    fluidRow(
      fluidRow(
        column(6, uiOutput("plotContainer")),  
        column(6, plotOutput("subjectPlot"))   
      )
    )
  )
  return(rt)
}

statGraph_server = function(input, output, session)
{
  observeEvent(input$selectButton, {
    output$plotContainer <- renderUI({
      class_plots <- statGraphClass(dataT())
      plot_output_list <- lapply(seq_along(class_plots), function(i) {
        plotOutput(paste0("plot", i))
      })
      fluidRow(plot_output_list)
    })
    
    class_plots <- NULL
    observe({
      class_plots <- statGraphClass(dataT())
      lapply(seq_along(class_plots), function(i) {
        output[[paste0("plot", i)]] <- renderPlot({
          class_plots[[i]]
        })
      })
    })
    
    output$subjectPlot <- renderPlot({
      subject_stats <- calculateSubjectStats(dataT())
      ggplot(subject_stats, aes(x = subject, y = `Средняя оценка`)) + geom_bar(stat = "identity") + labs(title = "Средняя оценка по предметам")
    })
  })
}

statGraphClass = function(data) {
  class_stats <- calculateClassStats(data)
  
  class_plots <- lapply(unique(class_stats$class), function(class_name) {
    class_data <- subset(class_stats, class == class_name)
    plot <- ggplot(class_data, aes(x = Предмет, y = `Среднее`)) + geom_bar(stat = "identity") + labs(title = paste("Среднее по классу", class_name))
    return(plot)
  })
  
  return(class_plots)
}