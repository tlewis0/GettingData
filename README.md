
    Overview:
  The included R script called run_analysis.R reads the data set "getdata_projectfiles_UCI HAR Dataset" available at "https://d396qusza40orc.cloudfront.net" and ouputs a data set to projData.txt which contains a summary of the data by activity and subject



The data set is processed in a series of steps:

    1) Merged the training and the test sets to create one data set:

    Using rbind the test and train datasets are combined into one main dataset having dimensions of 10299 x 561


2) Extracted only the measurements on the mean and standard deviation for each measurement:
    
    The features data set contains a description of the measurement data in that is in the main data set columns. 
Using this feature data set, the columns in the main data set were removed leaving only the ones columns containing mean or std measurement data.  Data containing meanFreq was also omitted.  This leaves a data set with dimensions of  10299 x 66
The columns were then labelled corresponding to the measurement data.
 
 
3) Converted the activity indices into descriptive activity names and then added the column to the main data set:
    The activities data sets are in the files called y_test.txt and y_train.txt.  The activities are given as integers from 1 to 6. 
The activity_labels data set contains a mapping of the activity indices to a descriptive value.
The two activity data sets were combined with rbind and, converted to the descriptive names from the activity_labels data set, and then the column was added to the main data set with cbind.
This leaves a data set with dimensions of 10299 x 67


4) Add subject values from test and train files to main data set:
    The subject data sets are in the files called subject_test.txt and subject_train.txt.
The two subject data sets were combined with rbind and added to the main data set with cbind.
This leaves a data set with dimensions of 10299 x 68


5) A second independent tidy data set with the average of each variable for each activity and each subject was created:
    Using the aggregate function over the variables subject and activity, a data set summarizing the sensor data by activity and subject was created.
The resulting data set had dimensions of 180 x 68
Column names were transferred from the main data set.
The data set was saved to file "projData.txt using write.table



    All the necessary data sets are in the zipped file "getdata_projectfiles_UCI HAR Dataset.zip" which can be downloaded at this location:
"https://d396qusza40orc.cloudfront.net"


R code to download and unzip the file to the working dir:

fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"

zipFile <- "UCI_HAR_Dataset.zip"

if (!file.exists(zipFile)) {

    download.file(fileUrl, destfile = zipFile, method = "curl")
}

unzip(zipFile) #file will unzip to ./UCI HAR Dataset directory



