#q1 ?
#When at the free-throw line for two shots, a basketball player makes at least one free throw 90% of the time. 80% of the time,
#the player makes the first shot, 80% of the time the player makes the second shot and 70% of the time she makes both shots.
#What is the conditional probability that the player makes the second shot given that she missed the first?
 PA = 0.80
 PB = 0.80
 PAorB = 0.9 # =PB +PA - PAandB
 PAandB = 0.7 # P(A&B) = P(B|A)P(A) =  P(A|B)PB
 PBA = PAandB/PA
 
 (PBAbar = (PB - PBA*PA)/(1-PA)) # (PA - PAB*PB)/(1-PB))
 
# q2 ok
tp = 0.75
fn = 0.52  # 0.52 -0.75
pv =0.3
(p = (tp*pv)/(tp*pv + (1-fn)*(1-pv) ))


#q3 ok
# mean(rnorm(100, 1100, 75))
pnorm(70, mean=80, sd=10.)

#q4 ok
 qnorm(0.95, 1100, sd=75)

 1100 + 1.645 *75
#[1] 1223.375
 x=sapply(rep(100,100), function (x) mean(rnorm(x,1100,75)))
  y=sapply(rep(1,100), function (x) mean(rnorm(x,1100,75)))
  hist(x, main ="Distribution of Mean of 100 Normally Distributed r.v 100 samples", xlab =paste("SD is",sd(x)))
  hist(y, main ="Distribution of 1 Normally Distributed r.v 100 samples", xlab =paste("SD is",sd(y)))
  pnorm(70, mean=80, sd=10.)
#q5 ok

# q6
# You flip a fair coin 5 times, 
# what's the probability of getting 4 or 5 heads? Express your answer as a percentage to the nearest percentage point.
 p=0.5
 5*p**4*(1-p) + p**5
 choose(5,4)*p^4*(1-p) +choose(5,5)*p^5
 pbinom(3, size=5, prob =0.5, lower.tail=FALSE)

 # q7
p1 <- pnorm(c(0,14,16), 15, 10)
 (p1[3] - p1[2])/(1-p1[1])
 v<-c()
 for(i in 1:10000){
     d<-rnorm(100,15,10)
     v[i]<-mean(d)
 }
# sd(v)
 mean(v>=14&v<=16)

 # q8
d<-runif(1000)
mean(d)
var(d)

# q9
 v<-c()
 for(i in 1:1000){
     d<-runif(100)
     v[i]<-mean(d)
 }
 sd(v)
 
 
#q10
ppois(10, lambda=5*3)


# Q11
 9*8*7/(3*2)
