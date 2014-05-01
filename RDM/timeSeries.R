
#Time Series Analysis
#
# Time Series Decomposition
# Time series decomposition is to decompose a time series
# into trend, seasonal, cyclical and irregular components

timeSerie <- function(){
    data(AirPassengers)
    f<-decompose(AirPassengers)

    str(f)
    # seasonal figures
    f$figure
    plot(f$figure, type="b", xaxt ="n", xlab ="")

    #get names of 12 months in English words
    monthNames <- months(ISOdate(2011,1:12,1))
    #lable x-axis with month names
    #las is set to 2 for vertical label orientation
    axis(1, at=1:12, labels =monthNames, las=2)

    plot(f)
}

timeSeriesForecasting <- function(){
    fit <- arima(AirPassengers, order=c(1,0,0), list(order=c(2,1,0), period=12))
    fore <- predict(fit, n.ahead=24)
    # error bounds at 95% confidence level
    U <- fore$pred + 2*fore$se
    L <- fore$pred - 2*fore$se
    ts.plot(AirPassengers, fore$pred, U, L, col=c(1,2,4,4), lty = c(1,1,2,2))
    legend("topleft", c("Actual", "Forcast", "Error Bounds (95% Confidence)"), col=c(1,2,4), lty=c(1,1,2))
   }

# Time serie clustering is to partition time series data into groups based on similarity or distance,
# so that time series in the same cluster are similar to each other.
# Euclidean sitance, Manhanttan distance, Maximum norm, Hamming distance. 
# angle between two vectors (inner product)
# and Dynamic Time Warping.
timeSeriesClustering <- function(){
  library(dtw) 
  idx <- seq(0, 2*pi, len=100)
  
  a <- sin(idx) + runif(100)/10
  b <- cos(idx)
  align <- dtw(a, b, step=asymmetricP1, keep=TRUE)
  dtwPlotTwoWay(align)
  
}
SyntheticControlChart <- function(){
  url <- "http://kdd.ics.uci.edu/databases/synthetic_control/synthetic_control.data"
  download.file(url, destfile="./data/synthetic_control.data",method="curl")
  sc <-   read.table("./data/synthetic_control.data", header=F, sep="")
  # show one sample from each class
  idx <- c(1,101,201,301,401,501)
  sample1 <- t(sc[idx,])
  plot.ts(sample1, main="")
  
#}
#hie <- function(){
  # Hierarchical clustering with Eucildean distanc
  set.seed(6218)
  
  n <- 10
  s <- sample(1:100, n)
  idx <- c(s, 100+s, 200+s, 300+s, 400+s, 500+s)
  sample2 <- sc[idx,]
  observedLabels <- rep(1:6, each=n)
  # hierarchical clustering with Euclidean distance
  hc <- hclust(dist(sample2), method="average")
  plot(hc, labels=observedLabels, main="")
  # cut tree to get 6 clusters
  rect.hclust(hc, k=6)
  memb <- cutree(hc, k=6)
  table(observedLabels, memb)
  
  # Hierarchical clustering with DTW
  library(dtw)
  distMatrix <- dist(sample2, method="DTW")
  hc <- hclust(distMatrix, method="average")
  plot(hc, labels=observedLabels, main="")
  # cut tree to get 6 clusters
  rect.hclust(hc, k=6)
  memb <- cutree(hc, k=6)
  table(observedLabels, memb)

           
}

# Time series classification is to build a classification model based on labeled time series and then
# use the model to predict the label of unlabeled time series. New features extracted from time series
# may help to improve the performance of classification models. Techniques for feature extraction
# include Singular Value Decomposition (SVD), Discrete Fourier Transform (DFT), Discrete Wavelet
# Transform (DWT), Piecewise Aggregate Approximation (PAA), Perpetually Important Points
# (PIP), Piecewise Linear Representation, and Symbolic Representation.

timeSeriesClassification <- function(){
  classId <- rep(as.character(1:6), each=100)
  newSc <- data.frame(cbind(classId, sc))
  library(party)
  ct <- ctree(classId ~ ., data=newSc,
              controls = ctree_control(minsplit=30, minbucket=10, maxdepth=5))
  pClassId <- predict(ct)
  table(classId, pClassId)
  
  # accuracy
  (sum(classId==pClassId)) / nrow(sc)
  plot(ct, ip_args=list(pval=FALSE), ep_args=list(digits=0))
}  
  
  
withNewFeature <-function(){  
  library(wavelets)
  wtData <- NULL
  for (i in 1:nrow(sc)) {
    a <- t(sc[i,])
    wt <- dwt(a, filter="haar", boundary="periodic")
    wtData <- rbind(wtData, unlist(c(wt@W, wt@V[[wt@level]])))
  }
  wtData <- as.data.frame(wtData)
  wtSc <- data.frame(cbind(classId, wtData))
   # build a decision tree with DWT coefficients
  ct <- ctree(classId ~ ., data=wtSc,
                  + controls = ctree_control(minsplit=30, minbucket=10, maxdepth=5))
   pClassId <- predict(ct)
   table(classId, pClassId)
  (sum(classId==pClassId)) / nrow(wtSc)
  plot(ct, ip_args=list(pval=FALSE), ep_args=list(digits=0))
  
}


knn <- function(){
  k <- 20
  # create a new time series by adding noise to time series 501
  newTS <- sc[501,] + runif(100)*15
  distances <- dist(newTS, sc, method="DTW")
  s <- sort(as.vector(distances), index.return=TRUE)
  # class IDs of k nearest neighbors
  table(classId[s$ix[1:k]])
  
}