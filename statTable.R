source("editing.R")
library(tidyr)
library(kableExtra)

statTable = function()
{
  rt <- list(
    fluidRow(
      column(width = 6,
        h3("Статистика по классам"),
        tableOutput("classStatsTable")
      ),
      column(width = 6,
        h3("Статистика учеников"),
        tableOutput("studentStatsTable")
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
    
    output$classStatsTable <- renderUI({
      class_tables <- lapply(unique(classStats$class), function(class_name) {
        class_data <- classStats[classStats$class == class_name, ]
        total_students <- class_data$count[1]  # Используем значение count для каждого класса
        
        class_table <- paste("<h4>Класс:", class_name, "- Всего учеников:", total_students, "</h4>", kable(subset(class_data, select = -c(class, count)), "html") %>%
                               kable_styling(full_width = F))
        if (class_name != unique(classStats$class)[length(unique(classStats$class))]) {
          class_table <- paste(class_table, " ")  # Add a horizontal line after each class table
        }
        return(class_table)
      })
      HTML(paste(class_tables, collapse = "\n"))
    })
  })
}

calculateClassStats <- function(data) {
  # Преобразование входных данных в удобный формат
  data_df <- as.data.frame(data, stringsAsFactors = FALSE)
  
  # Расчет статистики для каждого класса и предмета
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
      `%5` = sum(grade == "5") / n() * 100
    ) #%>%
    #mutate(class = ifelse(row_number() == 1, class, ""))  # Insert class name every 5 rows
  
  stats_renamed <- stats %>%
    rename(`Предмет` = subject)
  
  return(stats_renamed)
}
