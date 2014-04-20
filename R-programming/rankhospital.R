rankhospital <- function(state, outcome, num){
  ## REad outcome data
  data <- read.csv("outcome-of-care-measures.csv", colClasses = "character")
  outcomes <-c("heart attack", "heart failure", "pneumonia")
  indics   <-c(11, 17, 23)
  
  ## Check state and outcome are valid
  if (!state %in% data$State) stop("invalid state")
  if (!outcome %in% outcomes) stop("invalid outcome")
  
  i <- indics[match(outcome, outcomes)]
  
  hospitals <- data[data$State == state, c(2,i)]
  hospitals[,2] <- as.numeric(hospitals[,2])
  names(hospitals)<- c("hospital", "deathRate")
#  hospitals <- na.omit(hospitals)

  a<- rank(hospitals[,2], na.last=NA)
  
  if (num =="best"){
    r <- 1
  } else if( num =="worst"){
     r<- length(a)
  }else if (num <= length(a)){
    r <- num
  }else{
    return(NA)
  }
  return(hospitals$hospital[order(hospitals$deathRate, hospitals$hospital)[r]])
}