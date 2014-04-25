#### MySQL ####
library(RMySQL)

## connecting and listing databases
ucscDB<-dbConnect(MySQL(), user="genome",host="genome-mysql.cse.ucsc.edu")
result<-dbGetQuery(ucscDB,"show databases;"); dbDisconnect(ucscDB)
result

##connecting to hg19 and listing tables
hg19<-dbConnect(MySQL(), user="genome",db="hg19",host="genome-mysql.cse.ucsc.edu")
allTables<-dbListTables(hg19)
length(allTables)

##Get dimmensions of a specific table
dbListFields(hg19, "affyU133Plus2")
dbGetQuery(hg19,"select count(*) from affyU133Plus2")

##read from the table
affyData <-dbReadTable(hg19,"affyU133Plus2")
head(affyData)

##select a specific subset
query<-dbSendQuery(hg19, "select * from affyU133Plus2 where misMatches between 1 and 3")
affyMis <- fetch(query); quantile(affyMis$misMatches)

affyMisSmall<-fetch(query, n=10); dbClearResult(query);
dim(affyMisSmall)

dbDisconnect(hg19)


#### READ from HDF5 ####
#
source("http://bioconductor.org/biocLite.R")
biocLite("rhdf5")

library(rhdf5)
created = h5createFile("example.h5")
created

created = h5createGroup("example.h5","foo")
created = h5createGroup("example.h5","baa")
created = h5createGroup("example.h5","foo/foobaa")
h5ls("example.h5")

#Write to groups
A = matrix(1:10, nr=5, nc=2)
h5write(A, "example.h5","foo/A")
B = array(seq(0.1,2.0, by=0.1),dim=c(5,2,2))
attr(B,"scale")<-"Liter"
h5write(B,"example.h5","foo/foobaa/B")
h5ls("example.h5")

## reading data
readA = h5read("example.h5","foo/A")
readB = h5read("example.h5","foo/foobaa/B")
readdf= h5read("example.h5","df")
readA

## writing/reading chunks
h5write(c(12,13,14),"example.h5","foo/A",index=list(1:3,1))
h5read("example.h5","foo/A")


#### reading data from the web ####
## webscraping
con = url("http://scholar.google.com/citations?user=HI-I6C0AAAAJ")

htmlCode = readLines(con)
close(con)
htmlCode

library(XML)
url <- "http://scholar.google.com/citations?user=HI-I6C0AAAAJ")
html <- htmlTreeParse(url, useInternalNodes=T)

xpathSApply(html, "//title",xmlValue)
xpathSApply(html,"//td[@id='col-citedby']",xmlValue)


library(httr); html2 = GET(url)
content2 = content(html2, as="text")
parsedHtml = htmlParse(content2, asText=TRUE)
xpathSApply(parsedHtml, "//title", xmlValue)

pg1 = GET("http://httpbin.org/basic-auth/user/passwd",authenticate("user","passwd"))
pg1

##using handles
google = handle("http://google.com")
pg1 = GET(handle=google,path="/")
pg2 = GET(handle=google,path="search")



#### Twitter API ####
myapp = oauth_app("twitter",
                  key="LZMG9RxP4hFiDowxYMQ",
                  secret="Ap8NNB1lEJLb03s25k7QK6HhfiEcnHcOaebn6mpXo0")
sig = sign_oauth1.0(myapp,
                    token="369198012-s0YaD6OjfXhKK5yYAdB8JfJkyrMrOMqPSYeh38Kq",
                    token_secret="rpITlQtCH409EOzKyc0as0HbBLqFuRJoqwIBmPr9P4")

homeTL=GET("https://api.twitter.com/1.1/statuses/home_timeline.json",sig)


json1 = content(homeTL)
json2 = jsonLite::fromJSON(toJSON(json1))
json2[1,1:4]



##Q2
acs<-read.csv("getdata/ss06pid.csv")
sqldf("select pwgtp1 from acs where AGEP < 50")
## Q3  unique(acs$AGEP)
sqldf("select distinct AGEP from acs ")

## Q4
con = url("http://biostat.jhsph.edu/~jleek/contact.html")
htmlCode = readLines(con)
close(con)
#htmlCode
nchar(htmlCode[c(10,20,30,100)])

## Q5
con<-url("https://d396qusza40orc.cloudfront.net/wksst8110.for")
htmlCode = readLines(con)
close(con)
#htmlCode
nchar(htmlCode[c(10,20,30,100)])

##

data<-read.fwf("getdata/getdata%2Fwksst8110.for",widths=c(-1,9,-5,4,4,-5,4,4,-5,4,4,-5,4,4),skip=4)
sum(data[4])
