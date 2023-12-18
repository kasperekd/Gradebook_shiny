library(ggplot2)
source("statTable.R")

statGraph = function()
{
  rt <- list(
    selectInput("classSelect", "Выбор класса", choices = NULL),
    br(),
    fluidRow(
        column(6, uiOutput("plotContainer")),  
        column(6, plotOutput("subjectPlot"))   
    )
  )
  return(rt)
}

statGraph_server = function(input, output, session)
{
  observeEvent(input$selectButton, {
    class_stats <- calculateClassStats(dataT())
    subject_stats <- calculateSubjectStats(dataT())
    
    class_plots <- classPlots(class_stats)
    subject_plot <- subjectPlot(subject_stats)
    
    output$plotContainer <- renderUI({
      plot_output_list <- lapply(seq_along(class_plots), function(i) {
        plotOutput(paste0("plot", i))
      })
      plot_output_list
    })
    
    output$subjectPlot <- renderPlot({
      subject_plot
    })
    
    lapply(seq_along(class_plots), function(i) {
      output[[paste0("plot", i)]] <- renderPlot({
        class_plots[[i]]
      })
    })
    
    updateSelectInput(session, "classSelect", choices = unique(class_stats$class))
  })
  
  observe({
    req(input$classSelect)
    class_stats <- calculateClassStats(dataT())
    class_plots <- classPlots(class_stats)
    subject_stats <- calculateSubjectStats(dataT())
    
    selected_class <- input$classSelect
    class_index <- match(selected_class, unique(class_stats$class))
    
    output$subjectPlot <- renderPlot({
      subjectPlot(subject_stats)
    })
    
    lapply(seq_along(class_plots), function(i) {
      output[[paste0("plot", i)]] <- renderPlot({
        if (i == class_index) {
          class_plots[[i]]
        } else {
          NULL
        }
      })
    })
  })

}

classPlots = function(class_stats) {
  class_plots <- lapply(unique(class_stats$class), function(class_name) {
    class_data <- subset(class_stats, class == class_name)
    plot <- ggplot(class_data, aes(x = Предмет, y = `Среднее`, fill = Предмет)) +
      geom_bar(stat = "identity") +
      labs(title = paste("Среднее по классу", class_name), 
           x = "Предмет", y = "Среднее") +
      theme_minimal()
    return(plot)
  })
  return(class_plots)
}

subjectPlot = function(subject_stats) {
  subject_plot <- ggplot(subject_stats, aes(x = subject, y = `Средняя оценка`, fill = subject)) +
    geom_bar(stat = "identity") +
    labs(title = "Средняя оценка по предметам",
         x = "Предмет", y = "Средняя оценка") +
    theme_minimal()
  return(subject_plot)
}

# statGraphCalc = function(data) {
#   subject_stats <- calculateSubjectStats(data)
#   class_stats <- calculateClassStats(data)
#   
#   class_plots <- lapply(unique(class_stats$class), function(class_name) {
#     class_data <- subset(class_stats, class == class_name)
#     plot <- ggplot(class_data, aes(x = Предмет, y = `Среднее`, fill = Предмет)) +
#       geom_bar(stat = "identity") +
#       labs(title = paste("Среднее по классу", class_name), 
#            x = "Предмет", y = "Среднее") +
#       theme_minimal()
#     return(plot)
#   })
#   
#   subject_plot <- ggplot(subject_stats, aes(x = subject, y = `Средняя оценка`, fill = subject)) +
#     geom_bar(stat = "identity") +
#     labs(title = "Средняя оценка по предметам",
#          x = "Предмет", y = "Средняя оценка") +
#     theme_minimal()
#   
#   return(list(class_plots, subject_plot))
# }


# statGraphCalc = function(data) {
#   subject_stats <- calculateSubjectStats(data)
#   class_stats <- calculateClassStats(data)
#   
#   class_plots <- lapply(unique(class_stats$class), function(class_name) {
#     class_data <- subset(class_stats, class == class_name)
#     plot <- ggplot(class_data, aes(x = Предмет, y = `Среднее`, fill = Предмет)) +
#       geom_bar(stat = "identity") +
#       labs(title = paste("Среднее по классу", class_name)) +
#       theme_minimal() +
#       theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
#       guides(fill=guide_legend(title="Предмет")) +
#       scale_fill_brewer(palette="Set3") +
#       theme(legend.position="bottom") +
#       theme(legend.direction="horizontal") +
#       theme(legend.key.size = unit(8, "pt"),
#             plot.title = element_text(size = 14, face = "bold"))
#     return(plot)
#   })
#   
#   subject_plot <- ggplot(subject_stats, aes(x = subject, y = `Средняя оценка`, fill = subject)) +
#     geom_bar(stat = "identity") +
#     labs(title = "Средняя оценка по предметам") +
#     theme_minimal() +
#     theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
#     guides(fill=guide_legend(title="Предмет")) +
#     scale_fill_brewer(palette="Set3") +
#     theme(legend.position="bottom") +
#     theme(legend.direction="horizontal") +
#     theme(legend.key.size = unit(8, "pt"),
#           plot.title = element_text(size = 14, face = "bold"))
#   
#   return(list(class_plots, subject_plot))
# }