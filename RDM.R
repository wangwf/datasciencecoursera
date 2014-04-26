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
