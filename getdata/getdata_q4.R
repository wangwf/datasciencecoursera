##question 1
url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv"
filename = "Fss06hid.csv"
## describing the variable name
##https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FPUMSDataDict06.pdf

if(!file.exists(filename)){
  download.file(url, destfile=filename, method="curl")
}

data <- read.csv(filename)


strsplit(names(data[123]),"wgtp")

####

url3_1 <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FGDP.csv"
filename31 <- "GDP.csv"
if(!file.exists(filename31)){
  download.file(url3_1, destfile=filename31, method="curl")
}
gdp<-read.csv(filename31)

d<-as.character(gdp[5:194,5])
d<- as.numeric(gsub(",","",d))
mean(d)

##Q3
countryNames <- as.character(gdp[4:195,]$X.2)

##Q4
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
d<-as.character(mergedata[,13])
length(grep("^Fiscal year end: June*",d))


