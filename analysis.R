library(data.table)
library(plyr)
library(dplyr)


uci_data<- "UCI\ HAR\ Dataset"
feature_file<-paste(uci_data,"/features.txt",sep="")
activity_file<-paste(uci_data,"/activity_labels.txt",sep="")
subject_file_t<-paste(uci_data,"/train/subject_train.txt",sep="")
y_file_t<-paste(uci_data,"/train/y_train.txt",sep="")
X_file_t<-paste(uci_data,"/train/X_train.txt",sep="")
subject_file_test<-paste(uci_data,"/test/subject_test.txt",sep="")
y_file_test<-paste(uci_data,"/test/y_test.txt",sep="")
X_file_test<-paste(uci_data,"/test/X_test.txt",sep="")

#+++++++++++++++++++++++++++++++++++++++++++
# Reading files
#++++++++++++++++++++++++++++++++++++++++++++++++

activitylabels<-read.table(activity_file)
subject_train<-read.table(subject_file_t,col.names=c("subject"))
y_train<-read.table(y_file_t,col.names=c("activity"))
X_train<-read.table(X_file_t,nrows=7352, comment.char="")
subject_test<-read.table(subject_file_test,col.names=c("subject"))
y_test<-read.table(y_file_test,col.names=c("activity"))
X_test<-read.table(X_file_test, nrows=2947, comment.char="")

#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
#Step1: Merge the train and test set to create one dataset
#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

training_data<-cbind(X_train,subject_train,y_train)
testing_data<-cbind(X_test,subject_test,y_test)
merge_data<-rbind(training_data,testing_data)

#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# Step2: Extracts only the measurements on the mean and standard deviation for each measurement. 
#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

feature_list <- read.table(feature_file, col.names = c("id", "name"))
features <- c(as.vector(feature_list[, "name"]), "subject", "activity")
selected_feature_ids <- grepl("mean|std|subject|activity", features) & !grepl("meanFreq", features)
extracted_data = merge_data[, selected_feature_ids]

#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
#sTEP3:Uses descriptive activity names to name the activities in the data set
#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
activities <- read.table(activity_file, col.names=c("id", "name"))
for (i in 1:nrow(activities)) {
  extracted_data$activity[extracted_data$activity == activities[i, "id"]] <- as.character(activities[i, "name"])
}

#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# Step 4:Appropriately labels the data set with descriptive variable names. 
#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
selected_feature_names <- features[selected_feature_ids]
selected_feature_names <- gsub("\\(\\)", "", selected_feature_names)
selected_feature_names <- gsub("Acc", "-acceleration", selected_feature_names)
selected_feature_names <- gsub("Mag", "-Magnitude", selected_feature_names)
selected_feature_names <- gsub("^t(.*)$", "\\1-time", selected_feature_names)
selected_feature_names <- gsub("^f(.*)$", "\\1-frequency", selected_feature_names)
selected_feature_names <- gsub("(Jerk|Gyro)", "-\\1", selected_feature_names)
selected_feature_names <- gsub("BodyBody", "Body", selected_feature_names)
selected_feature_names <- tolower(selected_feature_names)
names(extracted_data)<- selected_feature_names

#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# Step5:From the data set in step 4, creates a second, independent tidy data set with the average 
#of each variable for each activity and each subject.
#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
selected_tidy_data<- ddply(extracted_data,c("subject","activity"),numcolwise(mean))
write.table(selected_tidy_data,file="selected_tidy_data.txt",row.name=FALSE)
tidy_data<-read.table("selected_tidy_data.txt",sep="",header=TRUE)
