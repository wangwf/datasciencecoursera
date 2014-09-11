
fblog <- "en_US/en_US.blogs.txt"
fnews <- "en_US//en_US.news.txt"
ftwitter <- "en_US//en_US.twitter.txt"

# egrep -n "^.{$(wc -L < en_US/en_US.blogs.txt )}$" en_US/en_US.blogs.txt 
# awk '{ print length(), NR, $0 | "sort -rn" }' en_US/en_US.blogs.txt | head -n 1
40836 483415
# awk '{ print length(), NR, $0 | "sort -rn" }' en_US/en_US.news.txt | head -n 1
11385 123628
# awk '{ print length(), NR, $0 | "sort -rn" }' en_US/en_US.twitter.txt | head -n 1
214 1484357

tw <- readLines("en_US/en_US.twitter.txt")
length(tw)

nlove =0
nhate =0
str1= "love"
str2= "hate"
for( line in 1:length(tw)){
    if(grepl(str1, tw[line])) nlove = nlove +1
    if(grepl(str2, tw[line])) nhate = nhate +1
}
print(nlove)
print(nhate)
ratio = nlove/nhate
print(ratio)

str3 = "biostats"
#for( line in 1:length(tw)){ if(grepl(str3, tw[line])) print(tw[line]) }
lapply(tw, function(x) if(grepl(str3, x))print(x))


str4="A computer once beat me at chess, but it was no match for me at kickboxing"
nl = 0
lapply(tw, function(x) if(grep(str4, x))nl = nl+1)
#for(line in 1:length(tw)){ if(grepl(str4, tw[line]))nl = nl+1}weq415aghls
print(nl)


tw <- readLines("en_US/en_US.twitter.txt")

length(tw)
head(tw)
tail(tw)

#tw = strsplit(tw, "<<[^>]*>>")[1]
#length(tw)
library(tm)  # text mining package
doc.vec <- VectorSource(tw)
doc.corpus <-Corpus(doc.vec)
summary(doc.corpus)

doc.corpus <- tm_map(doc.corpus, tolower)
doc.corpus <- tm_map(doc.corpus, removePunctuation)
doc.corpus <- tm_map(doc.corpus, removeNumbers)
doc.corpus <- tm_map(doc.corpus, removeWords, stopwords("english"))


