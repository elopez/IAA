options(scipen = 999)
data = read.csv("out-ejc/test-error.csv", header=F)
colnames(data) <- c("train", "error")
aggregate(.~train, data=data, median, na.rm=TRUE)
