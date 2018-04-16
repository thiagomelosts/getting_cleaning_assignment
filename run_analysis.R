# This script is designed for the Getting and Cleaning data assignment
# The main goal is to create one tidy data set based on some txt files

# Reading the data:
test_x <- read.table("X_test.txt")
test_y <- read.table("Y_test.txt")
test_subject <- read.table("subject_test.txt")
train_x <- read.table("X_train.txt")
train_y <- read.table("Y_train.txt")
train_subject <- read.table("subject_train.txt")
features <- read.table("features.txt")
activity_labels <- read.table("activity_labels.txt")

# According to the README.txt file, the features.txt is a description of all the
# 561 features in the vector represented by each line. Therefore, we can use it
# as the name of the columns for the "test_x" and "train_y" objects:
colnames(test_x) <- features$V2
colnames(train_x) <- features$V2

# The "test_y" and "train_y" objects have the activity labels for each record.
# Therefore, we can use them in a new column "activity" and assign their 
# values for each record (or each row):
test_x <- cbind(test_y, test_x)
train_x <- cbind(train_y, train_x)
colnames(test_x)[1] <- "activity"
colnames(train_x)[1] <- "activity"

# The "test_subject" and "train_subject" objects identity the subject for each
# record. Therefore, we can use them in a new column "subject" and assign their 
# values for each record (or each row):
test_x <- cbind(test_subject, test_x)
train_x <- cbind(train_subject, train_x)
colnames(test_x)[1] <- "subject"
colnames(train_x)[1] <- "subject"

# [Item 1] We can now bind the test and train datasets in one:
data <- rbind(test_x, train_x)

# [Item 2] In order to extract the mean and standard deviation for each variable
# we can use the grepl function and look for the characters "mean" or "std":
extract <- grepl("mean|std", colnames(data))
extract_data <- data[,extract]

# Then we can add back the first and second columns, and have a data frame with
# the subject, the activity and the means and standard deviations:
data <- cbind(data[, c(1, 2)], extract_data)

# [Item 3] For a tidy dataset, we can replace the numeric activity labels with 
# more significant labels, such as "WALKING", found in the "activity_labels"
# object, using a for loop:
for (i in 1:nrow(data)) {
    
    # First, we find which is the row with the correct label in the 
    # "activity_label" object
    label <- which(data$activity[i] == activity_labels$V1)
    
    # Then we replace the number with the word on the "data" object:
    data$activity[i] <- as.character(activity_labels$V2[label])
}

# [Item 4] The data set already has descriptive names for all variables, which
# were assigned on lines 17, 18, 25, 26, 33 and 34.

# [Item 5] In order to calculate the average of each variable for each activity
# and subject, we can split the data and use the lapply function:
data_split <- split(data[,-c(1,2)], list(data$subject, data$activity))

# Calculate the mean for each column:
data_means <- lapply(data_split, colMeans)

# Convert data_means to a data frame:
data_means <- as.data.frame(t(as.data.frame(data_means)))

# Create the "subject" and "activity" columns:
subject <- sub("\\..*", "", rownames(data_means))
subject <- sub("X", "", temp_sub)
activity <- as.numeric(temp_sub)
activity <- sub(".*\\.", "", rownames(data_means))

# Combining the columns and removing the row names:
data_means <- cbind(subject, activity, data_means)
rownames(data_means) <- c()

# Creating a txt file from data_means:
write.table(data_means, file = "means.txt", row.name = FALSE)