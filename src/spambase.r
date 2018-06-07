packages <- c("caret", "randomForest", "MASS", "nnet", "e1071", "ada")
if (length(setdiff(packages, rownames(installed.packages()))) > 0) {
  install.packages(setdiff(packages, rownames(installed.packages())))  
}

install.packages("doMC", repos="http://R-Forge.R-project.org")

library(caret)
library(randomForest) # randomForest method
library(MASS) # linear discrimant analysis
library(nnet) # neural network
library(ada)
library(e1071) #funcctions for class analysis
# configure multicore
library(doMC)
registerDoMC(cores=4)
spam_data = read.csv(file = "https://archive.ics.uci.edu/ml/machine-learning-databases/spambase/spambase.data", header=FALSE)
summary(spam_data)
colnames(spam_data)[58] = "spam"   # change label of last column for convenience

spam_data$spam = as.factor(spam_data$spam)

set.seed(1234)

spam_sample = spam_data[sample(nrow(spam_data), 750), ]
training_index = createDataPartition(spam_sample$spam, p=.7, list=FALSE)

training_set = spam_sample[training_index, ] 
testing_set = spam_sample[-training_index, ]


#set up the training control
tr_ctrl = trainControl(method = "repeatedcv",number = 10,repeats = 10)


#train the models
lda_train = train(spam ~ ., 
                  data=training_set, 
                  method="lda",
                  trControl=tr_ctrl)

nnet_train = train(spam ~ ., 
                   data=training_set, 
                   method="nnet",
                   trControl=tr_ctrl)

knn_train = train(spam ~ ., 
                  data=training_set, 
                  method="knn",
                  trControl=tr_ctrl)

forest_train = train(spam ~ ., 
                     data=training_set, 
                     method="rf",
                     trControl=tr_ctrl)

svm_train = train(spam ~ ., 
                  data=training_set, 
                  method="svmLinear",
                  trControl=tr_ctrl)
ada_train = train(spam ~ ., 
                  data=training_set, 
                  method="ada",
                  trControl=tr_ctrl)


pred_forest = predict(forest_train, testing_set[,-58])
pred_lda = predict(lda_train, testing_set[,-58])
pred_nnet = predict(nnet_train, testing_set[,-58])
pred_knn = predict(knn_train, testing_set[,-58])
pred_svm = predict(svm_train, testing_set[,-58])
pred_ada = predict(ada_train, testing_set[,-58])

confusion_forest = confusionMatrix(pred_forest,testing_set$spam)
confusion_lda = confusionMatrix(pred_lda,testing_set$spam)
confusion_nnet = confusionMatrix(pred_nnet,testing_set$spam)
confusion_knn = confusionMatrix(pred_knn,testing_set$spam)
confusion_svm = confusionMatrix(pred_svm, testing_set$spam)
confusion_ada = confusionMatrix(pred_ada, testing_set$spam)


plot(confusion_knn$table)
