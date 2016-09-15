

#The purpose of this project is to demonstrate your ability to collect, 
#work with, and clean a data set.
###################################################################################################
###################################################################################################
###################################################################################################

library(reshape2)
filename <- "getdata.zip"

##CHECK IF  EXIST DOWNLOAD .ZIP and unzip
if (!file.exists(filename)){
  fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip "
  download.file(fileURL, filename, method="curl")
}  
if (!file.exists("UCI HAR Dataset")) { 
  unzip(filename) 
}

#READ LABELS FILE
etiquetas <- read.table("UCI HAR Dataset/activity_labels.txt")
etiquetas[,2] <- as.character(etiquetas[,2])

#READ FILE FEATURES
ca<- read.table("UCI HAR Dataset/features.txt")
ca[,2] <- as.character(ca[,2])


#AVERAGE AND STANDARD DEVIATION
med_std= grep(".*mean.*|.*std.*", ca[,2])
med_std_nombres= ca[med_std,2]
med_std_nombres= gsub('-mean', 'Mean', med_std_nombres)
med_std_nombres= gsub('-std', 'Std', med_std_nombres)
med_std_nombres= gsub('[-()]', '', med_std_nombres)


#LOAD DATASET
train <- read.table("UCI HAR Dataset/train/X_train.txt")[med_std]
trainActivities <- read.table("UCI HAR Dataset/train/Y_train.txt")
trainSubjects <- read.table("UCI HAR Dataset/train/subject_train.txt")
train <- cbind(trainSubjects, trainActivities, train)

test <- read.table("UCI HAR Dataset/test/X_test.txt")[med_std]
testActivities <- read.table("UCI HAR Dataset/test/Y_test.txt")
testSubjects <- read.table("UCI HAR Dataset/test/subject_test.txt")
test <- cbind(testSubjects, testActivities, test)


# JOINING THE DATA OF TRAINING WITH TEST DATA
matriz <- rbind(train, test)
colnames(matriz) <- c("subject", "activity", med_std_nombres)

# Matrix with average return of each variable for each activity and subject
matriz$activity <- factor(matriz$activity, levels = activityLabels[,1], labels = activityLabels[,2])
matriz$subject <- as.factor(matriz$subject)
matriz1<- melt(matriz, id = c("subject", "activity"))
matriz_media <- dcast(matriz1, subject + activity ~ variable, mean)

write.table(matriz_media, "tidy.txt", row.names = FALSE, quote = FALSE)
