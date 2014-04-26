data(iris)


## have a look at Data
dim(iris)
summary(iris)
head(iris)
str(iris)
attributes(iris)
names(iris)

#Explor indiviual variable
summary(iris)
quantile(iris$Sepal.Length, c(0.1, 0.3, 0.65))
var(iris$Sepal.Length)
hist(iris$Sepal.Length)
plot(density(iris$Sepal.Length))

# table(), pie(), barplot()
table(iris$Species)
pie(tablie(iris$Species))
barplot(table(iris$Species))

#Explore multiple vaiable
cov(iris$Sepal.Length, iris$Sepal.Width)
cov(iris[,1:4])
cor(iris[,1:4])

#compute the stats of Sepal.Length of every Species with aggregate() 
aggregate(Sepal.Length ~ Species, summary, data=iris)
tapply(iris$Sepal.Length, iris$Species, summary)

#boxplot, shows the median, first and third quartile of a distribution, and outliers.
boxplot(Sepal.Length ~ Species, data=iris)

# with(data, expression)
with(iris, plot(Sepal.Length, Sepal.Width, col=Species, pch = as.numeric(Species)))
#jitter() adds a small amount of noise to the dat before ploting, avoid overlaps
plot(jitter(iris$Sepal.Length), jitter(iris$Sepal.Width))

pairs(iris[,1:4])


#
## Decision Trees and Random Forest
# Decision Tree with package party
# PARTY package (Hotborn et al. 2010)
decisionTreeWithParty(){
    set.seed(1234)
    ind <-sample(2, nrow(iris), replace=TRUE, prob=c(0.7,0.3))
    trainData <-iris[ind==1,]
    testData <-iris[ind==2,]

    data(iris)
    library(party)
    myFormula <- Species ~ Sepal.Length + Sepal.Width + Petal.Length +Petal.Width
    # myFormula <- Species ~ . #  to predict using all other variables
    iris_ctree <-ctree(myFormula, data=trainData)
    # check the prediction
    table(predict(iris_ctree), trainData$Species)
    print(iris_ctree)
    plot(iris_ctree)
    plot(iris_ctree, type="simple")
    # predict on test data
    testPred <- predict(iris_ctree, newdata = testData)
    table(testPred, testData$Species)
}
# decision tree with 'rpart' package
# library(rpart)
# iris_rpart <- rpart(myFormula, data=trainData, control=rpart.control(minsplit=10))
# plot(iris_rpart, type="simple")

#
# Random forest
# limitations :
#   can't handle missing values
#   maximum number of level of each categorical attribute
randomForest(){
    set.seed(1234)
    ind <-sample(2, nrow(iris), replace=TRUE, prob=c(0.7,0.3))
    trainData <-iris[ind==1,]
    testData <-iris[ind==2,]

    library(randomForest)
    rf<-randomForest(Species ~ ., data=trainData, ntree=100, proximity=TRUE)
    table(predict(rf), trainData$Species)

    print(rf)

    attributes(rf)
    importance(rf)

    irisPred <-predict(rf, newdata=testData)
    table(irisPred, testData$Species)

    #The margin of a data point is as the proportion of votes for the correct class
    # minus maximum proportion of votes for other classes.
    plot(margin(rf, testData$Species))
}
