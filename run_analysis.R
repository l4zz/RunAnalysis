## RunAnalysis project

## Coding...
# You should create one R script called run_analysis.R that does the following. 
# 1 - Merges the training and the test sets to create one data set.
# 2 - Extracts only the measurements on the mean and standard deviation for each measurement. 
# 3 - Uses descriptive activity names to name the activities in the data set
# 4 - Appropriately labels the data set with descriptive variable names. 
# 5 - From the data set in step 4, creates a second, independent tidy data set with the
#	  average of each variable for each activity and each subject.

## helper stuff // de-cluttering
source('load_datasets.R')
source('unifier.R')

## this bit is the main script

# !important
# script will not run if files are not present; checking!
file_check()

# indexes of the columns without mean or std
dropfeats <- NULL

# all column names
features <- load_features()

activityLabels <- load_activities() # unchecked

# reading in test set, complete with subjects and activities
testSet <- load_testset(features)

# reading in train set, complete with subjects and activities
trainSet <- load_trainset(features)

# re-uniting the train and test data sets into one
singleSet <- unifier(testSet, trainSet, dropfeats)

# re-naming the activity
singleSet$activity <- as.character(singleSet$activity)
for (i in seq_len(nrow(activityLabels))) {
	singleSet$activity[singleSet$activity %in% activityLabels[i,1]] <- as.character(activityLabels[i,2])
}

# just a quick name change
oldnames <- names(singleSet)
oldnames <- gsub('.', '', oldnames, fixed=T)
#oldnames <- gsub('mean', "_mean_", oldnames, fixed=T)
#oldnames <- gsub('std', "_std_", oldnames, fixed=T)
names(singleSet) <- tolower(oldnames)
# names of variables should be:
# - all lower case when possible
# - descriptive (diagnosis vs Dx)
# - not duplicated
# - not have underscores or dots or white spaces

# acc - accelerometer; split up into:
#  BodyAcc - bodyacceleration
#  GravityAcc - gravityacceleration
# gyr - gyroscope
# t - time
# f - fastfouriertransform
# XYZ - XYZ axis

# calculating the avgs for each variable
tidyData <- aggregate(singleSet, by=list(singleSet$activity, singleSet$subject), FUN=mean)
drop <- c("activity", "subject")
tidyData <- tidyData[, !(names(tidyData) %in% drop)]
oldnames <- names(tidyData)
oldnames <- gsub('Group.1', 'activity', oldnames, fixed=T)
oldnames <- gsub('Group.2', 'subject', oldnames, fixed=T)
oldnames <- gsub('bodybody', 'body', oldnames, fixed=T)
#oldnames <- gsub('', 'mean_.Body', oldnames)
names(tidyData) <- oldnames

#write.table(tidyData, file="UCI_HAR_tidy.tsv", sep="\t", row.names=F)

