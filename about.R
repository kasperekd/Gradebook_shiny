
about = function()
{
  #plotOutput("animation")
}

about_server = function(input, output)
{
  output$zoom_plot <- renderPlot({
    x <- seq(0, 10, length.out = 100)
    y <- sin(input$scale * x)
    
    p <- ggplot() +
      geom_line(aes(x, y)) +
      xlim(0, 10) +
      ylim(-10, 10)
    
    print(p)
  })
}