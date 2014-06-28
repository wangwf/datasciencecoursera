
#Question 1
# Consider the space shuttle data ?shuttle in the MASS library.
# Consider modeling the use of the autolander as the outcome (variable name use).
# Fit a logistic regression model with autoloader (variable auto) use
# (labeled as "auto" 1) versus not (0) as predicted by wind sign (variable wind).
# Give the estimated odds ratio for autoloader use comparing head winds, labeled
# as "head" in the variable headwind (numerator) to tail winds (denominator).

library(MASS)
fit1 <- glm(use~wind, family=binomial(logit),data=shuttle)

# Question 2
# Consider the previous problem. Give the estimated odds ratio for autoloader
# use comparing head winds (numerator) to tail winds (denominator) adjusting
# for wind strength from the variable magn.
fit2<-glm(use~factor(wind)+magn, family = binomial, data = shuttle)
exp(fit2$coeff)

# Question 3
# If you fit a logistic regression model to a binary variable, for example
# use of the autolander, then fit a logistic regression model for one minus
# the outcome (not using the autolander) what happens to the coefficients?

fit2 <- glm(as.factor(2-as.numeric(shuttle$use))~wind, family=binomial(logit),data=shuttle)
fit1$coeff
fit2$coeff

# Question 4
# Consider the insect spray data InsectSprays. Fit a Poisson model using
# spray as a factor level. Report the estimated relative rate comapring spray A
# (numerator) to spray B (denominator).
glm1 <- glm(count~spray-1, data=InsectSprays,family="poisson")
e<-(glm1$coeff)
e[1]/e[2]


#Question 6
# Consider the data
x <- -5:5
y <- c(5.12, 3.93, 2.67, 1.87, 0.52, 0.08, 0.93, 2.05, 2.54, 3.87, 4.97)
#Using a knot point at 0, fit a linear model that looks like a hockey stick with
#two lines meeting at x=0. Include an intercept term, x and the knot point term.
#What is the estimated slope of the line after 0?

plot(x, y)
knots <- 0
splineTerms <-sapply(knots, function(knot) (x>knot)*(x-knot))
xMat <- cbind(1, x, splineTerms)
yhat <- predict(lm(y~xMat -1))
lines(x, yhat, col="red", lwd=2)

e <- lm(y~xMat-1)$coeff
e
e[2]+e[3]