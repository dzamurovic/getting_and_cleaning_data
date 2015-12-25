# Getting and Cleaning Data - Course project

This is the course project for the Getting and Cleaning Data Coursera course.
The R script, `run_analysis.R`, does the following:

1. download a file from the predefined location and unzip it (if it doesn't already exist) in the working directory
2. load features and activity labels from the unzipped files
3. load training and test data
4. merge training and test data into one dataset
5. convert the activity and subject columns into factors
6. create a tidy dataset that consists of the average (mean) value of each variable for each subject and activity pair

The final result is rendered into 'tidy.txt'.