# Downloading the dataset zip file
if(!file.exists("./data")){dir.create("./data")}
downloadfile <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(downloadfile,destfile = "./data/datafile.zip")

# 1. Merging the training and the test sets to create one data set

# Extracting the dataset zip file
unzip(zipfile = "./data/datafile.zip", exdir = "./data")

# Reading the dataset
features <- read.table("./data/UCI HAR Dataset/features.txt")
activityLabels <- read.table("./data/UCI HAR Dataset/activity_labels.txt")

# Reading the test data
x_test <- read.table("./data/UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("./data/UCI HAR Dataset/test/y_test.txt")
subject_test <- read.table("./data/UCI HAR Dataset/test/subject_test.txt")

# Reading the train data
x_train <- read.table("./data/UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("./data/UCI HAR Dataset/train/y_train.txt")
subject_train <- read.table("./data/UCI HAR Dataset/train/subject_train.txt")

# Merging train and test datasets into one dataset
x_both <- rbind(x_test,x_train)
y_both <- rbind(y_test,y_train)
subject_both <- rbind(subject_test,subject_train)

# Assigning column names
names(subject_both) <- c("subjectId")
names(y_both) <- c("activityId")
names(x_both) <- features[,2]

# Column binding to get merged dataset
mergedData <- cbind(x_both,y_both,subject_both)

# 2. Extracting only the measurements on the mean and standard deviation for each measurement
col_names <- colnames(mergedData)
std_and_mean <- (grepl("activityId", col_names)
                 | grepl("subjectId", col_names)
                 | grepl("mean", col_names)
                 | grepl("std", col_names))
mean_and_std <- mergedData[, std_and_mean==TRUE]

# 3. Using descriptive activity names to name the activities in the data set
setOfActivityNames <- merge(mean_and_std, activityLabels, by="activityId", all.x = TRUE)

# 5. Making the second tidy set
secondTidySet <- aggregate(. ~subjectId + activityId, setOfActivityNames, mean)
secondTidySet <- secondTidySet[order(secondTidySet$subjectId, secondTidySet$activityId),]

# Writing the tidy set to a .txt file
write.table(secondTidySet, "secondTidySet.txt", row.name=FALSE)