#Load activity data sets for test and train within working directory

testactivity  <- read.table("C:/Users/viyeh/Documents/Resume/Coursera/Getting and Cleaning Data/UCI HAR Dataset/test/Y_test.txt" , header = FALSE)
trainactivity <- read.table("C:/Users/viyeh/Documents/Resume/Coursera/Getting and Cleaning Data/UCI HAR Dataset/train/Y_train.txt", header = FALSE)

#Load subject data sets for test and training

testsubject  <- read.table("C:/Users/viyeh/Documents/Resume/Coursera/Getting and Cleaning Data/UCI HAR Dataset/test/subject_test.txt", header = FALSE)
trainsubject <- read.table("C:/Users/viyeh/Documents/Resume/Coursera/Getting and Cleaning Data/UCI HAR Dataset/train/subject_train.txt", header = FALSE)

#Load features data sets for test and training

testfeatures  <- read.table("C:/Users/viyeh/Documents/Resume/Coursera/Getting and Cleaning Data/UCI HAR Dataset/test/X_test.txt", header = FALSE)
trainfeatures <- read.table("C:/Users/viyeh/Documents/Resume/Coursera/Getting and Cleaning Data/UCI HAR Dataset/train/X_train.txt", header = FALSE)

## 1. Merges the training and the test sets to create one data set.

## Read feature data
features <- read.table("C:/Users/viyeh/Documents/Resume/Coursera/Getting and Cleaning Data/UCI HAR Dataset/features.txt")
head(features)

## Read activity labels
activity_labels <- read.table("C:/Users/viyeh/Documents/Resume/Coursera/Getting and Cleaning Data/UCI HAR Dataset/activity_labels.txt")

## Create tidy activity labels
colnames(activity_labels) <- c("activity_id", "activity_name")

## Create tidy training data set
colnames(trainfeatures) <- features[,2]
colnames(trainactivity)  <- "activity_id"
colnames(trainsubject) <- "subject_id"
tidy_train_set <- cbind(trainactivity, trainsubject, trainfeatures)

## Create tidy test data set
colnames(testfeatures) <- features[,2]
colnames(testactivity)  <- "activity_id"
colnames(testsubject) <- "subject_id"
tidy_test_set <- cbind(testactivity, testsubject, testfeatures)

## Merge tidy training and test sets
tidy_data_set <- rbind(tidy_train_set, tidy_test_set)

## 2. Extracts only the measurements on the mean and standard deviation for each measurement.
measurements <- grep("mean|std", colnames(tidy_data_set), value = TRUE )

## Subset these measurements from tidy_data_set
extract_mean_std <- tidy_data_set[ , measurements]

## 2.3 Add activity_id and subject_id
mean_std_data_set <- cbind(activity_id = tidy_data_set$activity_id, subject_id = tidy_data_set$subject_id, 
                           extract_mean_std)

## 3. Uses descriptive activity names to name the activities in the data set
head(mean_std_data_set)
activity_mean_std_data_set <- merge(mean_std_data_set, activity_labels, by = "activity_id")

## 4. Appropriately labels the data set with descriptive variable names.
## completed in step 1

## 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
install.packages("dplyr")
library("dplyr")
average_per_activity_subject <- activity_mean_std_data_set %>%
  group_by(subject_id, activity_id, activity_name) %>%
  summarise_all(funs(mean))

## Write data in new txt file
write.table(average_per_activity_subject, "average_per_activity_subject.txt", row.name = FALSE)