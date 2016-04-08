##########################################################################################################

## Coursera Getting and Cleaning Data Course Project
## Shannon McDaniel
## 2016-04-08

# runAnalysis.r File Description:

# This script will perform the following steps on the UCI HAR Dataset downloaded from 
# https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 
# 1. Merge the training and the test sets to create one data set.
# 2. Extract only the measurements on the mean and standard deviation for each measurement. 
# 3. Use descriptive activity names to name the activities in the data set
# 4. Appropriately label the data set with descriptive activity names. 
# 5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject. 

##########################################################################################################


# Clean up workspace
rm(list=ls())

#set working directory to the location where the UCI HAR Dataset was unzipped
setwd("~/Desktop/Coursera/Getting and Cleaning Data - Class 3/UCI HAR Dataset");

# 1. Merge the training and the test sets to create one data set

# Read in the data from files
features <- read.table('./features.txt',header=FALSE); #imports features.txt
a_Type <- read.table('./activity_labels.txt',header=FALSE); #imports activity_labels.txt
s_Train <- read.table('./train/subject_train.txt',header=FALSE); #imports subject_train.txt
xTrain <- read.table('./train/x_train.txt',header=FALSE); #imports x_train.txt
yTrain <- read.table('./train/y_train.txt',header=FALSE); #imports y_train.txt

library(plyr); load plyr

# 2. Extract only the measurements on the mean and standard deviation for each measurement

X_test <- read.table("test/X_test.txt")
y_test <- read.table("test/y_test.txt")
subject_test <- read.table("test/subject_test.txt")
X_data <- rbind(xTrain, X_test)
y_data <- rbind(yTrain, y_test)
subject_data <- rbind(s_Train, subject_test)

# Get only Mean and Std Deviation for each Activity

M_and_S <- grep("-(mean|std)\\(\\)", features[,2])
X_data <- X_data[, M_and_S]
names(X_data) <- features[M_and_S, 2]

# 3. Use descriptive activity names to name the activities in the data set

y_data[,1] <- a_Type[y_data[,1],2]
names(y_data) <- "Activity"

# 4. Appropriately label the data set with descriptive activity names

names(subject_data) <- "Subject"
all_data <- cbind(X_data, y_data, subject_data)

# 5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject

averages_data <- ddply(all_data, .(Subject, Activity), function(x) colMeans(x[, 1:66]))
write.table(averages_data, "averages_data.txt", row.name=FALSE)
View(all_data)
