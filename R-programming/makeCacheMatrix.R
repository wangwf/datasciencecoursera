makeCachematrix <-function(x=matrix()){
    invM <- NULL
    set <- function(y){
        x <<- y
        invM <<- NULL
    }
    get <- function() invM
    setinvM <- function(invMatrix) invM <<- invMatrix
    getinM  <- function() invM
    list(set = set, get = get,
         setinvM = setinvM,
         getinvM = getinvM)
}

cacheSolve <- function(x, ...){
    invM <- x$getinM()
    if(!is.null(invM)){
        message("getting cached data")
        return(invM)
    }
    data <- x$get()
    invM <-solve(data) 
    x$setinvM(invM)
    invM
}