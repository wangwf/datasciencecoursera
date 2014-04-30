quicksort <- function (xxs) {
    size <- length(xxs)
    
    if (size < 2) return(xxs)
    
    x <- xxs[1]
    xs <- xxs[2:size]
    
    lesser <- NULL
    greater <- NULL
    
    for (y in xs) {
        if (y < x) lesser <- c(lesser, y)
        else greater <- c(greater, y)
    }
    
    c(quicksort(lesser), x, quicksort(greater))
}