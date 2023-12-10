upload = function()
{
  rt = list(
    fluidRow(
      column(width = 4,
             fileInput("files", "Загрузка фалов", multiple = TRUE, accept = c('.csv', '.txt', '.xlsx')),
             selectInput("encoding", "Кодировка:", choices = c("Windows-1251", "UTF-8"))
      ),
      column(width = 4,align = "right",
             tableOutput("fileTable")
      ),
      column(width = 4, align = "left",
             selectInput("fileSelection", "Выбор файла", choices = NULL),
             actionButton("deleteButton", "Удалить"),
             actionButton("selectButton", "Выбрать")
      )
    )
  )
  return(rt)
}

getSelected = function(input, output)
{
  if (!is.null(textOutput("fileSelected"))) 
  {
    return(textOutput("fileSelected"))
  }
  return(NULL)
}

upload_server = function(input, output, session)
{
  observeEvent(input$files, {
    if (!is.null(input$files)) {
      if (!dir.exists("./uploaded_files")) {
        dir.create("./uploaded_files")
      }
      for (i in 1:length(input$files$datapath)) {
        file_name <- basename(input$files$name[i])
        new_file_path <- file.path("./uploaded_files", file_name)
        file.copy(input$files$datapath[i], new_file_path)
      }
      updateFilesList()
      updateFilesTable()
    }
  })
  
  updateFilesList <- function() {
    fileList <- list.files("./uploaded_files", pattern="\\.(csv|txt|xlsx)$", full.names = FALSE)
    updateSelectInput(session, "fileSelection", choices = fileList)
  }
  updateFilesTable <- function() {
    fileList <- list.files("./uploaded_files", pattern="\\.(csv|txt|xlsx)$", full.names = FALSE)
    output$fileTable <- renderTable({
      data.frame(Файлы = fileList, check.names = FALSE)
    })
  }
  
  
  updateFilesList()
  updateFilesTable()
  
  observeEvent(input$deleteButton, {
    fileList <- list.files("./uploaded_files", pattern="\\.(csv|txt|xlsx)$", full.names = FALSE)
    if (length(fileList) == 0) {
      showNotification("Список файлов пуст", type = "warning")
    } else {
      fileToRemove <- input$fileSelection
      if (!is.null(fileToRemove)) {
        confirmDelete <- shiny::modalDialog(
          title = "Подтверждение",
          footer = tagList(
            actionButton("deleteConfirmed", "Да"),
            modalButton("Нет")
          ),
          size = "m",
          "Вы уверены, что хотите удалить файл ", fileToRemove, "?"
        )
        showModal(confirmDelete)
      }
    }
  })
  
  observeEvent(input$deleteConfirmed, {
    fileToRemove <- file.path("./uploaded_files", input$fileSelection)
    file.remove(fileToRemove)
    updateFilesList()
    updateFilesTable()
    removeModal()
  })
}