library("e1071")

args <- commandArgs(TRUE)

file = args[1]
d = read.csv(file, header=F)
classnr = ncol(d)

classes <- factor(d[,classnr])
data <- d[,-classnr]

classifier <- naiveBayes(data, classes)
pred <- predict(classifier, data)

print("Train:")
table(pred, classes)

file = args[2]
d = read.csv(file, header=F)

classes <- factor(d[,classnr])
data <- d[,-classnr]

pred <- predict(classifier, data)

print("Test:")
table(pred, classes)
