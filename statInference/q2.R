#q1
#When at the free-throw line for two shots, a basketball player makes at least one free throw 90% of the time. 80% of the time,
#the player makes the first shot, 80% of the time the player makes the second shot and 70% of the time she makes both shots.
#What is the conditional probability that the player makes the second shot given that she missed the first?
 PA = 0.80
 PB = 0.80
 PAandB = 0.7 # P(A&B) = P(A) + P(B) - P(B|A)PA
 PAB = PA + PB - PAandB
 (PBAbar = (PA - PAB*PB)/(1-PB))
 
# q2
tp = 0.75
fn = 0.52  # 0.52 -0.75
pv =0.3
(p = (tp*pv)/(tp*pv + (1-fn)*(1-pv) ))


#q3
pnorm(70, mean=80, sd=10.)

#q4
 qnorm(0.95, 1100, sd=75)

 1100 + 1.645 *75
#[1] 1223.375

#q5

# q6
# You flip a fair coin 5 times, 
# what's the probability of getting 4 or 5 heads? Express your answer as a percentage to the nearest percentage point.
 p=0.5
 p**4*(1-p) + p**5

# q7
p1 <- pnorm(c(0,14,16), 15, 10)
 (p1[3] - p1[2])/(1-p1[1])

# q8
d<-runif(1000)
mean(d)
var(d)

# q9
 v<-c()
 for(i in 1:1000){
     d<-runif(100)
     v[i]<-var(d)
 }
 mean(v)
 1/12
 
#q10
ppois(10, lambda=5*3)


# Q11
 9*8*7/(3*2)
