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
# 1. Have total emissions from PM2.5 decreased in the United States from 1999 to 2008?
#
plot(tapply(NEI$Emissions, NEI$year, sum), type="l", xlab="year", ylab="Emissions",main="PM2.5 in the Baltimore City")

#
# 2. Have total emissions from PM2.5 decreased in the Baltimore City, Maryland (fips == "24510") from 1999 to 2008?
#
NEIb  <- NEI[NEI$fips=="24510",]

plot(tapply(NEIb$Emissions, NEIb$year, sum), type="l", xlab="year", ylab="Emissions",main="PM2.5 in the Baltimore City")

#
# 3. Of the four types of sources indicated by the type (point, nonpoint, onroad, nonroad) variable,
#    which of these four sources have seen decreases in emissions from 1999–2008 for Baltimore City?
#Which have seen increases in emissions from 1999–2008? Use the ggplot2 plotting system to make a plot answer this question.
#
library(ggplot2)
#NEIby <- aggregate(NEIb$Emissions, by=list(NEIb$year, NEIb$type), sum)
NEIby <- tapply(NEIb$Emissions, list(NEIb$year, NEIb$type), sum)
NEIby
#qplot(year, Emissions, data=NEIby, color = type, geom="line")
#plot(NEI$year, NEI$Emission)



# 4. Across the United States, how have emissions from coal combustion-related sources changed from 1999–2008?

# 5. How have emissions from motor vehicle sources changed from 1999–2008 in Baltimore City?

# 6. Compare emissions from motor vehicle sources in Baltimore City with emissions from motor vehicle sources in Los Angeles County,
# California (fips == "06037"). Which city has seen greater changes over time in motor vehicle emissions?
