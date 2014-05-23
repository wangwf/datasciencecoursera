downloadFiles<-function(
    dataURL="https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
){
    if(!file.exists("Source_Classification_Code.rds")){
    #    dir.create("./data")
        temp <-tempfile()
        download.file(dataURL, temp, method="curl")
        unzip(temp,exdir="./data/")
        unlink(temp)
    }else{
        message("data already downloaded.")
    }
}

NEI <- readRDS("./summarySCC_PM25.rds")
SCC <- readRDS("./Source_Classification_Code.rds")

#
# 1. Have total emissions from PM2.5 decreased in the United States from 1999 to 2008?
#
png("plot1.png")
NEI_by_year <- tapply(NEI$Emissions, NEI$year, sum)
plot(NEI_by_year, type="b", xlab="year", ylab="PM2.5 Emissions",main="PM2.5 in the Baltimore City",xaxt="n")
axis(1,at=1:4,labels = rownames(NEI_by_year), col.axis="blue",las=0)
dev.off()
