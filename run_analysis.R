#Getting and Cleaning Data Course - project


# read train data from files

Xtrain <- read.table("G:/MyCoursera/3_GettingandCleaningData/getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/train/X_train.txt")
Ytrain <- read.table("G:/MyCoursera/3_GettingandCleaningData/getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/train/Y_train.txt")
trainsubject <- read.table("G:/MyCoursera/3_GettingandCleaningData/getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/train/subject_train.txt")

# read test data from files

Xtest <- read.table("G:/MyCoursera/3_GettingandCleaningData/getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/test/X_test.txt")
Ytest <- read.table("G:/MyCoursera/3_GettingandCleaningData/getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/test/Y_test.txt")
testsubject <- read.table("G:/MyCoursera/3_GettingandCleaningData/getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/test/subject_test.txt")

# 1. Merges the training and the test sets to create one data set.

Xtotal <- rbind(Xtrain, Xtest)
Ytotal <- rbind(Ytrain, Ytest)
totalsubject <- rbind(trainsubject, testsubject)

# 2. Extracts only the measurements on the mean and standard deviation for each measurement.
features <- read.table("G:/MyCoursera/3_GettingandCleaningData/getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/features.txt")
selected_var <- features[grep("mean\\(\\)|std\\(\\)",features[,2]),]
Xtotal <- Xtotal[,selected_var[,1]]


# 3. Uses descriptive activity names to name the activities in the data set
activitylabels <- read.table("G:/MyCoursera/3_GettingandCleaningData/getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/activity_labels.txt")
colnames(Ytotal) <- "activity"
Ytotal$activitylabel <- factor(Ytotal$activity, labels = as.character(activitylabels[,2]))
activitylabel <- Ytotal[,-1]

# 4. Appropriately labels the data set with descriptive variable names.

colnames(Xtotal) <- features[selected_var[,1],2]

# 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

colnames(totalsubject) <- "subject"

total <- cbind(Xtotal, activitylabel, totalsubject)

total_mean <- total %>% group_by(activitylabel, subject) %>% summarize_each(funs(mean))

write.table(total_mean, file = "G:/MyCoursera/3_GettingandCleaningData/getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/tidydata.txt", row.names = FALSE, col.names = TRUE)