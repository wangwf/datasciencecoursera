fileUrl <- "https://data.baltimorecity.gov/api/views/dz54-2aru/rows.csv?accessType=DOWNLOAD"
download.file(fileUrl, destfile="cameras.csv",method="curl")

cameraData <-read.csv("./cameras.csv")
names(cameraData)

#tolower(names(cameraData))

## splitting variable names
splitNames <- strsplit(names(cameraData), "\\.")

## Quick aside --lists
mylist <-list(letters <- c("A","b", "c"), numbers =1:3)
head(mylist)

#Fixing character vectors -- sapply()
splitNames[[6]][1]
firstElement <- function(x){x[1]}
sapply(splitNames, firstElement)

## Peer review Data

sub("_", "", names(reviews))
testName <- "this_is_a_test"
sub("_", "", testNames)
gsub("_","", testNames)

##Finding values --grep(), grepl()
grep("Alameda", cameraData$intersection)

table(grepl("Alameda", cameraData$intersection))

cameraData[grepl("Alameda", cameraData$intersection),]
cameraData[!grepl("Alameda", cameraData$intersection),]

length(grep("Alameda", cameraData$intersection))


## more useful string functions
library(stringr)
nchar("Jeffrey Leek")
substr("Jeffrey Leek", 1,7)
paste("Jeffrey", "Leek")
paste0("Jeffrey", "Leek")
str_trim("Jeff      ")


###### Regular experssion

"^i think" ## start
"morning$" ## $ represent the end of a line
##  []
## [Ii] m
## ^[0-9][a-zA-Z]
## [^?.]$
## "." is used to refer to any character.
## "flood|fire"  or
## * means any number
## + means at least one of the item
## { and } are referred to as interval quantifier


#### Date

dl = date()

class(dl)

