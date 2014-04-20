agecount <- function(age = NULL) {
        if(is.null(age)){
                stop("Age parameter cannot be null.")
        } else if(age < 1 | age > 150){
                stop("Let's not be absurd now...")
        } else if(!is.numeric(age)) {
                stop("Only integer values accepted.")
        } else {
                homicides <- readLines("homicides.txt")
                s <- paste('( |,)', age, ' years old', sep='')
                r <- regexpr(s, homicides)
                c <- 0
                for(i in r){
                        if(i != -1){
                                c <- c + 1
                        }
                }
                return(c)
        }
}