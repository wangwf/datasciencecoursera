
#Time Series Analysis
#
# Time Series Decomposition
# Time series decomposition is to decompose a time series
# into trend, seasonal, cyclical and irregular components

timeSerie <- function(){
    data(AirPassengers)
    f<-decompose(AirPassengers)

    str(f)
    # seasonal figures
    f$figure
    plot(f$figure, type="b", xaxt ="n", xlab ="")

    #get names of 12 months in English words
    monthNames <- months(ISOdate(2011,1:12,1))
    #lable x-axis with month names
    #las is set to 2 for vertical label orientation
    axis(1, at=1:12, labels =monthNames, las=2)

    plot(f)
}

timeSeriesForecasting <- function(){
    fit <- arima(AirPassengers, order=c(1,0,0), list(order=c(2,1,0), period=12))
    fore <- predict(fit, n.ahead=24)
    # error bounds at 95% confidence level
    U <- fore$pred + 2*fore$se
    L <- fore$pred - 2*fore$se
    ts.plot(AirPassengers, fore$pred, U, L, col=c(1,2,4,4), lty = c(1,1,2,2))
    legend("topleft", c("Actual", "Forcast", "Error Bounds (95% Confidence)"), col=c(1,2,4), lty=c(1,1,2))
   }