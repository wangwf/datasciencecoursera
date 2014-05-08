

## Download file and read-into
source("./readData.R")
downloadFiles()
hpc <- readData()


### plot3, Energy sub metering
plot3 <- function(){

    png("plot3.png")
    plot(hpc$newT,hpc$Sub_metering_1, type="l",xlab="", ylab="Energy sub metering");
    lines(hpc$newT, hpc$Sub_metering_2, col="red",lwd=2);
    lines(hpc$newT, hpc$Sub_metering_3, col="blue",lwd=2);
    legend("topright", pch=2, col=c("black", "red", "blue"), legend=c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))
    dev.off()
}


plot3()
