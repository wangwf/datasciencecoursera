makeVector <- function(x=numberic()){
    m <- NULL
    set <-function(y){
        x <<- y ## <<- operator assign a value to object in an environment, not current one
        m <<- NULL
    }
    get <- function() x
    setmean <- function(mean) m <<- mean
    getmean <- function() m
    list( set = set, get=get,
          setmean = setmean,
          getmean = getmean)
}
