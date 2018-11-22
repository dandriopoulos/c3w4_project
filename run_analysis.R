###Packages:
library(dplyr)
library(data.table)
#install.packages("matrixStats")
#install.packages("data.table")
#install.packages("stringr")
library(matrixStats)
library(stringr)
#install.packages("plyr")
library(plyr)
#install.packages("reshape2")
library(reshape2)


#Read features data
features<-read.table("features.txt",header = FALSE)
features<-select(features,-V1)
features<-dplyr::rename(features,featurenames=V2)

#Read activities names:
activity_labels<-read.table("activity_labels.txt",header = FALSE)
activity_labels<-dplyr::rename(activity_labels,number=V1,name=V2)
activity_labels$name<-tolower(activity_labels$name)

#Read the test data and labels
test_data<-read.table("X_test.txt", header = FALSE, sep = "" )
test_data_labels<-read.table("y_test.txt", header = FALSE, sep = "")
colnames(test_data)<-features$featurenames

test_data_labels$V1<-factor(test_data_labels$V1)
test_data_labels<-dplyr::rename(test_data_labels,activity=V1)
test_combined<-cbind(test_data_labels,test_data)



#Read the train data and labels
train_data<-read.table("X_train.txt", header = FALSE, sep = "" )
train_data_labels<-read.table("y_train.txt", header = FALSE, sep = "")
colnames(train_data)<-features$featurenames

train_data_labels$V1<-factor(train_data_labels$V1) #Convert the activity variable to a factor
train_data_labels<-dplyr::rename(train_data_labels,activity=V1)
train_combined<-cbind(train_data_labels,train_data)


#Combine test and train
test_train_comb<-rbind(test_combined,train_combined)


#Selecting mean and std variables
list_mean<-grep("mean",names(test_train_comb)) #find the column number of variables for mean calculations
list_std<-grep("std",names(test_train_comb)) #find the column number of variables for std calculations
list_total<-c(list_mean,list_std) #index list for mean & std variables
test_train_total<-test_train_comb[,c(1,list_total)] #dataset with 79 variables corresponding to mean and std vars

#Test for correct number of dimension after reduction to mean/std variables:
print(dim(test_train_total)) #test that the number of rows between test_train_comb and test_train_total

#Switches to descriptive activity names to name the activities in the data set
test_train_total$activity<-mapvalues(test_train_total$activity, c(1:6), activity_labels$name)

####Step 5: Tidy dataset creation with summaries:
tidy_dataset<-test_train_total #backup dataset for test_train_total

#Add the subject identifiers to the tidy data set:
subject_test<-read.table("subject_test.txt", header = FALSE, sep = "")
subject_train<-read.table("subject_train.txt", header = FALSE, sep = "")
subjects<-rbind(subject_test,subject_train)
tidy_dataset<-cbind(subjects,tidy_dataset)
tidy_dataset<-dplyr::rename(tidy_dataset, subject_names=V1)

#Converts the subject numbers to factors, as this is a more suitable class:
tidy_dataset$subject_names<-factor(tidy_dataset$subject_names)

#Calculate mean by subject and activity
ids<-c("activity","subject_names")
data_l<-setdiff(colnames(tidy_dataset),ids)
melted<-melt(tidy_dataset, id = ids, measure.vars = data_l)
tidy<-reshape2::dcast(melted, subject_names + activity ~ variable, mean)

#Export tidy set:
write.table(tidy,file = "tidy_data.txt")
