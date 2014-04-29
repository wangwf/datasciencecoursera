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

lineraRegression <- function(){
    year <-rep(2008:2010, each=4)
    quarter <- rep(1:4, 3)
    cpi <- c(162.2, 164.6, 166.5, 166.0,
             166.2, 167.0, 168.6, 169.5,
             171.0, 172.1, 173.3, 174.0)
    plot(cpi, xaxt="n", ylab="CPI", xlab="")
    # draw x-axis
    axis(1, labels=paste(year,quarter,sep="Q"), at=1:12, las=3)
    
    cor(year, cpi)
    cor(quarter,cpi)
    
    fit <-lm(cpi ~ year + quarter)
    attributes(fit)
    fit
    residuals(fit) # fit$residuals
    
    #prediction for 2011
    cpi2011 <- fit$coefficients[[1]] + fit$coefficients[[2]]*2011 + fit$coefficients[[3]]*(1:4)
    cpi2011
    data2011 <- data.frame(year=2011, quarter=1:4)
    cpi2011 <-predict(fit, newdata=data2011)
    
    plot(fit)
    

}

#generalized Linear Regression model generalizes linear regression by allowing the linear
# model to be replaced to the response variable via a link function and allowing the
# magnitude of the variance of each measurement to be a function of its predicted values.
generalizedLinearRegression() <- function(){
    data("bodyfat", "mboost")
    myFormula <- DEXfat ~ age + waistcirc + hipcirc + elbowbreadth + kneebreadth
    bodyfat.glm <- glm(myFormula, family=gaussian("logit"), data = bodyfat)
    # family=gauusian("log")
    summary(bodyfat.glm)
    
    pred <- predict(bodyfat.glm, type="response")
    plot(bodyfat$DEXfat, pred, xlab="Observed Values", ylab ="Predicted Values")
    abline(a=0, b =1)

}

# Non-Linear Regression nls()
#

### Clustering
#
# k-means clustering
kmeansClustering <- function(){
  iris2<- iris
  iris2$Species <- NULL
  (kmeans.result <- kmeans(iris2, 3))
  table(iris$Species, kmeans.result$cluster)
  
  plot(iris2[c("Sepal.Length", "Sepal.Width")], col = kmeans.result$cluster)
  points(kmeans.result$centers[,c("Sepal.Length","Sepal.Width")], col = 1:3, pch=8, cex =2)
  
}

### K-Medoids Clustering
#  similar to k-mean, but a cluster is represented with the object closest to the center of the cluster.
kMedoidsClustering <- function(){
  library(fpc)
  pamk.result <- pamk(iris2)
  #
  pamk.result$nc
  table(pamk.result$pamobject$clustering, iris$Species)
  layout(matrix(c(1,2), 1, 2)) # 2 graphs per page
  plot(pamk.result$pamobject)
  layout(matrix(1))
  
  pam.result <- pam(iris2, 3)
  table(pam.result$clustering, iris$Species)
  layout(matrix(c(1,2), 1, 2)) # 2 graphs per page
  plot(pam.result$pamobject)
  layout(matrix(1))

}

hierarchicalClustering <-function(){
  idx <- sample(1:dim(iris)[1], 40)
  irisSample <- iris[idx, ]
  irisSample$Species <- NULL
  hc <- hclust(dist(irisSample), method="ave")
  plot(hc, hang = -1, labels = iris$Species[idx])
  #cut tree into 3 clusters
  rect.hclust(hc, k=3)
  groups <- cutree(hc, k=3)
  
  
}

#density-base Clustering
densityBasedClustering <-function(){
  library(fpc)
  iris2 <- iris[-5] # remove class tags
  

  ds <- dbscan(iris2, eps=0.42, MinPts=5)
  # compare clusters with original class labels
  table(ds$cluster, iris$Species)
  
  plot(ds, iris2)
  plot(ds, iris2[c(1,4)])
  plotcluster(iris2, ds$cluster)
  
  set.seed(435)
  idx <- sample(1:nrow(iris), 10)
  newData <- iris[idx,-5]
  newData <- newData + matrix(runif(10*4, min=0, max=0.2), nrow=10, ncol=4)
  # label new data
  myPred <- predict(ds, iris2, newData)
  # plot result
  plot(iris2[c(1,4)], col=1+ds$cluster)
  points(newData[c(1,4)], pch="*", col=1+myPred, cex=3)
  # check cluster labels
  table(myPred, iris$Species[idx])
  
  
}

