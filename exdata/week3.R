
#
#Hierarchical clustering
#

hierarchical <- function(){
    set.seed(1234)
    par(mar=c(0,0,0,0))
    x <- rnorm(12, mean=rep(1:3, each=4), sd = 0.2)
    y <- rnorm(12, mean=rep(c(1,2,1), each =4), sd = 0.2)
    plot(x, y, col="blue", pch=19, cex =2)
    text(x +0.05, y + 0.05, labels = as.character(1:12))
    dataFrame  <- data.frame(x = x, y = y)
    distxy <- dist(dataFrame)
    
    hClustering <- hclust(distxy)
    plot(hClustering)
    #hc <- rect.hclust(hClustering, k=3)
    myplclust(hClustering, lab= rep(1:3, each=4), lab.col = rep(1:3, each =4))
}

myplclust <- function(hclust, lab=hclust$labels, lab.col=rep(1, length(hclust$labels)),
                      hang = 0.1,...){
    ##
    y <- rep(hclust$height, 2)
    x <- as.numeric(hclust$merge)
    y <- y[which(x <0 )]
    x <- x[which(x <0 )]
    x <- abs(x)
    y <- y[order(x)]
    x <- x[order(x)]
    plot(hclust, labels = FALSE, hang =hang, ...)
    text(x =x, y = y[hclust$order] - (max(hclust$height)* hang), labels = lab[hclust$order],
         col = lab.col[hclust$order], srt =90, adj = c(1, 0.5), xpd = NA, ...)
    
}

heatmapEx1 <- function(){
    dataFrame <- data.frame(x =x, y=y)
    set.seed(143)
    dataMatrix <-as.matrix(dataFrame)[sample(1:12),]
    heatmap(dataMatrix)
}

# k-mean
kmeanEx <- function(){
    dataFrame <- data.frame(x =x, y=y)
    kmeansObj <- kmeans(dataFrame, centers=3)
    names(kmeansObj)
    
    kmeansObj$cluster
    par( mar = rep(0.2, 4))
    plot(x, y, col= kmeansObj$cluster, pch=19, cex =2)
    points(kmeansObj$centers, col=1:3, pch =3, cex =3, lwd=3)
    
    #Heatmaps
    set.seed(1234)
    dataMatrix <- as.matrix(dataFrame)[sample(1:12), ]
    kmeansObj2 <- kmeans(dataMatrix, centers =3)
    par(mfrow = c(1,2), mar =c(2,4, 0.1, 0.1))
    image(t(dataMatrix)[, nrow(dataMatrix):1], yaxt="n")
    image(t(dataMatrix)[, order(kmeansObj2$cluster)], yaxt="n")
    
}


## Dimensional reduction
dimRedu <- function(){
    set.seed(12345)
    par(mar = rep(0.2, 4))
    dataMatrix <- matrix(rnorm(400), nrow=40)
    image(1:10, 1:40, t(dataMatrix)[, nrow(dataMatrix):1])
    
    #cluster the data
    par(mar =rep(0.2, 4))
    heatmap(dataMatrix)
    
    #add a pattern
    set.seed(678910)
    for (i in 1:40){
        #flip a coin
        coinFlip <- rbinom(1, size =1, prob = 0.5)
        #if coin is heads add a common pattern to that row
        if (coinFlip){
            dataMatrix[i, ] <- dataMatrix[i, ] + rep(c(0,3), each=5)
        }
    }
    
    
    hh <- hclust(dist(dataMatrix))
    dataMatrixOrdered <- dataMatrix[hh$order, ]
    par(mfrow = c(1, 3))
    image(t(dataMatrixOrdered)[, nrow(dataMatrixOrdered):1])
    plot(rowMeans(dataMatrixOrdered), 40:1, , xlab = "Row Mean", ylab = "Row", pch = 19)
    plot(colMeans(dataMatrixOrdered), xlab = "Column", ylab = "Column Mean", pch = 19)
    
}

