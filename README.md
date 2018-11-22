Getting and Cleaning Data Project: The Dets
================

Project Details
---------------

In the Course Project for the Coursera Course **Getting and Cleaning Data**, I collected, cleaned, and summarized sensor data.

This README file attempts to:

-   Explain how the `run_analysis.R` script works.

Step-by-Step explanation:
-------------------------

As per the course instructions, the goals of my `run_analysis.R` script has to accomplish the following:

1.  Merges the training and the test sets to create one data set.
2.  Extracts only the measurements on the mean and standard deviation for each measurement.
3.  Uses descriptive activity names to name the activities in the data set.
4.  Appropriately labels the data set with descriptive variable names.
5.  From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

To accomplish the above code, `run_analysis.R` does the following per Goal:

### Steps:

#### Goal 1

-   Create data directory
-   Download and extract the data
-   Load various packages
-   Read `features.txt` and `activity_labels.txt` and properly contextualize column names
-   Read the `X_test.txt` and `y_test.txt` and use the latter to properly label column names
-   Read the `X_train.txt` and `y_train.txt` and use the latter to properly label column names
-   Combine the train and test data to form one data set using `rbind`

#### Goal 2

-   Extract predictors with mean and std in their titles using the `grep` function
-   Add a visual test for the correct number of dimensions for the trimmed data set `test_train_total`
-   Switches to descriptive activity names to name the activities in the data set using the `mapvalues` function

#### Goal 3 and 4:

-   Add the subject identifiers to the tidy data set using the `subject_test.txt` and `subject_train.txt` data sets
-   Convert the subject numbers to factors, as this is a more suitable class

#### Goal 5:

-   Calculate mean by subject and activity using `melt` and `dcast` functions from the `reshape2` package
-   Lastly, create the new `tidy_data.txt` set that will be uploaded to the Git repo
