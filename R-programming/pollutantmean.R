pollutantmean <- function(directory, pollutant, id = 1:332) {
  ## 'directory' is a character vector of length 1 indicating
  ## the location of the CSV files
  
  ## 'pollutant' is a character vector of length 1 indicating
  ## the name of the pollutant for which we will calculate the
  ## mean; either "sulfate" or "nitrate".
  
  ## 'id' is an integer vector indicating the monitor ID numbers
  ## to be used
  
  ## Return the mean of the pollutant across all monitors list
  ## in the 'id' vector (ignoring NA values)
  
  dataFrame<-NULL
  for(i in id){
    df<-getmonitor(i,directory)
    
    #  nobs<-nrow(subset(df,sulfate!="NA" & nitrate!="NA"))  #this is strong-coupled on the data frame format of all the monitors
    #rbind(dataFrame,data.frame(id=i,nobs=nobs))->dataFrame
    rbind(dataFrame, data.frame(df[pollutant][!is.na(df[pollutant])]))->dataFrame
  }
  return(mean(dataFrame[,]))
#  m=mean(dataFrame$pollutant)
#  m =mean(dataFrame[pollutant][!is.na(dataFrame[pollutant])])
#  return(m)
}
#source("pollutantmean.R")
#pollutantmean("specdata", "sulfate", 1:10)
 ## [1] 4.064
#pollutantmean("specdata", "nitrate", 70:72)
 ## [1] 1.706
#pollutantmean("specdata", "nitrate", 23)
 ## [1] 1.281