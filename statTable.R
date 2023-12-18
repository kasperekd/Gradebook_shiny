source("editing.R")
library(tidyr)
library(kableExtra)

statTable = function()
{
  rt <- list(
    fluidRow(
      column(width = 6, style="min-width: 49vw; max-width: 50vw;",
             h3("Статистика по классам"),
             tableOutput("classStatsTable")
      ),
      column(width = 6, style="min-width: 49vw; max-width: 50vw;",
             h3("Статистика по предметам"),
             tableOutput("subjectStatsTable")
      )
    )
  )
  return(rt)
}

statTable_server = function(input, output, session)
{
  
  observeEvent(input$selectButton, {
    data <- dataT()
    classStats <- calculateClassStats(data)
    subjectStats <- calculateSubjectStats(data)
    
    output$classStatsTable <- renderUI({
      class_tables <- lapply(unique(classStats$class), function(class_name) {
        class_data <- classStats[classStats$class == class_name, ]
        total_students <- class_data$count[1] 
        
        class_table <- paste("<h4>Класс:", class_name, "- Всего учеников:", total_students, "</h4>", kable(subset(class_data, select = -c(class, count)), "html") %>%
                               kable_styling(full_width = F))
        if (class_name != unique(classStats$class)[length(unique(classStats$class))]) {
          class_table <- paste(class_table, " ")  
        }
        return(class_table)
      })
      HTML(paste(class_tables, collapse = "\n"))
    })
    
    output$subjectStatsTable <- renderUI({
      subject_table <- paste("<h4>Всего учеников:", nrow(dataT()), "</h4>", kable(subjectStats, "html") %>%
                               kable_styling(full_width = F))
      HTML(subject_table)
    })
  })
}

calculateSubjectStats <- function(data) {
  data_df <- as.data.frame(data, stringsAsFactors = FALSE)
  
  subject_stats <- data_df %>%
    gather(subject, grade, -name, -class) %>%
    group_by(subject) %>%
    summarise(
      `Средняя оценка` = mean(as.numeric(grade), na.rm = TRUE),
      `Медианная оценка` = median(as.numeric(grade), na.rm = TRUE),
      `%1` = sum(grade == "1") / n() * 100,
      `%2` = sum(grade == "2") / n() * 100,
      `%3` = sum(grade == "3") / n() * 100,
      `%4` = sum(grade == "4") / n() * 100,
      `%5` = sum(grade == "5") / n() * 100
    )
  
  return(subject_stats)
}

calculateClassStats <- function(data) {
  data_df <- as.data.frame(data, stringsAsFactors = FALSE)
  
  stats <- data_df %>%
    gather(subject, grade, -name, -class) %>%
    group_by(class, subject) %>%
    summarise(
      `Среднее` = mean(as.numeric(grade), na.rm = TRUE),
      `Медиана` = median(as.numeric(grade), na.rm = TRUE),
      count = n(),
      `%1` = sum(grade == "1") / n() * 100,
      `%2` = sum(grade == "2") / n() * 100,
      `%3` = sum(grade == "3") / n() * 100,
      `%4` = sum(grade == "4") / n() * 100,
      `%5` = sum(grade == "5") / n() * 100,
      .groups = 'drop'
    ) 
  stats_renamed <- stats %>%
    rename(`Предмет` = subject)
  
  return(stats_renamed)
}