
## download and unzip files
downloadFiles<-function(
    dataURL="https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
    ){
    if(!file.exists("./UCI_HAR_Dataset/")){
        dir.create("./UCI_HAR_Dataset")
        temp <-tempfile()
        download.file(dataURL, temp, method="curl")
        unzip(temp,exdir=".")
        ## rename dir-name ""UCI HAR Dataset" to "UCI_HAR_Dataset"
        # mv UCI\ HAR\ Dataset/ UCI_HAR_Dataset
        file.rename("UCI HAR Dataset", "UCI_HAR_Dataset")
        unlink(temp)
    }else{
      message("UCI_HAR_Dataset already downloaded.")
    }
}

# subject_*.txt, one of 30 volunteers
# X_train.txt/X_test.txt, 561-feature vector with time and frequencey domain variable
# y_train.txt/y_test.txt, 1:6, one of six activities ( (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING))

# ReadData and 
# Extracts only the measurements on the mean and standard deviation for each measurement. 
readData <- function(pathPrefix = "UCI_HAR_Dataset/train", fileSuffix = "train", nsampleSize = -1L){
    #read subject
    subject <- read.table(paste0(pathPrefix,"/subject_",fileSuffix,".txt"),nrows=nsampleSize,
                         col.names=c("subjectID"))

    # read the measurement variables -- features
    features <- read.table(paste0(pathPrefix,"/../features.txt"),
                           col.names=c("featureID","featureName"))

    #Extracts only the measurements on the mean and standard deviation for each measurement
    # Note: exclude variables with meanFreq()
    selectedFeatures <- features[grepl("mean\\(\\)|std\\(\\)", features$featureName),]

    #read X data, and subseting
    data <- read.table(paste0(pathPrefix,"/X_",fileSuffix,".txt"), nrows=nsampleSize,
                    col.names=features$featureName)
    data <- data[,selectedFeatures$featureID]

    #read y data -- activities
    Y <- read.table(paste0(pathPrefix,"/y_",fileSuffix,".txt"), nrows=nsampleSize,
                col.names=c("activityID"))
    
    # append the length of activity and subject
    if( nrow(subject) != nrow(data)){message("Error: Mismatch between subject_*.txt and X_*.txt")}
    if( nrow(subject) != nrow(Y)){message("Error: Mismatch between subject_*.txt and y_*.txt")}

    data <- cbind(subject, Y, data)
    data
}

#Merge the training and the test sets to create one data set.
mergeData<-function(){
    nsampleSize = -1L  # set small number for testing
    trainData <- readData("UCI_HAR_Dataset/train", "train", nsampleSize)
    testData  <- readData("UCI_HAR_Dataset/test","test", nsampleSize)
    mergeData <-rbind(trainData, testData)
    mergeData
}


## 3. Uses descriptive activity names to name the activities in the data set
## 4. Appropriately labels the data set with descriptive activity names. 
activityLabel <- function(data, labelFile="UCI_HAR_Dataset//activity_labels.txt"){
    activityLabels <- read.table(labelFile,col.names=c("activityID","activityName"))
    activityLabels$activityName <- as.factor(activityLabels$activityName)
    dataLabled<-merge(data,activityLabels)
    dataLabled
}

## 5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject. 
createTidyDataset <- function(data){
    library(reshape2)
    #melt the dataset
    ids <- c("activityID","activityName", "subjectID")
    measureVar <-setdiff(colnames(data), ids)
    meltedData <- melt(data, iid=ids, measure.vars=measureVar)
    
    #casting
    dcast(meltedData, activityName + subjectID ~variable, mean)
}

#create a tidy data file and save it
writeTidyDataFile <-function(outputfile="tidydata.txt"){
    tidyData <- createTidyDataset( activityLabel(mergeData()))
    write.table(tidyData, outputfile)
}