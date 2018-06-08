# Ceci est la question bonus, il faut appeler la classe spambase.r si besoin d'installer la librairie e1071 en amont
library(e1071)
library(tm)

source("nettoyage.R")
source("fonctions.R")
data <- as.data.frame(read.csv("dataset/bonus.csv", sep=",", header=T))

# Le nombre de fichier dans chaque classe
repClassesSpam <- generateRepClassesSpam(200,200)

#Remplacer svm par l'algo qu'on souhaite utiliser
model <- svm(repClassesSpam ~ ., data = data, cost = 100,type='C',kernel='linear', gamma = 1)


classer<- function(fichier){
  timer<- proc.time()[3]
  corpus <-VCorpus(URISource(fichier))
  corpus <- nettoyage(corpus)
  vocab <- colnames(data)[1:ncol(data)]
  mat20 <- DocumentTermMatrix(corpus,control=list(dictionary=vocab))
  monfile <- as.matrix(mat20)
  pred <- predict(model,monfile)
  classe <- classwithPredict(pred[1])
  print(proc.time()[3]-timer)
  return(get_classname(classe))
}
