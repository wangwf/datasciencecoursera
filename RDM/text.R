library(twitteR)
# retrieve the first 200 tweets (or all tweets if fewer than 200) from the
# user timeline of @rdatammining
rdmTweets <- userTimeline("rdatamining", n=200)
(nDocs <- length(rdmTweets))
