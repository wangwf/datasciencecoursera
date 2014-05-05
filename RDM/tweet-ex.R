
library(twitteR)

#install_github("twitteR", username="geoffjentry")

#### Twitter API ####
#Retrieving Text from Twitter
#Twitter API requires authentication since March 2013. 
#Please follow instructions in "Section 3 - Authentication with OAuth" in the twitteR vignettes on CRAN or this link to complete authentication before running the code below.

twitterKey <-read.table("../getdata/twitter.txt", colClasses="character")
consumerkey=twitterKey$V2[[1]]
consumersecret=twitterKey$V2[[2]]
token = twitterKey$V2[[3]]
token_secret=twitterKey$V2[[4]]

setup_twitter_oauth(consumerkey, consumersecret, token, token_secret)

source("./twitterMap.R")
twitterMap("simplystats")

# search twitter 
delta <- function(){
    delta.tweets = searchTwitter('@delta', n=1500)
    tweet = delta.tweets[[1]] # tweet is an object of type "status" from twitteR
    class(tweet)
    
    # help page("?status") describes some accessor methods like getScreenName() and
    # getText()
    tweet$getScreenName()
    tweet$getText()
    
    delta.text = lapply(delta.tweets, function(t) t$getText() )
    head(delta.text, 5)
    
    # Estimating Sentiment
    hu.liu.pos = scan("./data//positive-words.txt", what = 'character',comment.char=";")
    hu.liu.neg = scan("./data/negative-words.txt", what = 'character', comment.char=";")
    
    # add a few more industry-specific terms
    pos.words = c(hu.liu.pos, 'upgrade')
    neg.words = c(hu.liu.neg,'wtf', 'wait', 'waiting', 'epicfail', 'mechanical')

    #tests
    sample =c("You're awesome and I love you",
              "I hate and hate and hate, So angry. Die!",
              "Impressed and amazed: you are peerless in your achievement of 
              unparalleled mediocrity.")
    
    source("./sentiment.R")
    result = score.sentiment(sample, pos.words, neg.words)
    class(result)
    result$score
    
    # score the tweets
    #### Error !
    delta.scores = score.sentiment(delta.text, pos.words, neg.words, .progress='text')
    
    delta.scores$airline ='Delta'
    delta.scores$code = 'DL'
    
    #
    hist(delta.scores$score)
    all.scores = rbind( american.scores, continental.scores, delta.scores,
                        jetblue.scores, southwest.scores, united.scores, us.scores)
}