
#LOAD dplyr
library("dplyr")

#Read data for test and train subjects, activities, and observations
testX <- read.table("./UCI HAR Dataset/test/X_test.txt")
testY <- read.table("./UCI HAR Dataset/test/y_test.txt")
trainX <- read.table("./UCI HAR Dataset/train/X_train.txt")
trainY <- read.table("./UCI HAR Dataset/train/y_train.txt")
subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt")
subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt")

#Change the column names to the features.txt data set
features <- read.table("./UCI HAR Dataset/features.txt")

names(testX) <- features$V2
names(trainX) <- features$V2
names(testY) <- "Activity"
names(trainY) <- "Activity"
names(subject_test) <- "Subjects"
names(subject_train) <- "Subjects"

#Combine the two tables for a MERGED DATA SET
testTable <- cbind(subject_test, testY, testX)
trainTable <- cbind(subject_train, trainY, trainX)

combinedTable <- rbind(testTable, trainTable)

activity_labels <- read.table("./UCI HAR Dataset/activity_labels.txt", stringsAsFactors = FALSE)

MeanStdMeas <- combinedTable[ , grepl("mean\\(|std", names(combinedTable))]

#CREATE THE COMBINED DATA SET
combined <- cbind(combinedTable$Subjects, combinedTable$Activity, MeanStdMeas)

colnames(combined)[1] <- "Subjects"
colnames(combined)[2] <- "Activity"        

#Change the Ativity names
for(i in 1:nrow(combined)){
  
    for(j in 1:nrow(activity_labels)){
        
        if(combined$Activity[i] == activity_labels$V1[j]){
            
            combined$Activity[i] <- activity_labels$V2[j]
            
        }
      
    }
  
}

############# FINAL DATA SET ##########################
#GROUP BY SUBJECT AND ACTIVITY WITH MEAN OF EACH OBSERVATION
avg_combined <- combined %>%
group_by(Subjects, Activity) %>%
summarise_all(funs(mean))


