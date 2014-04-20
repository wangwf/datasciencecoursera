x<-list(a=1:5, b=rnorm(10))
lapply(x,mean)

lapply(x, runif, min=0,max=10)

lapply(x, function(elt) elt[,1])


## tapply
x<-c(rnorm(10), runif(10), rnorm(10,1))
f<-gl(3,10)
tapply(x, f, mean)

## split()
str(split)

library(datasets)
head(airquality)
s<-split(airquality, airquality$Month)
lapply(s, function(x) colMeans(x[,c("Ozone","Solar.R","Wind")]))

# Splitting a Data Frame
sapply(s, function(x) colMeans(x[,c("Ozone","Solar.R","Wind")], na.rm=TRUE))

#spliting on more than one Level
x<-rnorm(10)
f1<-g1(2,5)
f2<-g2(5,2)
interaction(f1, f2)
str(split(x, list(f1,f2)))


## mapply, a multivariate apply of sorts which applies a function in parallel over a set of arguments
list(rep(1,4), rep(2, 3), rep(3,2), rep(4,1))
mapply( rep, 1:4, 4:1)

#vectorizing a function
noise<- function(n, mean, sd){ rnorm(n, mean, sd)}
noise(5, 1, 2)
noise(1:5, 1:5, 2)
mapply(noise, 1:5, 1:5, 2)  # == list(noise(1,1,2), noise(2,2,2), noise(3,3,2), noise(4,4,2), noise(5,5,2))



## Q1
lapply(iris[iris["Species"]=="virginica",]["Sepal.Length"], mean, na.rm=T)

apply(iris[, 1:4], 2, mean)

with(mtcars, tapply(mpg, cyl, mean))  # sapply(split(mtcars$mpg, mtcars$cyl), mean)

d<-with(mtcars, tapply(hp,cyl, mean))
d[3]-d[1]
