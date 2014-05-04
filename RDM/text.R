

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

# retrieve the first 200 tweets (or all tweets if fewer than 200) from the
# user timeline of @rdatammining
rdmTweets <- userTimeline("rdatamining", n=200)
(nDocs <- length(rdmTweets))

rdmTweets[1:3]

# Transforming Text
# The tweets are first converted to a data frame and then to a corpus.

df <- do.call("rbind", lapply(rdmTweets, as.data.frame))
dim(df)

library(tm)
 # build a corpus, which is a collection of text documents
 # VectorSource specifies that the source is character vectors.
myCorpus <- Corpus(VectorSource(df$text))

# After that, the corpus needs a couple of transformations,\
# including changing letters to lower case,
# removing punctuations/numbers and removing stop words.
# The general English stop-word list is tailored by adding "available" and "via"
# and removing "r".

myCorpus <- tm_map(myCorpus, tolower)
 # remove punctuation
myCorpus <- tm_map(myCorpus, removePunctuation)
# remove numbers
myCorpus <- tm_map(myCorpus, removeNumbers)
# remove stopwords
 # keep "r" by removing it from stopwords
myStopwords <- c(stopwords('english'), "available", "via")
idx <- which(myStopwords == "r")
myStopwords <- myStopwords[-idx]
myCorpus <- tm_map(myCorpus, removeWords, myStopwords)

### Stemming Words

# In many cases, words need to be stemmed to retrieve their radicals.
#For instance, "example" and "examples" are both stemmed to "exampl".
# However, after that, one may want to complete the stems to their original forms,
# so that the words would look "normal".

#install.packages("SnowballC")
dictCorpus <- myCorpus
# stem words in a text document with the snowball stemmers,
 # which requires packages Snowball, RWeka, rJava, RWekajars
 myCorpus <- tm_map(myCorpus, stemDocument)
# inspect the first three ``documents"
inspect(myCorpus[1:3]) #(Some details are removed to make it short. Same applies to inspect() below.)

# stem completion
 myCorpus <- tm_map(myCorpus, stemCompletion, dictionary=dictCorpus)

#Print the first three documents in the built corpus.
 inspect(myCorpus[1:3])

#Something unexpected in the above stemming and stem completion is that,
#word "mining" is first stemmed to "mine", and then is completed to "miners",
#instead of "mining", although there are many instances of "mining" in the tweets,
#compared to only one instance of "miners".


#Building a Document-Term Matrix
myDtm <- TermDocumentMatrix(myCorpus, control = list(minWordLength = 1))
inspect(myDtm[266:270,31:40])

#Based on the above matrix, many data mining tasks can be done,
#for example, clustering, classification and association analysis.


## Frequent Terms and Associations

findFreqTerms(myDtm, lowfreq=10)

 # which words are associated with "r"?
 findAssocs(myDtm, 'r', 0.30)

 # which words are associated with "mining"?
 # Here "miners" is used instead of "mining",
 # because the latter is stemmed and then completed to "miners". :-(
 findAssocs(myDtm, 'miners', 0.30)


#Word Cloud

#After building a document-term matrix, we can show the importance of words with a word cloud (also kown as a tag cloud) . In the code below, word "miners" are changed back to "mining".

 library(wordcloud)
 m <- as.matrix(myDtm)
 # calculate the frequency of words
 v <- sort(rowSums(m), decreasing=TRUE)
 myNames <- names(v)
 k <- which(names(v)=="work") # "miners")
 myNames[k] <- "worker" #"mining"
 d <- data.frame(word=myNames, freq=v)
 wordcloud(d$word, d$freq, min.freq=3)


#####
tweets <- searchTwitter('#rstats', n=50)
head(strip_retweets(tweets, strip_manual=TRUE, strip_mt=TRUE))

# looking at user
crantastic <- getUser('crantastic')
crantastic$getDescription()
crantastic$getFollowersCount()
crantastic$getFriends(n=5)
crantastic$getFavorites(n=5)

wwf <-getUser("wangwf208")
wwf$getDescription()
wwf$getFollowersCount()
wwf$getFriends(n=5)

df <- twListToDF(tweets)
head(df)

sql_lite_file = tempfile()
register_sqlite_backend(sql_lite_file)
store_tweets_db(tweets)

from_db = load_tweets_db()
head(from_db)

#Timelines
#A Twitter timeline is simply a stream of tweets. We support two timelines,
#the user timeline and the home timeline. The former provides the most recent
# tweets of a specified user while the latter is used to display your own most
#recent tweets. These both return a list of status objects.
cran_tweets <- userTimeline('cranatic')
cran_tweets[1:5]

cran_tweets_large <- userTimeline('cranatic', n=100)
length(cran_tweets_large)

## Trends
# Twitter keeps track of topics that are popular at any given point of time,
#and allows one to extract that data. The getTrends function is used to pull
#current trend information from a given location, which is specified 
#using a WOEID (see http://developer.yahoo.com/geo/geoplanet/).

avail_trends = availableTrendLocations()
head(avail_trends)

close_trends = closestTrendLocations(-42.8, -71.1)
head(close_trends)

trends = getTrends(2367105)
head(trends)

#example of how one can interact with actual data.
# Here we will pull the most recent results from the public timeline and
# see the clients that were used to post those statuses.
# We can look at a pie chart to get a sense for the most common clients.
r_tweets <- searchTwitter("#rstats", n=300)
sources <- sapply(r_tweets, function(x) x$getStatusSource())
sources <- gsub("</a>", "", sources)
sources <- strsplit(sources, ">")
sources <- sapply(sources, function(x) ifelse(length(x) > 1, x[2], x[1]))
source_table = table(sources)
pie(source_table[source_table > 10])

