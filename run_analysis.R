setwd("C:/Users/Thu Mip/Desktop/UCI HAR Dataset")
library(plyr)

#1. Merge the training and the test sets to create one data set

features <- read.table("./features.txt")
activitylabels <- read.table("./activity_labels.txt")

xtrain <- read.table("./train/X_train.txt")
ytrain <- read.table("./train/y_train.txt")
subjecttrain <- read.table("./train/subject_train.txt")

xtest <- read.table("./test/X_test.txt")
ytest <- read.table("./test/y_test.txt")
subjecttest <- read.table("./test/subject_test.txt")

trainingData <- cbind(xtrain,ytrain,subjecttrain)
testData <- cbind(xtest,ytest,subjecttest)
Data <- rbind(trainingData,testData)

#2. Extract only the measurements on the mean and standard deviation for each measurement
mean_and_std <- grep("-(mean|std)\\(\\)", features[, 2])

#3. Use descriptive activity names to name the activities in the data set
xdata <- rbind(xtrain,xtest)
ydata <- rbind(ytrain,ytest)
names(xdata) <- features[, 2]
xdata1 <- xdata[, mean_and_std]
names(xdata1) <- features[meand_and_std,2]
names(ydata) <- "activity"
ydata[, 1] <- activitylabels[ydata[, 1], 2]

#4. Appropriately labels the data set with descriptive variable names
subjectdata <- rbind(subjecttrain, subjecttest)
names(subjectdata) <- "subject"
finaldata <- cbind(xdata, ydata,subjectdata)

#5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
ncol <- ncol(xdata1)
avgdata <- ddply(finaldata, .(subject, activity), function(x) colMeans(x[,1:ncol]))
write.table(avgdata, "avgdata.txt", row.name=FALSE)
