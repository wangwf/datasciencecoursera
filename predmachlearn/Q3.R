

library(AppliedPredictiveModeling)
data(segmentationOriginal)
library(rpart)
training = segmentationOriginal[ segmentationOriginal$Case=="Train",]
testing   = segmentationOriginal[ segmentationOriginal$Case=="Test",]

set.seed(125)
#modelFit<- rpart(Class~., data=training,method="class")

modelFit <- train(training$Class ~., method="rpart", data=training)
modelFit$finalModel

#a<-data.frame( TotalIntench2 = 23,000, FiberWidthCh1 = 10,PerimStatusCh1=2)
#testPC <- predict(modelFit, newdata=a)
print(modelFit$finalModel)
plot(modelFit$finalModel,uniform=TRUE,main="Classification Tree")
text(modelFit$finalModel,use.n=TRUE,all=TRUE,CEX=0.8)
library(rattle)
fancyRpartPlot(modelFit$finalModel)
               

## Q3
#install.packages("~/Downloads/pgmm_1.0.tar", repos=NULL, type="source")
library(pgmm)
data(olive)
olive = olive[,-1]
modelFit <- train(olive$Area~., method="rpart",data=olive)
print(modelFit$finalModel)

predict(modelFit, newdata = as.data.frame(t(colMeans(olive))))


#Q4
library(ElemStatLearn)
data(SAheart)
set.seed(8484)
train = sample(1:dim(SAheart)[1],size=dim(SAheart)[1]/2,replace=F)
trainSA = SAheart[train,]
testSA = SAheart[-train,]

set.seed(13234)
modelFit <- train(trainSA$chd~age+alcohol+obesity+tobacco+typea+ldl, method="glm", data=trainSA,family="binomial")
missClass = function(values,prediction){sum(((prediction > 0.5)*1) != values)/length(values)}
missClass(trainSA$chd, predict(modelFit, newdata=trainSA))
missClass(testSA$chd, predict(modelFit, newdata=testSA))

#q5
library(ElemStatLearn)
data(vowel.train)
data(vowel.test) 

#vowel.train$y <- as.factor(vowel.train$y)
#vowel.test$y <- as.factor(vowel.test$y)
vowel.train <- transform(vowel.train, y=factor(y))
vowel.test <- transform(vowel.test, y=factor(y))
set.seed(33833)

modFit <- train(y ~., data=vowel.train, method="rf", prox=TRUE, importance=TRUE)
varImp(modFit)

train.y <- cut2(vowel.train$y, g=11)
test.y <- cut2(vowel.test$y, g=11)

library(randomForest)
train.rf <- randomForest(train.y ~ ., data=vowel.train)
library(caret)
vm <- varImp(train.rf)

test.rf <- randomForest(test.y ~ ., data=vowel.test)
vm <- varImp(test.rf)

