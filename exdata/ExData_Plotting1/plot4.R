
## Download file and read-into
source("./readData.R")
downloadFiles()
hpc <- readData()

### plot4
plot4 <- function(){
    png("plot4.png")
    par(mfrow=c(2,2))
    with(hpc,{
        plot(hpc$newT, hpc$Global_active_power,type="l", ylab="Global Active Power (kilowatts)", xlab="")

        plot(newT,Voltage, type="l")

        plot(newT,Sub_metering_1, type="l",xlab="", ylab="Energy sub metering");
        lines(newT, Sub_metering_2, col="red",lwd=2);
        lines(newT, Sub_metering_3, col="blue",lwd=2);
        legend("topright", pch=2, col=c("black", "red", "blue"), legend=c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))

        plot(newT,Global_reactive_power, type="l")

    })
    dev.off()
    par(mfrow=c(1,1))
}

plot4()
