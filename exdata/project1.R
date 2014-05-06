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

data <- read.table("./data//household_power_consumption.txt", nrow=100, sep=";")
classes <- lapply(data, class)
data <- read.table("./data//household_power_consumption.txt", sep=";", colClasses=classes)
