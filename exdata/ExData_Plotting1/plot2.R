

## Download file and read-into
source("./readData.R")
downloadFiles()
hpc <- readData()


### plot2: Global active power versus time
plot2 <- function(){

    ### plot2
    png("plot2.png")
    #plot(hpc$newT, hpc$Global_active_power,type="l")
    plot(hpc$newT, hpc$Global_active_power,type="l", ylab="Global Active Power (kilowatts)", xlab="")
    dev.off()
}

plot2()