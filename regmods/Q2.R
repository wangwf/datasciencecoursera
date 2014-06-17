# Consider the following data with x as the predictor and y as as the outcome.
# Give a P-value for the two sided hypothesis test of whether \( \beta_1 \) 
# from a linear regression model is 0 or not.
x <- c(0.61, 0.93, 0.83, 0.35, 0.54, 0.16, 0.91, 0.62, 0.62)
y <- c(0.67, 0.84, 0.6, 0.18, 0.85, 0.47, 1.1, 0.65, 0.36)
fit <- lm(y~x)
summary(fit)$coefficients


n = length(x)
2*pt(summary(fit)$coefficients[[2,3]],df=n-2,lower.tail=FALSE)

# q2
summary(fit)$coefficients
sd(resid(fit))*sqrt( (n-1)/(n-2))
summary(fit)$sigma

# Q3
# In the mtcars data set, fit a linear regression model of weight (predictor) on mpg
# (outcome). Get a 95% confidence interval for the expected mpg at the average
# weight. What is the lower endpoint?
data(mtcars)
fit<-lm(mpg~wt, data=mtcars)
predict(fit, newdata=data.frame(wt=mean(mtcars$wt)),interval="confidence")


#summary(fit)$coefficient[2,1] - summary(fit)$coefficient[2,2]**qt(0.975,30)
#q5
# Consider again the mtcars data set and a linear regression model with mpg as predicted by weight (1,000 lbs). A new car is coming weighing 3000 pounds.
# Construct a 95% prediction interval for its mpg. What is the upper endpoint?
predict(fit, newdata=data.frame(wt=3),interval="prediction")

#q6
# Consider again the mtcars data set and a linear regression model with mpg as
# predicted by weight (in 1,000 lbs). A “short” ton is defined as 2,000 lbs.
# Construct a 95% confidence interval for the expected change in mpg per 1
# short ton increase in weight. Give the lower endpoint.

fit2<-lm(mpg~I(wt*1/2), data=mtcars)
sumCoef <- summary(fit2)$coefficients
sumCoef[1,1] + c(-1,1)*qt(0.975, df=fit2$df)*sumCoef[1,2]
sumCoef[2,1] + c(-1,1)*qt(0.975, df=fit2$df)*sumCoef[2,2]

predict(fit2, newdata=data.frame(wt=mean(mtcars$wt)),interval="confidence")

# Question 8
# I have an outcome, $$Y$$, and a predictor,
# $$X$$ and fit a linear regression model with $$Y = \beta_0 + \beta_1 X + \epsilon$$
# to obtain $$\hat \beta_0$$ and $$\hat \beta_1$$. What would be the consequence to
# the subsequent slope and intercept if I were to refit the model with a new
# regressor, $$X + c$$ for some constant, $$c$$?

#q9
y<- mtcars$mpg
x<- mtcars$wt
beta1 <- cor(y, x)*sd(y)/sd(x)
beta0 <- mean(y) - beta1*mean(x)
ssq1 <- sum( (y- beta0 - beta1*x)^2)
ssq2 <- sum((y-mean(y))^2)
ssq1/ssq2

