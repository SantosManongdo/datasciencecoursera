################################################################
# Getting and Cleaning Data Course Project
# Peer Graded Assignment
#
# Author: Maricel Santos-Manongdo
# Date: 22 March 2020
################################################################

# Load required library
library(dplyr)
library(data.table)

#  Create a temporary directory and file to store the file to download
td = tempdir()
tf  = tempfile(tmpdir=tempdir(), fileext=".zip")
download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip",destfile =  tf, method = "curl")

# Get the name of the first file in the zip archive
fname1 = unzip(tf, list=TRUE)$Name[1]
# Unzip the file to the temporary directory
unzip(tf, files=fname1, exdir=td, overwrite=TRUE)
# Get the full path to the extracted file
fpath1 = file.path(td, fname1)
# fname1 contains the activity labels

# Do the same for the rest of the files in the zipped file
fname2 = unzip(tf, list=TRUE)$Name[2]
# unzip the file to the temporary directory
unzip(tf, files=fname2, exdir=td, overwrite=TRUE)
fpath2 = file.path(td, fname2)

# fname16-18 contain subject_test, X_test and Y_test
# fname30-32 contain subject_train, X_train and Y_train
fname16 = unzip(tf, list=TRUE)$Name[16]
fname17 = unzip(tf, list=TRUE)$Name[17]
fname18 = unzip(tf, list=TRUE)$Name[18]
fname30 = unzip(tf, list=TRUE)$Name[30]
fname31 = unzip(tf, list=TRUE)$Name[31]
fname32 = unzip(tf, list=TRUE)$Name[32]

unzip(tf, files=fname16, exdir=td, overwrite=TRUE)
unzip(tf, files=fname17, exdir=td, overwrite=TRUE)
unzip(tf, files=fname18, exdir=td, overwrite=TRUE)
unzip(tf, files=fname30, exdir=td, overwrite=TRUE)
unzip(tf, files=fname31, exdir=td, overwrite=TRUE)
unzip(tf, files=fname32, exdir=td, overwrite=TRUE)

fpath16 = file.path(td, fname16)
fpath17 = file.path(td, fname17)
fpath18 = file.path(td, fname18)
fpath30 = file.path(td, fname30)
fpath31 = file.path(td, fname31)
fpath32 = file.path(td, fname32)




################################################################
# Answers to the peer graded assignment starts here

# 1. Merge the training and the test sets to create one data set.
# first read in the X and Y train and test data
x_train <- fread(fpath31, sep = " ", header = F)
x_test <- fread(fpath17, sep = " ", header = F)
y_train <- fread(fpath32, header = F)
y_test <- fread(fpath18, header = F)
subj_train <- fread(fpath30, header = F)
subj_test <- fread(fpath16, header = F)
# combine the measurement datasets in train and test
data_X <- rbind(x_train, x_test)
# combine the activity dataset in train and test
data_Y <- rbind(y_train, y_test)
# combine the subject dataset in train and test
data_subj <- rbind(subj_train, subj_test)

# combined training and test sets
data <- cbind(data_subj, data_Y, data_X)

 
# 2. Extract only the measurements on the mean and standard deviation for each measurement
sapply(data_X, function(x) c("Mean" = mean(x, na.rm = TRUE),
                           "Std. Dev" = sd(x)))

# 3. Use descriptive activity names to name the activities in the data set
# Read in the descriptive activity names in the features.txt
activty_label <- fread(fpath1,sep = " ", header = F)
# Name the activities in the dataset
data_Y <- data_Y %>%
        left_join(activty_label)
data_Y <- data_Y[2]

#	4. Appropriately label the data set with descriptive variable names.
# read in features name
features <- fread(fpath2,sep = " ", header = F)
# clean features replacing , and - with underscore and () with ""
features$V2 <- features$V2 %>%
          gsub(pattern ="," , replacement = "_") %>%
          gsub(pattern ="-" , replacement = "_") %>%
          gsub(pattern = "\\(", replacement = "") %>%
          gsub(pattern ="\\)" , replacement = "") 

# check for any duplicate values
duplicated(features$V2)
# make values unique to have unique column names
features$V2 <- make.unique(features$V2) 

# assign columnames to measurement features
names(data_X) <- features[[2]]
names(data_Y) <- "Activity"
names(data_subj) <- "Subj_ID"

# recombine the sub-datasets with appropriate labels
data <- cbind(data_subj, data_Y, data_X)


#	5. From the data set in step 4, create a second, independent tidy data set with the average of each variable for each activity and each subject.
data_2 <- data %>% group_by(Subj_ID, Activity) %>%
        summarise_all(list(~mean(.)))

# save the new dataset as text file
write.table(data_2, file = "./data_2.txt", row.names = FALSE)
