## unifier.R
# function that unfies the test and train data sets back into one
# and strips out the columns that are not related to mean nor
# standard deviation
# Input arguments are the two data frames and a numerical vector
# containing the indexes of the columns of interest
#
unifier <- function(test, train, colix) {
	# drop the columns that we are not interested in
	test <- test[, -colix]
	train <- train[, -colix]
	return(rbind(test, train))
}