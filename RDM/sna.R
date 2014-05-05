
# Social Media Analysis
source("http://biostat.jhsph.edu/~jleek/code/twitterMap.R")
twitterMap("RDataMining", fileName="twitterMap.pdf", nMax=1500)

# Load Data

# load termDocMatrix
 load("data/termDocMatrix.rdata")
 # inspect part of the matrix
 termDocMatrix[5:10,1:20]

# If the code with your own term-document matrix built with tm package,
# termDocMatrix <- as.matrix(termDocMatrix)

# Transform Data into an Adjacency Matrix
 # change it to a Boolean matrix
 termDocMatrix[termDocMatrix>=1] <- 1
 # transform into a term-term adjacency matrix
 termMatrix <- termDocMatrix %*% t(termDocMatrix) #
 # inspect terms numbered 5 to 10
 termMatrix[5:10,5:10]


# Build a Graph

#Now we have built a term-term adjacency matrix,
# where the rows and columns represents terms,
# and every entry is the number of co-occurrences of two terms.
#Next we can build a graph with graph.adjacency() from package igraph.

library(igraph)
 # build a graph from the above matrix
 g <- graph.adjacency(termMatrix, weighted=T, mode = "undirected")
 # remove loops
 g <- simplify(g)


# Plot the Graph
 # set seed to make the layout reproducible
set.seed(3952)
layout1 <- layout.fruchterman.reingold(g)
plot(g, layout=layout1)


plot(g, layout=layout.kamada.kawai)
tkplot(g, layout=layout.kamada.kawai)

 V(g)$label.cex <- 2.2 * V(g)$degree / max(V(g)$degree)+ .2
 V(g)$label.color <- rgb(0, 0, .2, .8)
 V(g)$frame.color <- NA
 egam <- (log(E(g)$weight)+.4) / max(log(E(g)$weight)+.4)
 E(g)$color <- rgb(.5, .5, 0, egam)
 E(g)$width <- egam
 # plot the graph in layout1
     plot(g, layout=layout1)


# Network of Tweets
#   we can also build a graph of tweets
#   base on the number of terms that they have in common. 
# remove "r", "data" and "mining"
 idx <- which(dimnames(termDocMatrix)$Terms %in% c("r", "data", "mining"))
 M <- termDocMatrix[-idx,]
 # build a tweet-tweet adjacency matrix
 tweetMatrix <- t(M) %*% M
 library(igraph)
 g <- graph.adjacency(tweetMatrix, weighted=T, mode = "undirected")
 V(g)$degree <- degree(g)
 g <- simplify(g)
 # set labels of vertices to tweet IDs
 V(g)$label <- V(g)$name
 V(g)$label.cex <- 1
 V(g)$label.color <- rgb(.4, 0, 0, .7)
 V(g)$size <- 2
 V(g)$frame.color <- NA

barplot(table(V(g)$degree))

 idx <- V(g)$degree == 0
 V(g)$label.color[idx] <- rgb(0, 0, .3, .7)
 # load twitter text
 library(twitteR)
 load(file = "data/rdmTweets.RData")
 # convert tweets to a data frame
 df <- do.call("rbind", lapply(rdmTweets, as.data.frame))
 # set labels to the IDs and the first 20 characters of tweets
 V(g)$label[idx] <- paste(V(g)$name[idx], substr(df$text[idx], 1, 20), sep=": ")
 egam <- (log(E(g)$weight)+.2) / max(log(E(g)$weight)+.2)
 E(g)$color <- rgb(.5, .5, 0, egam)
 E(g)$width <- egam
 set.seed(3152)
 layout2 <- layout.fruchterman.reingold(g)
 plot(g, layout=layout2)

g2 <- delete.vertices(g, V(g)[degree(g)==0])
plot(g2, layout=layout.fruchterman.reingold)
g3 <- delete.edges(g, E(g)[E(g)$weight <= 1])
 g3 <- delete.vertices(g3, V(g3)[degree(g3) == 0])
plot(g3, layout=layout.fruchterman.reingold)

df$text[c(7,12,6,9,8,3,4)]

## Two mode network
