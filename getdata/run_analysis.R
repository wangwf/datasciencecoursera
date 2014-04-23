#if(!file.exists("./wearable")){dir.create("./wearable")}
dataURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
temp<-tempfile()
download.file(dataURL, temp, method="curl")
#unz(temp, "a.d/")
#data <-read.table(unz(temp, filename="UCI_HAR_Dataset.dat"))

#
# X_train.txt/X_test.txt, 561-feature vector with time and frequencey domain variable
# y_train.txt/y_test.txt, lablels of 30 volunteers
nsample=100
trainSubject <-readLines("./UCI_HAR_Dataset/train//subject_train.txt",n=nsample)
trainX <- read.table("UCI_HAR_Dataset/train/X_train.txt",nrows=nsample)
trainY <- read.table("UCI_HAR_Dataset/train/y_train.txt",nrows=nsample)
if( length(trainSubject) != nrow(trainX)){message("Error: Mismatch between subject_train.txt and X_train.txt")}
if( length(trainSubject) != nrow(trainY)){message("Error: Mismatch between subject_train.txt and y_train.txt")}

#estSubject <-readLines("./UCI_HAR_Dataset/test//subject_test.txt")
#estX <- read.table("UCI_HAR_Dataset/test/X_test.txt")
#estY <- read.table("UCI_HAR_Dataset/test/y_test.txt")

## check length of format of subject*.txt and *_train.txt
#f( length(testSubject) != nrow(testX)){message("Error: Mismatch between subject_test.txt and X_test.txt")}
#f( length(testSubject) != nrow(testY)){message("Error: Mismatch between subject_test.txt and y_test.txt")}

# A 561-feature vector with time and frequency domain variables. 