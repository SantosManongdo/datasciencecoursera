# Getting and Cleaning the data

Project overview

This course project aims to demonstrate the ability to collect, work with, and clean a data set. The data used in this project came from the Human Activity Recognition Using Smartphones experiments conducted by Davide Anguita, Alessandro Ghio, Luca Oneto, Xavier Parra and Jorge L. Reyes-Ortiz.  As mentioned in the Features_info document, the experiments have been carried out with a group of 30 volunteers wearing a smartphone on their waist while performing six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING). Using the embedded accelerometer and gyroscope in the smartphone, the 3-axial linear acceleration and 3-axial angular velocity were captured  at a constant rate of 50Hz. The data collected were randomly partitioned into two sets where measurements from 70% of the volunteers were marked as training data and the remaining 30% as test data. A full description of the  features is available at this site > (http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphonesm).

The data itself can be downloaded from this url,(https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip) and a detailed description of the data can be read in the README.txt. This and the following files are contained in the zipped file:
* 'features_info.txt': Shows information about the variables used on the feature vector.
* 'features.txt': List of measurement feature names
* 'activity_labels.txt': Links the class labels with their activity name.
* 'train/X_train.txt': Training set - 70 % of the randomly partitioned measurement data obtained from volunteers.
* 'train/y_train.txt': Training labels - numeric value of the activity for which the training measurement data were obtained.
* 'train/subject_train.txt' Train subject identifier refers the volunteer who performed the activity.
* 'test/X_test.txt': Test set - 30 % of the randomly partitioned measurement data obtained from volunteers.
* 'test/y_test.txt': Test labels -  numeric value of the activity for which the test measurements data were obtained.
* 'test/subject_test.txt' Test subject identifier refers the volunteer who performed the activity.


Project Objective

To reinforce the learning in this course, this project provides a list of tasks to complete which are as follows:

	1. Merge the training and the test sets to create one data set.
	2. Extract only the measurements on the mean and standard deviation for each measurement.
	3. Use the descriptive activity names to name the activities in the data set
	4. Appropriately label the data set with descriptive variable names.
	5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject

Getting the data

Using the download.file(), the .zip file  was downloaded and saved to a temporary file in a  temporary directory using the
base R functions tempdir() and tempfile(). Since there are more than 1 file contained in the zipped file, each individual file 
was unzipped to a temporary directory. Full path where the file was saved in the temporary directory was captured. The fread() 
function from the data.table package is used to read in the data. The combined dataset has 563 variables or features and 10299 
observations. There were 561  features and the other 2 columns were the subject identifier and the activity label.

Cleaning the data

The feature.txt file that contains the feature names for the 561 data_X columns was unzipped and loaded in the RStudio global 
environment. The presence of special characters like comma, hyphen, open and close parenthesis signify the need for data cleaning.
This special characters if not replaced or removed will cause issue when the data is manipuated and analysed at a later stage. 
Gsub() function was used to replace the said characters with underscore or null value for the open and close parenthesis.
Duplicate feature names found were repla

For the last task required in this project, dplyr's chaining method was used to group the cleaned dataset from previous step by
subject id and activity . Then the rest of the columns were summarised by obtaining the mean of each column.
