# run_analysis.R

library(data.table)

#set directory vars
setwd("//home//toddb/classes//GettingData//proj")
projDir <- "./UCI HAR Dataset/"
testDir <- paste(projDir,"test/",sep = "")
trainDir <- paste(projDir,"train/",sep = "")

#create data frame containg both X test and train data:
xData <- rbind( as.data.frame(read.table(paste(testDir, "X_test.txt", sep = ""), dec =".", header=FALSE, stringsAsFactors = FALSE, na.strings="?")), as.data.frame(read.table(paste(trainDir, "X_train.txt", sep = ""), dec =".", header=FALSE, stringsAsFactors = FALSE, na.strings="?")))

#the features data set maps to the x data columns, 
# use the features data set entries to remove columns not containing mean and std data
# also add feature labels to the resulting data set, remove "()" 
feat <- read.table(paste(projDir, "features.txt", sep = ""), dec =".", header=FALSE, stringsAsFactors = FALSE, na.strings="?")

allData <- as.data.frame(xData[,1])
lab <- gsub("\\()","",feat[1,2])
colnames(allData)[1] <- lab
j <- 2
for (i in 2:ncol(xData)){
    lab <- gsub("\\()","",feat[i,2])
    addCol <- 0
    if (length(grep("mean",lab)>0)) {
        addCol <- 1
        if (length(grep("meanFreq",lab)>0))
            addCol <- 0
    }
    else if (length(grep("std",lab)>0)) 
        addCol <- 1
    if (addCol == 1) {
        allData <- cbind(allData, xData[,i])
        colnames(allData)[j] <- lab
        j <- j+1
    }
}

#add activities (y) from test and train files to data set
# replace numeric vals with activity labels before adding to allData
# dataset "data" is no longer needed, so overwrite it
yData <- rbind( as.data.frame(read.table(paste(testDir, "y_test.txt", sep = ""), dec =".", header=FALSE, stringsAsFactors = FALSE, na.strings="?")), as.data.frame(read.table(paste(trainDir, "y_train.txt", sep = ""), dec =".", header=FALSE, stringsAsFactors = FALSE, na.strings="?")))

actTbl <- read.table(paste(projDir, "activity_labels.txt", sep = ""), dec =".", header=FALSE, stringsAsFactors = FALSE, na.strings="?")

actNames <- vector(mode="character", length=nrow(allData))
for (i in 1:nrow(yData)){
    actNames[i] <- actTbl[which(actTbl[,1]==yData[i,1]),2]
}
allData <- cbind(allData,actNames)
colnames(allData)[ncol(allData)] <- "activity"

#add subj vals from test and train files to data set
subj <- rbind(as.data.frame(read.table(paste(testDir, "subject_test.txt", sep = ""), dec =".", header=FALSE, stringsAsFactors = FALSE, na.strings="?")),
as.data.frame(read.table(paste(trainDir, "subject_train.txt", sep = ""), dec =".", header=FALSE, stringsAsFactors = FALSE, na.strings="?")))

allData <- cbind(allData,subj)
colnames(allData)[ncol(allData)] <- "subject"

#  combine data sets based on activity and subject
actCt <- nrow(actTbl)
subjCt <- nrow(unique(subj, incomparables = FALSE))
agData <- as.data.frame(matrix(ncol = ncol(allData), nrow = actCt*subjCt))
ag <- aggregate( allData[,1]~activity+subject, allData, mean )
agData[,1] <- ag[,1]; agData[,2] = ag[,2]; agData[,3] <- ag[,3]
colnames(agData)[1] <- "activity"
colnames(agData)[2] <- "subject"
colnames(agData)[3:ncol(allData)] <- colnames(allData)[1:(ncol(allData)-2)]

for (i in 2:(ncol(allData)-2)) {
    ag <- aggregate( allData[,i]~activity+subject, allData, mean )
    agData[,i+2] <- ag[,3]
}

write.table(agData, paste(projDir, "projData.txt", sep = ""), quote=FALSE, row.name=FALSE)





