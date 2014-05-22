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
png("plot1.png")
NEI_by_year <- tapply(NEI$Emissions, NEI$year, sum)
plot(NEI_by_year, type="b", xlab="year", ylab="PM2.5 Emissions",main="PM2.5 in the Baltimore City",xaxt="n")
axis(1,at=1:4,labels = rownames(NEI_by_year), col.axis="blue",las=0)
dev.off()
#
# 2. Have total emissions from PM2.5 decreased in the Baltimore City, Maryland (fips == "24510") from 1999 to 2008?
#

NEI_Baltimore <- NEI[NEI$fips=="24510",]
NEI_Baltimore_year <- tapply(NEI_Baltimore$Emissions, NEI_Baltimore$year, sum)

png("plot2.png")
plot(NEI_Baltimore, type="l", xlab="year", ylab="Emissions",main="PM2.5 in the Baltimore City",xaxt="n")
axis(1,at=1:4,labels = rownames(NEI_Baltimore_year), col.axis="blue",las=0)
dev.off()

#
# 3. Of the four types of sources indicated by the type (point, nonpoint, onroad, nonroad) variable,
#    which of these four sources have seen decreases in emissions from 1999–2008 for Baltimore City?
#Which have seen increases in emissions from 1999–2008? Use the ggplot2 plotting system to make a plot answer this question.
#
library(ggplot2)
#NEI_B_yt <- tapply(NEI_Baltimore$Emissions, list(NEI_Baltimore$year, NEI_Baltimore$type), sum)
NEI_B_yt <- aggregate(Emissions~year+type, NEI_Baltimore, sum)

png("plot3.png")
qplot(year,Emissions,  data=NEI_B_yt, geom=c("point","smooth"),col=type)

# increase POINT, 
#plot(NEI_B_yt[,1],type="b", xaxt="n")
#axis(1,at=1:4,labels = rownames(NEI_Baltimore), col.axis="blue",las=0)
#lines(as.numeric(c(1:4)),NEI_B_yt[,2], col="blue",lwd=2)
#lines(as.numeric(c(1:4)),NEI_B_yt[,3], col="blue",lwd=2)
#lines(as.numeric(c(1:4)),NEI_B_yt[,4], col="blue",lwd=2)

#qplot(year, Emissions, data=NEIby, color = type, geom="line")
#plot(NEI$year, NEI$Emission)
dev.off()


# 4. Across the United States, how have emissions from coal combustion-related sources changed from 1999–2008?
png("plot4.png")
SCC_coal_comb <- SCC[grepl("coal", SCC$SCC.Level.Three, ignore.case=TRUE) |
                     grepl("Lignite", SCC$SCC.Level.Three, ignore.case=TRUE),]
NEI_coal <- NEI[NEI$SCC %in%SCC_coal_comb$SCC,]
NEI_coal_y <- aggregate(Emissions~ year, NEI_coal,sum)
plot(NEI_coal_y$Emissions/1e3~NEI_coal_y$year, type="b", xlab="year", ylab="PM2.5 Emissions (Kilo tons)",
     main="Emissions of PM2.5 per year of coal cumbustors -USA")


SCC_coal_comb <- SCC[
        grepl("combustion", SCC$SCC.Level.One, ignore.case=TRUE) &
      (grepl("coal", SCC$SCC.Level.Three, ignore.case=TRUE) |
      grepl("lignite", SCC$SCC.Level.Three, ignore.case=TRUE)), ]
dev.off()

# 5. How have emissions from motor vehicle sources changed from 1999–2008 in Baltimore City?
png("plot5.png")
NEI_Baltimore_onRoad <- NEI[(NEI$fips=="24510" & NEI$type=="ON-ROAD"),]
NEI_Baltimore_onRoad_year <- aggregate(Emissions~ year, NEI_Baltimore_onRoad,sum)
plot(NEI_Baltimore_onRoad_year$Emissions~NEI_Baltimore_onRoad_year$year,
     type="b", xlab="year", ylab="PM2.5 Emissions (Kilo tons)",
     main="Emissions of PM2.5 from motor vehicle source in Baltimore")

dev.off()

# 6. Compare emissions from motor vehicle sources in Baltimore City with emissions from motor vehicle sources in Los Angeles County,
# California (fips == "06037"). Which city has seen greater changes over time in motor vehicle emissions?
png("plot6.png")
NEI_onRoad <- NEI[((NEI$fips=="24510"| NEI$fips=="06037") & NEI$type=="ON-ROAD"),]
NEI_onRoad_y <-aggregate(Emissions ~year+fips, NEI_onRoad, sum)
NEI_onRoad_y$fips <- as.factor(NEI_onRoad_y$fips)

qplot(year,Emissions,  data=NEI_onRoad_y, geom=c("point","smooth"),method="lm",col=fips)
dev.off()

