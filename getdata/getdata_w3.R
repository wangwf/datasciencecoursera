
'''
 The goal of tidy data
   Each variable forms a column
   Each observation froms a row
   Each table/file stores data about one kind of observation (e.g. people/hospital)
'''

##Melting data frames
library(reshape2)
head(mtcars)
tail(mtcars)

mtcars$carname <-rownames(mtcars)
carMelt <- melt(mtcars, id=c("carname", "gear", "cyl"), measure.vars=c("mpg","hp"))

#Casting data frames
cylData <-dcast(carMelt, cyl ~ variable)
cylData


#Averaging values
head(InsectSprays)
tapply(InsectSprays$count, InsectSprays$spray, sum)

# Another way -split
spIns <- split(InsectSprays$count, InsectSprays$spray)
spIns

sprCount <-lapply(spIns, sum)
sprCount


unlist(sprCount)
sapply(spIns, sum)

ddply(InsectSpray, .(spray), summarize, sum=sum(count))


##Creating a new variable
spraySums <- ddply(InsectSprays, .(spray), summarize, sum=ave(count, FUN=sum))
dim(spraySums)

