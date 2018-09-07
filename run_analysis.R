
## LOADING DATA
setwd("/u1/saurmeht/UCI HAR Dataset")
features <- read.table("features.txt")
activity_labels <- read.table("activity_labels.txt")
setwd("test")
test_data <- read.table("X_test.txt")
test_act <- read.table("y_test.txt")
subject_test <- read.table("subject_test.txt")
setwd("../train")
train_data <- read.table("X_train.txt")
train_act <- read.table("y_train.txt")
subject_train <- read.table("subject_train.txt")


## MERGING DATA
merged_data <- rbind(test_data,train_data)


## GIVE DESCRIPTIVE VARIABLE NAMES
names(merged_data) <- features$V2


## FIND INDICES OF MEAN & STD
idx <- grep("mean|std", features$V2)


## KEEP ONLY MEAN & STD
mean_std_data <- merged_data[,idx]


## ADDING ACTIVITIES TO DATA AND ACTIVITIES NAMES
act_merg <- rbind(test_act, train_act) #adding activities from test and train
names(act_merg) <- "Act_No"
mean_std_act_data <- cbind(act_merg, mean_std_data) #adding activities to data


## CONVERTING ACTIVITY NO TO ACTIVITY NAMES
names(activity_labels) <- c("Act_No", "activity")
library(plyr)
inter_data <- join(activity_labels,mean_std_act_data)
library(dplyr)
data_step4 <- select(inter_data, -(Act_No))


## ADDING SUBJECTS
sub_merg <- rbind(subject_test, subject_train) #adding subjects from test and train
names(sub_merg) <- "subject"
data_sub <- cbind(sub_merg, data_step4) #adding subjects to data


## GROUPING BY SUBJECTS AND ACTIVITIES
grouped_data <- group_by(data_sub, subject, activity)
final_data <- summarize_all(grouped_data, mean)

# setwd("/u1/saurmeht/R_assignment")
write.table(final_data,"final_data.txt",sep=",",row.names=TRUE)
