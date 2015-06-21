## load_datasets.R
# helper functions for loading and initial
# treatment of the datasets

# file_check()
# checks all files exist in the original data structure
# if one or more files fail the check, stops execution
# with message informing which file(s) is missing
#
file_check <- function() {
	message('Loading datasets')
	files <- c('UCI HAR Dataset/features.txt',
			   'UCI HAR Dataset/activity_labels.txt',
			   'UCI HAR Dataset/test/X_test.txt',
			   'UCI HAR Dataset/test/y_test.txt',
			   'UCI HAR Dataset/test/subject_test.txt',
			   'UCI HAR Dataset/train/X_train.txt',
			   'UCI HAR Dataset/train/y_train.txt',
			   'UCI HAR Dataset/train/subject_train.txt')
	fileCheck <- file.exists(files)
	if (FALSE %in% fileCheck) {
		badFiles <- files[!fileCheck]
		fileList <- paste(badFiles, collapse="' '")
		fileList <- paste(fileList, "'", sep='')
		stop(paste("Could not find files: '", fileList, sep=''))
	}
}

## load_features()
# loads features of the measurements as factors; these
# correspond to the names of the columns in the data
# sets, which have be converted into 'character' type
# before assigning them as names
# Also retrieves the indexes of the columns that have
# do not have mean or standard deviation calculation
#
load_features <- function() {
	features <- read.table('UCI HAR Dataset/features.txt',
								header=F, sep=' ')
	# variables without mean and standard deviation
	dropfeats <- features[grep("std|mean", features$V2, invert=T),]
	dropfeats <<- as.numeric(dropfeats$V1)
	return(as.character(features[[2]]))
}

## load_activities()
#
load_activities <- function() {
	activityLabels <- read.table('UCI HAR Dataset/activity_labels.txt',
								header=F, sep=' ')
	return(activityLabels)
}

## load_testset()
# loads the test data set data, the labels and subjects
# returns a data frame with all these individual sets combined
#
load_testset <- function(names) {
	testSet <- read.table('UCI HAR Dataset/test/X_test.txt',
						  header=F, col.names=names)
	testLabel <- read.table('UCI HAR Dataset/test/y_test.txt',
						  header=F, col.names=c('activity'))
	testSubject <- read.table('UCI HAR Dataset/test/subject_test.txt',
						  header=F, col.names=c('subject'))
	testSet <- cbind(testSet, testSubject, testLabel)
	return(testSet)
}

## load_trainset()
# loads the train data set data, the labels and subjects
# returns a data frame with all these individual sets combined
#
load_trainset <- function(names) {
	trainSet <<- read.table('UCI HAR Dataset/train/X_train.txt',
						  header=F, col.names=names)
	trainLabel <<- read.table('UCI HAR Dataset/train/y_train.txt',
						  header=F, col.names=c('activity'))
	trainSubject <<- read.table('UCI HAR Dataset/train/subject_train.txt',
						  header=F, col.names=c('subject'))
	trainSet <- cbind(trainSet, trainSubject, trainLabel)
	return(trainSet)
}