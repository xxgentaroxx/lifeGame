
# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)

shinyUI(fluidPage(

  # Application title
  titlePanel("Game of Life"),

  # Sidebar with a slider input for number of bins
  sidebarLayout(
    sidebarPanel(
      actionButton("nextgen", "Move 1 Time"),
      HTML("</br></br>"),
      actionButton("forever", "Move Forever"),
      HTML("</br></br>"),
      actionButton("stop", "Stop"),
      HTML("</br></br>"),
      actionButton("reset", "Reset")
    ),

    # Show a plot of the generated distribution
    mainPanel(
      plotOutput("distPlot", height = "600px", click=clickOpts(id="plot_click"))
    )
  )
))
