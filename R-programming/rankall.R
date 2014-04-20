<<<<<<< HEAD
rankall <- function(outcome, num = "best") {
  outcomes <- c('heart attack', 'heart failure', 'pneumonia')
  indices <- c(11, 17, 23)
  
  if (!outcome %in% outcomes) stop("invalid outcome")
  
  data <- read.csv("outcome-of-care-measures.csv")
  
  i <- indices[match(outcome, outcomes)]
  hospitals <- data[, c(2, 7, i)]
  hospitals[, 3] <- as.numeric(as.character(hospitals[, 3]))
=======
##
rankall <- function(outcome, num){
  ## Read outcome data
  data <- read.csv("outcome-of-care-measures.csv")
  outcomes <-c("heart attack", "heart failure", "pneumonia")
  indics   <-c(11, 17, 23)
  
  ## Check state and outcome are valid
  if (!outcome %in% outcomes) stop("invalid outcome")
  
  i <- indics[match(outcome, outcomes)]
  
  hospitals <- data[, c(2,7,i)]
  hospitals[,3] <- as.numeric(hospitals[,3])
  names(hospitals)<- c("hospital", "state","deathRate")
>>>>>>> ca67fe2d14323c3ca4c861bb10759e28a7a95752
  hospitals <- na.omit(hospitals)
  names(hospitals) <- c("hospital", "state", "rate")
  
  if (num == "best") {
    num <- 1
<<<<<<< HEAD
  } else if (num == "worst") {
  } else {
    num <- as.numeric(num)
    if (is.na(num)) {
      stop("invalid num")
    } else if (num > nrow(hospitals)) {
      return(NA)
    }
  }
  
  results <- NULL
  
  for(state in levels(hospitals$state)) {
    hospitals_for_state <- hospitals[hospitals$state == state, ]
    
    if (num == "worst") {
      n <- nrow(hospitals_for_state)
    } else {
      n <- num
    }
    result <- hospitals_for_state[order(hospitals_for_state$rate, hospitals_for_state$hospital), c(1, 2)][n, ]
    result$state <- rep(state, nrow(result))
    results <- rbind(results, result)  
  }
  
  rownames(results) <- NULL
  
=======
  } else if( num =="worst"){
  } else{
    if (is.na(num)) stop("invalid num")
    else if (num>nrow(hospitals)) {
        return(NA)
    }
  }

  hospitals_by_state <- split(hospitals, hospitals$state)
 
  results <- NULL
  for(state in levels(hospitals$state)){
    hospitals_for_state <- hospitals[hospitals$state == state,]
    if(num == "worst"){
        n<- nrow(hospitals_for_state)
    }else{
        n <-num
    }
    result <- hospitals_for_state[order(hospitals_for_state$deathRate, hospitals_for_state$hospital, na.last=NA),c(1,2)][n,]
    result$state <- rep(state, nrow(result))
    results<-rbind(results, state,result)
  }
  rownames(results) <-NULL
>>>>>>> ca67fe2d14323c3ca4c861bb10759e28a7a95752
  return(results)
}