count <- function(cause=NULL){
        homicides <- readLines("homicides.txt")
        options <- c("asphyxiation", "blunt force",
                        "other", "shooting",
                        "stabbing", "unknown")
        if(is.null(cause) | is.na(match(cause, options))){
                stop("Invalid cause of death specified.")
        } else {
                if(cause=="asphyxiation"){
                        s <- "[Aa]sphyxiation"
                } else if( cause=="blunt force" ){
                        s <- "[Bb]lunt force"
                } else if( cause=="other" ){
                        s <- "[Oo]ther"
                } else if( cause=="shooting" ){
                        s <- "[Ss]hooting"
                } else if( cause=="stabbing" ){
                        s <- "[Ss]tabbing"
                } else if( cause=="unknown" ){
                        s <- "[Uu]nknown"
                }
                return(length(grep(paste("<dd>Cause: ", s, '</dd>', sep=''), homicides)))
        }
}