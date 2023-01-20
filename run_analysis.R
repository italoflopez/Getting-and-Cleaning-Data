library(data.table)
library(dplyr)
setwd("Curso 3")
download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip",destfile = "data.zip")
unzip("data.zip")
x_train<-read.table("C://Users//ilopez//OneDrive - Superintendencia de Bancos de la Republica Dominicana//Documentos//Data Science Specialization//Data_Science_Specialization//Curso 3//UCI HAR Dataset//train//X_train.txt")
y_train<-read.table("C://Users//ilopez//OneDrive - Superintendencia de Bancos de la Republica Dominicana//Documentos//Data Science Specialization//Data_Science_Specialization//Curso 3//UCI HAR Dataset//train//y_train.txt")
x_test<-read.table("C://Users//ilopez//OneDrive - Superintendencia de Bancos de la Republica Dominicana//Documentos//Data Science Specialization//Data_Science_Specialization//Curso 3//UCI HAR Dataset//test//X_test.txt")
y_test<-read.table("C://Users//ilopez//OneDrive - Superintendencia de Bancos de la Republica Dominicana//Documentos//Data Science Specialization//Data_Science_Specialization//Curso 3//UCI HAR Dataset//test//y_test.txt")

# Cargue etiquetas de actividad + características
activityLabels <- read.table("UCI HAR Dataset/activity_labels.txt")
activityLabels[,2] <- as.character(activityLabels[,2])
features <- read.table("UCI HAR Dataset/features.txt")
features[,2] <- as.character(features[,2])

# Extraiga solo los datos sobre la media y la desviación estándar
featuresWanted <- grep(".*mean.*|.*std.*", features[,2])
featuresWanted.names <- features[featuresWanted,2]
featuresWanted.names = gsub('-mean', 'Mean', featuresWanted.names)
featuresWanted.names = gsub('-std', 'Std', featuresWanted.names)
featuresWanted.names <- gsub('[-()]', '', featuresWanted.names)


# Cargar los conjuntos de datos
train <- read.table("UCI HAR Dataset/train/X_train.txt")[featuresWanted]
trainActivities <- read.table("UCI HAR Dataset/train/Y_train.txt")
trainSubjects <- read.table("UCI HAR Dataset/train/subject_train.txt")
train <- cbind(trainSubjects, trainActivities, train)

test <- read.table("UCI HAR Dataset/test/X_test.txt")[featuresWanted]
testActivities <- read.table("UCI HAR Dataset/test/Y_test.txt")
testSubjects <- read.table("UCI HAR Dataset/test/subject_test.txt")
test <- cbind(testSubjects, testActivities, test)

# combinar conjuntos de datos y agregar etiquetas
allData <- rbind(train, test)
colnames(allData) <- c("subject", "activity", featuresWanted.names)

# convertir actividades y temas en factores
allData$activity <- factor(allData$activity, levels = activityLabels[,1], labels = activityLabels[,2])
allData$subject <- as.factor(allData$subject)

allData.melted <- melt(allData, id = c("subject", "activity"))
allData.mean <- dcast(allData.melted, subject + activity ~ variable, mean)

write.table(allData.mean, "tidy.txt", row.names = FALSE, quote = FALSE)