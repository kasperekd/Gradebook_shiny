source("upload.R")

editing = function()
{
  rt = list(
    DT::dataTableOutput("table")
  )
  return(rt)
}

selected = NULL
editing_server = function(input, output, session)
{
  observeEvent(input$selectButton, {
    fileList <- list.files("./uploaded_files", pattern="\\.(csv|txt|xlsx)$", full.names = FALSE)
    if (length(fileList) == 0) {
      showNotification("Список файлов пуст", type = "warning")
    } else {
      if (!is.null(input$fileSelection)) 
      {
        selected <- paste0("./uploaded_files/", input$fileSelection)
        print(selected)
        data <- readr::read_delim(selected ,delim = ';', locale = readr::locale(encoding = input$encoding),show_col_types = FALSE)
        output$table <- DT::renderDataTable({
          if (!is.null(selected))
          {
            df <- data
            DT::datatable(df, options = list(columnDefs = list(list(orderable = TRUE, targets = 0))))
          }
        })
      }
    }
  })
}