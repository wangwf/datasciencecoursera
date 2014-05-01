
#Association Rule

str(Titanic)
df <- as.data.frame(Titanic)
head(df)

titanic.raw <- NULL
for(i in 1:4) {
  titanic.raw <- cbind(titanic.raw, rep(as.character(df[,i]), df$Freq))
}
titanic.raw <- as.data.frame(titanic.raw)
names(titanic.raw) <- names(df)[1:4]
dim(titanic.raw)

str(titanic.raw)
head(titanic.raw)
summary(titanic.raw)

#A classic algorithm for association rule mining is APRIORI [Agrawal and Srikant, 1994]. It is a
#level-wise, breadth-first algorithm which counts transactions to find frequent itemsets and then
#derive association rules from them. An implementation of it is function apriori() in package
#arules [Hahsler et al., 2011]. Another algorithm for association rule mining is the ECLAT algorithm
#[Zaki, 2000], which finds frequent itemsets with equivalence classes, depth-first search and set
#intersection instead of counting. It is implemented as function eclat() in the same package.
#
#Below we demonstrate association rule mining with apriori(). With the function, the default
#settings are: 1) supp=0.1, which is the minimum support of rules; 2) conf=0.8, which is the
#minimum confidence of rules; and 3) maxlen=10, which is the maximum length of rules.

library(arules)
# find association rules with default settings
rules.all <- apriori(titanic.raw)
rules.all

inspect(rules.all)

rules <- apriori(titanic.raw, control = list(verbose=F),
                 parameter = list(minlen=2, supp=0.005, conf=0.8),
                 appearance = list(rhs=c("Survived=No", "Survived=Yes"),
                                   default="lhs"))
quality(rules) <- round(quality(rules), digits=3)
rules.sorted <- sort(rules, by="lift")
 inspect(rules.sorted)


# Removing Redundancy
#Some rules generated in the previous section (see rules.sorted, page 89) provide little or no
#extra information when some other rules are in the result. For example, the above rule 2 provides
#no extra knowledge in addition to rule 1, since rules 1 tells us that all 2nd-class children survived.
#Generally speaking, when a rule (such as rule 2) is a super rule of another rule (such as rule 1)
#and the former has the same or a lower lift, the former rule (rule 2) is considered to be redundant.
#Other redundant rules in the above result are rules 4, 7 and 8, compared respectively with rules 3, 6 and 5.
#Below we prune redundant rules. Note that the rules have already been sorted descendingly
#by lift.


  
  # find redundant rules
  subset.matrix <- is.subset(rules.sorted, rules.sorted)
  subset.matrix[lower.tri(subset.matrix, diag=T)] <- NA
  redundant <- colSums(subset.matrix, na.rm=T) >= 1
  which(redundant)
 # remove redundant rules
  rules.pruned <- rules.sorted[!redundant]
  inspect(rules.pruned)


    rules <- apriori(titanic.raw,
                   parameter = list(minlen=3, supp=0.002, conf=0.2),
                   appearance = list(rhs=c("Survived=Yes"),
                                       lhs=c("Class=1st", "Class=2nd", "Class=3rd",
                                               "Age=Child", "Age=Adult"),
                                       default="none"),
                   control = list(verbose=F))
   rules.sorted <- sort(rules, by="confidence")
   inspect(rules.sorted)


library(arulesViz)
 plot(rules.all)
