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