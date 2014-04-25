

##question 1
'''
The American Community Survey distributes downloadable data about United States communities.
Download the 2006 microdata survey about housing for the state of Idaho using download.file() from here
'''
url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv"
filename = "ss06hid.csv"
## describing the variable name
##https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FPUMSDataDict06.pdf

if(!file.exists(filename)){
  download.file(url, destfile=filename, method="curl")
}

data <- read.csv(filename)
## How many housing units in this survey were worth more than $1,000,000
nrow(data[which(data$VAL>=24),]) #53

##the households on greater than 10 acres who sold more than $10,000 worth of agriculture products
data[which(data$ACR==3 & data$AGS==6),]
head(data[which(data$ACR==3 & data$AGS==6),][,1:12])

##Q2
# The variable FES in the code book. Which of the "tidy data" principles does this variable violate?
#Tidy data has one variable per column.


##Q3
library(xlsx)
'''
Download the Excel spreadsheet on Natural Gas Aquisition Program here: 
  https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FDATA.gov_NGAP.xlsx 
Read rows 18-23 and columns 7-15 into R and assign the result to a variable called:  dat 
What is the value of:  sum(dat$Zip*dat$Ext,na.rm=T) 
'''
data <- read.xlsx("https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FDATA.gov_NGAP.xlsx")
head(data)
dat <- data[18:23, 7:15]
sum(dat$Zip*dat$Ext,na.rm=T)

##Q4
library(XML)
url4="https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Frestaurants.xml"
download.file(url4,destfile='./restaurants.xml',method='curl')
doc <- xmlTreeParse("./restaurants.xml",useInternal=TRUE)
rootNode <-xmlRoot(doc)
xmlName(rootNode)
xpathSApply(rootNode,"//zipcode",xmlValue)
length(x[x=="21231"])
#n=0; for(i in 1:1327){if(x[i]=="21231"){n=n+1} }; n


#Q5
url5="https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06pid.csv"
download.file(url5,destfile='./ss06pid.csv',method='curl')
DT<-data.table("Fss06pid.csv")

bench<-microbenchmark(DT[,mean(pwgtp15),by=SEX],
                      tapply(DT$pwgtp15,DT$SEX,mean),
                      sapply(split(DT$pwgtp15,DT$SEX),mean), 
                      mean(DT[DT$SEX==2,]$pwgtp15))
print(bench, order="median")

