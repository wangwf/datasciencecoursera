
# univariate outlier detection

#boxplot.stats(), returns the statistics for producing boxplots.
OutlierByBoxplot <- function(){
  set.seed(3147)
  x<-rnorm(100)
  summary(x)

  boxplot.stats(x)$out
  boxplot(x)
  
  # multivariate data
  y<-rnorm(100)
  df <- data.frame(x,y)
  rm(x,y)
  head(df)
  attach(df) # attached to the R search path.
  (a<-which(x %in% boxplot.stats(x)$out)) # index of outliers from x
  (b<-which(y %in% boxplot.stats(y)$out)) # index of outliers from y

  detach(df)

  plot(df)
  outlier.list1 <-intersect(a,b)
  points(df[outlier.list1,], col="red", pch="+", cex=2.5)

  outlier.list2 <-union(a,b)
  points(df[outlier.list2,], col="blue", pch="x", cex=2.0)

}
  ### Outlier Detection with LOF
  # LOF (Local Outlier Factor)

OutlierLOF <- function(){
  library(DMwR)
  iris2 <-iris[,1:4]
  outlier.scores <- lofactor(iris2, k=5)
  plot(density(outlier.scores))
  
  #pick top 5 as outlier
  outliers <- order(outlier.scores, decreasing=TRUE)[1:5]
  print(outliers)
  print(iris2[outliers,])
  
  n <- nrow(iris2)
  labels <- 1:n
  labels[-outliers] <- "."
  biplot(prcomp(iris2), cex=.8, xlabs=labels) #  prcomp()  principle component analysis; biplo
  
  pch <- rep(".", n)
  pch[outliers] <- "+"
  col <- rep("black", n)
  col[outliers] <- "red"
  pairs(iris2, pch=pch, col=col)
  
  ## Package Rlof provides lof(), a parallel implementation of the LOF algorithm
  library(Rlof)
  outlier.scores <- lof(iris2, k=5)
  CHAPTER 7. OUTLIER DETECTION
  # try with different number of neighbors (k = 5,6,7,8,9 and 10)
  outlier.scores <- lof(iris2, k=c(5:10))
  
}

# By grouping data into clustering, those data not assigned to any clusters are taken as outliers
# Density-based clustering
OutlierByClustering <-function(){
  iris2 <- iris[,1:4]
  kmeans.result <- kmeans(iris2, centers =3)
  kmeans.result$centers  # cluster centers
  kmeans.result$cluster
  
  # calculate distances between objects and cluster centers
  centers <- kmeans.result$centers[kmeans.result$cluster, ]
  distances <- sqrt(rowSums((iris2 - centers)^2))
  # pick top 5 largest distances
  outliers <- order(distances, decreasing=T)[1:5]
  # who are outliers
  print(outliers)
  
  print(iris2[outliers,])
 
  plot(iris2[,c("Sepal.Length", "Sepal.Width")], pch="o",
       col=kmeans.result$cluster, cex=0.3)
  # plot cluster centers
  points(kmeans.result$centers[,c("Sepal.Length", "Sepal.Width")], col=1:3,
         pch=8, cex=1.5)
  # plot outliers
  points(iris2[outliers, c("Sepal.Length", "Sepal.Width")], pch="+", col=4, cex=1.5)
  
}

#outlier detection from time series data.
# In this example, the time series data are first decomposed with robust regression using function stl().
# STL (Seasonal-trend decomposition based on Loess)
OutlierFromTimeSeries <- function(){
  f <- stl(AirPassengers, "periodic", robust=TRUE)
  (outliers <-which(f$weights <1e-8))
  
  #set layout
  op <- par(mar=c(0, 4, 0, 3), oma=c(5, 0, 4, 0), mfcol=c(4, 1))
  plot(f, set.pars=NULL)
  
  sts <- f$time.series
  # plot outliers
  points(time(sts)[outliers], 0.8*sts[,"remainder"][outliers], pch="x", col="red")
  par(op) # reset layout
  
}
