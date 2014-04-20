url<-"https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv" 

if(!file.exists('./Cpp/R')){dir.create("./Cpp/R")}
download.file(url,destfile="./Fss06hid.csv",method="curl")

list.files('./')
out<-read.csv("Fss06hid.csv")
sum(out$VAL==24, na.rm=TRUE)

#Q3
#outtable<-read.table("Fss06hid.csv")
# library(xlsx) 
url3="https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FDATA.gov_NGAP.xlsx"
download.file(url3,destfile='./gov_NGAP.xlsx',method='curl')
colIndex <- 7:15
rowIndex <- 18:23
dat<-read.xlsx('./gov_NGAP.xlsx',sheetIndex=1,colIndex=colIndex, rowIndex=rowIndex,header=TRUE)
dat
sum(dat$Zip*dat$Ext, na.rm=T)

#Q4
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
download.file(url5,destfile='./Fss06pid.csv',method='curl')
DT<-data.table("Fss06pid.csv")

bench<-microbenchmark(DT[,mean(pwgtp15),by=SEX],
                      tapply(DT$pwgtp15,DT$SEX,mean),
                      sapply(split(DT$pwgtp15,DT$SEX),mean), 
                      mean(DT[DT$SEX==2,]$pwgtp15))
print(bench, order="median")
