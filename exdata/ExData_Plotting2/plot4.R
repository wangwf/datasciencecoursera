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

