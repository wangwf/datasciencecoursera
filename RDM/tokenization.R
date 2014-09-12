
string1 <- "This is a test. I'd like to test..."
strsplit(string1, "\\s+")[[1]]

# strsplit(x, '(?<![^!?.])\\s+', perl=T)

library("RWeka")
library(RWekajars)
NGramTokenizer(string1,Weka_control(min=1,max=1))

## Option 1: retrieve tweets from Twitter
library(twitteR)
tweets <- userTimeline("RDataMining", n = 3200)
## Option 2: download @RDataMining tweets from RDataMining.com
url <- "http://www.rdatamining.com/data/rdmTweets.RData"
download.file(url, destfile = "./data/rdmTweets.RData")
## load tweets into R
load(file = "./data/rdmTweets-201306.RData")


(n.tweet <- length(tweets))
## [1] 320
tweets[1:5]


# convert tweets to a data frame
# tweets.df <- do.call("rbind", lapply(tweets, as.data.frame)) tweets.df <- twListToDF(tweets)
dim(tweets.df)
## [1] 320 14
library(tm)
# build a corpus, and specify the source to be character vectors myCorpus <- Corpus(VectorSource(tweets.df$text))
# convert to lower case
# myCorpus <- tm_map(myCorpus, tolower)
# 
# tm v0.6
myCorpus <- tm_map(myCorpus, content_transformer(tolower))


# remove punctuation
myCorpus <- tm_map(myCorpus, removePunctuation) # remove numbers
myCorpus <- tm_map(myCorpus, removeNumbers)
# remove URLs
removeURL <- function(x) gsub("http[[:alnum:]]*", "", x)
myCorpus <- tm_map(myCorpus, removeURL)
# add two extra stop words: 'available' and 'via'
myStopwords <- c(stopwords("english"), "available", "via")
# remove 'r' and 'big' from stopwords
myStopwords <- setdiff(myStopwords, c("r", "big"))
# remove stopwords from corpus
myCorpus <- tm_map(myCorpus, removeWords, myStopwords)
#
#￼# keep a copy of corpus to use later as a dictionary for stem
# completion
myCorpusCopy <- myCorpus
# stem words
myCorpus <- tm_map(myCorpus, stemDocument)


# inspect the first 5 documents (tweets) inspect(myCorpus[1:5]) 
# The code below is used for to make text fit for paper width 
for (i in 1:5) {
    cat(paste("[[", i, "]] ", sep = ""))
    writeLines(myCorpus[[i]])
}
