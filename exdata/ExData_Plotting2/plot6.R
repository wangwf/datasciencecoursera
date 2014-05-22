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


# 6. Compare emissions from motor vehicle sources in Baltimore City with emissions from motor vehicle sources in Los Angeles County,
# California (fips == "06037"). Which city has seen greater changes over time in motor vehicle emissions?
png("plot6.png")
NEI_onRoad <- NEI[((NEI$fips=="24510"| NEI$fips=="06037") & NEI$type=="ON-ROAD"),]
NEI_onRoad_y <-aggregate(Emissions ~year+fips, NEI_onRoad, sum)
NEI_onRoad_y$fips <- as.factor(NEI_onRoad_y$fips)

qplot(year,Emissions,  data=NEI_onRoad_y, geom=c("point","smooth"),method="lm",col=fips)
dev.off()

