
##question 1
# The American Community Survey distributes downloadable data about United States communities.
# Download the 2006 microdata survey about housing for the state of Idaho using download.file() from here:   
#  https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv 
# and load the data into R. The code book, describing the variable names is here:   
#  https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FPUMSDataDict06.pdf 
# Create a logical vector that identifies the households on greater than 10 acres 
# who sold more than $10,000 worth of agriculture products. Assign that logical vector
# to the variable agricultureLogical. Apply the which() function like this to identify
# the rows of the data frame where the logical vector is TRUE. which(agricultureLogical)
# What are the first 3 values that result?
Q1 <- function(){
  url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv"
  filename = "ss06hid.csv"
  ## describing the variable name
  ##https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FPUMSDataDict06.pdf
  if(!file.exists(filename)){
    download.file(url, destfile=filename, method="curl")
  }

  data <- read.csv(filename)
  ##the households on greater than 10 acres who sold more than $10,000 worth of agriculture products
  data[which(data$ACR==3 & data$AGS==6),]
  head(data[which(data$ACR==3 & data$AGS==6),][,1:12])
}

### Q2
# Using the jpeg package read in the following picture of your instructor into R 
# https://d396qusza40orc.cloudfront.net/getdata%2Fjeff.jpg 
# Use the parameter native=TRUE. What are the 30th and 80th quantiles of the resulting data?
Q2 <- function(){
  library(jpeg)
  url2 <- "https://d396qusza40orc.cloudfront.net/getdata%2Fjeff.jpg"
  filename2 <- "jeff.jpg"
  if(!file.exists(filename2)){
    download.file(url2, destfile=filename2, method="curl")
  }
  data2<-readJPEG(filename2, native=TRUE)
  quantile(data2,c(0.30,0.80))

}

##### Question 3
# Load the Gross Domestic Product data for the 190 ranked countries in this data set:   
#  https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FGDP.csv 
# Load the educational data from this data set:   
#  https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FEDSTATS_Country.csv 
# Match the data based on the country shortcode. How many of the IDs match?
# Sort the data frame in descending order by GDP rank. What is the 13th country in the resulting data frame? 
#
# Original data sources: 
#  http://data.worldbank.org/data-catalog/GDP-ranking-table 
# http://data.worldbank.org/data-catalog/ed-stats

url3_1 <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FGDP.csv"
url3_2 <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FEDSTATS_Country.csv"
filename31 <- "GDP.csv"
filename32 <- "EDSTATS_Country.csv"
if(!file.exists(filename31)){
  download.file(url3_1, destfile=filename31, method="curl")
}
if(!file.exists(filename32)){
  download.file(url3_2, destfile=filename32, method="curl")
}
gdp<-read.csv(filename31)
ed <-read.csv(filename32)

#colnames(gdp)[1]="CountryCode"
colnames(gdp)<-c("CountryCode", "ranking",  "X.1", "name", "gdpData","X.4","X.5","X.6","X.7","X.8")
#gdp[,2] <-as.numeric(gdp[,2]); gdp[,5] <-as.numeric(gdp[,5])
gdp<-gdp[5:194,c(1,2,4,5)]

mergedata<-merge(gdp,ed,by="CountryCode",all=F)

nrow(mergedata)
mergedata[mergedata$ranking==13,1:4]

mergedata[,2] <- as.numeric(as.character(mergedata[,2]));
#mergedata[,4] <- as.integer(mergedata[,4])
#head(mergedata[order(as.numeric(as.character(mergedata$ranking)), decreasing=F),1:5],n=15)
head(mergedata[order(mergedata$ranking, decreasing=F=T),1:5],n=13)


# Q4
#mean(as.numeric(as.character(mergedata[mergedata$Income.Group == "High income: OECD",2])))
#mean(as.numeric(as.character(mergedata[mergedata$Income.Group == "High income: nonOECD",2])))
mean(mergedata[mergedata$Income.Group == "High income: OECD",2])
mean(mergedata[mergedata$Income.Group == "High income: nonOECD",2])

# Q5
table(mergedata[mergedata$ranking<39,]$Income.Group)
