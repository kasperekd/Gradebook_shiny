
about = function()
{
  rt = list(
    uiOutput("meImg"),
    tags$hr(),
    h3("Автор:"),
    h4("Ошлаков Константин"),
    h5("Группа ИА-232"),
    h5("Контактная информация:"),
    tags$a("kasperekd@mail.ru",href="mailto:kasperekd@mail.ru"),
    br(),
    actionButton("startPong", "|.|", style="opacity: 0;"),
    br(),
    tags$head(tags$script(src = "pong.js")),
    tags$head(tags$script('
      $(document).ready(function() {
        var canvasVisible = false;
        $("#startPong").click(function() {
          if (canvasVisible) {
            $("#gameCanvas").hide();
            canvasVisible = false;
          } else {
            $("#gameCanvas").show();
            canvasVisible = true;
          }
        });
      });
    ')),
    tags$canvas(id = "gameCanvas", width = 800, height = 400, style="display:none")
    #tags$canvas(id = "gameCanvas", width = 800, height = 400)

  )
  return(rt)
}

#flag = 0
about_server = function(input, output)
{
  output$meImg <- renderUI({
    tags$img(src = "itsme.jpg", width = 300, height = 300)
  })
  
  # outputOptions(output, "gameCanvas", suspendWhenHidden = FALSE)
  
  # observeEvent(input$startPong, {
  #   output$gameCanvas <- renderUI({
  #     tags$canvas(id = "gameCanvas", width = 800, height = 400)
  #   })
  # })
  
}