#
# Download data file, unzip
#
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

#
# loading data
readDataOld <- function(){
    fname="./data//household_power_consumption.txt"
    data <- read.table(fname, nrows=100, header=TRUE,sep=";")
    classes <- sapply(data, class)

    #
    data <- read.table(fname,skip = 66636, nrow = 2880, sep = ";", header=TRUE,col.names = classes)
}
#######################################################################
# The dataset has 2,075,259 rows and 9 columns.
# We will only be using data from the dates 2007-02-01 and 2007-02-02.
######################################################################
readData <- function(){
    library(sqldf)
    fname="./data//household_power_consumption.txt"
    mySql <- "SELECT * from file where Date='1/2/2007' OR Date ='2/2/2007'"
    hpc <- read.csv2.sql(fname, mySql)
    #hpc$Date <- as.Date(hpc$Date, "%d%m%Y") # convert date format

    hpc$newT<-strptime(paste(hpc$Date, hpc$Time),"%d/%m/%Y %H:%M:%S")
    hpc
}

## Download file and read-into
#downloadFiles()
#hpc <- readData()
