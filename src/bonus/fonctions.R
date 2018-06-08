get_classname <- function(i)
{
classes <- c("spam","nonspam")
return(classes[i])
}

classwithPredict <- function(predicted,indice){
  return(as.numeric(predicted)[indice])
}

vectorizePredict <- function(predicted){
  res <-return(sapply(1:length(predicted), function(i)
      as.numeric(predicted)[i]))
  return(res)
}

generateRepClassesSpam<- function(nbSpam, nbNonSpam){
  res <- c(rep(1,nbSpam),rep(2,nbNonSpam))
  return(res)
}

mkCsv <- function(freq){
  fullBrut <- VCorpus(
  DirSource(directory = "dataset/bonus",encoding = "UTF-8",pattern = NULL,recursive = TRUE,mode = "text"))
  full <- nettoyage(fullBrut)
  mat <-DocumentTermMatrix(full)
  muMat2 <- findFreqTerms(mat, lowfreq=freq)
  mat<- DocumentTermMatrix(full,control=list(dictionary=muMat2))
  M <- as.matrix(mat)
  write.table(M, "dataset/bonus.csv", row.names=TRUE, sep=",",na="0")
}
