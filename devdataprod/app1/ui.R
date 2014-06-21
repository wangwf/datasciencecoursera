library(shiny)
shinyUI(pageWithSidebar(
    headerPanel("MPG "),
    sidebarPanel(
        helpText("mtcars dataset correlation matrix"),
       # sliderInput('mu', 'Guess at the mean MPG',value = 20, min = 10, max = 35, step = 0.1,),
        selectInput(inputId = "displayOpt",
                    label = "corrplot option:",
                    choices = c("circle","square","ellipse","number","col","pie"),
                    selected="circle")
        ),
    mainPanel(
     #   plotOutput('mpgHist')
        plotOutput('corPlot')
        
    )
))