data(mtcars)
mtcars <- transform(mtcars, cyl = factor(cyl))
lm1 = lm(mpg~cyl+wt-1, data=mtcars)
summary(lm1)$coef[3,1]-summary(lm1)$coef[1,1]

lm2 = lm(mpg~cyl+wt, data=mtcars)
summary(lm2)$coef[3,1]


summary(lm(mpg~cyl+wt, data=mtcars))$coef
summary(lm(mpg~cyl, data=mtcars))$coef

#q3
summary(lm(mpg~cyl+wt+wt*cyl, data=mtcars))


#q4
summary(lm(mpg~I(wt*0.5)+factor(cyl), data=mtcars))$coef


#Question 5  Consider the following data set

x <- c(0.586, 0.166, -0.042, -0.614, 11.72)
y <- c(0.549, -0.026, -0.127, -0.751, 1.344)
# Give the hat diagonal for the most influential point
fit<-lm(y~x)
round(dfbetas(fit)[,2],4) # dfbetas instead dfbeta
round(hatvalues(fit),4)


