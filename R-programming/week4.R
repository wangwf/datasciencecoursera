
## generating random number from linear model
set.seed(20)
x <- rnorm(100)
e <- rnorm(100, 0, 2)
y <- 0.5 + 2* x + e
summary(y)
plot(x,y)

#system.time()
system.time(readLine("http://www.jhsph.edu"))

hilber<- function(n){
    i<-1:n
    1/outer(i-1, i, "i")
}
x<-hilbert(1000)
system.time(svd(x))

system.time({
    n<-100
    r<- numberic(n)
    for (i in 1:n){
        x<-rnorm(n)
        r[i] <-mean(x)
    }
})

##
library(datasets)
#x1<-rnorm(1000000); x2<-1:1000000; y<-x2
Rprof()
fit <- lm(y ~ x1 + x2)
Rprof(NULL)
summaryRprof()

