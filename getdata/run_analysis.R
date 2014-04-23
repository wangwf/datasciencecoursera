#if(!file.exists("./wearable")){dir.create("./wearable")}
dataURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
temp<-tempfile()
download.file(dataURL, temp, method="curl")
#unz(temp, "a.d/")
#data <-read.table(unz(temp, filename="UCI_HAR_Dataset.dat"))

# subject_*.txt, one of 30 volunteers
# X_train.txt/X_test.txt, 561-feature vector with time and frequencey domain variable
# y_train.txt/y_test.txt, 1:6, one of six activities ( (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING))
# 
nsample=100
trainSubject <-readLines("./UCI_HAR_Dataset/train//subject_train.txt",n=nsample)
trainX <- read.table("UCI_HAR_Dataset/train/X_train.txt",nrows=nsample)
trainY <- read.table("UCI_HAR_Dataset/train/y_train.txt",nrows=nsample)
if( length(trainSubject) != nrow(trainX)){message("Error: Mismatch between subject_train.txt and X_train.txt")}
if( length(trainSubject) != nrow(trainY)){message("Error: Mismatch between subject_train.txt and y_train.txt")}

testSubject <-readLines("./UCI_HAR_Dataset/test//subject_test.txt", n=nsample)
testX <- read.table("UCI_HAR_Dataset/test/X_test.txt", nrows=nsample)
testY <- read.table("UCI_HAR_Dataset/test/y_test.txt", nrows=nsample)

## check length of format of subject*.txt and *_train.txt
if( length(testSubject) != nrow(testX)){message("Error: Mismatch between subject_test.txt and X_test.txt")}
if( length(testSubject) != nrow(testY)){message("Error: Mismatch between subject_test.txt and y_test.txt")}


## 1. Merges the training and the test sets to create one data set
mergeX <- rbind(trainX, testX)
mergeY <- rbind(trainY, testY)


## 2. Extracts only the measurements on the mean and standard deviation for each measurement. 
#means <- lapply(trainX, mean)
#sds   <- lapply(trainX, sd)
mergeX<- mergeX[,1:6]  #  mean (x,y,x) and std (x,y,z)

## 3. Uses descriptive activity names to name the activities in the data set

newNames <- c("tBodyAccMeanX","tBodyAccMeanY","tBodyAccMeanZ","tBodyAccStdX","tBodyAccStdY","tBodyAccStdZ")
names(mergeX) <- newNames

## 4. Appropriately labels the data set with descriptive activity names. 
rownames(mergeX) <- as.character(mergeY)

## 5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject. 
# write.table(newData)
