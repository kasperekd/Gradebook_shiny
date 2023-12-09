#TODO sort bu number

source("upload.R")

statTable = function()
{
  rt = list(
    #mainPanel(textOutput("fileSelected")),
    DT::dataTableOutput("table")
  )
  #print(selFILE1)
  return(rt)
}

statTable_server = function(input, output, session, selected)
{
  
  # file_selected <- reactive({
  #   session$clientData$output_fileSelected
  # })
   #print(selFILE)
  
  data <- reactive({
    req(selected)

    df <- readr::read_delim(selected ,delim = ';', locale = readr::locale(encoding = input$encoding),show_col_types = FALSE)
    return(df)
  })

  output$table <- DT::renderDataTable({
    if (!is.null(selected))
    {
      df <- data()
      #print(typeof(df$columnDefs))
      #df$colname <- as.numeric(as.character(df$colname))
      DT::datatable(df, options = list(columnDefs = list(list(orderable = TRUE, targets = 0))))
      #datatable$colnames = as.numeric(datatable$colnames)
    }
  })

}
# statTable_server = function(input, output)
# {
#   data <- reactive({
#     #req(input$files)
# 
#     df <- readr::read_delim(output$fileSelected,delim = ';', locale = readr::locale(encoding = input$encoding),show_col_types = FALSE)
#     return(df)
#   })
# 
#   output$table <- DT::renderDataTable({
#     if (!is.null(output$fileSelected))
#     {
#       df <- data()
#       #print(typeof(df$columnDefs))
#       #df$colname <- as.numeric(as.character(df$colname))
#       DT::datatable(df, options = list(columnDefs = list(list(orderable = TRUE, targets = 0))))
#       #datatable$colnames = as.numeric(datatable$colnames)
#     }
#   })
# 
# }