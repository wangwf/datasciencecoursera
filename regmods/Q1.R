
## Q1
x <- c(0.18, -1.54, 0.42, 0.95)
w <- c(2, 1, 3, 1)
mu <- c(0.1471, 0.0025, 1.077, 0.30)
s1<- c(0,0,0,0)
for(i in 1:4) s1[i]=sum( w*(x -mu[i])^2)
mu[which(s1==min(s1))]


##q2
x <- c(0.8, 0.47, 0.51, 0.73, 0.36, 0.58, 0.57, 0.85, 0.44, 0.42)
y <- c(1.39, 0.72, 1.55, 0.48, 1.19, -1.59, 1.23, -0.65, 1.49, 0.05)
x1 <- x - mean(x)
y1 <- y - mean(y)
(beta<- coef(lm(y1~x1))[2])
plot(x1, y1,pch=19, cex=1.1)
abline(0, beta)

##   using y= beta*x,   lm(y~x-1) where -1 means remove constant
lm(y~x-1)

##q3

data(mtcars)
beta <- lm( mpg-mean(mpg) ~ I(wt-mean(wt)), data=mtcars)

plot( mpg-mean(mpg) ~I(wt-mean(wt)), data=mtcars)
abline(0, coef(beta)[2])

#q6
x <- c(8.58, 10.46, 9.01, 9.64, 8.86)
x1<- (x-mean(x))/sd(x)

##q7
x <- c(0.8, 0.47, 0.51, 0.73, 0.36, 0.58, 0.57, 0.85, 0.44, 0.42)
y <- c(1.39, 0.72, 1.55, 0.48, 1.19, -1.59, 1.23, -0.65, 1.49, 0.05)

lm( y ~ x)

# q9 What value minimizes the sum of the squared distances between these points and itself?
x <- c(0.8, 0.47, 0.51, 0.73, 0.36, 0.58, 0.57, 0.85, 0.44, 0.42)
mean(x)
mu <- c(0.36,0.8,0.44,0.573)
s1<-c(rep(0,4))
for(i in 1:4) s1[i] <- sum( (x- mu[i])^2)
s1
mu[which(s1==min(s1))]

