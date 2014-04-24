
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
    }
}

# subject_*.txt, one of 30 volunteers
# X_train.txt/X_test.txt, 561-feature vector with time and frequencey domain variable
# y_train.txt/y_test.txt, 1:6, one of six activities ( (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING))

# Extracts only the measurements on the mean and standard deviation for each measurement. 
extactFeatures <-function(){
    features <-read.table("./UCI_HAR_Dataset/features.txt") #,colClasses="character")
    #selectedFeatures<-features[grepl("mean()|std()",features[,2]),]
    #  select feature with mean() or std(),  excluding meanFreq()
    # grepl("mean\\(\\)",features[,2]),
    selected<-(grepl("mean()",features[,2],fixed=TRUE)
               |grepl("std()",features[,2],fixed=TRUE))
    selectedFeatures<-features[selected,]
}

readData <- function(pathSuffix = "UCI_HAR_Dataset/train", fileSuffix = "train", nsampleSize = -1L){
    #read subject
    subject <- read.table(paste0(pathSuffix,"/subject_",fileSuffix,".txt"),nrows=nsampleSize,
                         col.names=c("subjectID"))

    # read the measurement variables -- features
    features <- read.table(paste0(pathSuffix,"/../features.txt"),
                           col.names=c("featureID","featureName"))

    #Extracts only the measurements on the mean and standard deviation for each measurement
    # Note: exclude variables with meanFreq()
    selectedFeatures <- features[grepl("mean\\(\\)|std\\(\\)", features$featureName),]

    #read X data, and subseting
    data <- read.table(paste0(pathSuffix,"/X_",fileSuffix,".txt"), nrows=nsampleSize,
                    col.names=features$featureName)
    data <- data[,selectedFeatures$featureID]

    #read y data -- activities
    Y <- read.table(paste0(pathSuffix,"/y_",fileSuffix,".txt"), nrows=nsampleSize,
                col.names=c("activityID"))
    
    # append the length of activity and subject
    if( nrow(subject) != nrow(data)){message("Error: Mismatch between subject_*.txt and X_*.txt")}
    if( nrow(subject) != nrow(Y)){message("Error: Mismatch between subject_*.txt and y_*.txt")}

    data <- cbind(subject, Y, data)
    data
}

mergeData<-function(nsampleSize= -1L){
    trainData <- readData("UCI_HAR_Dataset/train", "train", nsampleSize)
    testData  <- readData("UCI_HAR_Dataset/test","test", nsampleSize)
    mergeData <-rbind(trainData, testData)
    mergeData
}

## 2. Extracts only the measurements on the mean and standard deviation for each measurement. 
## 3. Uses descriptive activity names to name the activities in the data set
## 4. Appropriately labels the data set with descriptive activity names. 
## 5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject. 
# write.table(newData)

#carMelt <- melt(mtcars, id=c("carname", "gear", "cyl"), measure.vars=c("mpg","hp"))
##Casting data frames
#cylData <-dcast(carMelt, cyl ~ variable)

activityLabel <- function(data, labelFile="UCI_HAR_Dataset//activity_labels.txt"){
    activityLabels <- read.table(labelFile,col.names=c("activityID","activityName"))
    activityLabels$activityName <- as.factor(activityLabels$activityName)
    dataLabled<-merge(data,activityLabels)
    dataLabled
}

getTidyDataset <- function(mergeData){
    library(reshape2)
    #melt the dataset
    ids <- c("activityID","activityName", "subjectID")
    measureVar <-setdiff(colnames(mergeData), ids)
    meltedData <- melt(mergeData, iid=ids, measure.vars=measureVar)
    
    #casting
    dcast(meltedData, activityName + subjectID ~variable, mean)
}

#create a tidy data file and save it
writeTidyDataFile <-function(outputname="tidydata.txt"){
    tidyData <- getTidyDataset( activityLabel(mergeData()))
    write.table(tidyData, outputname)
}