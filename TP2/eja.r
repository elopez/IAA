options(scipen = 999)
data = read.csv("eja/discrete-error.csv", header=F)
colnames(data) <- c("lrnrate", "momentum", "error")
aggregate(.~lrnrate+momentum, data=data, median, na.rm=TRUE)
