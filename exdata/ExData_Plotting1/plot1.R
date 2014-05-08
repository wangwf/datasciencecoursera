

## Download file and read-into
source("./readData.R")
downloadFiles()
hpc <- readData()

## plot1 Globale active power histogram, save it to plot1.png
plot1 <- function(){
    #plot1
    png("plot1.png")
    hpc$Global_active_power <- as.numeric(hpc$Global_active_power)
    hist(hpc$Global_active_power,col="red",xlab="Global Active Power (kilowatts)", ylab="Frequency", main="Global Active Power")
    dev.off()
}

plot1()