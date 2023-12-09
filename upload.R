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
             actionButton("selectButton", "Выбрать"),
             #textOutput("output$text1"),
             mainPanel(textOutput("fileSelected"))
      )
    )
  )
  return(rt)
}

#assign(selFILE1, NULL, envir = .GlobalEnv)

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
  #session$set("file_selected", input$fileSelection)
  #output$text1 <- renderText({paste("You have selected", input$fileSelection)})
  #selFILE <- paste0("./uploaded_files/")
  selFILE1 = "./uploaded_files/example (1)(3) — копия.csv"
  
  observeEvent(input$selectButton, {
    fileList <- list.files("./uploaded_files", pattern="\\.(csv|txt|xlsx)$", full.names = FALSE)
    if (length(fileList) == 0) {
      showNotification("Список файлов пуст", type = "warning")
    } else {
      if (!is.null(input$fileSelection)) 
      {
        
        output$fileSelected <- renderText({paste0("./uploaded_files/", input$fileSelection)})
        #selFILE <- paste0("./uploaded_files/", input$fileSelection)
        assign(selFILE1, paste0("./uploaded_files/", input$fileSelection)) 
        #session$set("file_selected", output$fileSelection)
        # output$fileSelected = renderText(paste0("./uploaded_files/",fileToSelect, collapse = NULL))  
        # print(class(input$fileSelection))
        # print(input$fileSelection)
         #print(output$text1)
        
        #print(class(input$files))
      }
    }
  })
  
  
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
  
  return(selFILE1)
}