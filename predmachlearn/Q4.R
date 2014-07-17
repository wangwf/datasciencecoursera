library(caret)
library(ElemStatLearn)
data(vowel.train)
data(vowel.test) 

vowel.train<- transform(vowel.train, y=factor(y))
vowel.test<- transform(vowel.test, y=factor(y))

set.seed(33833)

modFit1 <- train(y~., data=vowel.train,method="rf")
modFit2 <- train(y~., data=vowel.train,method="gbm")

pred1 <- predict(modFit1, newdata=vowel.test)
pred2 <- predict(modFit2, newdata=vowel.test)

df = data.frame(y=vowel.test$y, rf=pred1, gbm=pred2)
acc_rf_gb = ifelse( df$rf == df$gbm, ifelse(df$rf==df$y, TRUE, FALSE), FALSE)

acc_rf = vowel.test$y==pred1
acc_gbm= vowel.test$y==pred2
mean(acc_rf)
mean(acc_gbm)

#mean(vowel.test$y==pred1&vowel.test$y==pred2)
mean(vowel.test$y[pred1 == pred2] == pred1[pred1 == pred2])


### Question 2
# Load the Alzheimer's data using the following commands
set.seed(3433)
library(AppliedPredictiveModeling)
data(AlzheimerDisease)
adData = data.frame(diagnosis,predictors)
inTrain = createDataPartition(adData$diagnosis, p = 3/4)[[1]]
training = adData[ inTrain,]
testing = adData[-inTrain,]
# Set the seed to 62433 and predict diagnosis with all the other variables
# using a random forest ("rf"), boosted trees ("gbm") and linear discriminant
# analysis ("lda") model. Stack the predictions together using random forests
# ("rf"). What is the resulting accuracy on the test set? Is it better or worse
# than each of the individual predictions?
set.seed(62433)
trControl = trainControl(method="cv")
modFit1 <- train(diagnosis~., data=training,method="rf", trControl=trControl)
modFit2 <- train(diagnosis~., data=training,method="gbm", trControl=trControl)
modFit3 <- train(diagnosis~., data=training,method="lda", trControl=trControl)

pred1 <- predict(modFit1, newdata=testing)
pred2 <- predict(modFit2, newdata=testing)
pred3 <- predict(modFit3, newdata=testing)

(acc_rf  <- mean(testing$diagnosis==pred1))
(acc_gbm <- mean(testing$diagnosis==pred2))
(acc_lda <- mean(testing$diagnosis==pred3))

##stacking
predDF <- data.frame(pred1, pred2, pred3, diagnosis=testing$diagnosis)
combModFit <- train(diagnosis~. , method="gam", data=predDF)
combPred <- predict(combModFit, predDF)


### Question 3
#Load the concrete data with the commands:
set.seed(3523)
library(AppliedPredictiveModeling)
data(concrete)
inTrain = createDataPartition(concrete$CompressiveStrength, p = 3/4)[[1]]
training = concrete[ inTrain,]
testing = concrete[-inTrain,]
# Set the seed to 233 and fit a lasso model to predict Compressive Strength.
# Which variable is the last coefficient to be set to zero as the penalty
# increases? (Hint: it may be useful to look up ?plot.enet).
trainModel <- train(CompressiveStrength ~ .,data=training, method="lasso")

object <- enet(x=as.matrix(subset(training, select=-c(CompressiveStrength))), y=training$CompressiveStrength, lambda=0)
plot(object,xvar="step")
# plot.enet(object, xvar=c("penalty"))
plot.enet(trainModel$finalModel, xvar="penalty", use.color=T)
cnames <-names(testing[-9])
legend("top", inset=c(-0.2,0), cnames, ncol=2, pch=8, lty=1:length(cnames), col=1:length(cnames))

# Question 4
# Load the data on the number of visitors to the instructors blog from here: 
#    https://d396qusza40orc.cloudfront.net/predmachlearn/gaData.csv Using the commands:
# download.file(url="https://d396qusza40orc.cloudfront.net/predmachlearn/gaData.csv",destfile="gaData.csv",method="curl")
library(forecast); require(lubridate)
dat = read.csv("gaData.csv")
training = dat[year(dat$date)==2011,]
tstrain = ts(training$visitsTumblr)

# Fit a model using the bats() function in the forecast package to the training
# time series. Then forecast this model for the remaining time points.
# For how many of the testing points is the true value within the 95% prediction interval bounds?
testing = dat[year(dat$date)>2011,]
tstest = ts(testing$visitsTumblr)
tl = dim(testing)[1] # length(testing$visitsTumblr)

plot(forecast(bats(tstrain),h=tl)) # 235 is the number of remaining time point
f<-forecast(bats(tstrain),h=tl, level=95) $ level confidence level
#sum(tstest>=f$lower[,1]&tstest<=f$upper[,1])/tl #Calculate the percentage that true values fall between 95% confidence interval
mean(tstest>=f$lower[,1]&tstest<=f$upper[,1])

# Question 5
# Load the concrete data with the commands:
set.seed(3523)
library(AppliedPredictiveModeling)
data(concrete)
inTrain = createDataPartition(concrete$CompressiveStrength, p = 3/4)[[1]]
training = concrete[ inTrain,]
testing = concrete[-inTrain,]
# Set the seed to 325 and fit a support vector machine using the e1071 package
# to predict Compressive Strength using the default settings. Predict on the
# testing set. What is the RMSE?
set.seed(325)
library(e1071)

modSVM <- svm(CompressiveStrength~., data=training)
pred1 <- predict(modSVM, newdata=testing)
#rmse
sqrt(mean((pred1-testing$CompressiveStrength)^2, na.rm=TRUE))
sqrt(sum((pred1-testing$CompressiveStrength)^2)/length(pred1))
