library(UsingR); data(galton)

par(mfrow=c(1,2))

hist(galton$child, col="blue", breaks=100)
hist(galton$parent, col="blue", breaks=100)

x<-galton$child
y<-galton$parent
beta1  <- cor(y,x)*sd(y)/sd(x)
beta0 <- mean(y) - beta1*mean(x)
rbind(c(beta0,beta1), coef(lm(y~x)))