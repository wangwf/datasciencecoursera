load("../courses/04_ExploratoryAnalysis/clusteringExample/data/samsungData.rda")
names(samsungData)[1:12]

table(samsungData$activity)

#
#plotting average acceleration for first subject
#
samsungData <- transform(samsungData, activity = factor(activity))
sub1 <-subset(samsungData, subject ==1)

par(mfrow = c(1, 2), mar = c(5, 4, 1,1))
plot(sub1[,1], col=sub1$activity, ylab = names(sub1)[1])
plot(sub1[,2], col=sub1$activity, ylab = names(sub1)[2])
legend("bottomright", legend = unique(sub1$activi), col = unique(sub1$activity),
       pch=1)

#plotting max acceleration
par(mfrow = c(1, 2))
plot(sub1[, 10], pch = 19, col = sub1$activity, ylab = names(sub1)[10])
plot(sub1[, 11], pch = 19, col = sub1$activity, ylab = names(sub1)[11])

#Singular Value decomposition
svd1 = svd(scale(sub1[, -c(562, 563)]))
par(mfrow = c(1, 2))
plot(svd1$u[, 1], col = sub1$activity, pch = 19)
plot(svd1$u[, 2], col = sub1$activity, pch = 19)

plot(svd1$v[, 2], pch = 19)

maxContrib <- which.max(svd1$v[, 2])
distanceMatrix <- dist(sub1[, c(10:12, maxContrib)])
hclustering <- hclust(distanceMatrix)
myplclust(hclustering, lab.col = unclass(sub1$activity))
names(samsungData)[maxContrib]

#kmean clustering
kClust <- kmeans(sub1[, -c(562, 563)], centers = 6)
table(kClust$cluster, sub1$activity)

kClust <- kmeans(sub1[, -c(562, 563)], centers = 6, nstart = 1)
table(kClust$cluster, sub1$activity)

kClust <- kmeans(sub1[, -c(562, 563)], centers = 6, nstart = 100)
table(kClust$cluster, sub1$activity)