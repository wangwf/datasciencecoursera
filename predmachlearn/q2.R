
#q2
library(AppliedPredictiveModeling)
data(concrete)
library(caret)
set.seed(975)
inTrain = createDataPartition(mixtures$CompressiveStrength, p = 3/4)[[1]]
training = mixtures[ inTrain,]
testing = mixtures[-inTrain,]

index = 1:dim(training)[1]
for(i in 1:dim(training)[2]){
    cut = cut2(training[,i], g = 5)
    print(qplot(index,training$CompressiveStrength,col=cut) + labs(title = names(training)[i]))
}


###Q3
library(AppliedPredictiveModeling)
data(concrete)
library(caret)
set.seed(975)
inTrain = createDataPartition(mixtures$CompressiveStrength, p = 3/4)[[1]]
training = mixtures[ inTrain,]
testing = mixtures[-inTrain,]

hist(concrete$Superplasticizer)
hist(log(concrete$Superplasticizer+1))

#Question 4
#Load the Alzheimer's disease data using the commands:
set.seed(3433)
library(AppliedPredictiveModeling)
data(AlzheimerDisease)
adData = data.frame(diagnosis,predictors)
inTrain = createDataPartition(adData$diagnosis, p = 3/4)[[1]]
training = adData[ inTrain,]
testing = adData[-inTrain,]

#Find all the predictor variables in the training set that begin with IL.
#Perform principal components on these variables with the preProcess() function
#from the caret package.
#Calculate the number of principal components needed to capture 80% of the variance.
# How many are there?
a <- which(grepl("^IL|diagnosis", colnames(training), ignore.case = F))
df <- training[,a]
b <- prcomp(df[,-1])
summary(b)

#preProcess.default(x = training[, c(58:69)], method = "pca", thresh = 0.8)
preProcess(x = training[, a[-1]], method = "pca", thresh = 0.8)




#Question 5
#Load the Alzheimer's disease data using the commands:
set.seed(3433)
library(AppliedPredictiveModeling)
data(AlzheimerDisease)
adData = data.frame(diagnosis,predictors)
inTrain = createDataPartition(adData$diagnosis, p = 3/4)[[1]]
training = adData[ inTrain,]
testing = adData[-inTrain,]
#Create a training data set consisting of only the predictors with variable names
# beginning with IL and the diagnosis.
# Build two predictive models, one using the predictors as they are and one using
# PCA with principal components explaining 80% of the variance in the predictors.
# Use method="glm" in the train function.
# What is the accuracy of each method in the test set? Which is more accurate?

a <- which(grepl("^IL|diagnosis", colnames(training), ignore.case = F))
df <- training[,a]

preProc<-preProcess(x = training[, a[-1]], method = "pca", thresh = 0.8)
trainPC <- predict(preProc, training[,a[-1]])
modelFit <- train(training$diagnosis ~., method="glm", data=trainPC)

testPC <- predict(preProc, testing[,a[-1]])
confusionMatrix(testing$diagnosis, predict(modelFit, testPC))
