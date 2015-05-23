# UCI-HAR-Dataset_Project

---
title: "README"
output: html_document
---
## Project:UCI HAR Dataset
This project is assigned as part of course assessment  of 
getting & cleaning course in coursera. <br>
UCI HAR Dataset has been provided
to create tidy data out of this.


The project needs to create R script, including following steps:

**Step1:**  Merges the training and the test sets to create one data set.<br>
**Step2:**Extracts only the measurements on the mean and standard deviation for each measurement.<br>
**Step3:**Uses descriptive activity names to name the activities in the data set<br>
**Step4:**Appropriately labels the data set with descriptive variable names.<br>
**Step5:**From the data set in step 4, creates a second, independent tidy data set with the average of       each variable for each activity and each subject.

### RCode

analysis.R is the source file, which needs to put in working directory. This file contains code for all steps mentioned above. Source the file in RStudio using command:

```{r,eval=FALSE}
source('~/analysis1_R.R')
```

The tidy data is created  and stored in file extracted_tidy_data.txt.
Tidy data can be load in r using command:

```{r,eval=FALSE}
tidy_data<-read.table("extracted_tidy_data.txt")
```



