source("upload.R")
library(readxl)
library(DataEditR)
library(readr)
library(openxlsx)

editing <- function()
{
  rt <- list(
    fluidRow(
      actionButton("addButton", "Добавить"),
      downloadButton("downloadButton", "Скачать измененный файл"),
      actionButton("saveButton", "Сохранить изменения"),
      # dataFilterUI("edit-1"),
      dataEditUI("edit_1")
      #data_edit(dataEditUI("edit-1"))
    )
  )
  return(rt)
}

selected <- NULL
dataT <- reactiveVal(NULL)

editing_server <- function(input, output, session)
{
  #dataT <- reactiveVal(NULL)

  observeEvent(input$selectButton, {
    tryCatch({
      fileList <- list.files("./uploaded_files", pattern="\\.(csv|txt|xlsx)$", full.names = FALSE)
      if (length(fileList) == 0) {
        showNotification("Список файлов пуст", type = "warning")
      } else {
        if (!is.null(input$fileSelection)) 
        {
          readTable(input, output, session, dataT)
        }
      }
    }, error = function(e) {
      dataT(NULL)
      print("Ошибка при открытии файла")
    })
  })
  
  output$downloadButton <- downloadHandler(
      filename = function() {
        paste("edited_file", tools::file_ext(input$fileSelection), sep = ".")
      },
      content = function(file) {
        if (!is.null(dataT())) {
          edited_data <- data_edit()  
          if (tools::file_ext(input$fileSelection) %in% c("txt", "csv")) {
            write.table(edited_data, file, sep = ";", row.names = FALSE, col.names = TRUE, quote = FALSE) 
            #write.table(edited_data, file, sep = ";", row.names = FALSE, col.names = TRUE, quote = FALSE, fileEncoding = as.character(guess_encoding(selected)[1, "encoding"]))  # Сохранение измененных данных в файл
          } else if (tools::file_ext(input$fileSelection) == "xlsx") {
            openxlsx::write.xlsx(edited_data, file.path("./uploaded_files", file_name))
          }
          #showNotification("Файл скачен", type = "message")
        }else
        {
          showNotification("Файл не выбран", type = "warning")
        }
      }
  )
  
  observeEvent(input$saveButton, {
    #if (!is.null(input$fileSelection)) {
    if (!is.null(dataT())) {
      showNotification("Изменения сохранены", type = "message")
      edited_data <- data_edit() 
      file_name <- basename(input$fileSelection)
      if (tools::file_ext(file_name) %in% c("txt", "csv")) {
        write.table(edited_data, file.path("./uploaded_files", file_name), sep = ";", row.names = FALSE, col.names = TRUE, quote = FALSE)
      } else if (tools::file_ext(file_name) == "xlsx") {
        openxlsx::write.xlsx(edited_data, file.path("./uploaded_files", file_name))
        #write.xlsx(edited_data, file.path("./uploaded_files", file_name), row.names = FALSE)  # Сохранение измененных данных в файл
      }
    } else
    {
      showNotification("Файл не выбран", type = "warning")
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
        numericInput("mathemathics", "Математика", 0),
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
      mathemathics = input$mathemathics,
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
  
  readTable <- function(input, output, session, dataT)
  {
    selected <- paste0("./uploaded_files/", input$fileSelection)
    if (file.info(selected)$size == 0) {
      showNotification("Загруженный файл пуст", type = "warning")
      header_data <- data.frame(name = character(), class = character(), informatics = numeric(), physics = numeric(), mathemathics = numeric(), literature = numeric(), music = numeric())
      dataT(header_data)
    } else {
      if (tools::file_ext(selected) %in% c("txt", "csv")) {
        tryCatch({
          df <- readr::read_delim(selected, delim = ';', locale = readr::locale(encoding = as.character(guess_encoding(selected)[1, "encoding"])), show_col_types = FALSE)
        }, error = function(e) {
          showNotification("Ошибка при чтении файла", type = "error")
        })
        if (!all(c("name", "class", "informatics", "physics", "mathemathics", "literature", "music") %in% colnames(df))) {
          showNotification("Заголовки в файле не соответствуют ожидаемым", type = "warning")
          header_data <- data.frame(name = character(), class = character(), informatics = numeric(), physics = numeric(), mathemathics = numeric(), literature = numeric(), music = numeric())
          dataT(header_data)
        } else {
          dataT(df)
        }
      } else if (tools::file_ext(selected) == "xlsx") {
        tryCatch({
          df <- readxl::read_xlsx(selected)
        }, error = function(e) {
          showNotification("Ошибка при чтении файла", type = "error")
        })
        if (!all(c("name", "class", "informatics", "physics", "mathemathics", "literature", "music") %in% colnames(df))) {
          showNotification("Заголовки в файле не соответствуют ожидаемым", type = "warning")
          header_data <- data.frame(name = character(), class = character(), informatics = numeric(), physics = numeric(), mathemathics = numeric(), literature = numeric(), music = numeric())
          dataT(header_data)
        } else {
          dataT(df)
        }
      }
    }
  }
  
    data_to_edit <- reactive({ dataT() })  
    data_edit <- dataEditServer("edit_1", data = data_to_edit)
    
    # observe({
    #   req(input$classSelect)
    #   data_to_edit <- reactive({ dataT() })  
    #   data_edit <- dataEditServer("edit_1", data = data_to_edit)
    # })

}