
library(UsingR)
data(mtcars)
library(corrplot)
shinyServer(
    function(input, output) {
        output$mpgHist <- renderPlot({
            #plot(mpg~wt, data=mtcars)
            hist(mtcars$mpg, xlab='car MPG', col='lightblue',main='mtcars')
            mu <- input$mu
            lines(c(mu, mu), c(0, 20),col="red",lwd=5)
            mse <- mean((mtcars$mpg - mu)^2)
            text(13, 12, paste("mu = ", mu))
            text(13, 10, paste("MSE = ", round(mse, 2)))
        })
        output$corPlot <- renderPlot({
            corMat <- cor(mtcars)
            diag(corMat) <- 0  # remove diagnal elements
            maxCor <- max(abs(corMat))
            minCor <- min(corMat)
            
            corrplot(corMat, input$displayOpt, title="Correlation Matrix")
        })
        
    }
)
