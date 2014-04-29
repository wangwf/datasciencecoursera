##
## lapply: Loop over a list and evaluate a function on each element
## sapply: Same as lapply but try to simplify the result
## apply:  Apply a function over the margin of an array
## tapply: Apply a function over subsets of a vector
## mapply: Multivariate version of lapply
#
#  An auxiliary function split is also useful, particularly in conjunction with lapply.

x<-list(a=1:5, b=rnorm(10))
lapply(x,mean)

lapply(x, runif, min=0,max=10)

x <- list(a = matrix(1:4, 2, 2), b = matrix(1:6, 3, 2))
lapply(x, function(elt) elt[,1])

## 
## sapply:
##
## apply: is used to evaluate a function (ofter an anonymous one) over the margins of an array
##   It is often used to apply a function to the rows or columns of a matrix
##   It can be used with general arrays, e.g. taking the average of an array of matrices.
##   It is not really faster than writing a loop, but it works in one line.
##
##    x is matrix
##      rowSums = apply(x, 1, sum)
##      rowMeans= apply(x, 1, mean)
##      colSums = apply(x, 2, sum)
##      colMeans= apply(x, 2, mean)
##
## Quantiles of the rows of a matrix
x <- matrix(rnorm(200), 20, 10)
apply(x, 1, quantile, probs = c(0.25, 0.75))

# average amtrix in an array
a <- array(rnorm(2*2*10), c(2, 2, 10))
apply(a, c(1,2), mean)


## tapply
x<-c(rnorm(10), runif(10), rnorm(10,1))
f<-gl(3,10)
# take group means without simplification
tapply(x, f, mean, simplify = FALSE)
# find group ranges
tapply(x, f, range)

## split() takes a vector or other objects and splits it into groups determined by a factor or list of factors
#
str(split)
x <- c(rnorm(10), runif(10), rnorm(10,1))
f <- gl(3,10)
split(x,f)
lapply(split(x,f), mean)

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
