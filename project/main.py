import pandas
import os

# Load the dataset
data = pandas.read_csv(os.environ['HOME'] + "/git/SpamDetector/dataset/spambase.csv", sep=",")

# Clean the data
data.__delitem__("word_freq_george")
data.__delitem__("word_freq_650")

print(data)