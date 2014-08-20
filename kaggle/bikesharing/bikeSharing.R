getwd()
setwd("/home/wenfeng/code/datasciencecoursera/kaggle/bikesharing")
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

vars <- names(test)
train2<-train[,c(vars,"count")]
names(train2)

#library(randomForest)
#rfModel <- randomForest(count ~ .,data = train2,importance = TRUE,ntrees = 500)
#print(rfModel)

par(mfrow = c(3,3))
hist(train$season)
hist(train$holiday)
hist(train$workingday)
hist(train$weather)
plot(train$temp,train$atemp)
hist(train$humidity)
hist(train$windspeed)

par(mfrow=c(1,1))

#linear regression
fit1 <-lm(count~., data=train2)
pred <- predict(fit1, data=train2)
plot(train2$count, pred)

predTest <- predict(fit1, data=test)
