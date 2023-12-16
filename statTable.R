source("editing.R")

statTable = function()
{
  rt <- list(
    fluidRow(
      tableOutput("classStatsTable"),
      br(),
      tableOutput("overallStatsTable")
    )
  )
  return(rt)
}

statTable_server = function(input, output, session)
{
  
  # observeEvent(input$selectButton, {
  #   output$out <- renderTable({
  #     data.frame(dataT(), check.names = FALSE)
  #   })
  # })
  # 
  
  
  observeEvent(input$selectButton, {
    data <- dataT()
    classStats <- calculateClassStats(data)
    overallStats <- calculateOverallStats(data)
    
    output$classStatsTable <- renderTable({
      classStats
    })
    
    output$overallStatsTable <- renderTable({
      overallStats
    })
  })
  
}

calculateClassStats = function(data) {
  classStats <- by(data, data$class, function(subdata) {
    stats <- sapply(subdata[, -c(1, 2)], function(x) {
      avg <- mean(x)
      med <- median(x)
      count <- length(x)
      percent <- mean(x > 50) * 100  # Assuming percentage of students with score > 50
      c(avg = avg, med = med, count = count, percent = percent)
    })
    stats <- t(stats)
    colnames(stats) <- c("Average", "Median", "Count", "Percent")
    stats <- format(stats, digits = 2, nsmall = 2)
    return(stats)
  })
  classStats <- do.call(rbind, classStats)
  classStats <- as.data.frame(classStats)
  return(classStats)
}

# Function to calculate statistics for all students across all classes for each subject
calculateOverallStats = function(data) {
  overallStats <- sapply(data[, -c(1, 2)], function(x) {
    avg <- mean(x)
    med <- median(x)
    count <- length(x)
    percent <- mean(x > 50) * 100  # Assuming percentage of students with score > 50
    c(avg = avg, med = med, count = count, percent = percent)
  })
  overallStats <- t(overallStats)
  colnames(overallStats) <- c("Average", "Median", "Count", "Percent")
  overallStats <- format(overallStats, digits = 2, nsmall = 2)
  overallStats <- as.data.frame(overallStats)
  return(overallStats)
}