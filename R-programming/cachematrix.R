## Put comments here that give an overall description of what your functions do

##
## function to create a matrix
makeCacheMatrix <- function(x = matrix()) {
    invM <- NULL
    #set the new matrix
    set <- function(y){
        x <<- y
        invM <<- NULL
    }
    # gets the original matrix
    get <- function() x
    #sets the inversed matrix
    setinvM <- function(invMatrix) invM <<- invMatrix
    # returns the inversed one
    getinvM  <- function() invM
    # returns a  list
    list(set = set, get = get,
         setinvM = setinvM,
         getinvM = getinvM)
}


## if the inverse-matrix is null, create one with solve()/ginv()
## otherwise use cached value
cacheSolve <- function(x, ...) {
        ## Return a matrix that is the inverse of 'x'
    invM <- x$getinvM()
    #check whether invM is NULL
    if(!is.null(invM)){
        message("getting cached data")
        return(invM)
    }
    ## the invM is NULL, compute it
    data <- x$get()
    invM <-solve(data) # or using ginv(data) in MASS package
    x$setinvM(invM)
    invM
}

## two tests
x<-rbind(c(1, -1/4), c(-1/4, 1))  
xMat<-makeCacheMatrix(x)
invxM <-cacheSolve(xMat)
invxM <-cacheSolve(xMat)
x %*% invxM

x<-matrix(c(1,2,3,0,1,4,5,6,0),3,3)
xMat<-makeCacheMatrix(x)
invxM <-cacheSolve(xMat)
invxM <-cacheSolve(xMat)
x %*% invxM


