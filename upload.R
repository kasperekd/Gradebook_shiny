upload = function()
{
  rt = list(
    fileInput("files", "Выберите файлы  .csv для загрузки", multiple = TRUE),
    selectInput("encoding", "Выберите кодировку:",
                choices = c("Windows-1251", "UTF-8")),
    actionButton("deleteButton", "Удалить выбранный файл")

  )
  return(rt)
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
    }
  })
  
  updateFilesList <- function() {
    fileList <- list.files("./uploaded_files", pattern="*.csv", full.names = FALSE)
    updateSelectInput(session, "fileSelection", choices = fileList)
  }
  
  output$fileList <- renderUI({
    updateFilesList()
    selectInput("fileSelection", "Выберите файл для удаления:", choices = NULL)
  })
  
  observeEvent(input$deleteButton, {
    fileList <- list.files("./uploaded_files", pattern="*.csv", full.names = FALSE)
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
    removeModal()
  })
}