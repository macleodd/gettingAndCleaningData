# Read train data as data.frame(s)
trainSubject <- read.table("train/subject_train.txt")
trainActivity <- read.table("train/y_train.txt")
trainMeasurements <- read.table("train/X_train.txt")

# Read test data as data.frame(s)
testSubject <- read.table("test/subject_test.txt")
testActivity <- read.table("test/y_test.txt")
testMeasurements <- read.table("test/X_test.txt")

# Merge the training and the test sets
allSubject <- rbind(trainSubject, testSubject)
allActivity <- rbind(trainActivity, testActivity)
allMeasurements <- rbind(trainMeasurements, testMeasurements)

# Label the measurements with with descriptive variable names
features <- read.table("features.txt")[,2]
names(allMeasurements) <- features

# Find mean and standard deviation features
featuresOfInterest <- grepl("-mean\\(|-std\\(", features)

# Only keep measurements on the mean and standard deviation for each measurement
allMeasurements <- allMeasurements[,featuresOfInterest]

# Read activity names
activityNames <- read.table("activity_labels.txt")[,2]

# Substitute activity identities with activity names
allActivity <- factor(allActivity[[1]], labels=activityNames)

# Make into a combined data.frame
df <- cbind(allSubject, allActivity, allMeasurements)

# Labels the first two columns with descriptive names
names(df)[1:2] <- c("Subject", "Activity")

# Aggregate by Subject and Activity
tidyDataSet <- aggregate(. ~ Subject + Activity, data=df, FUN=mean)

# Save as a txt file created with write.table() using row.name=FALSE
write.table(tidyDataSet, file="tidyDataSet.txt", row.name=FALSE)
