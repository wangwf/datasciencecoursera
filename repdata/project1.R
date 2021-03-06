downloadFiles<-function(
    dataURL="https://d396qusza40orc.cloudfront.net/repdata%2Fdata%2Factivity.zip"

){
    if(!file.exists("./data/activity.csv")){
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

readData <- function(){
    d <- read.csv("data/activity.csv")
    hist(d[!is.na(d$steps),]$steps)
    
    dsteps <- d[!is.na(d$steps),]$steps
    summary(dsteps)
    mean(d[!is.na(d$steps),]$steps)
    median(d[!is.na(d$steps),]$steps)
    
    plot(d$interval, d$steps, type="l")
    
    summary(d$steps)
    nrow(d[is.na(d$steps),])
}

