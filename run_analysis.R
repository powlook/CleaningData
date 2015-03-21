TidyData
library(dplyr)

## Creating the activity labels
activity <- read.table("activity_labels.txt", header = FALSE) 
names(activity) <- c("Labels","Action")
activity$Action <- as.character(activity$Action)

## Creating the feature labels
features <- read.table("features.txt", header = FALSE)
names(features) <- c("Labels","Desc")

## ----- This segment prepares the tidy data for training table
## Reading the subject_activity into the table
getwd()  ## get working directory
subject_train <- read.table("./train/subject_train.txt", header = FALSE, sep="")  ##sub-folder from the working directory
names(subject_train) <- c("Subject")

## Reading the activity type into the table
act_train <- read.table("./train/y_train.txt", header = FALSE, sep="")    ##sub-folder from the working directory
names(act_train) <- c("Activity")
act_train <- mutate(act_train,c(1:length(act_train$Activity)))
names(act_train) <- c("Activity","Actions")
for (i in 1:length(act_train$Activity)){act_train$Actions[i]=activity[act_train$Activity[i],2]}

## Reading the Training Data into table
train_table <- read.table("./train/X_train.txt", header = FALSE, sep="")  ##sub-folder from the working directory
names(train_table) <- features$Desc 

## Binding the activity and subject labels to the training data table
train_table <- cbind(act_train$Actions,train_table)
train_table <- cbind(subject_train,train_table)
names(train_table)[2] <- "Activity"



## ----- This segment prepares the tidy data for test table
## Reading the subject_activity into the table
getwd()  ## get working directory
subject_test <- read.table("./test/subject_test.txt", header = FALSE, sep="")  ##sub-folder from the working directory
names(subject_test) <- c("Subject")

## Reading the activity type into the table
act_test <- read.table("./test/y_test.txt", header = FALSE, sep="")    ##sub-folder from the working directory
names(act_test) <- c("Activity")
act_test <- mutate(act_test,c(1:length(act_test$Activity)))
names(act_test) <- c("Activity","Actions")
for (i in 1:length(act_test$Activity)){act_test$Actions[i]=activity[act_test$Activity[i],2]}


## Reading the Training Data into table
test_table <- read.table("./test/X_test.txt", header = FALSE, sep="")  ##sub-folder from the working directory
names(test_table) <- features$Desc  ## Assigning the feature description to the column variables


## Binding the activity and subject labels to the test data table
test_table <- cbind(act_test$Actions,test_table)
test_table <- cbind(subject_test,test_table)
names(test_table)[2] <- "Activity"

## Binding both the test and training tables, extracting the means and std combining them again

temp_table  <- rbind(test_table,train_table)                          ## This table will have 563 columns and 7352 rows
temp_mean   <- temp_table[,grepl("mean\\(\\)",colnames(temp_table))] ## extract the mean() of the measurements
temp_std    <- temp_table[,grepl("std\\(\\)",colnames(temp_table))]  ## extract the std()  of the measurements
temp_act    <- temp_table[,c(1,2)]                                   ## extract the activity and subject column
temp_table1 <- cbind(temp_mean,temp_std)    
final_table <- cbind(temp_act,temp_table1)  ## combining all the means and std columns giving 68 columns and 7352 rows

Sorted_table <- final_table[order(final_table$Subject,final_table$Activity),] ## Sorting by Subject and Activity

write.table(final_table,file="./final_table.csv",quote=T,append=F,sep=",",eol = "\n", na = "NA", dec = ".",row.names=FALSE,col.names=TRUE)

Mean_table <- aggregate(Sorted_table, by = list(Sorted_table$Subject,Sorted_table$Activity), FUN = "mean")
Mean_table <- Mean_table[,-c(1,2)]    ## Remove the first 2 columns which was created by the aggregate function


