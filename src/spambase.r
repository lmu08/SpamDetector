packages <- c("caret", "randomForest", "MASS", "nnet", "e1071", "ada", "klaR", "kernlab", "gbm", "rpart.plot")
if (length(setdiff(packages, rownames(installed.packages()))) > 0) {
  install.packages(setdiff(packages, rownames(installed.packages())))  
}
if(!require(doMC)) {
  install.packages("doMC", repos="http://R-Forge.R-project.org")
}

library(caret)
library(randomForest) # randomForest method
library(MASS) # linear discrimant analysis
library(nnet) # neural network
library(ada)
library(e1071) #funcctions for class analysis
library(kernlab)
library(gbm)
library(rpart)
# configure multicore
# library(doMC)
# numCores <- detectCores()
# registerDoMC(cores = numCores)
spam_data = read.csv(file = paste0(getwd(),"/Github/Spamdetector/dataset/spambase.csv"), header=FALSE)
# information of the set
#summary(spam_data)
colnames(spam_data)[56] = "spam"   # change label of last column for convenience

spam_data$spam = as.factor(spam_data$spam)

set.seed(1234)

spam_sample = spam_data[sample(nrow(spam_data), 750), ]
training_index = createDataPartition(spam_sample$spam, p=.7, list=FALSE)

training_set = spam_sample[training_index, ] 
testing_set = spam_sample[-training_index, ]


#set up the training control
tr_ctrl = trainControl(method = "repeatedcv",number = 10,repeats = 3)


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
# ### finding optimal value of a tuning parameter
# sigDist <- sigest(spam ~ ., data = training_set, frac = 1)
# ### creating a grid of two tuning parameters, .sigma comes from the earlier line. we are trying to find best value of .C
# svmTuneGrid <- data.frame(.sigma = sigDist[1], .C = 2^(-2:7))
# 
# svm_train = train(spam ~ ., 
#                   data=training_set, 
#                   method="svmRadial",
#                   trControl=tr_ctrl,
#                   tuneGrid = svmTuneGrid)

forest_train = train(spam ~ ., 
                     data=training_set, 
                     method="rf",
                     trControl=tr_ctrl)

rpart_train = train(spam ~ ., 
                     data=training_set, 
                     method="rpart",
                     trControl=tr_ctrl)
library(rpart.plot)
prp(rpart_train$finalModel, extra = 1)

svm_train = train(spam ~ ., 
                  data=training_set, 
                  method="svmLinear",
                  trControl=tr_ctrl)
ada_train = train(spam ~ ., 
                  data=training_set, 
                  method="ada",
                  trControl=tr_ctrl)

gbm_train = train(spam ~ ., 
                  data=training_set, 
                  method="gbm",
                  trControl=tr_ctrl)

# Varying ntree
control <- trainControl(method="repeatedcv", number=10, repeats=3, search="grid")
tunegrid <- expand.grid(.mtry=c(sqrt(ncol(spam[,1:56]))))
modellist <- list()
for (ntree in c(1000, 1500, 2000, 2500)) {
  fit <- train(spam~., data=training_set, method="rf", metric="Accuracy", tuneGrid=tunegrid, trControl=control, ntree=ntree)
  key <- toString(ntree)
  modellist[[key]] <- fit
}
# compare results
results <- resamples(modellist)
summary(results)
dotplot(results)

x <- spam[,1:56]
y <- spam[,57]
# Varying ntree and mtry
customRF <- list(type = "Classification", library = "randomForest", loop = NULL)
customRF$parameters <- data.frame(parameter = c("mtry", "ntree"), class = rep("numeric", 2), label = c("mtry", "ntree"))
customRF$grid <- function(x, y, len = NULL, search = "grid") {}
customRF$fit <- function(x, y, wts, param, lev, last, weights, classProbs, ...) {
  randomForest(x, y, mtry = param$mtry, ntree=param$ntree, ...)
}
customRF$predict <- function(modelFit, newdata, preProc = NULL, submodels = NULL)
  predict(modelFit, newdata)
customRF$prob <- function(modelFit, newdata, preProc = NULL, submodels = NULL)
  predict(modelFit, newdata, type = "prob")
customRF$sort <- function(x) x[order(x[,1]),]
customRF$levels <- function(x) x$classes

# train model
control <- trainControl(method="repeatedcv", number=10, repeats=3)
tunegrid <- expand.grid(.mtry=c(1:15), .ntree=c(1000, 1500, 2000, 2500))
custom <- train(spam~., data=training_set, method=customRF, metric="Accuracy", tuneGrid=tunegrid, trControl=control)
summary(custom)
plot(custom)

pred_forest = predict(forest_train, testing_set[,-56])
pred_lda = predict(lda_train, testing_set[,-56])
pred_nnet = predict(nnet_train, testing_set[,-56])
pred_knn = predict(knn_train, testing_set[,-56])
pred_svm = predict(svm_train, testing_set[,-56])
pred_ada = predict(ada_train, testing_set[,-56])
pred_gbm = predict(gbm_train, testing_set[,-56])


confusion_forest = confusionMatrix(pred_forest,testing_set$spam)
confusion_lda = confusionMatrix(pred_lda,testing_set$spam)
confusion_nnet = confusionMatrix(pred_nnet,testing_set$spam)
confusion_knn = confusionMatrix(pred_knn,testing_set$spam)
confusion_svm = confusionMatrix(pred_svm, testing_set$spam)
confusion_ada = confusionMatrix(pred_ada, testing_set$spam)
confusion_gbm = confusionMatrix(pred_gbm, testing_set$spam)

plot(confusion_forest$table)
