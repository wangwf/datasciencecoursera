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


#
# 2. Have total emissions from PM2.5 decreased in the Baltimore City, Maryland (fips == "24510") from 1999 to 2008?
#

NEI_Baltimore <- NEI[NEI$fips=="24510",]
NEI_Baltimore_year <- tapply(NEI_Baltimore$Emissions, NEI_Baltimore$year, sum)

png("plot2.png")
plot(NEI_Baltimore, type="l", xlab="year", ylab="Emissions",main="PM2.5 in the Baltimore City",xaxt="n")
axis(1,at=1:4,labels = rownames(NEI_Baltimore_year), col.axis="blue",las=0)
dev.off()

