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

