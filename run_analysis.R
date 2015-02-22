library(plyr)

# Step 1- Reading and Merges the training sets to create one data set.

# Reading the training sets to create one data set.
x_train <- read.table("Dataset\\train\\X_train.txt")
y_train <- read.table("Dataset\\train\\y_train.txt")
subject_train <- read.table("Dataset\\train\\subject_train.txt")

# Reading the test sets to create one data set.
x_test <- read.table("Dataset\\test\\X_test.txt")
y_test <- read.table("Dataset\\test\\y_test.txt")
subject_test <- read.table("Dataset\\test\\subject_test.txt")

# Merging Data

# create x_data set using x train and test
x_data <- rbind(x_train, x_test)

# create y_data set using y train and test
y_data <- rbind(y_train, y_test)

# create subject data set
subject_data <- rbind(subject_train, subject_test)

# Step 2-Extract only the measurements on the mean and standard deviation for each measurement

features <- read.table("Dataset\\features.txt")

# get only columns with mean() or std() in their names
mean_and_std_features <- grep("-(mean|std)\\(\\)", features[, 2])

# subset the desired columns
x_data <- x_data[, mean_and_std_features]

# correct the column names
names(x_data) <- features[mean_and_std_features, 2]


# Step 3 - Use descriptive activity names to name the activities in the data set
activities <- read.table("Dataset\\activity_labels.txt")

# update values with correct activity names
y_data[, 1] <- activities[y_data[, 1], 2]

# correct column name
names(y_data) <- "activity"

# Step 4 - Appropriately label the data set with descriptive variable names

# correct column name
names(subject_data) <- "subject"

# prepare single data set
all_data <- cbind(x_data, y_data, subject_data)

# Step 5 - Create a second, independent tidy data set with the average of each variable for each activity and each subject
averages_data <- ddply(all_data, .(subject, activity), function(x) colMeans(x[, 1:66]))

write.table(averages_data, "data.txt", row.name=FALSE)