library(reshape2)
library(dplyr)

#create temporary directory and file for downloaded data zip file, then download file.
td <- tempdir()
tf <- tempfile(tmpdir=td,fileext=".zip")
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl, tf)
dateDownloaded <- date()

# Read file names to determine which ones are needed.
filenames <- unzip(tf,list=TRUE)
filenames

# Unzip only files needed 
fname <- unzip(tf,list = TRUE)$Name[c(1,2,16,17,18,30,31,32)]
unzip(tf, files=fname,exdir=td,overwrite=TRUE)
fpath <- file.path(td,fname)

#Read each required file into R from fname
activity_labels <- read.table(fpath[1]) 
dataset_features <- read.table(fpath[2])
subject_test <- read.table(fpath[3])
X_test <- read.table(fpath[4])
Y_test <- read.table(fpath[5])
subject_train <- read.table(fpath[6])
X_train <- read.table(fpath[7])
Y_train <- read.table(fpath[8])

# add column name for activity code and subject ID code
names(Y_test) <-c ("activity_code")
names(subject_test) <-c ("subject_id")
names(subject_train) <-c ("subject_id")
names(Y_train) <- c("activity_code")

# add columns with activity code and subject_id to test file (2947 rows)
mergetestdata <- cbind(Y_test,X_test)
mergetestdata <- cbind(subject_test,mergetestdata)

# add columns with activity code and subject_id to train file (7352 rows)
mergetraindata <- cbind(Y_train,X_train)
mergetraindata <- cbind(subject_train,mergetraindata)

#add column to indicate whether record is from test or train file
mergetraindata <- cbind(group = "train",mergetraindata)
mergetestdata <- cbind(group = "test",mergetestdata)

# merge test and train files into one dataset that includes activity code, test group and subject ID
combined_data <- rbind(mergetestdata,mergetraindata)

#add new rows to dataset_features to reflect added column names to combined_data
newrows <- data.frame(V1 = 0,V2 = c("group","subject_id","activity_code"))
dataset_features <- rbind(newrows,dataset_features)

# change column names in merged dataset to measurement names from features file
new_column_names <- as.vector(dataset_features$V2)
names(combined_data) <- new_column_names

# subset datafile to include only columns measuring mean and standard deviation
subset_data <- combined_data[grep("group|subject_id|activity_code|mean([^a-zA-Z])|std([^a-zA-Z])",names(combined_data))]

# convert activity codes to activity description
subset_data$activity_code[subset_data$activity_code==1]<-"WALKING"
subset_data$activity_code[subset_data$activity_code==2]<-"WALKING_UPSTAIRS"
subset_data$activity_code[subset_data$activity_code==3]<-"WALKING_DOWNSTAIRS"
subset_data$activity_code[subset_data$activity_code==4]<-"SITTING"
subset_data$activity_code[subset_data$activity_code==5]<-"STANDING"
subset_data$activity_code[subset_data$activity_code==6]<-"LAYING"

#order data by subject_id, then activity
subset_data <- subset_data[order(subset_data[,2],subset_data[,3]),]

#melt data set by subject_id,activity_code, and group.
melted_data <- melt(subset_data, id.vars = c("subject_id","activity_code","group"))

# group by subject_id,activity_code, group, and variable
grouped_data <- group_by(melted_data,subject_id,activity_code,group,variable)

# summarize the mean of the values of each variable by subject_id and activity_code  
summarized_data <- summarize(grouped_data,mean(value))


#reverting to wide data for readability
tidydata <- dcast(summarized_data, subject_id + activity_code  + group ~ variable)

#output tidydata
tidydata
