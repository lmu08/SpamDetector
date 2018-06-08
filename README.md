# SpamDetector

This project contains two directories. dataset and src to execute actions.

##dataset

Dataset folder contains dataset made by google.
It can be found [here](https://archive.ics.uci.edu/ml/datasets/spambase).

It also includes a bonus folder that contains two sub-directory spam and non spam
and should contains HTML email.

Unfortunately, it doesn't contains data yet. Please fulfil with your own data if
you want to generate make predictions.

## src

src folder contains spambase.r file and a bonus folder.

In spambase.r you will be able to discover all our researches to find the most accurate algorithm based on google data

The bonus folder contains 3 files:
- main.R
- nettoyage.R
- fonctions.R

You should be at root of the project if you want to use it.

nettoyage.R allow you to clean-up html files contained in bonus corpus.
fonctions.R contains tools used by main.R, but also mkCsv function allowing you generate
a CSV file based on a corpus with choosen number of FreqTerm.

For example:
```
mkCsv(70)
```
Will generates a csv with the vocabulary of the 70 most used word in mails

main.R creates the model with choosen algorithm (default SVM but you can change)
Once model is generated you can predict with following line. classer func return predicted class
```
file <- source("<file_to_be_predict>")
classer(file)
```



