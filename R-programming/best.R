## Find the best hospital in a state
best <- function(state, outcome){
  data <- read.csv("outcome-of-care-measures.csv", colClasses = "character")
  outcomes <-c("heart attack", "heart failure", "pneumonia")
  indics   <-c(11, 17, 23)
  
  if (!state %in% data$State) stop("invalid state")
  if (!outcome %in% outcomes) stop("invalid outcome")
  
  i <- indics[match(outcome, outcomes)]
  
  hospitals <- data[data$State == state, c(2,i)]
  hospitals[,2] <- as.numeric(hospitals[,2])
  names(hospitals)<- c("name", "deathRate")
  hospitals <- na.omit(hospitals)
  
  minDeath <- min(hospitals$deathRate)
  
  candidates <- hospitals[hospitals$deathRate==minDeath,]$name
  return(as.character(sort(candidates)[1]))
}