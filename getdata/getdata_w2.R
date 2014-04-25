library(RMySQL)

##Example -- UCSC database
# connect and listing databases
ucscDb <- dbConnect(MySQL(), user="genome",
                    host="genome-mysql.cse.ucsc.edu")
result <- dbGetQuery(ucscDb, "show database;"); dbDisconnect(ucscDb)
result

# connecting to hg19 and listing tables
hg19 <- dbConnect(MySQL(), user="genome", db="hg19",
                  host="genome-mysql.cse.ucsc.edu")
allTables <- dbListTables(hg19)
length(allTables)

# Get dimensions of a specific table
dbListFields(hg19, "affyU133Plus2")
dbGetQuery(hg19, "select count(*) from affyU133Plus2")

# read from the table
affyData <- dbReadTable(hg19, "affyU133Plus2")
head(affyData)

# Select a specific subset
query <-dbSendQuery(hg19, "select * from affyU133Plus2 where misMatches between 1 and 2")
affyMis <- fetch(query);
quantile(affyMis$misMatches)

affMisSmall <- fetch(query, n=10);
dbClearResult(query)

dim(affyMisSmall)

dbDisconnect(hg19)



#### HDF5, used for storing large data sets
source("http://bioconductor.org/biocLite.R")
library("rhdf5")
 
library(rhdf5)
created = h5createFile("example.h5")
created

created = h5createGroup("example.h5", "foo")
created = h5createGroup("example.h5", "baa")
created = h5createGroup("example.h5", "foo/foobaa")
h5ls("example.h5")

## Write to groups
A = matrix(1:10, nr =5, nc =2)
h5write(A, "example.h5", "foo/A")
B = array(seq(0.1, 2.0, by = 0.1), dim=c(5,2,2))
attr(B, "scale") <- "liter"
h5write(B, "example.h5", "foo/foobaa/B")
h5ls("example.h5")

## Write to a data set
df = data.frame(1L:5L, seq(0,1, length.out=5),
                c("ab", "cde", "fghi", "a","s"), stringsAsFactors = FALSE)
h5write(df, "example.h5","df")
h5ls("example.h5")

### Reading data
readA = h5read("example.h5", "foo/A")
readB = h5read("example.h5", "foo/foobaa/B")
readdf= h5read("example.h5", "df")
readA

# Writing and reading chunks
h5write(c(12, 13, 14), "example.h5", "foo/A", index = list(1:3,1))
h5read("example.h5", "foo/A")



### Reading data from the web
#### WEB api
## Getting data off webpages -- readLines()
con = url("http://scholar.google.com/citations?user=HI-I6C0AAAAJ")
htmlCode = readLines(con)
close(con)
htmlCode

## Parsing with XML
library(XML)
url <- "http://scholar.google.com/citations?user=HI-I6C0AAAAJ"
html <- htmlTreeParse(url, useInternalNodes=T)
xpathSApply(html, "//title", xmlValue)
xpathSApply(html, "//td[@id='col-citedby']", xmlValue)

## GET from the httr package
library(httr); html2 = GET(url)
content2 = content(html2, as ="text")
parsedHtml = htmlParse(content2, asText =TRUE)
xpathSApply(parsedHtml, "//title", xmlValue)

## Accessing websites with password
pg1 = GET("http://httpbin.org/basic-auth/user/passwd")
pg1
pg2 = GET("http://httpbin.org/basic-auth/user/passwd",
          authenticate("user", "passwd"))
pg2

names(pg2)

## Using handles
google = handle("http://google.com")
pg1 = GET(handle=google, path="/")
pg2 = GET(handle=google, path="search")


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
