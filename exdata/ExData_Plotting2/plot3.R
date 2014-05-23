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
# 3. Of the four types of sources indicated by the type (point, nonpoint, onroad, nonroad) variable,
#    which of these four sources have seen decreases in emissions from 1999–2008 for Baltimore City?
#Which have seen increases in emissions from 1999–2008? Use the ggplot2 plotting system to make a plot answer this question.
#
library(ggplot2)
#NEI_B_yt <- tapply(NEI_Baltimore$Emissions, list(NEI_Baltimore$year, NEI_Baltimore$type), sum)
NEI_B_yt <- aggregate(Emissions~year+type, NEI_Baltimore, sum)

png("plot3.png")
qplot(year,Emissions,  data=NEI_B_yt, geom=c("point","smooth"),method="lm",col=type)
dev.off()

# increase POINT, 
#plot(NEI_B_yt[,1],type="b", xaxt="n")
#axis(1,at=1:4,labels = rownames(NEI_Baltimore), col.axis="blue",las=0)
#lines(as.numeric(c(1:4)),NEI_B_yt[,2], col="blue",lwd=2)
#lines(as.numeric(c(1:4)),NEI_B_yt[,3], col="blue",lwd=2)
#lines(as.numeric(c(1:4)),NEI_B_yt[,4], col="blue",lwd=2)

#qplot(year, Emissions, data=NEIby, color = type, geom="line")
#plot(NEI$year, NEI$Emission)

