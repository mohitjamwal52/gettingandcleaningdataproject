library(data.table)
library(dplyr)


#loading the features and activity lables datasets
featureNames <- read.table("UCI HAR Dataset/features.txt",col.names = c("n","functions"))
activityLabels <- read.table("UCI HAR Dataset/activity_labels.txt", header = FALSE, col.names = c("n","activity"))


#reading training data
subjectTrain <- read.table("UCI HAR Dataset/train/subject_train.txt", header = FALSE, col.names = "subject")
activityTrain <- read.table("UCI HAR Dataset/train/y_train.txt", header = FALSE, col.names = "code")
featuresTrain <- read.table("UCI HAR Dataset/train/X_train.txt", header = FALSE, col.names = featureNames$functions)

#reading testsubjectTest 
subjectTest <- read.table("UCI HAR Dataset/test/subject_test.txt", header = FALSE, col.names = "subject")
activityTest <- read.table("UCI HAR Dataset/test/y_test.txt", header = FALSE, col.names = "code")
featuresTest <- read.table("UCI HAR Dataset/test/X_test.txt", header = FALSE, col.names = featureNames$functions) 

#merging the dataset 
subject <- rbind(subjectTrain, subjectTest)
activity <- rbind(activityTrain, activityTest)
features <- rbind(featuresTrain, featuresTest)


newMergedData <- cbind(features,activity,subject)

  
#the measurements on the mean and standard deviation for each measurement.
measurementMeanSTD <- newMergedData %>% select(subject, code, contains("mean"), contains("std"))


measurementMeanSTD$code <- activityLabels[measurementMeanSTD$code, 2]

#data set with descriptive variable names.

names(measurementMeanSTD)[2] = "activity"
names(measurementMeanSTD)<-gsub("Acc", "Accelerometer", names(measurementMeanSTD))
names(measurementMeanSTD)<-gsub("Gyro", "Gyroscope", names(measurementMeanSTD))
names(measurementMeanSTD)<-gsub("BodyBody", "Body", names(measurementMeanSTD))
names(measurementMeanSTD)<-gsub("Mag", "Magnitude", names(measurementMeanSTD))
names(measurementMeanSTD)<-gsub("^t", "Time", names(measurementMeanSTD))
names(measurementMeanSTD)<-gsub("^f", "Frequency", names(measurementMeanSTD))
names(measurementMeanSTD)<-gsub("tBody", "TimeBody", names(measurementMeanSTD))
names(measurementMeanSTD)<-gsub("-mean()", "Mean", names(measurementMeanSTD), ignore.case = TRUE)
names(measurementMeanSTD)<-gsub("-std()", "STD", names(measurementMeanSTD), ignore.case = TRUE)
names(measurementMeanSTD)<-gsub("-freq()", "Frequency", names(measurementMeanSTD), ignore.case = TRUE)
names(measurementMeanSTD)<-gsub("angle", "Angle", names(measurementMeanSTD))
names(measurementMeanSTD)<-gsub("gravity", "Gravity", names(measurementMeanSTD))


#Tidy data
measurementMeanSTD$subject <- as.factor(measurementMeanSTD$subject)
measurementMeanSTD <- data.table(measurementMeanSTD)


tidyData <- aggregate(. ~subject + activity, measurementMeanSTD, mean)
tidyData <- tidyData[order(tidyData$subject,tidyData$activity), ]
write.table(tidyData, file = "Tidy.txt", row.names = FALSE)
