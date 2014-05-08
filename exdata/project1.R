downloadFiles<-function(
    dataURL="https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
){
    if(!file.exists("./data/household_power_consumption.txt")){
    dir.create("./data")
    temp <-tempfile()
    download.file(dataURL, temp, method="curl")
    unzip(temp,exdir="./data/")
    ## rename dir-name ""UCI HAR Dataset" to "UCI_HAR_Dataset"
    # mv UCI\ HAR\ Dataset/ UCI_HAR_Dataset
    # file.rename("UCI HAR Dataset", "UCI_HAR_Dataset")
    unlink(temp)
  }else{
    message("data already downloaded.")
  }
}
readDataOld <- function(){
    fname="./data//household_power_consumption.txt"
    data <- read.table(fname, nrows=100, header=TRUE,sep=";")
    classes <- sapply(data, class)
    #classes[names(classes) %in% c("Date")] <- "Date"

    data <- read.table(fname, sep=";",header=TRUE,colClasses=classes, nrows=-1L)
    #data$Date <- as.Date(data$Date, "%d/%m/%Y")

    selectedDays =  as.Date(c("2007-02-01","2007-02-02"))
    #data <- read.table("./data//household_power_consumption.txt", sep=";", colClasses=classes, head=TRUE,subset=(Date %in% selectedDays))
    data[data$Date %in% selectedDays,1:2]

    nskip=60*24*2
    hpc <- read.table(fname,skip = 66636, nrow = 2880, sep = ";", header=TRUE,col.names = classes)
}
####################################
# The dataset has 2,075,259 rows and 9 columns.
# We will only be using data from the dates 2007-02-01 and 2007-02-02.
readData <- function(){
    library(sqldf)
    mySql <- "SELECT * from file where Date='1/2/2007' OR Date ='2/2/2007'"
    hpc <- read.csv2.sql(fname, mySql)
    #hpc$Date <- as.Date(hpc$Date, "%d%m%Y") # convert date format

    hpc$newT<-strptime(paste(hpc$Date, hpc$Time),"%d/%m/%Y %H:%M:%S")
    hpc
}

## Download file and read-into
downloadFiles()
hpc <- readData()

## plot1 Globale active power histogram
plot1 <- function(){
    #plot1
    png("plot1.png")
    hpc$Global_active_power <- as.numeric(hpc$Global_active_power)
    hist(hpc$Global_active_power,col="red",xlab="Global Active Power (kilowatts)", ylab="Frequency", main="Global Active Power")
    dev.off()
}

### plot2
plot2 <- function(){
    
    ### plot2
    png("plot2.png")
    #plot(hpc$newT, hpc$Global_active_power,type="l")
    plot(hpc$newT, hpc$Global_active_power,type="l", ylab="Global Active Power (kilowatts)", xlab="")
    dev.off()
}

### plot3 
plot3 <- function(){    
    
    png("plot3.png")
    plot(hpc$newT,hpc$Sub_metering_1, type="l",xlab="", ylab="Energy sub metering");
    lines(hpc$newT, hpc$Sub_metering_2, col="red",lwd=2);
    lines(hpc$newT, hpc$Sub_metering_3, col="blue",lwd=2);
    legend("topright", pch=2, col=c("black", "red", "blue"), legend=c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))
    dev.off()
}

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