library(reshape2)

# Download file from the predefined location and unzip it, if it doesn't exist, in the working directory.
dataset_zip_file <- "dataset.zip"
file_url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
if (!file.exists(dataset_zip_file)){
    download.file(file_url, dataset_zip_file, method<-"curl")
}

unzipped_dir <- "UCI HAR Dataset"
if (!file.exists(unzipped_dir)) {
    unzip(dataset_zip_file)
}

# Load features and activity labels from input files.
features <- read.table(paste(unzipped_dir, 'features.txt', sep = "/"), header = FALSE)
activity_labels <- read.table(paste(unzipped_dir, 'activity_labels.txt', sep = "/"), header = FALSE)

# We are interested only in mean and standard deviation of each measurement.
mean_and_std_features <- grep(".*mean.*|.*std.*", features[,2])
mean_and_std_features.names <- features[mean_and_std_features,2]
mean_and_std_features.names = gsub('-mean', 'Mean', mean_and_std_features.names)
mean_and_std_features.names = gsub('-std', 'Std', mean_and_std_features.names)
mean_and_std_features.names <- gsub('[-()]', '', mean_and_std_features.names)

# Load training information.
subject_training_data <- read.table(paste(unzipped_dir, 'train/subject_train.txt', sep = "/"), header = FALSE)
activity_training_data <- read.table(paste(unzipped_dir, 'train/y_train.txt', sep = "/"), header = FALSE)
features_training_data <- read.table(paste(unzipped_dir, 'train/x_train.txt', sep = "/"), header = FALSE)[mean_and_std_features]

# Merge training information into one set.
training_data <- cbind(subject_training_data, activity_training_data, features_training_data)

# Load test information.
subject_test_data <- read.table(paste(unzipped_dir, 'test/subject_test.txt', sep = "/"), header = FALSE)
activity_test_data <- read.table(paste(unzipped_dir, 'test/y_test.txt', sep = "/"), header = FALSE)
features_test_data <- read.table(paste(unzipped_dir, 'test/x_test.txt', sep = "/"), header = FALSE)[mean_and_std_features]

test_data <- cbind(subject_test_data, activity_test_data, features_test_data)

# Merge data in on final data set.
complete_data <- rbind(training_data, test_data)
colnames(complete_data) <- c("subject", "activity", mean_and_std_features.names)

# turn activities & subjects into factors
complete_data$activity <- factor(complete_data$activity, levels = activity_labels[,1], labels = activity_labels[,2])
complete_data$subject <- as.factor(complete_data$subject)

complete_data.melted <- melt(complete_data, id = c("subject", "activity"))
complete_data.mean <- dcast(complete_data.melted, subject + activity ~ variable, mean)

write.table(complete_data.mean, "tidy.txt", row.names = FALSE, quote = FALSE)
