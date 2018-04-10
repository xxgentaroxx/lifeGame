library(shiny)
library(ggplot2)
life <- matrix(data = FALSE, nrow = 50, ncol = 50)
life2 <- reshape2::melt(life)

lifenext <- function(life){
  lifenext <- life
  lifenext[1,] <- FALSE
  lifenext[50,] <- FALSE
  lifenext[,1] <- FALSE
  lifenext[,50] <- FALSE
  for(i in 2:49){
    for(j in 2:49){
      if(life[i,j]==FALSE){
        if(sum(life[i-1,j-1],life[i-1,j],life[i-1,j+1],
               life[i,  j-1],            life[i,  j+1],
               life[i+1,j-1],life[i+1,j],life[i+1,j+1])==3){
          lifenext[i,j] <- TRUE
        }
      } else {
        switch(sum(life[i-1,j-1],life[i-1,j],life[i-1,j+1],
                   life[i,  j-1],life[i,  j],life[i,  j+1],
                   life[i+1,j-1],life[i+1,j],life[i+1,j+1]),
               "1" = lifenext[i,j] <- FALSE,
               "2" = lifenext[i,j] <- FALSE,
               "3" = lifenext[i,j] <- TRUE,
               "4" = lifenext[i,j] <- TRUE,
               "5" = lifenext[i,j] <- FALSE,
               "6" = lifenext[i,j] <- FALSE,
               "7" = lifenext[i,j] <- FALSE,
               "8" = lifenext[i,j] <- FALSE,
               "9" = lifenext[i,j] <- FALSE
        )
      }
    }
  }
  life <<- lifenext
}

shinyServer(function(input, output, session) {
  
  timer <- reactiveTimer(500)
  forever <- FALSE
  
  observeEvent(input$forever, {
    if(forever==FALSE){
      updateActionButton(session, "forever", label="Stop")
      forever <<- TRUE
    }else{
      updateActionButton(session, "forever", label="Move Forever")
      forever <<- FALSE
    }
    })

  observe({
    timer()
    if(forever==TRUE){
      life <<- lifenext(life)
      }
    })
  
  observeEvent(input$nextgen,{
    life <<- lifenext(life)
  })
  
  observeEvent(input$reset,{
    life <<- matrix(data = FALSE, nrow = 50, ncol = 50)
  })

  output$distPlot <- renderPlot({
    input$nextgen
    input$reset
    input$forever
    forever
    if(forever==TRUE) timer()
    click.x <- round(as.numeric(input$plot_click$x-0.5))
    click.y <- round(as.numeric(input$plot_click$y-0.5))
    if(length(click.x)>0){
      if(click.x<1 | click.x>50) click.x <- 1:50
    }
    if(length(click.y)>0){
      if(click.y<1 | click.y>50) click.y <- 1:50
    }
    life[click.y,click.x] <<- !life[click.y,click.x]
    life2 <<- reshape2::melt(life)
    ghm <- ggplot(life2, aes(x = Var2, y = Var1, fill = value))
    ghm <- ghm + geom_tile() + guides(fill=FALSE) + coord_fixed(ratio=1) + labs(x=NULL,y=NULL)
    ghm
  })

})