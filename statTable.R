#TODO sort bu number

statTable = function()
{
  DT::dataTableOutput("table")
}

statTable_server = function(input, output)
{
  data <- reactive({
    req(input$files)  

    df <- readr::read_delim(input$files$datapath,delim = ';', locale = readr::locale(encoding = input$encoding),show_col_types = FALSE)
    return(df)
  })
  
  output$table <- DT::renderDataTable({
    if (!is.null(input$files)) 
    {
      df <- data()
      #print(typeof(df$columnDefs))
      #df$colname <- as.numeric(as.character(df$colname))
     DT::datatable(df, options = list(columnDefs = list(list(orderable = TRUE, targets = 0))))
      #datatable$colnames = as.numeric(datatable$colnames)
    }
  })
  
}