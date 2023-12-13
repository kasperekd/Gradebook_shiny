source("upload.R")
library(readxl)
library(DataEditR)

editing = function()
{
  rt = list(
    fluidRow(
      
        actionButton("addButton", "Добавить"),
        actionButton("addButton", "Добавить"),
      
        DT::dataTableOutput("table")
    )
  )
  return(rt)
}

selected = NULL

editing_server = function(input, output, session)
{
  data <- reactiveVal(NULL)
  
  observeEvent(input$selectButton, {
    fileList <- list.files("./uploaded_files", pattern="\\.(csv|txt|xlsx)$", full.names = FALSE)
    if (length(fileList) == 0) {
      showNotification("Список файлов пуст", type = "warning")
    } else {
      if (!is.null(input$fileSelection)) 
      {
        readTable(input, output, session, data)
      }
    }
  })
  
  observeEvent(input$addButton, {
    showModal(
      modalDialog(
        textInput("surname", "Фамилия"),
        textInput("name", "Имя"),
        textInput("patronymic", "Отчество"),
        textInput("class", "Класс"),
        textInput("informatics", "Информатика"),
        textInput("physics", "Физика"),
        textInput("mathematics", "Математика"),
        textInput("literature", "Литература"),
        textInput("music", "Музыка"),
        footer = tagList(
          actionButton("addStudent", "Добавить"),
          modalButton("Отмена")
        )
      )
    )
  })
  
  observeEvent(input$addStudent, {
    cols <- colnames(data())
    newStudent <- data.frame(
      name = paste(input$name, input$surname, input$patronymic, sep = " "),
      class = input$class,
      informatics = as.character(input$informatics),
      physics = as.character(input$physics),
      mathematics = as.character(input$mathematics),
      literature = as.character(input$literature),
      music = as.character(input$music)
    )
    if (is.null(data())) {
      data(data.frame(newStudent))
    } 
    else {
      common <- intersect(colnames(data()), colnames(newStudent))
      data<- rbind(data()[common], newStudent[common])
      data(data)
    }
    removeModal()
  })
  
  readTable = function(input, output, session, data)
  {
    selected <- paste0("./uploaded_files/", input$fileSelection) 
    if (tools::file_ext(selected) %in% c("txt", "csv")) {
      df <- readr::read_delim(selected, delim = ';', locale = readr::locale(encoding = input$encoding), show_col_types = FALSE)
    } else if (tools::file_ext(selected) == "xlsx") {
      df <- readxl::read_xlsx(selected)
    }
    data(df)
  }
  
  output$table <- DT::renderDataTable({
    if (!is.null(data()))
    {
      DT::datatable(data(), options = list(columnDefs = list(list(orderable = TRUE, targets = 0))))
    }
  })
}