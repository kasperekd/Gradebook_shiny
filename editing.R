source("upload.R")
library(readxl)
library(DataEditR)

editing <- function()
{
  rt <- list(
    fluidRow(
      actionButton("addButton", "Добавить"),
      dataOutputUI("output-1"),
      dataEditUI("edit-1")
    )
  )
  return(rt)
}

selected <- NULL

editing_server <- function(input, output, session)
{
  dataT <- reactiveVal(NULL)
  
  observeEvent(input$selectButton, {
    fileList <- list.files("./uploaded_files", pattern="\\.(csv|txt|xlsx)$", full.names = FALSE)
    if (length(fileList) == 0) {
      showNotification("Список файлов пуст", type = "warning")
    } else {
      if (!is.null(input$fileSelection)) 
      {
        readTable(input, output, session, dataT)
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
        numericInput("informatics", "Информатика", 0),
        numericInput("physics", "Физика", 0),
        numericInput("mathematics", "Математика", 0),
        numericInput("literature", "Литература", 0),
        numericInput("music", "Музыка", 0),
        footer = tagList(
          actionButton("addStudent", "Добавить"),
          modalButton("Отмена")
        )
      )
    )
  })
  
  observeEvent(input$addStudent, {
    cols <- colnames(dataT())
    newStudent <- data.frame(
      name = paste(input$surname, input$name, input$patronymic, sep = " "),
      class = input$class,
      informatics = input$informatics,
      physics = input$physics,
      mathematics = input$mathematics,
      literature = input$literature,
      music = input$music
    )
    if (is.null(dataT())) {
      dataT(data.frame(newStudent))
    } 
    else {
      common <- intersect(colnames(dataT()), colnames(newStudent))
      dataT <- rbind(dataT()[common], newStudent[common])
      dataT(dataT)
    }
    removeModal()
  })
  
  readTable <- function(input, output, session, data)
  {
    selected <- paste0("./uploaded_files/", input$fileSelection) 
    if (tools::file_ext(selected) %in% c("txt", "csv")) {
      df <- readr::read_delim(selected, delim = ';', locale = readr::locale(encoding = input$encoding), show_col_types = FALSE)
    } else if (tools::file_ext(selected) == "xlsx") {
      df <- readxl::read_xlsx(selected)
    }
    dataT(df)
  }
  
  data_to_edit <- reactive({ dataT() })  # Assign the existing table dataT to data_to_edit
  data_edit <- dataEditServer("edit-1", data = data_to_edit)
  dataOutputServer("output-1", data = data_edit)
  
}