
downloadFiles <- function(){
    trainURL<-"https://www.kaggle.com/c/bike-sharing-demand/download/train.csv"
    testURL <-"https://www.kaggle.com/c/bike-sharing-demand/download/test.csv"
    if(!file.exists("train.csv")){
        download.file(trainURL,"train.csv",method="curl")
    }
    if(!file.exists("test.csv")){
        download.file(testURL,"test.csv",method="curl")
    }
}

downloadFiles()

train<- read.csv("train.csv")
test <- read.csv("test.csv")

dim(train)
dim(test)

names(train)
names(test)

str(train)