
  This is a project on "getting and cleaning data" project.

  Data set information was download from http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones#.  "The experiments have been carried out with a group of 30 volunteers within an age bracket of 19-48 years. Each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist. Using its embedded accelerometer and gyroscope, we captured 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz. The experiments have been video-recorded to label the data manually. The obtained dataset has been randomly partitioned into two sets, where 70% of the volunteers was selected for generating the training data and 30% the test data.  The sensor signals (accelerometer and gyroscope) were pre-processed by applying noise filters and then sampled in fixed-width sliding windows of 2.56 sec and 50% overlap (128 readings/window). The sensor acceleration signal, which has gravitational and body motion components, was separated using a Butterworth low-pass filter into body acceleration and gravity. The gravitational force is assumed to have only low frequency components, therefore a filter with 0.3 Hz cutoff frequency was used. From each window, a vector of features was obtained by calculating variables from the time and frequency domain."

  For each record in the dataset it is provided:
    - Triaxial acceleration from the accelerometer (total acceleration) and the estimated body acceleration.
    - Triaxial Angular velocity from the gyroscope.
    - A 561-feature vector with time and frequency domain variables.
    - Its activity label.
    - An identifier of the subject who carried out the experiment.


     run_analysis.R:   r-script to collect, clean and reshape data. It prepares a tidy dataset.
     UCI_HAR_Dataset:  data repository,  download data set for training/test.
     CodeBook:         functions&variables used in run_analysis.R

To execute the r-script,
   source("run_analysis.R")
   writeTidyDataFile() #write to default output "tidydata.txt" 

Belows are functions defined in run_analysis.R.

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