#
# SVD   X = UDV^T
#  X: matrix
#  U : the column of U are orthogonal (left singular vector)
#  V : the column of V are orthogognal (right singular vector)
#  D : a diagonal matrix (single values)
# PCA: the principal components are equal to the right single values if you firstscale the values 
#      ( subtract the mean, divide by the standard deviation)
#
svdEX <- function(){
    svd1 <- svd(scale(dataMatrixOrdered))
    par(mfrow = c(1, 3))
    image(t(dataMatrixOrdered)[, nrow(dataMatrixOrdered):1])
    plot(svd1$u[, 1], 40:1, , xlab = "Row", ylab = "First left singular vector",
         pch = 19)
    plot(svd1$v[, 1], xlab = "Column", ylab = "First right singular vector", pch = 19)
    
    # Variance 
    par(mfrow = c(1, 2))
    plot(svd1$d, xlab = "Column", ylab = "Singular value", pch = 19)
    plot(svd1$d^2/sum(svd1$d^2), xlab = "Column", ylab = "Prop. of variance explained",
         pch = 19)
    
    # relationship to principal components
    pca1 <- prcomp(dataMatrixOrdered, scale = TRUE)
    plot(pca1$rotation[, 1], svd1$v[, 1], pch = 19, xlab = "Principal Component 1",
         ylab = "Right Singular Vector 1")
    abline(c(0, 1))
    
    
    #
    # Component of the SVD
    #
    constantMatrix <- dataMatrixOrdered*0
    for(i in 1:dim(dataMatrixOrdered)[1]){constantMatrix[i,] <- rep(c(0,1),each=5)}
    svd1 <- svd(constantMatrix)
    par(mfrow=c(1,3))
    image(t(constantMatrix)[,nrow(constantMatrix):1])
    plot(svd1$d,xlab="Column",ylab="Singular value",pch=19)
    plot(svd1$d^2/sum(svd1$d^2),xlab="Column",ylab="Prop. of variance explained",pch=19)
    
    set.seed(678910)
    for (i in 1:40) {
        # flip a coin
        coinFlip1 <- rbinom(1, size = 1, prob = 0.5)
        coinFlip2 <- rbinom(1, size = 1, prob = 0.5)
        # if coin is heads add a common pattern to that row
        if (coinFlip1) {
            dataMatrix[i, ] <- dataMatrix[i, ] + rep(c(0, 5), each = 5)
        }
        if (coinFlip2) {
            dataMatrix[i, ] <- dataMatrix[i, ] + rep(c(0, 5), 5)
        }
    }
    hh <- hclust(dist(dataMatrix))
    dataMatrixOrdered <- dataMatrix[hh$order, ]
    
    #Singular Value decomposition -- true pattern
    svd2 <- svd(scale(dataMatrixOrdered))
    par(mfrow = c(1, 3))
    image(t(dataMatrixOrdered)[, nrow(dataMatrixOrdered):1])
    plot(rep(c(0, 1), each = 5), pch = 19, xlab = "Column", ylab = "Pattern 1")
    plot(rep(c(0, 1), 5), pch = 19, xlab = "Column", ylab = "Pattern 2")
    
    svd2 <- svd(scale(dataMatrixOrdered))
    par(mfrow = c(1, 3))
    image(t(dataMatrixOrdered)[, nrow(dataMatrixOrdered):1])
    plot(svd2$v[, 1], pch = 19, xlab = "Column", ylab = "First right singular vector")
    plot(svd2$v[, 2], pch = 19, xlab = "Column", ylab = "Second right singular vector")
    
    
    # d and variance explained
    svd1 <- svd(scale(dataMatrixOrdered))
    par(mfrow = c(1, 2))
    plot(svd1$d, xlab = "Column", ylab = "Singular value", pch = 19)
    plot(svd1$d^2/sum(svd1$d^2), xlab = "Column", ylab = "Percent of variance explained",
         pch = 19)
    
    # missing values
    dataMatrix2 <- dataMatrixOrdered
    ## Randomly insert some missing data
    dataMatrix2[sample(1:100, size = 40, replace = FALSE)] <- NA
    svd1 <- svd(scale(dataMatrix2)) ## Doesn't work!
    
    library(impute) ## Available from http://bioconductor.org
    dataMatrix2 <- dataMatrixOrdered
    dataMatrix2[sample(1:100,size=40,replace=FALSE)] <- NA
    dataMatrix2 <- impute.knn(dataMatrix2)$data
    svd1 <- svd(scale(dataMatrixOrdered));
    svd2 <- svd(scale(dataMatrix2))
    par(mfrow=c(1,2));
    plot(svd1$v[,1],pch=19);
    plot(svd2$v[,1],pch=19)
    
    #
    # Face example
    #load("data/face.rda")
    load("../courses/04_ExploratoryAnalysis/dimensionReduction/data/face.rda")
    image(t(faceData)[, nrow(faceData):1])
    
    svd1 <- svd(scale(faceData))
    plot(svd1$d^2/sum(svd1$d^2), pch = 19, xlab = "Singular vector", ylab = "Variance explained")
    
    svd1 <- svd(scale(faceData))
    ## Note that %*% is matrix multiplication
    # Here svd1$d[1] is a constant
    approx1 <- svd1$u[, 1] %*% t(svd1$v[, 1]) * svd1$d[1]
    # In these examples we need to make the diagonal matrix out of d
    approx5 <- svd1$u[, 1:5] %*% diag(svd1$d[1:5]) %*% t(svd1$v[, 1:5])
    approx10 <- svd1$u[, 1:10] %*% diag(svd1$d[1:10]) %*% t(svd1$v[, 1:10])
    
    par(mfrow = c(1, 4))
    image(t(approx1)[, nrow(approx1):1], main = "(a)")
    image(t(approx5)[, nrow(approx5):1], main = "(b)")
    image(t(approx10)[, nrow(approx10):1], main = "(c)")
    image(t(faceData)[, nrow(faceData):1], main = "(d)")    ## Original data
    
}