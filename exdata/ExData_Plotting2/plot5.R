downloadFiles<-function(
    dataURL="https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
){
    if(!file.exists("./data/Source_Classification_Code.rds")){
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

NEI <- readRDS("./data//summarySCC_PM25.rds")
SCC <- readRDS("./data/Source_Classification_Code.rds")


# 5. How have emissions from motor vehicle sources changed from 1999–2008 in Baltimore City?
png("plot5.png")
NEI_Baltimore_onRoad <- NEI[(NEI$fips=="24510" & NEI$type=="ON-ROAD"),]
NEI_Baltimore_onRoad_year <- aggregate(Emissions~ year, NEI_Baltimore_onRoad,sum)
plot(NEI_Baltimore_onRoad_year$Emissions~NEI_Baltimore_onRoad_year$year,
     type="b", xlab="year", ylab="PM2.5 Emissions (Kilo tons)",
     main="Emissions of PM2.5 from motor vehicle source in Baltimore")

dev.off()

