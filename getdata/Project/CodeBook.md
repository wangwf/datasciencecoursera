http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones#

downloadFiles():
    check whether the data repository exists, if not, download and unzip it.


readData(pathPrefix, fileSuffix, nsampleSize ):
   - function parameters:
         pathPrefix = "UCI_HAR_Dataset/train" or "UCI_HAR_Dataset/train"
         fileSuffix = "train" or "test"
         nsampleSize: default -1L for all dataset.
   - read data files into R.
         subject_*.txt: an identifier of the subject who carried out the experiement
         feature.txt:   ID and names of 561-features from measurement. For this project, only extract
                        For this project, only extract the measurement on the mean and stand deviation for each measurement.
                        "meanFreq()" is excluded for convenience.
         X_*.txt:       data of 561-features.
         y_*.txt:       the label of 6 activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING)
   - feature extracts only  the measurement on the mean and stand deviation for each measurement
   - column-bind, labels the data set with descriptivie activity name, and subject identifier.

mergData():
  - read both training and test sets
  - Merge the training and the test to create one data set, mergeData

activityLabel(data, labelFile):
  - label the data set with descriptively names

createTidyDataset(data):
  - melt and dcast data

writeTidyDataFile(outputfile):
  - write tidy data to a local file
