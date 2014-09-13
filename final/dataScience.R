#
#
# Data Science with R
#
library(tm)
library(SnowballC)
library(RColorBrewer)
library(ggplot2)
library(Rgraphviz)


# Required packages
library(tm)
library(wordcloud)
# Locate and load the Corpus.
cname <- file.path(".", "corpus", "txt")
docs <- Corpus(DirSource(cname))
docs
summary(docs)
inspect(docs[[1]])
# Transforms
for (j in seq(docs))
{
    docs[[j]] <- gsub("/", " ", docs[[j]])
    docs[[j]] <- gsub("@", " ", docs[[j]])
    docs[[j]] <- gsub("\\|", " ", docs[[j]])
}
docs <- tm_map(docs, content_transformer(tolower)
docs <- tm_map(docs, removeNumbers)
docs <- tm_map(docs, removePunctuation)
docs <- tm_map(docs, removeWords, stopwords("english"))
docs <- tm_map(docs, removeWords, c("own", "stop", "words"))
docs <- tm_map(docs, stripWhitespace)
for (j in seq(docs))
{
    docs[[j]] <- gsub("specific transform", "ST", docs[[j]])
    docs[[j]] <- gsub("other specific transform", "OST", docs[[j]])
}
docs <- tm_map(docs, stemDocument)